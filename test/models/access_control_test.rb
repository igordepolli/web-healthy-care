require "test_helper"

class AccessControlTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert access_controls.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = AccessControl.new

    assert blank.invalid?
    assert_equal 2, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:patient]
    assert_equal ["obrigatório"], blank.errors[:doctor]
  end
end
