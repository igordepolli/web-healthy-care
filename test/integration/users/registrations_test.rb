
# frozen_string_literal: true

require "test_helper"

class Users::RegistrationsTest < ActionDispatch::IntegrationTest
  test "authorization" do
    get new_user_registration_path
    assert_response :ok
  end

  test "new layout" do
    get new_user_registration_path

    assert_select "h2", text: "Registrar"
    assert_select "form[action='#{user_registration_path}'][method='post']" do
      assert_select "input[name='user[email]'][required='required']"
      assert_select "input[name='user[password]'][required='required']"
      assert_select "input[name='user[password_confirmation]'][required='required']"
      assert_select "select[name='user[classification]'][required='required']" do
        assert_select "option[value='admin']", count: 0
        assert_select "option[value='doctor']"
        assert_select "option[value='patient']"
      end
      assert_select "input[type='submit'][value='Registrar-se']"
    end

    assert_select "a[href='#{new_user_session_path}']"
  end

  test "create success" do
    assert_difference -> { User.count } => 1 do
      post user_registration_path, params: {
        user: {
          email: "coco@gmail.com",
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
      assert user.patient?
    end
  end

  test "create fail" do
    assert_no_difference -> { User.count } do
      post user_registration_path, params: {
        user: {
          email: "coco@gmail.com",
          password: "123456",
          password_confirmation: "123456",
          classification: "admin"
        }
      }

      assert_select "li", text: "Tipo de usuário não é uma opção válida"
    end
  end
end
