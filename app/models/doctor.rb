# frozen_string_literal: true

class Doctor < ApplicationRecord
  include Allowable

  belongs_to :user

  has_many :access_controls

  validates :name, :last_name, presence: true
  validates :cpf, presence: true, cpf: true, uniqueness: true
  validates :crm, presence: true, uniqueness: true
  validates :email, email: true, uniqueness: { allow_blank: true }

  def full_name
    "#{name} #{last_name}"
  end
end
