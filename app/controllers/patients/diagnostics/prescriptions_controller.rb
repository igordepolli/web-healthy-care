# frozen_string_literal: true

class Patients::Diagnostics::PrescriptionsController < Patients::Diagnostics::TreatableController
  before_action :set_prescription, only: [:edit, :update]

  def new
    @prescription = Prescription.new
  end

  def edit
    @return_url = params[:mode] == "add_medication" ? patient_diagnostic_treatment_path(@patient, @diagnostic, @prescription.treatment) : patient_diagnostic_treatments_path(@patient, @diagnostic)
  end

  def create
    @prescription = @patient.prescriptions.new prescription_params

    if @prescription.save
      @prescription.create_treatment! diagnostic: @diagnostic, started_at: @prescription.date
      redirect_to new_patient_diagnostic_prescription_medication_prescription_path(@patient, @diagnostic, @prescription)
    else
      flash[:error] = @prescription.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @prescription.assign_attributes prescription_params

    if @prescription.save
      redirect_to new_patient_diagnostic_prescription_medication_prescription_path(@patient, @diagnostic, @prescription, mode: params[:mode])
    else
      flash[:error] = @prescription.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_prescription
      @prescription = @patient.prescriptions.find(params[:id])
    end

    def prescription_params
      params.require(:prescription).permit(:date, :medications_count, :file)
    end
end
