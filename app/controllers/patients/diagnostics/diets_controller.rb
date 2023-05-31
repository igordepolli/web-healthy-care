# frozen_string_literal: true

class Patients::Diagnostics::DietsController < Patients::Diagnostics::TreatableController
  def new
    @diet = @patient.diets.new
  end

  def create
    @diet = @patient.diets.new diet_params

    if @diet.save
      treatment = @diet.create_treatment! diagnostic: @diagnostic, started_at: @diet.date
      redirect_to patient_diagnostic_treatment_path(@patient, @diagnostic, treatment)
    else
      flash[:error] = @diet.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def diet_params
      params.require(:diet).permit(:date, :breakfast, :lunch, :dinner, :morning_snack, :afternoon_snack)
    end
end
