# frozen_string_literal: true

class Patients::AccessControlsController < ApplicationController
  include PatientDoctorScoped

  before_action :set_access_control, only: [:update, :destroy]

  def index
  end

  def create
    access_control = AccessControl.create! doctor: @doctor, patient: @patient

    render turbo_stream: turbo_stream.replace("aside-menu", partial: "patients/show/aside_menu", locals: { patient: @patient, doctor: @doctor, access_control: })
  end

  def update
    @access_control.update! expires_at: Time.zone.now + 2.hours
  end

  def destroy
    @access_control.destroy
  end

  private
    def set_access_control
      @access_control = @patient.access_controls.find(params[:id])
    end
end
