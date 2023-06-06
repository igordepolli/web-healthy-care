# frozen_string_literal: true

require "test_helper"

class BiodatumTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert biodata.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Biodatum.new

    assert blank.invalid?
    assert_equal 3, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:patient]
    assert_equal ["obrigatório"], blank.errors[:exam]
    assert_equal ["Pelo menos um dos biodados deve ter resultados!"], blank.errors[:base]
  end

  test "numericality attributes are validated" do
    blank = Biodatum.new patient: patients(:leo), exam: exams(:hemogram), systolic_pressure: 1.1, diastolic_pressure: 1.1, glycemia: 1.1, heart_rate: 1.1, cholesterol: 1.1, triglyceride: 1.1, creatinine: 1.1

    assert blank.invalid?
    assert_equal 6, blank.errors.count
    assert_equal ["não é um número inteiro"], blank.errors[:systolic_pressure]
    assert_equal ["não é um número inteiro"], blank.errors[:diastolic_pressure]
    assert_equal ["não é um número inteiro"], blank.errors[:glycemia]
    assert_equal ["não é um número inteiro"], blank.errors[:heart_rate]
    assert_equal ["não é um número inteiro"], blank.errors[:cholesterol]
    assert_equal ["não é um número inteiro"], blank.errors[:triglyceride]
  end
end
