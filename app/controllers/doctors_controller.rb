# frozen_string_literal: true

class DoctorsController < ApplicationController
  include DoctorScoped

  def new
    generic_response doctor: @doctor
  end

  def index
    @doctors = Doctor.where("last_name ~* :query OR crm ~* :query", query: params[:query])

    generic_response doctors: @doctors
  end

  def edit
    generic_response doctor: @doctor
  end

  def show
    generic_response doctor: @doctor
  end

  def create
    debugger
    @doctor.assign_attributes user: current_user, **doctor_params_create

    respond_after_create_or_update
  end

  def update
    @doctor.assign_attributes doctor_params_update

    respond_after_create_or_update
  end

  private
    def doctor_params_create
      params.require(:doctor).permit(:name, :last_name, :crm, :cpf, :email, :specialty)
    end

    def doctor_params_update
      params.require(:doctor).permit(:name, :last_name, :crm, :email, :specialty)
    end

    def respond_after_create_or_update
      respond_to do |format|
        if @doctor.save
          format.html { redirect_to doctor_path(@doctor) }
          format.json { render json: { doctor: @doctor, status: :created } }
        else
          format.html { render action: :new, status: :unprocessable_entity, flash: { error: @doctor.errors.full_messages } }
          format.json { render json: { errors: @doctor.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end
end
