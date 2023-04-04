# frozen_string_literal: true

class DiseasePatient < ApplicationRecord
  enum :status, { inactive: 0, active: 1, chronic: 2, acute: 3, remission: 4, terminal: 5 }, default: :active

  belongs_to :disease
  belongs_to :patient

  # has_one :treatment

  validates :diagnostic_date, presence: true
  validates :status, presence: true, uniqueness: { scope: [:disease_id, :patient_id], message: "O paciente já tem essa doença com este mesmo status!" }
end
