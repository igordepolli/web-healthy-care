# frozen_string_literal: true

module PatientScoped
  extend ActiveSupport::Concern

  included do
    prepend_before_action :set_patient
  end

  private
    def current_resource
      @patient
    end

    def set_patient
      @patient = Patient.find_by(id: params[:id]) || Patient.new
    end
end
