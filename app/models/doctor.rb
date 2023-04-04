# frozen_string_literal: true

class Doctor < ApplicationRecord
  belongs_to :user

  validates :name, :last_name, presence: true
  validates :cpf, presence: true, cpf: true, uniqueness: true
  validates :crm, presence: true, uniqueness: true
  validates :email, email: true, uniqueness: { allow_blank: true }
end
