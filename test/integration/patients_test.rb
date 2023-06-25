
# frozen_string_literal: true

require "test_helper"

class PatientsTest < ActionDispatch::IntegrationTest
  test "authorization" do
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
      assert_select "input[name='patient[city]']"
      assert_select "input[name='patient[state]']"
      assert_select "input[type='submit'][value='Registrar-se']"
    end

    assert_select "a[href='#{edit_user_registration_path}']", text: "Editar dados de usuário"
  end

  test "index" do
    patients(:leo).update_columns cpf: "053.725.450-11", email: "leo@gmail.com"

    sign_in users(:milena)

    get patients_path

    assert_select "h2", text: "Pacientes"
    assert_select "input[name='query'][placeholder='Buscar por sobrenome']"
    assert_select "input[type='submit'][value='Buscar']"

    get patients_path(query: "maralha")

    assert_select "h2", text: "Pacientes"
    assert_select "input[name='query'][placeholder='Buscar por sobrenome']"
    assert_select "input[type='submit'][value='Buscar']"
    assert_select "table" do
      assert_select "th", text: "Nome"
      assert_select "th", text: "CPF"
      assert_select "th", text: "Ação"
      assert_select "th" do
        assert_select "div", text: "Leonardo Maralha"
        assert_select "div", text: "leo@gmail.com"
      end
      assert_select "td", text: "053.725.450-11"
      assert_select "td" do
        assert_select "a[href='#{patient_dashboard_path(patients(:leo))}']", text: "Visualizar"
      end
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
          email: "coco@gmail.com",
          city: "Alegre",
          state: "ES"
        }
      }

      patient = Patient.last

      assert_redirected_to patient_dashboard_path(patient)

      assert_equal users(:pending), patient.user
      assert_equal "Coco", patient.name
      assert_equal "Depolli", patient.last_name
      assert_equal "3.102.312", patient.rg
      assert_equal "509.084.080-64", patient.cpf
      assert_equal "coco@gmail.com", patient.email
      assert_equal "Alegre", patient.city
      assert_equal "ES", patient.state
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
