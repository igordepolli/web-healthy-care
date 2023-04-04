# frozen_string_literal: true

require "test_helper"

class MedicationTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert medications.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Medication.new

    assert blank.invalid?
    assert_equal 1, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:name]
  end
end
