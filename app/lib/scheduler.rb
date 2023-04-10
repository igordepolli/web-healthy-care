# frozen_string_literal: true

module Scheduler
  Task = Struct.new(:name, :hours)

  mattr_accessor :tasks, default: [
    Task.new("clean_access_controls", [6, 18])
  ]

  def hour
    tasks.each do |task|
      if Time.zone.now.hour.in?(task.hours)
        SchedulerJob.perform_async(task.name)
      end
    end
  end
end
