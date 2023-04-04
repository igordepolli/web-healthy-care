require "test_helper"

class PatientTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert patients.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Patient.new

    assert blank.invalid?
    assert_equal 3, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:name]
    assert_equal ["obrigatório"], blank.errors[:last_name]
    assert_equal ["obrigatório"], blank.errors[:user]
  end
end
