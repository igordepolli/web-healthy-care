# frozen_string_literal: true

require "test_helper"

class MedicationSurgeryTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert medication_surgeries.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = MedicationSurgery.new

    assert blank.invalid?
    assert_equal 3, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:medication]
    assert_equal ["obrigatório"], blank.errors[:surgery]
    assert_equal ["obrigatório"], blank.errors[:dosage]
  end
end
