# frozen_string_literal: true

module DoctorScoped
  extend ActiveSupport::Concern

  included do
    prepend_before_action :set_doctor
  end

  private
    def current_resource
      @doctor
    end

    def set_doctor
      @doctor = Doctor.find_by(id: params[:id]) || Doctor.new
    end
end
