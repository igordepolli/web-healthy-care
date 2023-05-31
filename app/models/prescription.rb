# frozen_string_literal: true

class Prescription < ApplicationRecord
  belongs_to :patient

  has_many :medications, class_name: "MedicationPrescription"

  has_one :treatment, as: :treatable

  has_one_attached :file

  validates :date, presence: true, date: true
  validates :medications_count, presence: true, numericality: { greater_than: 0, only_integer: true }

  validate :check_file_presence

  private
    def check_file_presence
      errors.add(:file, "de prescrição obrigátorio!") unless file.attached?
    end
end
