# frozen_string_literal: true

require "test_helper"

class Patients::Diagnostics::Prescriptions::MedicationPrescriptionsTest < ActionDispatch::IntegrationTest
  setup do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    @patient      = patients(:leo)
    @diagnostic   = diagnostics(:leo_flu)
    @prescription = prescriptions(:for_flu)

    sign_in users(:milena)
  end

  test "authorization" do
    sign_out users(:milena)
    get new_patient_diagnostic_prescription_medication_prescription_path(@patient, @diagnostic, @prescription)
    assert_response :redirect

    sign_in users(:leo)
    get new_patient_diagnostic_prescription_medication_prescription_path(@patient, @diagnostic, @prescription)
    assert_response :redirect

    sign_in users(:milena)
    get new_patient_diagnostic_prescription_medication_prescription_path(@patient, @diagnostic, @prescription)
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get new_patient_diagnostic_prescription_medication_prescription_path(@patient, @diagnostic, @prescription)
    assert_response :redirect
  end

  test "layout" do
    get new_patient_diagnostic_prescription_medication_prescription_path(@patient, @diagnostic, @prescription)

    assert_select "#aside-menu"

    assert_select "a[href='#{edit_patient_diagnostic_prescription_path(@patient, @diagnostic, @prescription)}']"
    assert_select "h2", text: "Inserir medicamentos"
    assert_select "form[action='#{patient_diagnostic_prescription_medication_prescriptions_path(@patient, @diagnostic, @prescription)}'][method='post']" do
      assert_select "select[name='prescription[medications][][medication]']"
      assert_select "input[name='prescription[medications][][dosage]']"
      assert_select "input[name='prescription[medications][][schedule]']"
      assert_select "input[type='submit'][value='Cadastrar']"
    end
  end

  test "create" do
    treatments(:prescription_for_flu).delete

    assert_difference -> { MedicationPrescription.count } => 1, -> { Treatment.count } => 1 do
      post patient_diagnostic_prescription_medication_prescriptions_path(@patient, @diagnostic, @prescription), params: {
        prescription: {
          medications: [
            { medication: medications(:paracetamol).id, dosage: "20ml", schedule: "3x ao dia" }
          ]
        }
      }

      medication_prescription = MedicationPrescription.last
      treatment               = Treatment.last

      assert_redirected_to patient_diagnostic_treatment_path(@patient, @diagnostic, treatment)

      assert_equal medications(:paracetamol), medication_prescription.medication
      assert_equal "20ml",                    medication_prescription.dosage
      assert_equal "3x ao dia",               medication_prescription.schedule

      assert_equal treatment,                 @prescription.treatment

      assert_equal @diagnostic,               treatment.diagnostic
      assert_equal @patient,                  treatment.patient
      assert_equal @prescription,             treatment.treatable
      assert_equal @prescription.date,        treatment.started_at
    end
  end

  test "create fails" do
    assert_no_difference -> { MedicationPrescription.count }, -> { Treatment.count } do
      post patient_diagnostic_prescription_medication_prescriptions_path(@patient, @diagnostic, @prescription), params: {
        prescription: {
          medications: [
            { medication: medications(:paracetamol).id, schedule: "3x ao dia" }
          ]
        }
      }

      assert_response :unprocessable_entity
      assert_select ".alert", text: "Dosagem obrigatório"
    end
  end
end
