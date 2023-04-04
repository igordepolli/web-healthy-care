# frozen_string_literal: true

class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless cpf_valid?(value)
      record.errors.add(attribute, options[:message] || "CPF inválido")
    end
  end

  private
    def cpf_valid?(cpf)
      return false if cpf.blank?
      cpf = cpf.to_s.gsub(/[^0-9]/, "")
      return false if cpf.size != 11
      return false if cpf.match?(/(\d)\1{10}/)

      sum = 0
      (0..8).each do |i|
        sum += cpf[i].to_i * (10 - i)
      end

      sum_result = (sum * 10) % 11
      sum_result = 0 if sum_result == 10

      return false if sum_result != cpf[9].to_i

      sum = 0
      (0..9).each do |i|
        sum += cpf[i].to_i * (11 - i)
      end

      sum_result = (sum * 10) % 11
      sum_result = 0 if sum_result == 10

      return false if sum_result != cpf[10].to_i

      true
    end
end
