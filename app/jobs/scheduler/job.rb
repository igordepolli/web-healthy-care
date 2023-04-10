# frozen_string_literal: true

module Scheduler
  class Job < ApplicationJob
    queue_as :critical
    sidekiq_options retry: 3

    def perform(klass, method)
      time = Time.zone.now
      Slack::Scheduler.new(klass, method).notify unless method.to_s == "workers_alive?"

      Class.const_get("Scheduler::#{klass}").send(method)

      time = Time.zone.now - time
      Slack::Scheduler.new(klass, method, time).notify unless method.to_s == "workers_alive?"
    rescue StandardError => error
      Sentry.capture_exception(error)
    end
  end
end
