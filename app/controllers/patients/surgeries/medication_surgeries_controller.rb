# frozen_string_literal: true

class Patients::Surgeries::MedicationSurgeriesController < Patients::DashboardsController
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

    redirect_to patient_surgery_path(@patient, @surgery)
  end

  private
    def set_surgery
      @surgery = Surgery.find(params[:surgery_id])
    end

    def surgery_params
      params.require(:surgery).permit(medications: [:medication, :dosage])
    end
end
