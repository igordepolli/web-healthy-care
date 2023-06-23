# frozen_string_literal: true

class Patients::Diagnostics::Surgeries::MedicationSurgeriesController < Patients::Diagnostics::TreatableController
  before_action :set_surgery

  def new
  end

  def create
    surgery_params[:medications].each do |med|
      medication = Medication.find(med.delete(:medication))
      medication = @surgery.medications.new medication:, **med

      if !medication.save
        flash[:error] = medication.errors.full_messages
        render :new, status: :unprocessable_entity and return
      end
    end

    redirect_to patient_diagnostic_treatment_path(@patient, @diagnostic, @surgery.treatment)
  end

  private
    def set_surgery
      @surgery = @patient.surgeries.find(params[:surgery_id])
    end

    def surgery_params
      params.require(:surgery).permit(medications: [:medication, :dosage])
    end
end
