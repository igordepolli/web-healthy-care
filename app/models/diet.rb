# frozen_string_literal: true

class Diet < ApplicationRecord
  belongs_to :patient

  has_one :treatment, as: :treatable

  validates :date, presence: true, date: true

  validate :at_least_one_of_meals_not_nil

  private
    def at_least_one_of_meals_not_nil
      if [breakfast, lunch, dinner, morning_snack, afternoon_snack].all?(&:blank?)
        errors.add(:base, "Pelo menos uma das refeições deve conter uma instrução de dieta!")
      end
    end
end
