# frozen_string_literal: true

class Patient < ApplicationRecord
  belongs_to :user

  validates :name, :last_name, presence: true
  validates :email, format: { allow_blank: true, with: URI::MailTo::EMAIL_REGEXP, message: "deve ser um endereço de e-mail válido" }
end
