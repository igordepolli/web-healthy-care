# frozen_string_literal: true

module SetVariant
  extend ActiveSupport::Concern

  included do
    before_action -> { request.variant = platform }
  end

  private
    def platform
      mobile? ? :mobile : :desktop
    end

    def mobile?
      return false if Rails.env.test?

      user_agent = request.user_agent.downcase
      user_agent.include?("mobile") || user_agent.include?("android") || user_agent.include?("iphone")
    end
end
