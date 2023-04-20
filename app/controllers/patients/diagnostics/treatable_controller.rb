# frozen_string_literal: true

class Patients::Diagnostics::TreatableController < Patients::AccessController
  before_action :set_diagnostic

  private
    def set_diagnostic
      @diagnostic = @patient.diagnostics.find(params[:diagnostic_id])
    end
end
