# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]

    unless value.to_s.match?(EMAIL_REGEX)
      record.errors.add(attribute, options[:message] || "não é um email válido")
    end
  end
end
