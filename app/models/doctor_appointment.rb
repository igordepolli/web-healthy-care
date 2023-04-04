# frozen_string_literal: true

class DoctorAppointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor

  has_one_attached :sick_note

  validates :date, presence: true, date: true
end
