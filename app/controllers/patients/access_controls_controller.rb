# frozen_string_literal: true

class Patients::AccessControlsController < Patients::DashboardsController
  before_action :set_access_control, only: [:update, :destroy]

  def index
    @access_controls = @patient.access_controls.pendings
  end

  def create
    access_control = AccessControl.create! doctor: @doctor, patient: @patient

    render turbo_stream: turbo_stream.replace("aside-menu", partial: "patients/shared/aside_menu", locals: { patient: @patient, doctor: @doctor, access_control: })
  end

  def update
    @access_control.allow!

    render turbo_stream: turbo_stream.replace("aside-menu", partial: "patients/shared/aside_menu", locals: { patient: @patient, doctor: @doctor, access_control: @access_control })
  end

  def destroy
    @access_control.destroy!

    render turbo_stream: turbo_stream.replace("aside-menu", partial: "patients/shared/aside_menu", locals: { patient: @patient, doctor: @doctor, access_control: @access_control })
  end

  private
    def set_access_control
      @access_control = @patient.access_controls.find(params[:id])
    end
end
