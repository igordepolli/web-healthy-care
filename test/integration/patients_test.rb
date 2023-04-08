
# frozen_string_literal: true

require "test_helper"

class PatientsTest < ActionDispatch::IntegrationTest
  test "authorization" do
    get patient_path(patients(:leo))
    assert_response :redirect

    sign_in users(:igor)
    get patient_path(patients(:leo))
    assert_response :ok

    sign_in users(:milena)
    get patient_path(patients(:leo))
    assert_response :redirect

    sign_in users(:leo)
    get patient_path(patients(:leo))
    assert_response :ok

    get new_patient_path
    assert_response :redirect

    sign_in users(:pending)
    get new_patient_path
    assert_response :ok
  end

  test "new layout" do
    sign_in users(:pending)

    get new_patient_path

    assert_select "h2", text: "Registrar-se como paciente"
    assert_select "form[action='#{patients_path}'][method='post']" do
      assert_select "input[name='patient[name]'][required='required']"
      assert_select "input[name='patient[last_name]'][required='required']"
      assert_select "input[name='patient[rg]']"
      assert_select "input[name='patient[cpf]']"
      assert_select "input[name='patient[email]']"
      assert_select "input[type='submit'][value='Registrar-se']"
    end
  end

  test "create success" do
    sign_in users(:pending)

    assert_difference -> { Patient.count } => 1 do
      post patients_path, params: {
        patient: {
          name: "Coco",
          last_name: "Depolli",
          rg: "3.102.312",
          cpf: "509.084.080-64",
          email: "coco@gmail.com"
        }
      }

      patient = Patient.last

      assert_redirected_to patient_path(patient)

      assert_equal users(:pending), patient.user
      assert_equal "Coco", patient.name
      assert_equal "Depolli", patient.last_name
      assert_equal "3.102.312", patient.rg
      assert_equal "509.084.080-64", patient.cpf
      assert_equal "coco@gmail.com", patient.email
    end
  end

  test "create fail" do
    patients(:leo).update_column :cpf, "509.084.080-64"

    sign_in users(:pending)

    assert_no_difference -> { Patient.count } do
      post patients_path, params: {
        patient: {
          name: "Coco",
          last_name: "Depolli",
          rg: "3.102.312",
          cpf: "509.084.080-64",
          email: "coco@gmail.com"
        }
      }

      assert_response :unprocessable_entity
      assert_select ".alert", text: "CPF já foi usado"
    end
  end
end
