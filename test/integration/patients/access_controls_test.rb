
# frozen_string_literal: true

require "test_helper"

class Patients::AccessControlsTest < ActionDispatch::IntegrationTest
  test "authorization" do
    get patient_access_controls_path(patients(:leo))
    assert_response :redirect

    sign_in users(:leo)
    get patient_access_controls_path(patients(:leo))
    assert_response :ok

    sign_in users(:milena)
    get patient_access_controls_path(patients(:leo))
    assert_response :redirect
  end

  test "index" do
    sign_in users(:leo)

    get patient_access_controls_path(patients(:leo))

    assert_select "#aside-menu"
    assert_select "#access_control_#{access_controls(:milena_leo).id}" do
      assert_select "div", text: "O(a) doutor(a) Milena Regiani deseja acessar as suas informações médicas"
      assert_select "form[action='#{patient_access_control_path(patients(:leo), access_controls(:milena_leo))}']" do
        assert_select "input[name='_method'][value='patch']"
        assert_select "button[type='submit']"
      end
      assert_select "form[action='#{patient_access_control_path(patients(:leo), access_controls(:milena_leo))}']" do
        assert_select "input[name='_method'][value='delete']"
        assert_select "button[type='submit']"
      end
    end
  end

  test "create" do
    sign_in users(:milena)

    assert_difference -> { AccessControl.count } => 1 do
      post patient_access_controls_path(patients(:leo))

      access_control = AccessControl.last
      assert_equal patients(:leo), access_control.patient
      assert_equal doctors(:milena), access_control.doctor
      assert_nil access_control.expires_at
    end
  end

  test "update" do
    sign_in users(:leo)

    assert_nil access_controls(:milena_leo).expires_at
    patch patient_access_control_path(patients(:leo), access_controls(:milena_leo))
    assert_not_nil access_controls(:milena_leo).reload.expires_at
  end

  test "destroy" do
    sign_in users(:leo)

    assert_difference -> { AccessControl.count } => -1 do
      delete patient_access_control_path(patients(:leo), access_controls(:milena_leo))
    end
  end
end
