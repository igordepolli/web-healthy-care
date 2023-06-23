# frozen_string_literal: true

require "test_helper"

class Patients::Diagnostics::Surgeries::MedicationSurgeriesTest < ActionDispatch::IntegrationTest
  setup do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    @patient      = patients(:leo)
    @diagnostic   = diagnostics(:leo_flu)
    @surgery      = surgeries(:septoplasty)

    sign_in users(:milena)
  end

  test "authorization" do
    sign_out users(:milena)
    get new_patient_diagnostic_surgery_medication_surgery_path(@patient, @diagnostic, @surgery)
    assert_response :redirect

    sign_in users(:leo)
    get new_patient_diagnostic_surgery_medication_surgery_path(@patient, @diagnostic, @surgery)
    assert_response :redirect

    sign_in users(:milena)
    get new_patient_diagnostic_surgery_medication_surgery_path(@patient, @diagnostic, @surgery)
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get new_patient_diagnostic_surgery_medication_surgery_path(@patient, @diagnostic, @surgery)
    assert_response :redirect
  end

  test "layout" do
    get new_patient_diagnostic_surgery_medication_surgery_path(@patient, @diagnostic, @surgery)

    assert_select "#aside-menu"

    assert_select "a[href='#{edit_patient_diagnostic_surgery_path(@patient, @diagnostic, @surgery)}']"
    assert_select "h2", text: "Inserir medicamentos"
    assert_select "form[action='#{patient_diagnostic_surgery_medication_surgeries_path(@patient, @diagnostic, @surgery)}'][method='post']" do
      assert_select "select[name='surgery[medications][][medication]']"
      assert_select "input[name='surgery[medications][][dosage]']"
      assert_select "input[type='submit'][value='Cadastrar']"
    end
  end

  test "create" do
    assert_difference -> { MedicationSurgery.count } => 1 do
      post patient_diagnostic_surgery_medication_surgeries_path(@patient, @diagnostic, @surgery), params: {
        surgery: {
          medications: [
            { medication: medications(:paracetamol).id, dosage: "20ml" }
          ]
        }
      }

      medication_surgery = MedicationSurgery.last

      assert_redirected_to patient_diagnostic_treatment_path(@patient, @diagnostic, @surgery.treatment)

      assert_equal medications(:paracetamol), medication_surgery.medication
      assert_equal "20ml",                    medication_surgery.dosage
    end
  end

  test "create fails" do
    assert_no_difference -> { MedicationSurgery.count }, -> { Treatment.count } do
      post patient_diagnostic_surgery_medication_surgeries_path(@patient, @diagnostic, @surgery), params: {
        surgery: {
          medications: [
            { medication: medications(:paracetamol).id }
          ]
        }
      }

      assert_response :unprocessable_entity
      assert_select ".alert", text: "Dosagem obrigatório"
    end
  end
end
