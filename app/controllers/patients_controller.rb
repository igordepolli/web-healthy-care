# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :authenticate_user!, :set_patient

  def show
  end

  private
    def set_patient
      @patient = Patient.find(params[:id])
    end
end
