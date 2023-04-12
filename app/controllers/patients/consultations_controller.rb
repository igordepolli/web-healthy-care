# frozen_string_literal: true

class Patients::ConsultationsController < Patients::AccessController
  def new
  end

  def index
  end

  def show
  end

  def create
  end

  private
    def consultation_params
      params.require(:consultation).permit(:date, :reason)
    end
end
