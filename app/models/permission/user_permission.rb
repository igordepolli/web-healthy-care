# frozen_string_literal: true

module Permission
  class UserPermission < VisitorPermission
    def self.accept?(user)
      user.present?
    end

    def initialize(user)
      super(nil)
      user_basic_permission
      user_custom_permission user
    end

    private
      def owner?(model, user)
        model&.try(:user_id) == user.id
      end

      def user_basic_permission
        allow "dispatches", [:show]
        allow "users/registrations", [:edit, :update, :destroy]
        allow "devise/sessions", [:destroy]
      end

      def user_custom_permission(user)
        allow "patients", [:new, :create] do |patient|
          user.patient? && patient.new_record?
        end

        allow "doctors", [:new, :create] do |doctor|
          user.doctor? && doctor.new_record?
        end

        allow "patients", [:show] do |patient|
          owner?(patient, user) || user.doctor?
        end

        allow "patients", [:index] do |patient|
          user.doctor?
        end

        allow "doctors", [:show] do |doctor|
          owner?(doctor, user)
        end

        allow "patients/access_controls", [:create] do |(_, _)|
          user.doctor?
        end

        allow "patients/access_controls", [:update, :index, :destroy] do |(patient, _)|
          owner?(patient, user)
        end

        allow "patients/consultations", [:show, :index] do |(patient, doctor)|
          owner?(patient, user) || doctor&.allowed_by?(patient)
        end

        allow "patients/consultations", [:new, :create] do |(patient, doctor)|
          doctor&.allowed_by?(patient)
        end

        allow "patients/surgeries", [:show, :index] do |(patient, doctor)|
          owner?(patient, user) || doctor&.allowed_by?(patient)
        end

        allow "patients/surgeries", [:new, :create] do |(patient, doctor)|
          doctor&.allowed_by?(patient)
        end

        allow "patients/diagnostics", [:show, :index] do |(patient, doctor)|
          owner?(patient, user) || doctor&.allowed_by?(patient)
        end

        allow "patients/diagnostics", [:new, :create, :update] do |(patient, doctor)|
          doctor&.allowed_by?(patient)
        end
      end
  end
end
