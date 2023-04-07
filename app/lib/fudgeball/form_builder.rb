# frozen_string_literal: true

class Fudgeball::FormBuilder < ActionView::Helpers::FormBuilder
  include SelectHelper

  def input(attribute, type = "text", options = {})
    label_text = options.delete(:label)

    @template.content_tag "div", class: "field" do
      label(attribute, label_text, options) + form_field(attribute, type, options)
    end
  end

  def submit(text, options = {})
    classes = options.delete(:class)

    super text, class: "btn-primary #{classes}".squish, **options
  end

  def select(attribute, options = {}, html_options = {})
    label_text = options.delete(:label)
    choices    = options.delete(:choices) || choices_for(object, attribute)

    @template.content_tag "div", class: "field" do
      label(attribute, label_text, html_options) + super(attribute, choices, options, html_options)
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
end
