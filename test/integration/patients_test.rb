
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
    assert_response :ok

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

    assert_select "a[href='#{edit_user_registration_path}']", text: "Editar dados de usuário"
  end

  test "show layout for patient" do
    sign_in users(:leo)

    get patient_path(patients(:leo))

    assert_select "h2", text: "Leonardo"
    assert_select "#aside-menu" do
      assert_select "a[href='#{patient_access_controls_path(patients(:leo))}']" do
        assert_select "span", text: "Autorizações"
        assert_select "span", text: "1"
      end
      assert_select "a[href='#{patient_consultations_path(patients(:leo))}']", text: "Consultas"
    end
  end

  test "show layout for doctor" do
    AccessControl.delete_all

    sign_in users(:milena)

    get patient_path(patients(:leo))

    assert_select "h2", text: "Leonardo"
    assert_select "#aside-menu" do
      assert_select "a[href='#{patient_access_controls_path(patients(:leo))}']", text: "Autorizações", count: 0
      assert_select "a[href='#{patient_consultations_path(patients(:leo))}']", text: "Consultas", count: 0
      assert_select "a[href='#{patient_access_controls_path(patients(:leo))}']", text: "Solicitar informações"
    end

    access_control = AccessControl.create! doctor: doctors(:milena), patient: patients(:leo)

    get patient_path(patients(:leo))

    assert_select "h2", text: "Leonardo"
    assert_select "#aside-menu" do
      assert_select "a[href='#{patient_access_controls_path(patients(:leo))}']", text: "Autorizações", count: 0
      assert_select "a[href='#{patient_consultations_path(patients(:leo))}']", text: "Consultas", count: 0
      assert_select "span", text: "Aguardando autorização"
    end

    access_control.update_column :expires_at, Time.zone.now + 2.hours

    get patient_path(patients(:leo))

    assert_select "h2", text: "Leonardo"
    assert_select "#aside-menu" do
      assert_select "a[href='#{patient_access_controls_path(patients(:leo))}']", text: "Autorizações", count: 0
      assert_select "a[href='#{patient_consultations_path(patients(:leo))}']", text: "Consultas"
      assert_select "span", text: "Acesso autorizado até #{access_control.expires_at.strftime("%d/%m/%Y %Hh%M")}"
    end
  end

  test "index" do
    patients(:leo).update_columns cpf: "053.725.450-11", email: "leo@gmail.com"

    sign_in users(:milena)

    get patients_path

    assert_select "h2", text: "Pacientes"
    assert_select "input[name='last_name'][placeholder='Buscar por sobrenome']"
    assert_select "input[type='submit'][value='Buscar']"

    get patients_path(last_name: "maralha")

    assert_select "h2", text: "Pacientes"
    assert_select "input[name='last_name'][placeholder='Buscar por sobrenome']"
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
        assert_select "a[href='#{patient_path(patients(:leo))}']", text: "Visualizar"
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
