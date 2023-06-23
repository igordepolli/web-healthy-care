# frozen_string_literal: true

class Patients::Diagnostics::SurgeriesController < Patients::Diagnostics::TreatableController
  before_action :set_surgery, only: [:edit, :update]

  def new
    @surgery = @patient.surgeries.new
  end

  def edit
    @return_url = params[:mode] == "add_medication" ? patient_diagnostic_treatment_path(@patient, @diagnostic, @surgery.treatment) : patient_diagnostic_treatments_path(@patient, @diagnostic)
  end

  def create
    @surgery = @patient.surgeries.new surgery_params

    if @surgery.save
      @surgery.create_treatment! diagnostic: @diagnostic, started_at: @surgery.date
      redirect_to new_patient_diagnostic_surgery_medication_surgery_path(@patient, @diagnostic, @surgery)
    else
      flash[:error] = @surgery.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @surgery.assign_attributes surgery_params

    if @surgery.save
      redirect_after_update
    else
      flash[:error] = @surgery.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_surgery
      @surgery = @patient.surgeries.find(params[:id])
    end

    def surgery_params
      params.require(:surgery).permit(:date, :classification, :hospital, :discharged_at, :medications_count, :description)
    end

    def redirect_after_update
      if params[:mode] == "update_discharged_at"
        redirect_to patient_diagnostic_treatment_path(@patient, @diagnostic, @surgery.treatment)
      else
        redirect_to new_patient_diagnostic_surgery_medication_surgery_path(@patient, @diagnostic, @surgery, mode: params[:mode])
      end
    end
end
