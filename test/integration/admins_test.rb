
# frozen_string_literal: true

require "test_helper"

class AdminsTest < ActionDispatch::IntegrationTest
  test "authorization" do
    sign_in users(:igor)
    get admin_path
    assert_response :ok

    sign_in users(:leo)
    get admin_path
    assert_response :redirect

    sign_in users(:milena)
    get admin_path
    assert_response :redirect
  end
end
