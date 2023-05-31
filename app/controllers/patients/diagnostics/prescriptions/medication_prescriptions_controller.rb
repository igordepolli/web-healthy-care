# frozen_string_literal: true

class Patients::Diagnostics::Prescriptions::MedicationPrescriptionsController < Patients::Diagnostics::TreatableController
  before_action :set_prescription

  def new
  end

  def create
    prescription_params[:medications].each do |med|
      medication = Medication.find(med.delete(:medication))
      @prescription.medications.create! medication:, **med
    end

    treatment = @prescription.create_treatment! diagnostic: @diagnostic, started_at: @prescription.date
    redirect_to patient_diagnostic_treatment_path(@patient, @diagnostic, treatment)
  end

  private
    def set_prescription
      @prescription = Prescription.find(params[:prescription_id])
    end

    def prescription_params
      params.require(:prescription).permit(medications: [:medication, :dosage, :schedule])
    end
end
