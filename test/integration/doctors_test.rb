
# frozen_string_literal: true

require "test_helper"

class DoctorsTest < ActionDispatch::IntegrationTest
  setup do
    users(:pending).update_column :classification, :doctor
  end

  test "authorization" do
    get doctor_path(doctors(:milena))
    assert_response :redirect

    sign_in users(:igor)
    get doctor_path(doctors(:milena))
    assert_response :ok

    sign_in users(:leo)
    get doctor_path(doctors(:milena))
    assert_response :redirect

    sign_in users(:milena)
    get doctor_path(doctors(:milena))
    assert_response :ok

    get new_doctor_path
    assert_response :redirect

    sign_in users(:pending)
    get new_doctor_path
    assert_response :ok
  end

  test "new layout" do
    sign_in users(:pending)

    get new_doctor_path

    assert_select "h2", text: "Registrar-se como médico"
    assert_select "form[action='#{doctors_path}'][method='post']" do
      assert_select "input[name='doctor[name]'][required='required']"
      assert_select "input[name='doctor[last_name]'][required='required']"
      assert_select "input[name='doctor[crm]']"
      assert_select "input[name='doctor[cpf]']"
      assert_select "input[name='doctor[email]']"
      assert_select "input[name='doctor[specialty]']"
      assert_select "input[type='submit'][value='Registrar-se']"
    end

    assert_select "a[href='#{edit_user_registration_path}']", text: "Editar dados de usuário"
  end

  test "create success" do
    sign_in users(:pending)

    assert_difference -> { Doctor.count } => 1 do
      post doctors_path, params: {
        doctor: {
          name: "Coco",
          last_name: "Depolli",
          crm: "31213-ES",
          cpf: "509.084.080-64",
          email: "coco@gmail.com",
          specialty: "Neurologista"
        }
      }

      doctor = Doctor.last

      assert_redirected_to doctor_path(doctor)

      assert_equal users(:pending), doctor.user
      assert_equal "Coco", doctor.name
      assert_equal "Depolli", doctor.last_name
      assert_equal "31213-ES", doctor.crm
      assert_equal "509.084.080-64", doctor.cpf
      assert_equal "coco@gmail.com", doctor.email
      assert_equal "Neurologista", doctor.specialty
    end
  end

  test "create fail" do
    doctors(:milena).update_column :crm, "3.102.312"

    sign_in users(:pending)

    assert_no_difference -> { Doctor.count } do
      post doctors_path, params: {
        doctor: {
          name: "Coco",
          last_name: "Depolli",
          crm: "3.102.312",
          cpf: "509.084.080-64",
          email: "coco@gmail.com"
        }
      }

      assert_response :unprocessable_entity
      assert_select ".alert", text: "CRM já foi usado"
    end
  end
end
