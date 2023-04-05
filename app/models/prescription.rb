# frozen_string_literal: true

class Prescription < ApplicationRecord
  belongs_to :treatment

  has_one_attached :file

  validate :check_file_presence

  private
    def check_file_presence
      errors.add(:file, "Você deve adicionar o anexo de prescrição dos medicamentos!") unless file.attached?
    end
end
