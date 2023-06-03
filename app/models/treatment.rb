# frozen_string_literal: true

class Treatment < ApplicationRecord
  belongs_to :diagnostic
  belongs_to :treatable, polymorphic: true

  delegate :patient, to: :diagnostic

  validates :started_at, date: true
  validates :ended_at, date: true, comparison: { greater_than_or_equal_to: :started_at, allow_blank: true }
end
