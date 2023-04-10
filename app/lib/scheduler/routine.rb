# frozen_string_literal: true

module Scheduler
  class Routine
    def self.clean_access_controls
      AccessControl.where(expires_at: ..Time.zone.now).delete_all
    end
  end
end
