# frozen_string_literal: true

class Patients::DiagnosticsController < Patients::DashboardsController
  before_action :set_diagnostic, only: [:show, :update]

  def new
    @diagnostic = @patient.diagnostics.new
  end

  def index
    @diagnostics = @patient.diagnostics
  end

  def show
  end

  def update
    @diagnostic.assign_attributes diagnostic_update_params
    @diagnostic.cured_at = @diagnostic.cured? ? Time.zone.now : nil

    if @diagnostic.save
      render turbo_stream: turbo_stream.replace("sub-content", template: "patients/diagnostics/show", locals: { patient: @patient, diagnostic: @diagnostic })
    else
      flash[:error] = @diagnostic.errors.full_messages
      render :show, status: :unprocessable_entity
    end
  end

  def create
    treated_params = diagnostic_create_params.dup
    disease        = Disease.find(treated_params.delete(:disease))
    @diagnostic    = @patient.diagnostics.new disease:, **treated_params

    if @diagnostic.save
      # redirect_to patient_diagnostic_path(@patient, @diagnostic)
      redirect_to new_patient_diagnostic_treatment_path(@patient, @diagnostic)
    else
      flash[:error] = @diagnostic.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def diagnostic_create_params
      params.require(:diagnostic).permit(:disease, :diagnosed_at, :cured_at, :related_symptoms, :status)
    end

    def diagnostic_update_params
      params.require(:diagnostic).permit(:status)
    end

    def set_diagnostic
      @diagnostic = @patient.diagnostics.find(params[:id])
    end
end
