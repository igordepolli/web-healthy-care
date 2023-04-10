# frozen_string_literal: true

require_relative "../../app/lib/scheduler"

namespace :festalab do
  namespace :scheduler do
    include Scheduler

    task hour: :environment do
      hour
    end
  end
end
