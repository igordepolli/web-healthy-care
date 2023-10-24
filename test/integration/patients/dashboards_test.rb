
# frozen_string_literal: true

require "test_helper"

class Patient::DashboardsTest < ActionDispatch::IntegrationTest
  test "authorization" do
    get patient_dashboard_path(patients(:leo))
    assert_response :redirect

    sign_in users(:igor)
    get patient_dashboard_path(patients(:leo))
    assert_response :ok

    sign_in users(:milena)
    get patient_dashboard_path(patients(:leo))
    assert_response :ok

    sign_in users(:leo)
    get patient_dashboard_path(patients(:leo))
    assert_response :ok
  end

  test "show layout for patient" do
    sign_in users(:leo)

    get patient_dashboard_path(patients(:leo))

    assert_select "h5", text: "Leonardo Maralha"
    assert_select "span", text: "leo@gmail.com"
    assert_select "#aside-menu" do
      assert_select "a[href='#{patient_access_controls_path(patients(:leo))}']" do
        assert_select "span", text: "Autorizações"
        assert_select "span", text: "1"
      end
      assert_select "a[href='#{patient_consultations_path(patients(:leo))}']", text: "Consultas"
      assert_select "a[href='#{patient_surgeries_path(patients(:leo))}']",     text: "Cirurgias"
      assert_select "a[href='#{patient_diagnostics_path(patients(:leo))}']",   text: "Diagnósticos"
    end
  end

  test "show layout for doctor" do
    AccessControl.delete_all

    sign_in users(:milena)

    get patient_dashboard_path(patients(:leo))

    assert_select "h5", text: "Leonardo Maralha"
    assert_select "#aside-menu" do
      assert_select "a[href='#{patient_access_controls_path(patients(:leo))}']", text: "Autorizações",         count: 0
      assert_select "a[href='#{patient_consultations_path(patients(:leo))}']",   text: "Consultas",            count: 0
      assert_select "a[href='#{patient_surgeries_path(patients(:leo))}']",       text: "Cirurgias",            count: 0
      assert_select "a[href='#{patient_diagnostics_path(patients(:leo))}']",     text: "Diagnósticos",         count: 0
      assert_select "a[href='#{patient_access_controls_path(patients(:leo))}']", text: "Solicitar informações"
    end

    access_control = AccessControl.create! doctor: doctors(:milena), patient: patients(:leo)

    get patient_dashboard_path(patients(:leo))

    assert_select "h5", text: "Leonardo Maralha"
    assert_select "#aside-menu" do
      assert_select "a[href='#{patient_access_controls_path(patients(:leo))}']", text: "Autorizações", count: 0
      assert_select "a[href='#{patient_consultations_path(patients(:leo))}']",   text: "Consultas",    count: 0
      assert_select "a[href='#{patient_surgeries_path(patients(:leo))}']",       text: "Cirurgias",    count: 0
      assert_select "a[href='#{patient_diagnostics_path(patients(:leo))}']",     text: "Diagnósticos", count: 0
      assert_select "span", text: "Aguardando autorização"
    end

    access_control.update_columns expires_at: Time.zone.now + 2.hours, status: :authorized

    get patient_dashboard_path(patients(:leo))

    assert_select "h5", text: "Leonardo Maralha"
    assert_select "#aside-menu" do
      assert_select "a[href='#{patient_access_controls_path(patients(:leo))}']", text: "Autorizações", count: 0
      assert_select "a[href='#{patient_consultations_path(patients(:leo))}']",   text: "Consultas"
      assert_select "a[href='#{patient_surgeries_path(patients(:leo))}']",       text: "Cirurgias"
      assert_select "a[href='#{patient_diagnostics_path(patients(:leo))}']",     text: "Diagnósticos"
      assert_select "span", text: "Acesso autorizado até #{access_control.expires_at.strftime("%d/%m/%Y %Hh%M")}"
    end
  end
end
