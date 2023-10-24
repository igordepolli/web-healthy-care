
# frozen_string_literal: true

require "test_helper"

class Patients::Diagnostics::SurgeriesTest < ActionDispatch::IntegrationTest
  setup do
    access_controls(:milena_leo).update_columns expires_at: Time.zone.now + 2.hours, status: :authorized

    sign_in users(:milena)
  end

  test "authorization" do
    sign_out users(:milena)
    get new_patient_diagnostic_surgery_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect

    sign_in users(:leo)
    get new_patient_diagnostic_surgery_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect

    sign_in users(:milena)
    get new_patient_diagnostic_surgery_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get new_patient_diagnostic_surgery_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect
  end

  test "layout" do
    get new_patient_diagnostic_surgery_path(patients(:leo), diagnostics(:leo_flu))

    assert_select "#aside-menu"

    assert_select "a[href='#{new_patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu))}']"
    assert_select "h2", text: "Cadastrar nova cirurgia"
    assert_select "form[action='#{patient_diagnostic_surgeries_path(patients(:leo), diagnostics(:leo_flu))}'][method='post']" do
      assert_select "input[name='surgery[date]']"
      assert_select "select[name='surgery[classification]']"
      assert_select "input[name='surgery[hospital]']"
      assert_select "input[name='surgery[discharged_at]']"
      assert_select "textarea[name='surgery[description]']"
      assert_select "input[type='submit'][value='Cadastrar']"
    end
  end

  test "create" do
    assert_difference -> { Surgery.count } => 1, -> { Treatment.count } => 1 do
      post patient_diagnostic_surgeries_path(patients(:leo), diagnostics(:leo_flu)), params: {
        surgery: { date: "2023-01-01", classification: "elective", hospital: "Hospital Santa Casa", discharged_at: "2023-01-03", medications_count: 1, description: "Deu tudo errado" }
      }

      surgery   = Surgery.last
      treatment = Treatment.last

      assert_redirected_to new_patient_diagnostic_surgery_medication_surgery_path(patients(:leo), diagnostics(:leo_flu), surgery)

      assert_equal patients(:leo),        surgery.patient
      assert_equal "2023-01-01",          surgery.date.to_s
      assert_equal "elective",            surgery.classification
      assert_equal "Hospital Santa Casa", surgery.hospital
      assert_equal "2023-01-03",          surgery.discharged_at.to_s
      assert_equal 1,                     surgery.medications_count
      assert_equal "Deu tudo errado",     surgery.description
      assert_equal treatment,             surgery.treatment

      assert_equal diagnostics(:leo_flu), treatment.diagnostic
      assert_equal patients(:leo),        treatment.patient
      assert_equal surgery,               treatment.treatable
      assert_equal surgery.date,          treatment.started_at
    end
  end

  test "create fails" do
    assert_no_difference -> { Surgery.count }, -> { Treatment.count } do
      post patient_diagnostic_surgeries_path(patients(:leo), diagnostics(:leo_flu)), params: {
        surgery: { date: "2023-01-01", classification: "elective", hospital: "Hospital Santa Casa", discharged_at: "2022-12-31" }
      }

      assert_response :unprocessable_entity
      assert_select ".alert", text: "Data da alta deve ser maior ou igual que 2023-01-01"
    end
  end
end
