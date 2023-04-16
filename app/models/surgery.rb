# frozen_string_literal: true

class Surgery < ApplicationRecord
  enum :classification, { elective: 0, urgency: 1, other: 2 }

  belongs_to :patient
  belongs_to :doctor

  validates :classification, presence: true
  validates :date, presence: true, date: true
  validates :discharged_at, date: true
end
