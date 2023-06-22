# frozen_string_literal: true

require "test_helper"

class SurgeryTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert surgeries.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Surgery.new

    assert blank.invalid?
    assert_equal 5, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:patient]
    assert_equal ["obrigatório"], blank.errors[:classification]
    assert_equal ["obrigatório"], blank.errors[:date]
    assert_equal ["obrigatório", "não é um número"], blank.errors[:medications_count]
  end

  test "don't allow discharged at before date" do
    assert_raise ActiveRecord::RecordInvalid, "Data do fim deve ser maior ou igual que #{surgeries(:septoplasty).date.strftime("%Y-%m-%d")}" do
      surgeries(:septoplasty).update! discharged_at: 1.day.ago
    end
  end
end
