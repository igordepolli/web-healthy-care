# frozen_string_literal: true

class SchedulerJob
  include Sidekiq::Worker
  sidekiq_options queue: "critical"

  def perform(method)
    Scheduler::Routine.send(method)
  rescue StandardError => error
    Rails.logger.info(error)
  end
end
