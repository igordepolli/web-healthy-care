# frozen_string_literal: true

class Medication < ApplicationRecord
  validates :name, presence: true
end
