# frozen_string_literal: true

require "test_helper"

class DietTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert diets.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Diet.new

    assert blank.invalid?
    assert_equal 4, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:source]
    assert_equal ["obrigatório"], blank.errors[:breakfast]
    assert_equal ["obrigatório"], blank.errors[:lunch]
    assert_equal ["obrigatório"], blank.errors[:dinner]
  end
end
