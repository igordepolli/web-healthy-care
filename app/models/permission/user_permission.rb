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
        allow "devise/sessions", [:destroy]
      end

      def user_custom_permission(user)
        allow "patients", [:new, :create] do |_|
          user.patient?
        end

        allow "doctors", [:new, :create] do |_|
          user.doctor?
        end

        allow "patients", [:show] do |patient|
          owner?(patient, user)
        end

        allow "doctors", [:show] do |doctor|
          owner?(doctor, user)
        end
      end
  end
end
