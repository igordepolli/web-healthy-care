# frozen_string_literal: true

module Devise::RegistrationsHelper
  def options_for_user_classification
    options = [["Paciente", "patient"], ["Médico", "doctor"]]
    options << ["Admin", "admin"] if current_user&.admin?

    options_for_select(options)
  end
end
