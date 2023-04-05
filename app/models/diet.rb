# frozen_string_literal: true

class Diet < ApplicationRecord
  belongs_to :source, polymorphic: true

  validates :breakfast, :lunch, :dinner, presence: true
end
