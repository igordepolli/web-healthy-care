# frozen_string_literal: true

require "test_helper"
require "scheduler/routine"

module Scheduler
  class RoutineTest < ActiveSupport::TestCase
    test "clean access controls" do
      assert_no_difference -> { AccessControl.count } do
        Routine.clean_access_controls
      end

      access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

      assert_difference -> { AccessControl.count } => -1 do
        Routine.clean_access_controls
      end
    end
  end
end
