# frozen_string_literal: true

require "test_helper"

class DietTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert diets.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Diet.new

    assert blank.invalid?
    assert_equal 3, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:source]
    assert_equal ["obrigatório"], blank.errors[:patient]
    assert_equal ["Pelo menos uma das refeições deve conter uma instrução de dieta!"], blank.errors[:base]
  end
end
