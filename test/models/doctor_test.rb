# frozen_string_literal: true

require "test_helper"

class DoctorTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert doctors.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Doctor.new

    assert blank.invalid?
    assert_equal 6, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:name]
    assert_equal ["obrigatório"], blank.errors[:last_name]
    assert_equal ["obrigatório"], blank.errors[:crm]
    assert_equal ["obrigatório"], blank.errors[:cpf]
    assert_equal ["obrigatório"], blank.errors[:user]
    assert_equal ["obrigatório"], blank.errors[:specialty]
  end

  test "email validation" do
    doctors(:milena).email = "milena.com.br"

    assert doctors(:milena).invalid?
    assert_equal 1, doctors(:milena).errors.count
    assert_equal ["não é um email válido"], doctors(:milena).errors[:email]

    doctors(:milena).email = "milena@gmail.com"

    assert doctors(:milena).valid?
  end

  test "cpf validator" do
    doctors(:milena).cpf = "12345678910"

    assert doctors(:milena).invalid?
    assert_equal 1, doctors(:milena).errors.count
    assert_equal ["inválido"], doctors(:milena).errors[:cpf]

    doctors(:milena).cpf = "153.316.417-76"

    assert doctors(:milena).valid?
  end

  test "crm validator" do
    doctors(:milena).crm = "431234"

    assert doctors(:milena).invalid?
    assert_equal 1, doctors(:milena).errors.count
    assert_equal ["inválido"], doctors(:milena).errors[:crm]

    doctors(:milena).crm = "431234-ES"

    assert doctors(:milena).valid?
  end

  test "uniqueness cpf" do
    new_doctor = doctors(:milena).dup
    new_doctor.crm = "456789-ES"

    assert new_doctor.invalid?
    assert_equal 1, new_doctor.errors.count
    assert_equal ["já foi usado"], new_doctor.errors[:cpf]
  end

  test "uniqueness crm" do
    new_doctor = doctors(:milena).dup
    new_doctor.cpf = "873.981.950-79"

    assert new_doctor.invalid?
    assert_equal 1, new_doctor.errors.count
    assert_equal ["já foi usado"], new_doctor.errors[:crm]
  end

  test "uniqueness email" do
    doctors(:milena).update_column :email, "milena@gmail.com"

    new_doctor = doctors(:milena).dup
    new_doctor.cpf = "873.981.950-79"
    new_doctor.crm = "456789-ES"

    assert new_doctor.invalid?
    assert_equal 1, new_doctor.errors.count
    assert_equal ["já foi usado"], new_doctor.errors[:email]
  end

  test "full name" do
    assert_equal "Milena Regiani", doctors(:milena).full_name
  end
end
