# frozen_string_literal: true

class Patient < ApplicationRecord
  belongs_to :user

  has_many :diseases, through: :disease_patients, class_name: "Disease"
  has_many :appointments, class_name: "DoctorAppointment"

  validates :name, :last_name, presence: true
  validates :cpf, cpf: true, uniqueness: { allow_blank: true }
  validates :email, email: true, uniqueness: { allow_blank: true }
end
