# frozen_string_literal: true

require "test_helper"

class PrescriptionTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert prescriptions.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Prescription.new

    assert blank.invalid?
    assert_equal 2, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:treatment]
    assert_equal ["Você deve adicionar o anexo de prescrição dos medicamentos!"], blank.errors[:file]
  end
end
