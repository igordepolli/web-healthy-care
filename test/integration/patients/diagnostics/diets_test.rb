
# frozen_string_literal: true

require "test_helper"

class Patients::Diagnostics::DietsTest < ActionDispatch::IntegrationTest
  setup do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    sign_in users(:milena)
  end

  test "authorization" do
    sign_out users(:milena)
    get new_patient_diagnostic_diet_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect

    sign_in users(:leo)
    get new_patient_diagnostic_diet_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect

    sign_in users(:milena)
    get new_patient_diagnostic_diet_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get new_patient_diagnostic_diet_path(patients(:leo), diagnostics(:leo_flu))
    assert_response :redirect
  end

  test "layout" do
    get new_patient_diagnostic_diet_path(patients(:leo), diagnostics(:leo_flu))

    assert_select "#aside-menu"

    assert_select "a[href='#{new_patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu))}']"
    assert_select "h2", text: "Cadastrar nova dieta"
    assert_select "form[action='#{patient_diagnostic_diets_path(patients(:leo), diagnostics(:leo_flu))}'][method='post']" do
      assert_select "input[name='diet[date]']"
      assert_select "textarea[name='diet[breakfast]']"
      assert_select "textarea[name='diet[lunch]']"
      assert_select "textarea[name='diet[morning_snack]']"
      assert_select "textarea[name='diet[afternoon_snack]']"
      assert_select "input[type='submit'][value='Cadastrar']"
    end
  end

  test "create" do
    assert_difference -> { Diet.count } => 1, -> { Treatment.count } => 1 do
      post patient_diagnostic_diets_path(patients(:leo), diagnostics(:leo_flu)), params: {
        diet: { date: "2023-01-01", breakfast: "Biscoito", lunch: "Frango", dinner: "Costela", morning_snack: "Pão", afternoon_snack: "Bolo" }
      }

      diet      = Diet.last
      treatment = Treatment.last

      assert_redirected_to patient_diagnostic_treatment_path(patients(:leo), diagnostics(:leo_flu), treatment)

      assert_equal patients(:leo),        diet.patient
      assert_equal treatment,             diet.treatment
      assert_equal "2023-01-01",          diet.date.to_s
      assert_equal "Biscoito",            diet.breakfast
      assert_equal "Frango",              diet.lunch
      assert_equal "Costela",             diet.dinner
      assert_equal "Pão",                 diet.morning_snack
      assert_equal "Bolo",                diet.afternoon_snack

      assert_equal diagnostics(:leo_flu), treatment.diagnostic
      assert_equal patients(:leo),        treatment.patient
      assert_equal diet,                  treatment.treatable
      assert_equal "2023-01-01",          treatment.started_at.to_s
    end
  end

  test "create fails" do
    assert_no_difference -> { Diet.count }, -> { Treatment.count } do
      post patient_diagnostic_diets_path(patients(:leo), diagnostics(:leo_flu)), params: {
        diet: { date: "2023-01-01" }
      }

      assert_response :unprocessable_entity
      assert_select ".alert", text: "Pelo menos uma das refeições deve conter uma instrução de dieta!"
    end
  end
end
