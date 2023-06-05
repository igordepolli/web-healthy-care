# frozen_string_literal: true

class Patients::ExamsController < Patients::DashboardsController
  before_action :set_exam, only: :show

  def new
    @exam = @patient.exams.new
  end

  def index
    @exams = @patient.exams
  end

  def show
  end

  def create
    @exam = @patient.exams.new exam_params

    if @exam.save
      redirect_to patient_exam_path(@patient, @exam)
    else
      flash[:error] = @exam.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def exam_params
      params.require(:exam).permit(:classification, :date, :local, :result)
    end

    def set_exam
      @exam = @patient.exams.find(params[:id])
    end
end
