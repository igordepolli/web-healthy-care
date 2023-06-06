# frozen_string_literal: true

class Biodatum < ApplicationRecord
  belongs_to :patient
  belongs_to :exam

  validates :systolic_pressure, :diastolic_pressure, :glycemia, :heart_rate, :cholesterol, :triglyceride, numericality: { only_integer: true, allow_blank: true }

  validate :at_least_one_of_biodatas_not_nil

  private
    def at_least_one_of_biodatas_not_nil
      if [systolic_pressure, diastolic_pressure, glycemia, heart_rate, cholesterol, triglyceride, creatinine].all?(&:nil?)
        errors.add(:base, "Pelo menos um dos biodados deve ter resultados!")
      end
    end
end
