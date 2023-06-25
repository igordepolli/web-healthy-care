# frozen_string_literal: true

module ApplicationHelper
  def mobile?
    return false if Rails.env.test?

    user_agent = request.user_agent.downcase
    user_agent.include?("mobile") || user_agent.include?("android") || user_agent.include?("iphone")
  end

  def desktop?
    !mobile?
  end
end
