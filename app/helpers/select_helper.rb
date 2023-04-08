# frozen_string_literal: true

module SelectHelper
  def choices_for(model, attribute)
    choices_for_enum(model.class, attribute)
  end

  private
    def choices_for_enum(klass, attribute)
      pluralized_attribute = attribute.to_s.pluralize

      method = if klass.respond_to?("public_#{pluralized_attribute}")
        "public_#{pluralized_attribute}"
      else
        pluralized_attribute
      end

      klass.send(method).keys.map { [translate_enum_value(klass, attribute, _1), _1] }.sort_by(&:first)
    end

    def translate_enum_value(klass, attribute, value, sufix: nil)
      klass.human_attribute_name([attribute, sufix, value].reject(&:blank?).join("."))
    end
end
