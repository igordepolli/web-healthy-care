# frozen_string_literal: true

module LayoutsHelper
  def main_page_path(logged_patient, logged_doctor)
    return unless user_signed_in?

    logged_patient.present? ? patient_path(logged_patient) : doctor_path(logged_doctor)
  end
end
