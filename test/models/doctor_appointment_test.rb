# frozen_string_literal: true

require "test_helper"

class DoctorAppointmentTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert doctor_appointments.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = DoctorAppointment.new

    assert blank.invalid?
    assert_equal 3, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:patient]
    assert_equal ["obrigatório"], blank.errors[:doctor]
    assert_equal ["obrigatório"], blank.errors[:date]
  end
end
