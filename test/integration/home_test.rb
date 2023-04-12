
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
      assert_select "a[href='#{dispatches_path}']", text: "Web Healthy Care"
      assert_select "a[href='#{new_user_session_path}']", text: "Entrar"
    end
  end

  test "logged navbar" do
    sign_in users(:igor)

    get root_path

    assert_select "nav" do
      assert_select "a[href='#{dispatches_path}']", text: "Web Healthy Care"
      assert_select "a[href='#{dispatches_path}']", text: "Minha página"
      assert_select "a[href='#{edit_user_registration_path}']", text: "Editar"
      assert_select "a[href='#{destroy_user_session_path}']", text: "Logout"
    end
  end

  test "search for patient is just showing for admin or doctor" do
    sign_in users(:igor)

    get root_path
    assert_select "nav" do
      assert_select "a[href='#{patients_path}']", text: "Buscar pacientes"
    end

    sign_in users(:milena)

    get root_path
    assert_select "nav" do
      assert_select "a[href='#{patients_path}']", text: "Buscar pacientes"
    end

    sign_in users(:leo)

    get root_path
    assert_select "nav" do
      assert_select "a[href='#{patients_path}']", text: "Buscar pacientes", count: 0
    end
  end
end
