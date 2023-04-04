# frozen_string_literal: true

class Disease < ApplicationRecord
  validates :name, presence: true
end
