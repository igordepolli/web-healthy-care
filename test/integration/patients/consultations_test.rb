
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

  test "layout new" do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    sign_in users(:milena)

    get new_patient_consultation_path(patients(:leo))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{patient_consultations_path(patients(:leo))}']"
      assert_select "h2", text: "Cadastrar nova consulta"
      assert_select "form[action='#{patient_consultations_path(patients(:leo))}']" do
        assert_select "input[name='consultation[date]']"
        assert_select "textarea[name='consultation[reason]']"
        assert_select "input[name='consultation[sick_note]'][type='file']"
        assert_select "input[type='submit'][value='Cadastrar']"
      end
    end
  end

  test "layout show" do
    sign_in users(:leo)

    get patient_consultation_path(patients(:leo), consultations(:suspected_flu))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{patient_consultations_path(patients(:leo))}']"
      assert_select "p", text: "Paciente:  Leonardo Maralha"
      assert_select "p", text: "Médico:  Milena Regiani"
      assert_select "p", text: "Data da consulta:  #{Date.current.strftime("%d/%m/%Y")}"
      assert_select "p", text: "Léo está com suspeita de gripe"
    end
  end

  test "layout index" do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    sign_in users(:milena)

    get patient_consultations_path(patients(:leo))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{new_patient_consultation_path(patients(:leo))}']", text: "Nova consulta"
      assert_select "table" do
        assert_select "th", text: "Data"
        assert_select "th", text: "Médico"
        assert_select "th", text: "Ação"

        assert_select "#consultation_#{consultations(:suspected_flu).id}" do
          assert_select "td", text: "#{Date.current.strftime("%d/%m/%Y")}"
          assert_select "td", text: "Milena Regiani"
          assert_select "td a[href='#{patient_consultation_path(patients(:leo), consultations(:suspected_flu))}']", text: "Visualizar"
        end
      end
    end
  end

  test "create" do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    sign_in users(:milena)

    assert_difference -> { Consultation.count } => 1 do
      post patient_consultations_path(patients(:leo)), params: { consultation: { date: "2023-01-01", reason: "Dor de cabeça" } }

      consultation = Consultation.last

      assert_redirected_to patient_consultation_path(patients(:leo), consultation)

      assert_equal patients(:leo), consultation.patient
      assert_equal doctors(:milena), consultation.doctor
      assert_equal "2023-01-01", consultation.date.to_s
      assert_equal "Dor de cabeça", consultation.reason
    end
  end
end
