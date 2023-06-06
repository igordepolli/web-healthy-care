# frozen_string_literal: true

require "test_helper"

class Patient::BiodataTest < ActiveSupport::TestCase
  test "biodatum" do
    assert_equal biodata(:biodata_leo), patients(:leo).biodatum

    exam     = Exam.create! patient: patients(:leo), date: Time.zone.now, classification: :hemogram, local: "Laboratório Exemplo"
    biodatum = Biodatum.create! patient: patients(:leo), exam:, systolic_pressure: 12, diastolic_pressure: 8

    assert_equal biodatum, patients(:leo).biodatum
  end

  test "biodata" do
    assert_equal [biodata(:biodata_leo)], patients(:leo).biodata

    exam     = Exam.create! patient: patients(:leo), date: Time.zone.now, classification: :hemogram, local: "Laboratório Exemplo"
    biodatum = Biodatum.create! patient: patients(:leo), exam:, systolic_pressure: 12, diastolic_pressure: 8

    assert_equal [biodata(:biodata_leo), biodatum], patients(:leo).biodata
  end
end
