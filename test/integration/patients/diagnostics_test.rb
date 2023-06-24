
# frozen_string_literal: true

require "test_helper"

class Patients::DiagnosticsTest < ActionDispatch::IntegrationTest
  test "authorization new" do
    get new_patient_diagnostic_path(patients(:leo))
    assert_response :redirect

    sign_in users(:leo)
    get new_patient_diagnostic_path(patients(:leo))
    assert_response :redirect

    sign_in users(:milena)
    get new_patient_diagnostic_path(patients(:leo))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    get new_patient_diagnostic_path(patients(:leo))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get new_patient_diagnostic_path(patients(:leo))
    assert_response :redirect
  end

  test "authorization show" do
    get patient_diagnostic_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect

    sign_in users(:leo)
    get patient_diagnostic_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :ok

    sign_in users(:milena)
    get patient_diagnostic_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    get patient_diagnostic_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get patient_diagnostic_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect
  end

  test "authorization index" do
    get patient_diagnostics_path(patients(:leo))
    assert_response :redirect

    sign_in users(:leo)
    get patient_diagnostics_path(patients(:leo))
    assert_response :ok

    sign_in users(:milena)
    get patient_diagnostics_path(patients(:leo))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    get patient_diagnostics_path(patients(:leo))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get patient_diagnostics_path(patients(:leo))
    assert_response :redirect
  end

  test "layout new" do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    sign_in users(:milena)

    get new_patient_diagnostic_path(patients(:leo))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{patient_diagnostics_path(patients(:leo))}']"
      assert_select "h2", text: "Cadastrar novo diagnóstico"
      assert_select "form[action='#{patient_diagnostics_path(patients(:leo))}']" do
        assert_select "select[name='diagnostic[disease]']" do
          assert_select "option[value='#{diseases(:flu).id}']", text: "Gripe"
        end
        assert_select "input[name='diagnostic[diagnosed_at]']"
        assert_select "input[name='diagnostic[cured_at]']"
        assert_select "textarea[name='diagnostic[related_symptoms]']"
        assert_select "select[name='diagnostic[status]']" do
          assert_select "option[value='acute']",     text: "Aguda"
          assert_select "option[value='active']",    text: "Ativa"
          assert_select "option[value='chronic']",   text: "Crônica"
          assert_select "option[value='cured']",     text: "Curada"
          assert_select "option[value='remission']", text: "Em remissão"
          assert_select "option[value='inactive']",  text: "Inativa"
          assert_select "option[value='terminal']",  text: "Terminal"
        end
      end
    end
  end

  test "layout show" do
    diagnostics(:leo_flu).update_column :cured_at, Date.current

    sign_in users(:leo)

    get patient_diagnostic_path(patients(:leo), diagnostics(:leo_flu))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{patient_diagnostics_path(patients(:leo))}']"
      assert_select "p", text: "Paciente: Leonardo Maralha"
      assert_select "p", text: "Doença: Gripe"
      assert_select "p", text: "Data do diagnóstico: #{Date.current.strftime("%d/%m/%Y")}"
      assert_select "p", text: "Data da cura: #{Date.current.strftime("%d/%m/%Y")}"
      assert_select "p", text: "Corisa, catarro e mal estar"
      assert_select "p", text: "Status: Ativa"
    end
  end

  test "layout show for doctor has a form to update diagnostic status" do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    sign_in users(:milena)

    get patient_diagnostic_path(patients(:leo), diagnostics(:leo_flu))

    assert_select "#content" do
      assert_select "form[action='#{patient_diagnostic_path(patients(:leo), diagnostics(:leo_flu))}']" do
        assert_select "select[name='diagnostic[status]'][onchange='this.form.requestSubmit()']" do
          assert_select "option[value='acute']",     text: "Aguda"
          assert_select "option[value='active']",    text: "Ativa"
          assert_select "option[value='chronic']",   text: "Crônica"
          assert_select "option[value='cured']",     text: "Curada"
          assert_select "option[value='remission']", text: "Em remissão"
          assert_select "option[value='inactive']",  text: "Inativa"
          assert_select "option[value='terminal']",  text: "Terminal"
        end
      end
    end
  end

  test "layout index" do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    sign_in users(:milena)

    get patient_diagnostics_path(patients(:leo))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{new_patient_diagnostic_path(patients(:leo))}']", text: "Novo diagnóstico"
      assert_select "table" do
        assert_select "th", text: "Data"
        assert_select "th", text: "Doença"
        assert_select "th", text: "Status"
        assert_select "th", text: "Ação"

        assert_select "#diagnostic_#{diagnostics(:leo_flu).id}" do
          assert_select "td", text: "#{Date.current.strftime("%d/%m/%Y")}"
          assert_select "td", text: "Gripe"
          assert_select "td", text: "Ativa"
          assert_select "td a[href='#{patient_diagnostic_path(patients(:leo), diagnostics(:leo_flu))}']", text: "Visualizar"
        end
      end
    end
  end

  test "create" do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    sign_in users(:milena)

    assert_difference -> { Diagnostic.count } => 1 do
      post patient_diagnostics_path(patients(:leo)), params: {
        diagnostic: {
          disease: diseases(:flu).id,
          diagnosed_at: "2023-01-01",
          cured_at: "2023-01-02",
          related_symptoms: "Muita dor",
          status: :cured
        }
      }

      diagnostic = Diagnostic.last

      assert_redirected_to new_patient_diagnostic_treatment_path(patients(:leo), diagnostic)

      assert_equal patients(:leo), diagnostic.patient
      assert_equal diseases(:flu), diagnostic.disease
      assert_equal "2023-01-01",   diagnostic.diagnosed_at.to_s
      assert_equal "2023-01-02",   diagnostic.cured_at.to_s
      assert_equal "Muita dor",    diagnostic.related_symptoms
      assert diagnostic.cured?
    end
  end

  test "update" do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    sign_in users(:milena)

    patch patient_diagnostic_path(patients(:leo), diagnostics(:leo_flu)), params: {
      diagnostic: {
        status: :cured
      }
    }

    assert diagnostics(:leo_flu).reload.cured?
  end
end
