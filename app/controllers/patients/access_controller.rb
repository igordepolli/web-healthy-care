# frozen_string_literal: true

class Patients::AccessController < ApplicationController
  include PatientDoctorScoped

  before_action :set_access_control

  private
    def set_access_control
      @access_control = @patient.access_controls.where(doctor: @doctor).order(:id).last
    end
end
