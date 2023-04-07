# frozen_string_literal: true

module DesignSystem::Fudgeball::ComponentsHelper
  def fudgeball_button(text, options = {}, html_options = {})
    url        = options.delete(:url)
    color      = options.delete(:color) || "teal"
    text_color = options.delete(:text_color) || "white"
    classes    = html_options.delete(:class)

    link_to text, url, class: "btn-primary #{classes}", **html_options
  end

  def fudgeball_navbar_button(text, options = {}, html_options = {})
    url     = options.delete(:url)
    classes = html_options.delete(:class)

    link_to text, url, class: "btn-tertiary #{classes}", **html_options
  end

  def fudgeball_form(model: nil, scope: nil, url: nil, format: nil, remote: true, **options, &block)
    options[:turbo]   = true unless options.key?(:turbo)
    options[:local]   = true
    options[:builder] = Fudgeball::FormBuilder
    options[:id]      = "#{(model ? fudgeball_form_id(model, options.delete(:prefix)) : scope)}_form"
    options[:data]    = fudgeball_form_data_turbo(options) if remote
    options[:data]    = options[:data].merge(controller: "mask")

    form_with model:, scope:, url:, format:, **options, &block
  end

  private
    def fudgeball_form_id(model, prefix = nil)
      model = model.last if model.is_a?(Array)
      dom_id(model, prefix)
    end

    def fudgeball_form_data_turbo(options)
      data = options[:data] || {}
      data[:turbo]  = false if options.delete(:turbo) == false
      data[:action] = "turbo:submit-start->form#validate #{options.dig(:data, :action)}".squish
      data
    end
end
