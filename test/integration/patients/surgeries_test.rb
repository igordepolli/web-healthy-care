
# frozen_string_literal: true

require "test_helper"

class Patients::SurgeriesTest < ActionDispatch::IntegrationTest
  test "authorization new" do
    get new_patient_surgery_path(patients(:leo))
    assert_response :redirect

    sign_in users(:leo)
    get new_patient_surgery_path(patients(:leo))
    assert_response :redirect

    sign_in users(:milena)
    get new_patient_surgery_path(patients(:leo))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    get new_patient_surgery_path(patients(:leo))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get new_patient_surgery_path(patients(:leo))
    assert_response :redirect
  end

  test "authorization show" do
    get patient_surgery_path(patients(:leo), surgeries(:septoplasty))
    assert_response :redirect

    sign_in users(:leo)
    get patient_surgery_path(patients(:leo), surgeries(:septoplasty))
    assert_response :ok

    sign_in users(:milena)
    get patient_surgery_path(patients(:leo), surgeries(:septoplasty))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    get patient_surgery_path(patients(:leo), surgeries(:septoplasty))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get patient_surgery_path(patients(:leo), surgeries(:septoplasty))
    assert_response :redirect
  end

  test "authorization index" do
    get patient_surgeries_path(patients(:leo))
    assert_response :redirect

    sign_in users(:leo)
    get patient_surgeries_path(patients(:leo))
    assert_response :ok

    sign_in users(:milena)
    get patient_surgeries_path(patients(:leo))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    get patient_surgeries_path(patients(:leo))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    get patient_surgeries_path(patients(:leo))
    assert_response :redirect
  end

  test "layout new" do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    sign_in users(:milena)

    get new_patient_surgery_path(patients(:leo))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{patient_surgeries_path(patients(:leo))}']"
      assert_select "h2", text: "Cadastrar nova cirurgia"
      assert_select "form[action='#{patient_surgeries_path(patients(:leo))}']" do
        assert_select "input[name='surgery[date]']"
        assert_select "select[name='surgery[classification]']" do
          assert_select "option[value='elective']", text: "Eletiva"
          assert_select "option[value='other']", text: "Outro(a)"
          assert_select "option[value='urgency']", text: "Urgente"
        end
        assert_select "input[name='surgery[hospital]']"
        assert_select "input[name='surgery[discharged_at]']"
        assert_select "input[type='submit'][value='Cadastrar']"
      end
    end
  end

  test "layout show" do
    sign_in users(:leo)

    get patient_surgery_path(patients(:leo), surgeries(:septoplasty))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{patient_surgeries_path(patients(:leo))}']"
      assert_select "p", text: "Paciente: Leonardo Maralha"
      assert_select "p", text: "Data da cirurgia: #{Date.current.strftime("%d/%m/%Y")}"
      assert_select "p", text: "Tipo da cirurgia: Eletiva"
    end
  end

  test "layout index" do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    sign_in users(:milena)

    get patient_surgeries_path(patients(:leo))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{new_patient_surgery_path(patients(:leo))}']", text: "Nova cirurgia"
      assert_select "table" do
        assert_select "th", text: "Data"
        assert_select "th", text: "Tipo"
        assert_select "th", text: "Ação"

        assert_select "#surgery_#{surgeries(:septoplasty).id}" do
          assert_select "td", text: "#{Date.current.strftime("%d/%m/%Y")}"
          assert_select "td", text: "Eletiva"
          assert_select "td a[href='#{patient_surgery_path(patients(:leo), surgeries(:septoplasty))}']", text: "Visualizar"
        end
      end
    end
  end

  test "create" do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    sign_in users(:milena)

    assert_difference -> { Surgery.count } => 1 do
      post patient_surgeries_path(patients(:leo)), params: { surgery: { date: "2023-01-01", classification: :urgency, hospital: "Evangelico", discharged_at: "2023-01-10" } }

      surgery = Surgery.last

      assert_redirected_to patient_surgery_path(patients(:leo), surgery)

      assert_equal patients(:leo), surgery.patient
      assert_equal "2023-01-01", surgery.date.to_s
      assert surgery.urgency?
      assert_equal "Evangelico", surgery.hospital
      assert_equal "2023-01-10", surgery.discharged_at.to_s
    end
  end
end
