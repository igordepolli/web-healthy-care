# frozen_string_literal: true

require "test_helper"
require "scheduler/routine"

module Scheduler
  class RoutineTest < ActiveSupport::TestCase
    test "expires access controls" do
      access_controls(:milena_leo).update_columns expires_at: Time.zone.now - 1.minute, status: :authorized

      assert_changes -> { access_controls(:milena_leo).reload.status }, from: "authorized", to: "expired" do
        Routine.expires_access_controls
      end
    end
  end
end
