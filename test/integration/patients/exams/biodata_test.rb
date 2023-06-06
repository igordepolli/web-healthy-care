
# frozen_string_literal: true

require "test_helper"

class Patients::Exams::BiodataTest < ActionDispatch::IntegrationTest
  setup do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    Biodatum.delete_all

    sign_in users(:milena)
  end

  test "authorization" do
    sign_out users(:milena)
    get new_patient_exam_biodatum_path(patients(:leo), exams(:hemogram))
    assert_response :redirect

    sign_in users(:leo)
    get new_patient_exam_biodatum_path(patients(:leo), exams(:hemogram))
    assert_response :redirect

    sign_in users(:milena)
    get new_patient_exam_biodatum_path(patients(:leo), exams(:hemogram))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get new_patient_exam_biodatum_path(patients(:leo), exams(:hemogram))
    assert_response :redirect
  end

  test "layout" do
    get new_patient_exam_biodatum_path(patients(:leo), exams(:hemogram))

    assert_select "#aside-menu"

    assert_select "a[href='#{patient_exam_path(patients(:leo), exams(:hemogram))}']"
    assert_select "h2", text: "Cadastrar resultados do exame"
    assert_select "form[action='#{patient_exam_biodata_path(patients(:leo), exams(:hemogram))}'][method='post']" do
      assert_select "input[name='biodatum[systolic_pressure]']"
      assert_select "input[name='biodatum[diastolic_pressure]']"
      assert_select "input[name='biodatum[glycemia]']"
      assert_select "input[name='biodatum[heart_rate]']"
      assert_select "input[name='biodatum[cholesterol]']"
      assert_select "input[name='biodatum[triglyceride]']"
      assert_select "input[name='biodatum[creatinine]']"

      assert_select "input[type='submit'][value='Cadastrar']"
    end
  end

  test "create" do
    assert_difference -> { Biodatum.count } => 1 do
      post patient_exam_biodata_path(patients(:leo), exams(:hemogram)), params: {
        biodatum: { systolic_pressure: "12", diastolic_pressure: "8", glycemia: "10", heart_rate: "12", cholesterol: "14", triglyceride: "16", creatinine: "18.3" }
      }

      biodatum  = Biodatum.last

      assert_redirected_to patient_exam_path(patients(:leo), exams(:hemogram))

      assert_equal patients(:leo),   biodatum.patient
      assert_equal exams(:hemogram), biodatum.exam
      assert_equal 12,               biodatum.systolic_pressure
      assert_equal 8,                biodatum.diastolic_pressure
      assert_equal 10,               biodatum.glycemia
      assert_equal 12,               biodatum.heart_rate
      assert_equal 14,               biodatum.cholesterol
      assert_equal 16,               biodatum.triglyceride
      assert_equal 18.3,             biodatum.creatinine
    end
  end

  test "create fails" do
    assert_no_difference -> { Biodatum.count } do
      post patient_exam_biodata_path(patients(:leo), exams(:hemogram)), params: {
        biodatum: { systolic_pressure: "12.8" }
      }

      assert_response :unprocessable_entity
      assert_select ".alert", text: "Pressão sistólica não é um número inteiro"
    end
  end
end
