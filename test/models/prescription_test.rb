# frozen_string_literal: true

require "test_helper"

class PrescriptionTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert prescriptions.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Prescription.new

    assert blank.invalid?
    assert_equal 3, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:patient]
    assert_equal ["obrigatório"], blank.errors[:date]
    assert_equal ["Você deve adicionar o anexo de prescrição dos medicamentos!"], blank.errors[:file]
  end
end
