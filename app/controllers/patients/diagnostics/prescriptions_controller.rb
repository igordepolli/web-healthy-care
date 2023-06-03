# frozen_string_literal: true

class Patients::Diagnostics::PrescriptionsController < Patients::Diagnostics::TreatableController
  def new
    @prescription = Prescription.new
  end

  def create
    @prescription = @patient.prescriptions.new prescription_params

    if @prescription.save
      redirect_to new_patient_diagnostic_prescription_medication_prescription_path(@patient, @diagnostic, @prescription)
    else
      flash[:error] = @prescription.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def prescription_params
      params.require(:prescription).permit(:date, :medications_count, :file)
    end
end
