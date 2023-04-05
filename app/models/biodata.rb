# frozen_string_literal: true

class Biodata < ApplicationRecord
  belongs_to :source, polymorphic: true

  validate :at_least_one_of_biodatas_not_nil

  private
    def at_least_one_of_biodatas_not_nil
      if [systolic_pressure, diastolic_pressure, glycemia, heart_rate, cholesterol, triglyceride, creatinine].all?(&:nil?)
        errors.add(:base, "Pelo menos um dos biodados deve ter resultados!")
      end
    end
end
