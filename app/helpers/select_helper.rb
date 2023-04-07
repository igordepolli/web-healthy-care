# frozen_string_literal: true

module SelectHelper
  def choices_for(model, attribute, sort: true)
    options_for_enum(model.class, attribute, sort)
  end

  private
    def options_for_enum(klass, attribute, sort)
      keys   ||= klass.send(attribute.to_s.pluralize).keys
      options  = keys.map { |key| [translate_enum_value(klass, attribute, key), key] }

      sort ? options.sort_by(&:first) : options
    end

    def translate_enum_value(klass, attribute, value, sufix: nil)
      klass.human_attribute_name([attribute, sufix, value].reject(&:blank?).join("."))
    end
end
