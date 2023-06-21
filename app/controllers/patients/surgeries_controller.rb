# frozen_string_literal: true

class Patients::SurgeriesController < Patients::DashboardsController
  before_action :set_surgery, only: [:show, :update]

  def new
    @surgery = @patient.surgeries.new
  end

  def index
    @surgeries = @patient.surgeries
  end

  def show
  end

  def create
    @surgery = @patient.surgeries.new surgery_params_create

    if @surgery.save
      redirect_to patient_surgery_path(@patient, @surgery)
    else
      flash[:error] = @surgery.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @surgery.assign_attributes surgery_params_update

    if @surgery.save
      render turbo_stream: turbo_stream.replace("sub-content", template: "patients/surgeries/show")
    else
      flash[:error] = @surgery.errors.full_messages
      @surgery.reload
      render :show, status: :unprocessable_entity
    end
  end

  private
    def surgery_params_create
      params.require(:surgery).permit(:classification, :date, :hospital, :discharged_at)
    end

    def surgery_params_update
      params.require(:surgery).permit(:discharged_at)
    end

    def set_surgery
      @surgery = @patient.surgeries.find(params[:id])
    end
end
