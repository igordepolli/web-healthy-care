# frozen_string_literal: true

require "test_helper"

class PrescriptionTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert prescriptions.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Prescription.new

    assert blank.invalid?
    assert_equal ["obrigatório"], blank.errors[:patient]
    assert_equal ["obrigatório"], blank.errors[:date]
    assert_equal ["obrigatório", "não é um número"], blank.errors[:medications_count]
    assert_equal ["de prescrição obrigátorio!"], blank.errors[:file]
  end
end
