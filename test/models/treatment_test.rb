# frozen_string_literal: true

require "test_helper"

class TreatmentTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert treatments.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Treatment.new

    assert blank.invalid?
    assert_equal 2, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:diagnostic]
    assert_equal ["obrigatório"], blank.errors[:treatable]
  end

  test "don't allow ended at before started at" do
    assert_raise ActiveRecord::RecordInvalid, "Data do fim deve ser maior ou igual que #{treatments(:diet_for_flu).started_at.strftime("%Y-%m-%d")}" do
      treatments(:diet_for_flu).update! ended_at: 1.day.ago
    end
  end
end
