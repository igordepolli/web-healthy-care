# frozen_string_literal: true

class Surgery < ApplicationRecord
  enum :classification, { elective: 0, urgency: 1, other: 2 }

  belongs_to :patient

  has_many :medications, class_name: "MedicationSurgery"

  has_one :treatment, as: :treatable

  validates :classification, presence: true
  validates :date, presence: true, date: true
  validates :medications_count, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :discharged_at, date: true, comparison: { greater_than_or_equal_to: :date, allow_blank: true }
end
