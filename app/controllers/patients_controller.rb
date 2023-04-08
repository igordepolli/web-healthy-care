# frozen_string_literal: true

class PatientsController < ApplicationController
  include PatientScoped

  def new
  end

  def show
  end

  def create
    @patient.assign_attributes user: current_user, **patient_params

    if @patient.save
      redirect_to patient_path(@patient)
    else
      flash[:error] = @patient.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def patient_params
      params.require(:patient).permit(:name, :last_name, :rg, :cpf, :email)
    end
end
