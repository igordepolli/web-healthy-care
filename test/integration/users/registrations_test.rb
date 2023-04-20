
# frozen_string_literal: true

require "test_helper"

class Users::RegistrationsTest < ActionDispatch::IntegrationTest
  test "authorization" do
    get new_user_registration_path
    assert_response :ok

    get edit_user_registration_path
    assert_response :redirect

    sign_in users(:leo)
    get edit_user_registration_path
    assert_response :ok
  end

  test "new layout" do
    get new_user_registration_path

    assert_select "h2", text: "Registrar"
    assert_select "form[action='#{user_registration_path}'][method='post']" do
      assert_select "input[name='user[email]'][required='required']"
      assert_select "input[name='user[name]'][required='required']"
      assert_select "input[name='user[last_name]'][required='required']"
      assert_select "input[name='user[password]'][required='required']"
      assert_select "input[name='user[password_confirmation]'][required='required']"
      assert_select "select[name='user[classification]'][required='required']" do
        assert_select "option[value='admin']", count: 0
        assert_select "option[value='doctor']"
        assert_select "option[value='patient']"
      end
      assert_select "input[type='submit'][value='Registrar-se']"
    end

    assert_select "a[href='#{new_user_session_path}']", text: "Entrar"
  end

  test "edit layout" do
    sign_in users(:leo)

    get edit_user_registration_path

    assert_select "form[action='#{user_registration_path}']" do
      assert_select "input[name='user[email]'][required='required']"
      assert_select "input[name='user[name]'][required='required']"
      assert_select "input[name='user[last_name]'][required='required']"
      assert_select "input[name='user[password]']"
      assert_select "input[name='user[password_confirmation]']"
      assert_select "input[name='user[current_password]'][required='required']"
      assert_select "input[type='submit'][value='Atualizar dados']"
    end

    assert_select "a[href='#{dispatches_path}']", text: "Cancelar"
  end

  test "create success" do
    assert_difference -> { User.count } => 1 do
      post user_registration_path, params: {
        user: {
          email: "coco@gmail.com",
          name: "Coco",
          last_name: "Depolli",
          password: "123456",
          password_confirmation: "123456",
          classification: "patient"
        }
      }

      assert_redirected_to dispatches_path
      follow_redirect!
      assert_redirected_to new_patient_path

      user = User.last
      assert_equal "coco@gmail.com", user.email
      assert_equal "Coco", user.name
      assert_equal "Depolli", user.last_name
      assert user.patient?
    end
  end

  test "create fail" do
    assert_no_difference -> { User.count } do
      post user_registration_path, params: {
        user: {
          email: "coco@gmail.com",
          name: "Coco",
          last_name: "Depolli",
          password: "123456",
          password_confirmation: "123456",
          classification: "admin"
        }
      }

      assert_select "li", text: "Tipo de usuário não é uma opção válida"
    end
  end

  test "update success" do
    sign_in users(:leo)

    patch user_registration_path, params: {
      user: {
        email: "coco@gmail.com",
        name: "Coco",
        last_name: "Depolli",
        password: "456789",
        password_confirmation: "456789",
        current_password: "123456"
      }
    }

    assert_redirected_to dispatches_path
    follow_redirect!
    assert_redirected_to patient_dashboard_path(patients(:leo))

    users(:leo).reload
    assert_equal "coco@gmail.com", users(:leo).email
    assert_equal "Coco", users(:leo).name
    assert_equal "Depolli", users(:leo).last_name
  end

  test "update fail" do
    assert_no_difference -> { User.count } do
      post user_registration_path, params: {
        user: {
          email: "coco@gmail.com",
          name: "Coco",
          last_name: "Depolli",
          password: "123",
          password_confirmation: "123",
          current_password: "123456"
        }
      }

      assert_select "li", text: "Senha muito curto(a)"
    end
  end
end
