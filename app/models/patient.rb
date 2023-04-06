# frozen_string_literal: true

class Patient < ApplicationRecord
  belongs_to :user

  has_many :diagnostics
  has_many :consultations

  validates :name, :last_name, presence: true
  validates :cpf, cpf: true, uniqueness: { allow_blank: true }
  validates :email, email: true, uniqueness: { allow_blank: true }
end
