# frozen_string_literal: true

class DoctorsController < ApplicationController
  include DoctorScoped

  def new
  end

  def edit
  end

  def show
  end

  def create
    @doctor.assign_attributes user: current_user, **doctor_params_create

    if @doctor.save
      redirect_to doctor_path(@doctor)
    else
      flash[:error] = @doctor.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @doctor.assign_attributes doctor_params_update

    if @doctor.save
      redirect_to doctor_path(@doctor)
    else
      flash[:error] = @doctor.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def doctor_params_create
      params.require(:doctor).permit(:name, :last_name, :crm, :cpf, :email, :specialty)
    end

    def doctor_params_update
      params.require(:doctor).permit(:name, :last_name, :crm, :email, :specialty)
    end
end
