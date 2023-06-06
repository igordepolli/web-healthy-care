# frozen_string_literal: true

require "test_helper"

class Exam::BiodataTest < ActiveSupport::TestCase
  test "build biodatum" do
    Biodatum.delete_all

    biodatum = exams(:hemogram).build_biodatum

    assert_equal exams(:hemogram), biodatum.exam
    assert_equal exams(:hemogram).patient, biodatum.patient
  end
end
