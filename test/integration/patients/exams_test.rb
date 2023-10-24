
# frozen_string_literal: true

require "test_helper"

class Patients::ExamsTest < ActionDispatch::IntegrationTest
  setup do
    access_controls(:milena_leo).update_columns expires_at: Time.zone.now + 2.hours, status: :authorized

    sign_in users(:milena)
  end

  test "authorization new" do
    get new_patient_exam_path(patients(:leo))
    assert_response :ok

    sign_in users(:leo)
    get new_patient_exam_path(patients(:leo))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    sign_in users(:milena)
    get new_patient_exam_path(patients(:leo))
    assert_response :redirect
  end

  test "authorization show" do
    get patient_exam_path(patients(:leo), exams(:hemogram))
    assert_response :ok

    sign_in users(:leo)
    get patient_exam_path(patients(:leo), exams(:hemogram))
    assert_response :ok

    sign_in users(:pending)
    get patient_exam_path(patients(:leo), exams(:hemogram))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    sign_in users(:milena)
    get patient_exam_path(patients(:leo), exams(:hemogram))
    assert_response :redirect
  end

  test "authorization index" do
    get patient_exams_path(patients(:leo))
    assert_response :ok

    sign_in users(:leo)
    get patient_exams_path(patients(:leo))
    assert_response :ok

    sign_in users(:pending)
    get patient_exams_path(patients(:leo))
    assert_response :redirect

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    sign_in users(:milena)
    get patient_exams_path(patients(:leo))
    assert_response :redirect
  end

  test "layout new" do
    get new_patient_exam_path(patients(:leo))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{patient_exams_path(patients(:leo))}']"
      assert_select "h2", text: "Cadastrar novo exame"
      assert_select "form[action='#{patient_exams_path(patients(:leo))}']" do
        assert_select "input[name='exam[date]']"
        assert_select "select[name='exam[classification]']" do
          assert_select "option[value='hemogram']", text: "Hemograma"
          assert_select "option[value='cholesterol_and_triglycerides']", text: "Colesterol e triglicerídeos"
          assert_select "option[value='urea_and_creatinine']", text: "Ureia e creatinina"
          assert_select "option[value='urine']", text: "Urina"
          assert_select "option[value='faeces']", text: "Fezes"
          assert_select "option[value='eletrocardiogram']", text: "Eletrocardiograma"
          assert_select "option[value='other']", text: "Outro(a)"
        end
        assert_select "input[name='exam[local]']"
        assert_select "input[name='exam[result]']"
        assert_select "input[type='submit'][value='Cadastrar']"
      end
    end
  end

  test "layout show" do
    sign_in users(:leo)

    get patient_exam_path(patients(:leo), exams(:hemogram))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{patient_exams_path(patients(:leo))}']"
      assert_select "p", text: "Paciente: Leonardo Maralha"
      assert_select "p", text: "Data do exame: #{Date.current.strftime("%d/%m/%Y")}"
      assert_select "p", text: "Tipo do exame: Hemograma"
      assert_select "p", text: "Local do exame: Hospital de Alegre"

      assert_select "th", text: "Pressão sistólica"
      assert_select "td", text: "12"

      assert_select "th", text: "Pressão diastólica"
      assert_select "td", text: "8"
    end
  end

  test "layout index" do
    get patient_exams_path(patients(:leo))

    assert_select "#aside-menu"
    assert_select "#content" do
      assert_select "a[href='#{new_patient_exam_path(patients(:leo))}']", text: "Novo exame"
      assert_select "table" do
        assert_select "th", text: "Data"
        assert_select "th", text: "Tipo"
        assert_select "th", text: "Ação"

        assert_select "#exam_#{exams(:hemogram).id}" do
          assert_select "td", text: "#{Date.current.strftime("%d/%m/%Y")}"
          assert_select "td", text: "Hemograma"
          assert_select "td a[href='#{patient_exam_path(patients(:leo), exams(:hemogram))}']", text: "Visualizar"
        end
      end
    end
  end

  test "create" do
    assert_difference -> { Exam.count } => 1 do
      post patient_exams_path(patients(:leo)), params: { exam: { date: "2023-01-01", classification: :urine, local: "Evangelico", result: fixture_file_upload("test/fixtures/files/sick_note.pdf", "application/pdf") } }

      exam = Exam.last

      assert_redirected_to patient_exam_path(patients(:leo), exam)

      assert_equal patients(:leo),  exam.patient
      assert_equal "2023-01-01",    exam.date.to_s
      assert_equal "urine",         exam.classification
      assert_equal "Evangelico",    exam.local
      assert_equal "sick_note.pdf", exam.result.filename.to_s
    end
  end

  test "that button to register results is shown if exam hasn't biodatum yet and current user is doctor" do
    biodata(:biodata_leo).delete

    get patient_exam_path(patients(:leo), exams(:hemogram))

    assert_select "#content" do
      assert_select "a[href='#{new_patient_exam_biodatum_path(patients(:leo), exams(:hemogram))}']", text: "Cadastrar resultados"
    end

    sign_in users(:leo)

    get patient_exam_path(patients(:leo), exams(:hemogram))

    assert_select "#content" do
      assert_select "a[href='#{new_patient_exam_biodatum_path(patients(:leo), exams(:hemogram))}']", text: "Cadastrar resultados", count: 0
    end
  end
end
