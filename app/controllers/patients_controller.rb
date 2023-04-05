# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :authenticate_user!, :set_patient

  def new
  end

  def show
  end

  def create
  end

  private
    def set_patient
      @patient = Patient.find(params[:id])
    end
end
