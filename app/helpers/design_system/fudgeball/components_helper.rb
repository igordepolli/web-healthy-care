# frozen_string_literal: true

module DesignSystem::Fudgeball::ComponentsHelper
  def fudgeball_button(text, options = {}, html_options = {})
    url        = options.delete(:url)
    color      = options.delete(:color) || "blue"
    text_color = options.delete(:text_color) || "white"
    classes    = html_options.delete(:class)

    link_to text, url, class: "bg-#{color}-500 hover:bg-#{color}-700 text-#{text_color} font-bold py-2 px-4 rounded #{classes}", **html_options
  end
end
