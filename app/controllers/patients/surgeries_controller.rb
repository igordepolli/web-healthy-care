# frozen_string_literal: true

class Patients::SurgeriesController < Patients::AccessController
  before_action :set_surgery, only: :show

  def new
    @surgery = @patient.surgeries.new
  end

  def index
    @surgeries = @patient.surgeries
  end

  def show
  end

  def create
    @surgery = @patient.surgeries.new surgery_params

    if @surgery.save
      redirect_to patient_surgery_path(@patient, @surgery)
    else
      flash[:error] = @surgery.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def surgery_params
      params.require(:surgery).permit(:classification, :date, :hospital, :discharged_at)
    end

    def set_surgery
      @surgery = @patient.surgeries.find(params[:id])
    end
end
