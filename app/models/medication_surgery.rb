# frozen_string_literal: true

class MedicationSurgery < ApplicationRecord
  belongs_to :surgery
  belongs_to :medication

  delegate :name, to: :medication

  validates :dosage, presence: true
end
