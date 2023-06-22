# frozen_string_literal: true

class Patients::SurgeriesController < Patients::DashboardsController
  before_action :set_surgery, only: [:show, :edit, :update]

  def new
    @surgery = @patient.surgeries.new
  end

  def edit
  end

  def index
    @surgeries = @patient.surgeries
  end

  def show
  end

  def create
    @surgery = @patient.surgeries.new surgery_params

    if @surgery.save
      redirect_to new_patient_surgery_medication_surgery_path(@patient, @surgery)
    else
      flash[:error] = @surgery.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @surgery.assign_attributes surgery_params

    if @surgery.save
      redirect_or_render_after_update
    else
      flash[:error] = @surgery.errors.full_messages
      @surgery.reload
      render :show, status: :unprocessable_entity
    end
  end

  private
    def surgery_params
      params.require(:surgery).permit(:classification, :date, :hospital, :discharged_at, :medications_count)
    end

    def set_surgery
      @surgery = @patient.surgeries.find(params[:id])
    end

    def redirect_or_render_after_update
      if params[:mode] == "update_discharged_at"
        render turbo_stream: turbo_stream.replace("sub-content", template: "patients/surgeries/show")
      else
        redirect_to new_patient_surgery_medication_surgery_path(@patient, @surgery)
      end
    end
end
