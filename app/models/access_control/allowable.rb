# frozen_string_literal: true

module AccessControl::Allowable
  extend ActiveSupport::Concern

  included do
    def allow!
      update! expires_at: Time.zone.now + 2.hours, status: :authorized
    end
  end
end
