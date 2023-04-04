# frozen_string_literal: true

class Treatment < ApplicationRecord
  enum :classification, { medication: 0, surgery: 1, physiotherapy: 2, therapy: 3, diet: 4 }

  belongs_to :disease_patient

  validates :classification, presence: true
  validates :started_at, presence: true, date: true
  validates :ended_at, date: true
end
