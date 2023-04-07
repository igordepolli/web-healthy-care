# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: :show

  def new
    @patient = Patient.new
  end

  def show
  end

  def create
    patient = Patient.new user: current_user, **patient_params

    if patient.save
      redirect_to patient_path(patient)
    else
      flash[:error] = patient.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def patient_params
      params.require(:patient).permit(:name, :last_name, :rg, :cpf, :email)
    end

    def set_patient
      @patient = Patient.find(params[:id])
    end
end
