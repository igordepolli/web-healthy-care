# frozen_string_literal: true

class AccessControl < ApplicationRecord
  include Allowable

  belongs_to :doctor
  belongs_to :patient

  validates :expires_at, date: true
end
