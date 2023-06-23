# frozen_string_literal: true

class Patients::Diagnostics::Prescriptions::MedicationPrescriptionsController < Patients::Diagnostics::TreatableController
  before_action :set_prescription

  def new
  end

  def create
    prescription_params[:medications].each do |med|
      medication = Medication.find(med.delete(:medication))
      medication = @prescription.medications.new medication:, **med

      if !medication.save
        flash[:error] = medication.errors.full_messages
        render :new, status: :unprocessable_entity and return
      end
    end

    redirect_to patient_diagnostic_treatment_path(@patient, @diagnostic, @prescription.treatment)
  end

  private
    def set_prescription
      @prescription = @patient.prescriptions.find(params[:prescription_id])
    end

    def prescription_params
      params.require(:prescription).permit(medications: [:medication, :dosage, :schedule])
    end
end
