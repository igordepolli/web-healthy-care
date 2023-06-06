
# frozen_string_literal: true

require "test_helper"

class Patients::BiodataTest < ActionDispatch::IntegrationTest
  setup do
    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    sign_in users(:milena)
  end

  test "authorization show" do
    get patient_biodatum_path(patients(:leo), biodata(:biodata_leo))
    assert_response :ok

    sign_out users(:milena)
    get patient_biodatum_path(patients(:leo), biodata(:biodata_leo))
    assert_response :redirect

    sign_in users(:leo)
    get patient_biodatum_path(patients(:leo), biodata(:biodata_leo))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    sign_in users(:milena)
    get patient_biodatum_path(patients(:leo), biodata(:biodata_leo))
    assert_response :redirect
  end

  test "authorization index" do
    get patient_biodata_path(patients(:leo))
    assert_response :ok

    sign_out users(:milena)
    get patient_biodatum_path(patients(:leo), biodata(:biodata_leo))
    assert_response :redirect

    sign_in users(:leo)
    get patient_biodata_path(patients(:leo))
    assert_response :ok

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    sign_in users(:milena)
    get patient_biodata_path(patients(:leo))
    assert_response :redirect
  end

  test "layout show" do
    get patient_biodatum_path(patients(:leo), biodata(:biodata_leo))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{patient_biodata_path(patients(:leo))}']"

      assert_select "p", text: "Paciente: Leonardo Maralha"
      assert_select "p", text: "Data do exame: #{Time.current.strftime("%d/%m/%Y")}"
      assert_select "p", text: "Tipo do exame: Hemograma"

      assert_select "p", text: "Pressão sistólica: 12"
      assert_select "p", text: "Pressão diastólica: 8"
    end
  end

  test "layout index" do
    get patient_biodata_path(patients(:leo))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "table" do
        assert_select "th", text: "Exame"
        assert_select "th", text: "Data do exame"
        assert_select "th", text: "Ação"

        assert_select "#biodatum_#{biodata(:biodata_leo).id}" do
          assert_select "td", text: "Hemograma"
          assert_select "td", text: Time.current.strftime("%d/%m/%Y")
          assert_select "td a[href='#{patient_biodatum_path(patients(:leo), biodata(:biodata_leo))}']", text: "Visualizar"
        end
      end
    end
  end
end
