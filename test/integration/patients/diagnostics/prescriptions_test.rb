# frozen_string_literal: true

require "test_helper"

class Patients::Diagnostics::PrescriptionsTest < ActionDispatch::IntegrationTest
  setup do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    sign_in users(:milena)
  end

  test "authorization" do
    sign_out users(:milena)
    get new_patient_diagnostic_prescription_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect

    sign_in users(:leo)
    get new_patient_diagnostic_prescription_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect

    sign_in users(:milena)
    get new_patient_diagnostic_prescription_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get new_patient_diagnostic_prescription_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect
  end

  test "layout" do
    get new_patient_diagnostic_prescription_path(patients(:leo), diagnostics(:leo_flu))

    assert_select "#aside-menu"

    assert_select "a[href='#{patient_diagnostic_treatments_path(patients(:leo), diagnostics(:leo_flu))}']"
    assert_select "h2", text: "Cadastrar nova receita"
    assert_select "form[action='#{patient_diagnostic_prescriptions_path(patients(:leo), diagnostics(:leo_flu))}'][method='post']" do
      assert_select "input[name='prescription[date]']"
      assert_select "input[name='prescription[medications_count]']"
      assert_select "input[name='prescription[file]']"
      assert_select "input[type='submit'][value='Cadastrar']"
    end
  end

  test "create" do
    assert_difference -> { Prescription.count } => 1 do
      post patient_diagnostic_prescriptions_path(patients(:leo), diagnostics(:leo_flu)), params: {
        prescription: { date: "2023-01-01", medications_count: 2, file: fixture_file_upload("test/fixtures/files/sick_note.pdf", "application/pdf") }
      }

      prescription = Prescription.last

      assert_redirected_to new_patient_diagnostic_prescription_medication_prescription_path(patients(:leo), diagnostics(:leo_flu), prescription)

      assert_equal patients(:leo),        prescription.patient
      assert_equal "2023-01-01",          prescription.date.to_s
      assert_equal 2,                     prescription.medications_count
      assert_equal "sick_note.pdf",       prescription.file.filename.to_s
    end
  end

  test "create fails" do
    assert_no_difference -> { Prescription.count } do
      post patient_diagnostic_prescriptions_path(patients(:leo), diagnostics(:leo_flu)), params: {
        prescription: { date: "2023-01-01", medications_count: -1, file: fixture_file_upload("test/fixtures/files/sick_note.pdf", "application/pdf") }
      }

      assert_response :unprocessable_entity
      assert_select ".alert", text: "Quantidade de medicamentos deve ser maior que 0"
    end
  end
end
