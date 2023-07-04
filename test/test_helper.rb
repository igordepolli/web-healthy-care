if ENV["COVERAGE"]
  require "simplecov"

  SimpleCov.start "rails" do
    add_filter ["test", "app/channels", "app/packs", "app/assets", "app/controllers", "app/jobs", "app/mailers"]
    add_group "Models", "app/models"
    add_group "Validators", "app/validators"
    add_group "Views", "app/views"
  end
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/mock"
require "sidekiq/testing"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  if ENV["COVERAGE"]
    parallelize_setup do |worker|
      SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
    end

    parallelize_teardown do |worker|
      SimpleCov.result
    end
  end

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Necessary helpers
  include Devise::Test::IntegrationHelpers

  # Add more helper methods to be used by all tests here...
end
