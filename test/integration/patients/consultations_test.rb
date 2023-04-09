
# frozen_string_literal: true

require "test_helper"

class Patients::ConsultationsTest < ActionDispatch::IntegrationTest
  test "authorization new" do
    get new_patient_consultation_path(patients(:leo))
    assert_response :redirect

    sign_in users(:leo)
    get new_patient_consultation_path(patients(:leo))
    assert_response :redirect

    sign_in users(:milena)
    get new_patient_consultation_path(patients(:leo))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    get new_patient_consultation_path(patients(:leo))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get new_patient_consultation_path(patients(:leo))
    assert_response :redirect
  end

  test "authorization show" do
    get patient_consultation_path(patients(:leo), consultations(:suspected_flu))
    assert_response :redirect

    sign_in users(:leo)
    get patient_consultation_path(patients(:leo), consultations(:suspected_flu))
    assert_response :ok

    sign_in users(:milena)
    get patient_consultation_path(patients(:leo), consultations(:suspected_flu))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    get patient_consultation_path(patients(:leo), consultations(:suspected_flu))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get patient_consultation_path(patients(:leo), consultations(:suspected_flu))
    assert_response :redirect
  end

  test "authorization index" do
    get patient_consultations_path(patients(:leo))
    assert_response :redirect

    sign_in users(:leo)
    get patient_consultations_path(patients(:leo))
    assert_response :ok

    sign_in users(:milena)
    get patient_consultations_path(patients(:leo))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    get patient_consultations_path(patients(:leo))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get patient_consultations_path(patients(:leo))
    assert_response :redirect
  end
end
