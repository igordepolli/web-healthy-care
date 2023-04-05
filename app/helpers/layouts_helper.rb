# frozen_string_literal: true

module LayoutsHelper
  def main_page_path(logged_patient, logged_doctor)
    return unless user_signed_in?

    if logged_patient.present?
      patient_path(logged_patient)
    elsif logged_doctor.present?
      doctor_path(logged_doctor)
    else
      root_path
    end
  end
end
