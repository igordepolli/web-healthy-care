# frozen_string_literal: true

class Patient < ApplicationRecord
  include Biodata

  belongs_to :user

  has_many :access_controls
  has_many :consultations
  has_many :diagnostics
  has_many :surgeries
  has_many :diets
  has_many :prescriptions
  has_many :exams

  validates :name, :last_name, :city, presence: true
  validates :rg, uniqueness: { allow_blank: true }
  validates :cpf, cpf: true, uniqueness: { allow_blank: true }
  validates :email, email: true, uniqueness: { allow_blank: true }
  validates :state, presence: true, inclusion: { in: ::STATE_ABBREVIATIONS }

  def full_name
    "#{name} #{last_name}"
  end
end
