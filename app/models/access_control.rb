# frozen_string_literal: true

class AccessControl < ApplicationRecord
  include Allowable

  enum :status, { pending: 0, authorized: 1, denied: 2, expired: 3 }, default: :pending

  belongs_to :doctor
  belongs_to :patient

  validates :expires_at, date: true
end
