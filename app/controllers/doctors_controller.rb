# frozen_string_literal: true

class DoctorsController < ApplicationController
  include DoctorScoped

  def new
  end

  def show
  end

  def create
    @doctor.assign_attributes user: current_user, **doctor_params

    if @doctor.save
      redirect_to doctor_path(@doctor)
    else
      flash[:error] = @doctor.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def doctor_params
      params.require(:doctor).permit(:name, :last_name, :crm, :cpf, :email, :specialty)
    end
end
