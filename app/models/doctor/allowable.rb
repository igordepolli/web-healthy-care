# frozen_string_literal: true

module Doctor::Allowable
  extend ActiveSupport::Concern

  included do
    def allowed_by?(patient)
      access_controls.where(patient:, expires_at: Time.zone.now..2.hours.from_now).exists?
    end
  end
end
