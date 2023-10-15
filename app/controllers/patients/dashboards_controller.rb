# frozen_string_literal: true

class Patients::DashboardsController < ApplicationController
  include PatientDoctorScoped

  before_action :set_access_control

  def show
    generic_response patient: @patient, doctor: @doctor, access_control: @access_control
  end

  private
    def set_access_control
      @access_control = @patient.access_controls.where(doctor: @doctor).order(:id).last
    end
end
