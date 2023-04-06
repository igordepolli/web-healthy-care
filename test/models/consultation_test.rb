# frozen_string_literal: true

require "test_helper"

class ConsultationTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert consultations.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Consultation.new

    assert blank.invalid?
    assert_equal 3, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:patient]
    assert_equal ["obrigatório"], blank.errors[:doctor]
    assert_equal ["obrigatório"], blank.errors[:date]
  end
end
