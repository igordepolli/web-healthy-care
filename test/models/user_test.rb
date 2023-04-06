# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert users.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = User.new

    assert blank.invalid?
    assert_equal 3, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:email]
    assert_equal ["obrigatório"], blank.errors[:password]
    assert_equal ["obrigatório"], blank.errors[:classification]
  end
end
