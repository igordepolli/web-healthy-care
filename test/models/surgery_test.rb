# frozen_string_literal: true

require "test_helper"

class SurgeryTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert surgeries.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Surgery.new

    assert blank.invalid?
    assert_equal 4, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:patient]
    assert_equal ["obrigatório"], blank.errors[:doctor]
    assert_equal ["obrigatório"], blank.errors[:classification]
    assert_equal ["obrigatório"], blank.errors[:date]
  end
end
