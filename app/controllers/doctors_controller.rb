# frozen_string_literal: true

class DoctorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_doctor, only: :show

  def new
    @doctor = Doctor.new
  end

  def show
  end

  def create
    doctor = Doctor.new user: current_user, **doctor_params

    if doctor.save
      redirect_to doctor_path(doctor)
    else
      flash[:error] = doctor.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def doctor_params
      params.require(:doctor).permit(:name, :last_name, :crm, :cpf, :email)
    end

    def set_doctor
      @doctor = Doctor.find(params[:id])
    end
end
