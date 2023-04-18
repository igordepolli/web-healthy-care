# frozen_string_literal: true

class Treatment < ApplicationRecord
  belongs_to :diagnostic
  belongs_to :treatable, polymorphic: true, optional: true

  delegate :patient, to: :diagnostic

  validates :started_at, presence: true, date: true
  validates :ended_at, date: true
end
