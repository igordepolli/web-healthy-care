# frozen_string_literal: true

class Patients::Diagnostics::TreatmentsController < Patients::AccessController
  before_action :set_diagnostic
  before_action :set_treatment, only: [:show, :update]

  def new
    @treatment = @diagnostic.treatments.new
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

  def create
    @treatment = @diagnostic.treatments.new treatment_create_params

    if @treatment.save
      redirect_to patient_diagnostic_treatment_path(@patient, @diagnostic, @treatment)
    else
      flash[:error] = @treatment.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def treatment_create_params
      params.require(:treatment).permit(:classification, :recomendation, :started_at, :ended_at)
    end

    def treatment_update_params
      params.require(:treatment).permit(:ended_at)
    end

    def set_diagnostic
      @diagnostic = @patient.diagnostics.find(params[:diagnostic_id])
    end

    def set_treatment
      @treatment = @diagnostic.treatments.find(params[:id])
    end
end
