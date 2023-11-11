# frozen_string_literal: true

class PatientsController < ApplicationController
  include PatientScoped

  def new
    generic_response patient: @patient
  end

  def edit
    generic_response patient: @patient
  end

  def index
    @patients = Patient.where("last_name ~* ?", params[:query])

    generic_response patients: @patients
  end

  def create
    @patient.assign_attributes user: current_user, **patient_params_create

    if @patient.save
      redirect_to patient_dashboard_path(@patient)
    else
      flash[:error] = @patient.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @patient.assign_attributes patient_params_update

    if @patient.save
      redirect_to patient_dashboard_path(@patient)
    else
      flash[:error] = @patient.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def patient_params_create
      params.require(:patient).permit(:name, :last_name, :rg, :cpf, :email, :city, :state)
    end

    def patient_params_update
      params.require(:patient).permit(:name, :last_name, :email, :city, :state)
    end
end
