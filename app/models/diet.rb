# frozen_string_literal: true

class Diet < ApplicationRecord
  belongs_to :source, polymorphic: true

  validate :at_least_one_of_meals_not_nil

  private
    def at_least_one_of_meals_not_nil
      if [breakfast, lunch, dinner, morning_snack, afternoon_snack].all?(&:nil?)
        errors.add(:base, "Pelo menos uma das refeições deve conter uma instrução de dieta!")
      end
    end
end
