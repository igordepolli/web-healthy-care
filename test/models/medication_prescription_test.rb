# frozen_string_literal: true

require "test_helper"

class MedicationPrescriptionTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert medication_prescriptions.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = MedicationPrescription.new

    assert blank.invalid?
    assert_equal 4, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:medication]
    assert_equal ["obrigatório"], blank.errors[:prescription]
    assert_equal ["obrigatório"], blank.errors[:dosage]
    assert_equal ["obrigatório"], blank.errors[:schedule]
  end
end
