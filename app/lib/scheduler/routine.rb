# frozen_string_literal: true

module Scheduler
  class Routine
    def self.expires_access_controls
      AccessControl.where(expires_at: ..Time.zone.now).update_all status: :expired
    end
  end
end
