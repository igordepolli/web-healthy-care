# frozen_string_literal: true

class Patient < ApplicationRecord
  has_one :user

  validates :name, :last_name, presence: true
end
