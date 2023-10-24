
# frozen_string_literal: true

require "test_helper"

class Patients::Diagnostics::TreatmentsTest < ActionDispatch::IntegrationTest
  setup do
    access_controls(:milena_leo).update_columns expires_at: Time.zone.now + 2.hours, status: :authorized

    sign_in users(:milena)
  end

  test "authorization show" do
    get patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatments(:diet_for_flu))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute
    get patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatments(:diet_for_flu))
    assert_response :redirect

    sign_in users(:leo)
    get patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatments(:diet_for_flu))
    assert_response :ok

    sign_in users(:pending)
    get patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatments(:diet_for_flu))
    assert_response :redirect
  end

  test "authorization index" do
    get patient_diagnostic_treatments_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute
    get patient_diagnostic_treatments_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect

    sign_in users(:leo)
    get patient_diagnostic_treatments_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :ok

    sign_in users(:pending)
    get patient_diagnostic_treatments_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect
  end

  test "authorization new" do
    get new_patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute
    get new_patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect

    sign_in users(:leo)
    get new_patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect
  end

  test "layout show" do
    get patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatments(:diet_for_flu))

    assert_select "a[href='#{patient_diagnostic_treatments_path(patients(:leo), diagnostics(:leo_flu))}']"
    assert_select "p", text: "Doença: Gripe"
    assert_select "p", text: "Data de início: #{Time.current.strftime("%d/%m/%Y")}"
    assert_select "form[action='#{patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatments(:diet_for_flu))}']" do
      assert_select "input[type='hidden'][value='patch']"
      assert_select "p", text: "Data do fim:"
      assert_select "input[type='date'][name='treatment[ended_at]']"
      assert_select "input[type='submit'][value='Salvar data do fim']"
    end
    assert_select "#diet_#{diets(:for_treat_flu).id}" do
      assert_select "p", text: "Tipo de tratamento: Dieta"
      assert_select "p", text: "300g de frango, arroz e feijão"
    end
  end

  test "layout index" do
    get patient_diagnostic_treatments_path(patients(:leo), diagnostics(:leo_flu))

    assert_select "a[href='#{new_patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu))}']", text: "Novo tratamento"
    assert_select "table" do
      assert_select "th", text: "Tipo"
      assert_select "th", text: "Início"
      assert_select "th", text: "Fim"
      assert_select "th", text: "Ação"

      assert_select "td", text: "Receita médica"
      assert_select "td", text: treatments(:prescription_for_flu).started_at.strftime("%d/%m/%Y")
      assert_select "td" do
        assert_select "a[href='#{patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatments(:prescription_for_flu))}']"
      end

      assert_select "td", text: "Cirurgia"
      assert_select "td", text: treatments(:septoplasty_for_flu).started_at.strftime("%d/%m/%Y")
      assert_select "td" do
        assert_select "a[href='#{patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatments(:septoplasty_for_flu))}']"
      end

      assert_select "td", text: "Dieta"
      assert_select "td", text: treatments(:diet_for_flu).started_at.strftime("%d/%m/%Y")
      assert_select "td" do
        assert_select "a[href='#{patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatments(:diet_for_flu))}']"
      end
    end
  end

  test "layout new" do
    get new_patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu))

    assert_select "a[href='#{patient_diagnostic_treatments_path(patients(:leo), diagnostics(:leo_flu))}']"
    assert_select "h2", text: "Cadastrar novo tratamento para a Gripe de Leonardo Maralha"
    assert_select "a[href='#{new_patient_diagnostic_surgery_path(patients(:leo), diagnostics(:leo_flu))}']", text: "Cirurgia"
    assert_select "a[href='#{new_patient_diagnostic_diet_path(patients(:leo), diagnostics(:leo_flu))}']", text: "Dieta"
    assert_select "a[href='#{new_patient_diagnostic_prescription_path(patients(:leo), diagnostics(:leo_flu))}']", text: "Receita"
  end

  test "update" do
    patch patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatments(:diet_for_flu)), params: {
      treatment: {
        ended_at: Time.current
      }
    }

    assert_not_nil treatments(:diet_for_flu).reload.ended_at
  end

  test "update fails" do
    patch patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatments(:diet_for_flu)), params: {
      treatment: {
        ended_at: 1.day.ago
      }
    }

    assert_response :unprocessable_entity
    assert_select ".alert", text: "Data do fim deve ser maior ou igual que #{treatments(:diet_for_flu).started_at.strftime("%Y-%m-%d")}"
    assert_nil treatments(:diet_for_flu).reload.ended_at
  end
end
