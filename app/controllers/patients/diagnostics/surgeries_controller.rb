# frozen_string_literal: true

class Patients::Diagnostics::SurgeriesController < Patients::Diagnostics::TreatableController
  def new
    @surgery = @patient.surgeries.new
  end

  def create
    @surgery = @patient.surgeries.new surgery_params

    if @surgery.save
      treatment = @surgery.create_treatment! diagnostic: @diagnostic, started_at: @surgery.date
      redirect_to patient_diagnostic_treatment_path(@patient, @diagnostic, treatment)
    else
      flash[:error] = @surgery.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def surgery_params
      params.require(:surgery).permit(:date, :classification, :hospital, :discharged_at)
    end
end
