# frozen_string_literal: true

module DesignSystem::Fudgeball::ComponentsHelper
  def fudgeball_button(text, options = {}, html_options = {})
    url        = options.delete(:url)
    color      = options.delete(:color) || :primary
    classes    = html_options.delete(:class)

    if options[:type] == :button
      tag.button text, class: "btn-#{color} #{classes}".squish, type: :button, **html_options
    else
      link_to text, url, class: "btn-#{color} #{classes}".squish, **html_options
    end
  end

  def fudgeball_return_button(url, options = {})
    classes = options.delete(:class)

    link_to url, class: "text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-full text-sm p-2.5 text-center inline-flex items-center #{classes}", **options do
      concat(fudgeball_icon "arrow-left", size: 30, color_stroke: :white)
    end
  end

  def fudgeball_call_to_action(text, options = {}, html_options = {})
    url     = options.delete(:url)
    icon    = options.delete(:icon)
    color   = options.delete(:color) || :blue
    classes = html_options.delete(:class)

    link_to url, class: "max-w-sm p-6 bg-#{color}-200 border border-gray-200 rounded-lg shadow flex flex-col items-center hover:bg-#{color}-100 #{classes}" do
      concat(fudgeball_icon(icon[:name], size: 80, color: icon[:color], color_stroke: icon[:color_stroke])) if icon
      concat(tag.h5 text, class: "mt-2 text-2xl font-semibold tracking-tight text-gray-900")
    end
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

  def fudgeball_form_alert(options = {})
    if flash[:alert].present? && flash[:alert] != "Você já está logado."
      message = flash[:alert]
      flash.discard
      fudgeball_alert(message, :red, options)
    elsif flash[:error].present? && flash[:error] != "Você já está logado."
      response = flash[:error]
      flash.discard

      content_tag "div", id: "alerts" do
        render_flash_error(response, options)
      end
    end
  end

  def fudgeball_alert(text, color, options = {})
    classes    = options.delete(:class)
    text_class = options.delete(:text_class)

    content_tag "div", class: "alert bg-#{color}-200 px-4 py-2 rounded #{classes}".squish, **options do
      concat(tag.p text, class: "text-center #{text_class}")
    end
  end

  def fudgeball_icon(icon, size: nil, color: nil, color_stroke: nil, width: nil, height: nil)
    return "" if icon.blank?

    svg = File.read("app/assets/images/icons/#{icon}.svg")
    svg.gsub!(/height=".*?"/, "height=\"#{height || size}\"") if height || size
    svg.gsub!(/width=".*?"/, "width=\"#{width || size}\"") if width || size
    svg.gsub!(/fill=".*?"/, "fill=\"#{color_to_hex(color)}\"") if color
    svg.gsub!(/stroke=".*?"/, "stroke=\"#{color_to_hex(color_stroke)}\"") if color_stroke
    svg.html_safe
  end

  def fudgeball_icon_link(icon, options = {}, html_options = {})
    url  = options.delete(:url)
    type = options.delete(:type)

    if type == :button
      tag.button class: "btn-icon", type: :button, **html_options do
        concat(fudgeball_icon(icon, **options))
      end
    else
      link_to url, class: "btn-icon", **html_options do
        concat(fudgeball_icon(icon, **options))
      end
    end
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

    def render_flash_error(response, options)
      if response.is_a?(Array)
        response.each { concat(fudgeball_alert(_1, :red, options)) }
      else
        concat(fudgeball_alert(response, :red, options))
      end
    end

    def color_to_hex(color)
      case color.to_sym
      when :green
        "#0E9F6E"
      when :red
        "#F05252"
      when :white
        "#FFFFFF"
      when :black
        "#000000"
      else
        "#3B82F6"
      end
    end
end
