# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert users.all?(&:valid?)
  end

  test "database defaults are set" do
    assert_not users(:leo).admin
  end

  test "mandatory attributes are validated" do
    blank = User.new

    assert blank.invalid?
    assert_equal 2, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:email]
    assert_equal ["obrigatório"], blank.errors[:password]
  end
end
