# frozen_string_literal: true

class Patients::Diagnostics::TreatmentsController < Patients::Diagnostics::TreatableController
  before_action :set_treatment, only: [:show, :update]

  def new
  end

  def index
    @treatments = @diagnostic.treatments
  end

  def show
  end

  def update
    @treatment.assign_attributes treatment_update_params

    if @treatment.save
      render turbo_stream: turbo_stream.replace("content", partial: "patients/diagnostics/treatments/show/content", locals: { patient: @patient, diagnostic: @diagnostic, treatment: @treatment })
    else
      flash[:error] = @treatment.errors[:ended_at]
      render :show, status: :unprocessable_entity
    end
  end

  private
    def treatment_params
      params.require(:treatment).permit(:ended_at)
    end

    def set_treatment
      @treatment = @diagnostic.treatments.find(params[:id])
    end
end
