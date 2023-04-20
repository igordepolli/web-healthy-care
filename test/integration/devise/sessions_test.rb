
# frozen_string_literal: true

require "test_helper"

class Devise::SessionsTest < ActionDispatch::IntegrationTest
  test "authorization" do
    get new_user_session_path
    assert_response :ok
  end

  test "new layout" do
    get new_user_session_path

    assert_select "h2", text: "Login"
    assert_select "form[action='#{user_session_path}'][method='post']" do
      assert_select "input[name='user[email]'][required='required']"
      assert_select "input[name='user[password]'][required='required']"
      assert_select "input[type='submit'][value='Login']"
    end

    assert_select "a[href='#{new_user_session_path}']"
  end

  test "create success" do
    post user_session_path, params: {
      user: { email: "leo@gmail.com", password: "123456" }
    }

    assert_redirected_to dispatches_path
    follow_redirect!
    assert_redirected_to patient_dashboard_path(patients(:leo))
  end

  test "create fail" do
    post user_session_path, params: {
      user: { email: "leo@gmail.com", password: "1234567" }
    }

    assert_response :unprocessable_entity
    assert_select ".alert", text: "E-mail ou senha inválida."
  end

  test "destroy" do
    sign_in users(:leo)

    get patient_dashboard_path(patients(:leo))
    assert_response :ok

    delete destroy_user_session_path

    get patient_dashboard_path(patients(:leo))
    assert_response :redirect
  end
end
