# frozen_string_literal: true

class AccessControl < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient

  validates :expires_at, date: true
end
