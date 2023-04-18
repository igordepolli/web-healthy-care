# frozen_string_literal: true

require "test_helper"

class TreatmentTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert treatments.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Treatment.new

    assert blank.invalid?
    assert_equal 2, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:diagnostic]
    assert_equal ["obrigatório"], blank.errors[:started_at]
  end
end
