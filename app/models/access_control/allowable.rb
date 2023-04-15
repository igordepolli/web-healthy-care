# frozen_string_literal: true

module AccessControl::Allowable
  extend ActiveSupport::Concern

  included do
    def allowed?
      expires_at&.future?
    end

    def waiting_allow?
      expires_at.nil?
    end

    def allow!
      update! expires_at: Time.zone.now + 2.hours
    end
  end
end
