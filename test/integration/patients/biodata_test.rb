
# frozen_string_literal: true

require "test_helper"

class Patients::BiodataTest < ActionDispatch::IntegrationTest
  setup do
    access_controls(:milena_leo).update_columns expires_at: Time.zone.now + 2.hours, status: :authorized

    sign_in users(:milena)
  end

  test "authorization show" do
    get patient_biodata_path(patients(:leo))
    assert_response :ok

    sign_out users(:milena)
    get patient_biodata_path(patients(:leo))
    assert_response :redirect

    sign_in users(:leo)
    get patient_biodata_path(patients(:leo))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    sign_in users(:milena)
    get patient_biodata_path(patients(:leo))
    assert_response :redirect
  end

  test "layout show" do
    get patient_biodata_path(patients(:leo))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "p", text: "Data do exame: #{Time.current.strftime("%d/%m/%Y")}"
      assert_select "p", text: "Tipo do exame: Hemograma"
      assert_select "a[href='#{patient_exam_path(patients(:leo), exams(:hemogram))}']"

      assert_select "th", text: "Pressão sistólica"
      assert_select "td", text: "12"

      assert_select "th", text: "Pressão diastólica"
      assert_select "td", text: "8"
    end
  end
end
