# frozen_string_literal: true

class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    Date.parse(value.to_s)
  rescue ArgumentError
    record.errors.add(attribute, "não é uma data válida!")
  end
end
