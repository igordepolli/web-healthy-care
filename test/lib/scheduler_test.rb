# frozen_string_literal: true

require "test_helper"
require "scheduler"

class SchedulerTest < ActiveSupport::TestCase
  include Scheduler

  test "hour" do
    self.tasks = [Task.new("name", [0, 1])]

    Time.zone.stub :now, Time.new(2023, 1, 1, 0) do
      assert_difference -> { SchedulerJob.jobs.size } => 1 do
        hour
      end
    end

    Time.zone.stub :now, Time.new(2023, 1, 1, 2) do
      assert_no_difference -> { SchedulerJob.jobs.size } do
        hour
      end
    end
  end
end
