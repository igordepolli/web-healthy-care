# frozen_string_literal: true

# app/validators/crm_validator.rb
class CrmValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless valid_crm?(value)
      record.errors.add(attribute, options[:message] || "inválido")
    end
  end

  private
    def valid_crm?(value)
      # Número seguido de traço e sigla de um dos 27 estados do Brasil
      return true if value.match?(/^\d+-[A-Z]{2}$/) && ::STATE_ABBREVIATIONS.include?(value[-2..-1])

      # Sigla CRM/Estado seguido de números
      return true if value.match?(/^CRM\/[A-Z]{2}\s\d+$/) && ::STATE_ABBREVIATIONS.include?(value[4..5])

      # Número seguido da letra ‘P’
      return true if value.match?(/\d+P$/)

      # Número precedido da sigla ‘EME’
      return true if value.match?(/^EME\d+P$/)

      # Número precedido do número ‘300’
      return true if value.match?(/^300\d+P$/)

      false
    end
end
