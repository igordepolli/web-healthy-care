# frozen_string_literal: true

class Doctor < ApplicationRecord
  belongs_to :user

  validates :name, :last_name, presence: true
  validates :cpf, cpf: true, uniqueness: true
  validates :crm, presence: true, uniqueness: true
  validates :email, email: { allow_blank: true }, uniqueness: { allow_blank: true }
end
