
# frozen_string_literal: true

require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test "authorization" do
    get root_path
    assert_response :ok

    sign_in users(:igor)
    get root_path
    assert_response :ok

    sign_in users(:leo)
    get root_path
    assert_response :ok
  end

  test "unlogged navbar" do
    get root_path

    assert_select "nav" do
      assert_select "a[href='#{root_path}']", text: "Web Healthy Care"
      assert_select "a[href='#{new_user_registration_path}']", text: "Registrar-se"
      assert_select "a[href='#{new_user_session_path}']", text: "Login"
    end
  end

  test "logged navbar" do
    sign_in users(:igor)

    get root_path

    assert_select "nav" do
      assert_select "a[href='#{root_path}']", text: "Web Healthy Care"
      assert_select "a[href='#{dispatches_path}']", text: "Minha página"
      assert_select "a[href='#{destroy_user_session_path}']", text: "Logout"
    end
  end
end