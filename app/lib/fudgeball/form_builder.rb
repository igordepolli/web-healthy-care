# frozen_string_literal: true

class Fudgeball::FormBuilder < ActionView::Helpers::FormBuilder
  include SelectHelper

  def input(attribute, type = "text", options = {})
    @template.content_tag "div", class: "field" do
      @template.concat(label(attribute, options))
      @template.concat(form_field(attribute, type, options))
    end
  end

  def submit(text, options = {})
    color   = options.delete(:color) || :primary
    classes = options.delete(:class)

    super text, class: "btn-#{color} #{classes}".squish, **options
  end

  def select(attribute, options = {}, html_options = {})
    choices = options.delete(:choices) || choices_for(object, attribute)

    @template.content_tag "div", class: "field" do
      @template.concat(label(attribute, options))
      @template.concat(super(attribute, choices, options, html_options))
    end
  end

  def label(attribute, options = {})
    label = options.delete(:label)
    label = translate_attribute(attribute) if label.nil?

    super(attribute, label, options) if label
  end

  def attach_input(attribute, options = {})
    @template.content_tag "div", class: "field" do
      @template.concat(label(attribute, options))
      @template.concat(file_field(attribute, options))
    end
  end

  private
    def form_field(attribute, type, options)
      if respond_to?("#{type}_field")
        send("#{type}_field", attribute, options)
      else
        text_field_with_data_mask(attribute, type, options)
      end
    end

    def text_field_with_data_mask(attribute, type, options)
      options[:data] ||= {}
      options[:data][:mask_target] = type
      text_field attribute, options
    end

    def translate_attribute(attribute)
      I18n.t(attribute, scope: "activerecord.attributes.#{object.class.model_name.singular}")
    end
end
