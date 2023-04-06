# frozen_string_literal: true

require "test_helper"

class ExamTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert exams.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Exam.new

    assert blank.invalid?
    assert_equal 5, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:patient]
    assert_equal ["obrigatório"], blank.errors[:consultation]
    assert_equal ["obrigatório"], blank.errors[:classification]
    assert_equal ["obrigatório"], blank.errors[:date]
    assert_equal ["obrigatório"], blank.errors[:local]
  end
end
