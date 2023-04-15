# frozen_string_literal: true

class Patients::ConsultationsController < Patients::AccessController
  before_action :set_consultation, only: :show

  def new
    @consultation = Consultation.new
  end

  def index
    @consultations = @patient.consultations
  end

  def show
  end

  def create
    consultation = @patient.consultations.new doctor: @doctor, **consultation_params

    if consultation.save
      redirect_to patient_consultation_path(@patient, consultation)
    else
      flash[:error] = consultation.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def consultation_params
      params.require(:consultation).permit(:date, :reason, :sick_note)
    end

    def set_consultation
      @consultation = @patient.consultations.find(params[:id])
    end
end
