# frozen_string_literal: true

require "test_helper"

class PatientTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert patients.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Patient.new

    assert blank.invalid?
    assert_equal 3, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:name]
    assert_equal ["obrigatório"], blank.errors[:last_name]
    assert_equal ["obrigatório"], blank.errors[:user]
  end

  test "email validator" do
    patients(:leo).email = "leozin.com.br"

    assert patients(:leo).invalid?
    assert_equal 1, patients(:leo).errors.count
    assert_equal ["não é um email válido"], patients(:leo).errors[:email]

    patients(:leo).email = "leozin@gmail.com"

    assert patients(:leo).valid?
  end

  test "cpf validator" do
    patients(:leo).cpf = "12345678910"

    assert patients(:leo).invalid?
    assert_equal 1, patients(:leo).errors.count
    assert_equal ["CPF inválido"], patients(:leo).errors[:cpf]

    patients(:leo).cpf = "153.316.417-76"

    assert patients(:leo).valid?
  end

  test "uniqueness cpf" do
    patients(:leo).update_column :cpf, "153.316.417-76"

    new_patient = patients(:leo).dup

    assert new_patient.invalid?
    assert_equal 1, new_patient.errors.count
    assert_equal ["já foi usado"], new_patient.errors[:cpf]
  end

  test "uniqueness email" do
    patients(:leo).update_column :email, "leo@gmail.com"

    new_patient = patients(:leo).dup

    assert new_patient.invalid?
    assert_equal 1, new_patient.errors.count
    assert_equal ["já foi usado"], new_patient.errors[:email]
  end
end
