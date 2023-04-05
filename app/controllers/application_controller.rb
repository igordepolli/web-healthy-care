# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_logged_patient, :set_logged_doctor

  private
    def set_logged_patient
      @logged_patient = Patient.find_by(user: current_user)
    end

    def set_logged_doctor
      @logged_doctor = Doctor.find_by(user: current_user)
    end
end
