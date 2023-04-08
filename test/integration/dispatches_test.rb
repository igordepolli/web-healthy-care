
# frozen_string_literal: true

require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test "dispatches redirect to right place" do
    get dispatches_path
    assert_response :redirect

    sign_in users(:igor)
    get dispatches_path
    assert_redirected_to root_path

    sign_in users(:leo)
    get dispatches_path
    assert_redirected_to patient_path(patients(:leo))

    sign_in users(:milena)
    get dispatches_path
    assert_redirected_to doctor_path(doctors(:milena))

    sign_in users(:pending)
    get dispatches_path
    assert_redirected_to new_patient_path

    users(:pending).update_column :classification, :doctor

    get dispatches_path
    assert_redirected_to new_doctor_path
  end
end
