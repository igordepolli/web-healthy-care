# frozen_string_literal: true

class Patients::Diagnostics::TreatmentsController < Patients::Diagnostics::TreatableController
  before_action :set_treatment, :set_treatable, only: [:show, :update]

  def new
  end

  def index
    @treatments = @diagnostic.treatments
  end

  def show
  end

  def update
    @treatment.assign_attributes treatment_params

    if @treatment.save
      render turbo_stream: turbo_stream.replace("sub-content", template: "patients/diagnostics/treatments/show")
    else
      flash[:error] = @treatment.errors.full_messages
      @treatment.reload
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

    def set_treatable
      @treatable = @treatment.treatable
    end
end
