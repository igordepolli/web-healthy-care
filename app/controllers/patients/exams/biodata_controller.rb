# frozen_string_literal: true

class Patients::Exams::BiodataController < Patients::DashboardsController
  before_action :set_exam

  def new
    @biodatum = @exam.build_biodatum
  end

  def create
    @biodatum = @exam.build_biodatum(**biodatum_params)

    if @biodatum.save
      redirect_to patient_exam_path(@patient, @exam)
    else
      flash[:error] = @biodatum.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def biodatum_params
      params.require(:biodatum).permit(:systolic_pressure, :diastolic_pressure, :glycemia, :heart_rate, :cholesterol, :triglyceride, :creatinine)
    end

    def set_exam
      @exam = @patient.exams.find(params[:exam_id])
    end
end
