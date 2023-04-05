# frozen_string_literal: true

class MedicationPrescription < ApplicationRecord
  belongs_to :prescription
  belongs_to :medication

  validates :dosage, :schedule, presence: true
end
