# frozen_string_literal: true

module PatientDoctorScoped
  extend ActiveSupport::Concern

  included do
    prepend_before_action :set_patient, :set_doctor
  end

  private
    def current_resource
      [@patient, @doctor]
    end

    def set_patient
      @patient = Patient.find(params[:patient_id])
    end

    def set_doctor
      @doctor = Doctor.find_by(user: current_user)
    end
end
