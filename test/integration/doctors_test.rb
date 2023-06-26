
# frozen_string_literal: true

require "test_helper"

class DoctorsTest < ActionDispatch::IntegrationTest
  setup do
    # No setup de uma classe de teste, você define linhas que devem ser executadas antes de cada teste na classe

    # Aqui, estamos definindo que a instância de usuário nomeada como "pending" deve ser do tipo "Doctor"
    users(:pending).update_column :classification, :doctor
  end

  test "authorization" do
    # Este teste verifica se as autorizações para acessar as páginas estão funcionando corretamente

    # Aqui, simulamos uma requisição HTTP do tipo GET para a página do médico da fixture "milena", sem nenhum usuário logado no sistema
    get doctor_path(doctors(:milena))

    # Aqui, verificamos se a resposta da requisição foi um redirecionamento para a página de login, ou seja, que não é possível acessar a página de um médico sem estar logado
    assert_response :redirect

    # Aqui estamos logando um usuário no sistema, a fixture "igor" é um usuário do tipo "Admin", que tem acesso a todas as páginas
    sign_in users(:igor)

    # Aqui, simulamos uma requisição HTTP do tipo GET para a página de um médico específico, com o usuário "igor" logado no sistema
    get doctor_path(doctors(:milena))

    # Aqui, garantimos que a resposta da requisição foi um sucesso, ou seja, que o usuário "igor" tem acesso à página de um médico
    assert_response :ok

    # Aqui, estamos logando um usuário no sistema, a fixture "leo" é um usuário do tipo "Patient"
    sign_in users(:leo)

    # Aqui, simulamos uma requisição HTTP do tipo GET para a página de um médico específico, com o usuário "leo" logado no sistema
    get doctor_path(doctors(:milena))

    # Aqui, garantimos que a resposta da requisição foi um sucesso, ou seja, que o usuário "leo" tem acesso à página de um médico
    assert_response :ok

    # Aqui, estamos logando um usuário no sistema, a fixture "milena" é um usuário do tipo "Doctor", usuária esta que é a dona da página que estamos tentando acessar
    sign_in users(:milena)

    # Aqui, fazemos a mesma requisição HTTP do tipo GET para a página de um médico específico, com o usuário "milena" logado no sistema
    get doctor_path(doctors(:milena))

    # Aqui, garantimos que a resposta da requisição foi um sucesso, ou seja, que o usuário "milena" tem acesso à sua própria página
    assert_response :ok

    # Ainda com o usuário "milena" logado no sistema, simulamos uma requisição HTTP do tipo GET para a página de criação de um novo médico
    get new_doctor_path

    # Aqui, garantimos que a resposta da requisição foi um redirecionamento que deve ocorrer pois, esta Médica já está cadastrada no sistema
    assert_response :redirect

    # Aqui, estamos logando um usuário no sistema, a fixture "pending" é um usuário pré-cadastrado do tipo "Doctor", porém ainda não preencheu os dados complementares na página de criação de médico
    sign_in users(:pending)

    # Aqui, com o usuário "pending" logado no sistema, simulamos uma requisição HTTP do tipo GET para a página de criação de um novo médico
    get new_doctor_path

    # Aqui, garantimos que a resposta da requisição foi um sucesso, pois o usuário "pending" deve conseguir acessar a página de criação de um novo médico para completar seu cadastro
    assert_response :ok

    # Aqui, ainda com o usuário "pending" logado no sistema, simulamos uma requisição HTTP do tipo GET para a página de edição de médico da fixture "milena"
    get edit_doctor_path(doctors(:milena))

    # Aqui, garantimos que a resposta da requisição foi um redirecionamento que deve ocorrer pois, o usuário "pending" não tem permissão para editar o cadastro de outro médico
    assert_response :redirect

    # Aqui, novamente logamos como o usuário "milena"
    sign_in users(:milena)

    # Aqui, fazemos uma requisição HTTP do tipo GET para a página de edição de médico da fixture "milena"
    get edit_doctor_path(doctors(:milena))

    # Aqui, garantimos que a resposta da requisição foi um sucesso, pois o usuário "milena" deve conseguir acessar a página de edição de seu próprio cadastro
    assert_response :ok
  end

  test "new layout" do
    # Este teste verifica se o layout da página de criação de um novo médico está com os elementos corretos

    # Aqui, logamos como o usuário "pending", que é um usuário com permissão para acessar a página de criação de um novo médico
    sign_in users(:pending)

    # Aqui, simulamos uma requisição HTTP do tipo GET para a página de criação de um novo médico
    get new_doctor_path

    # Nas linhas abaixo, garantimos que todos os elementos esperados estão presentes na página
    assert_select "h2", text: "Registrar-se como médico"
    assert_select "form[action='#{doctors_path}'][method='post']" do
      assert_select "input[name='doctor[name]'][required='required']"
      assert_select "input[name='doctor[last_name]'][required='required']"
      assert_select "input[name='doctor[crm]']"
      assert_select "input[name='doctor[cpf]']"
      assert_select "input[name='doctor[email]']"
      assert_select "input[name='doctor[specialty]']"
      assert_select "input[type='submit'][value='Registrar-se']"
    end
    assert_select "a[href='#{edit_user_registration_path}']", text: "Editar dados de usuário"
  end

  test "index" do
    # Este teste verifica se o layout da página de listagem de médicos está com os elementos corretos

    # Aqui, logamos como o usuário "leo", que é um usuário com permissão para acessar a página de listagem de médicos
    sign_in users(:leo)

    # Aqui, simulamos uma requisição HTTP do tipo GET para a página de listagem de médicos
    get doctors_path

    # Nas linhas abaixo, garantimos que todos os elementos esperados estão presentes na página
    assert_select "h2", text: "Médicos"
    assert_select "input[name='query'][placeholder='Buscar por sobrenome ou CRM']"
    assert_select "input[type='submit'][value='Buscar']"

    # Aqui, fazemos uma requisição HTTP do tipo GET para a página de listagem de médicos, passando um parâmetro de busca
    get doctors_path(query: "regiani")

    # Nas linhas abaixo, garantimos que todos os elementos esperados estão presentes na página, principalmente se consta as informações da médica "Milena Regiani", visto que a busca foi por seu sobrenome
    assert_select "h2", text: "Médicos"
    assert_select "input[name='query'][placeholder='Buscar por sobrenome ou CRM']"
    assert_select "input[type='submit'][value='Buscar']"
    assert_select "table" do
      assert_select "th", text: "Nome"
      assert_select "th", text: "CRM"
      assert_select "th", text: "Especialidade"

      assert_select "th", text: "Milena Regiani"
      assert_select "td", text: "123456-SP"
      assert_select "td", text: "Cardiologista"
    end
  end

  test "create success" do
    # Este teste verifica se o cadastro de um novo médico está funcionando corretamente

    # Aqui, logamos como o usuário "pending", que é um usuário com permissão para fazer uma requisição POST de criação de um novo médico
    sign_in users(:pending)

    # Neste assert queremos garantir que, ao final da execução do código do bloco dele(definido por tudo entre o "do" e "end"), a quantidade de médicos no banco de dados tenha aumentado em 1
    assert_difference -> { Doctor.count } => 1 do
      # Aqui, simulamos uma requisição HTTP do tipo POST para a página de criação de um novo médico, passando os parâmetros necessários para o cadastro
      post doctors_path, params: {
        doctor: {
          name: "Coco",
          last_name: "Depolli",
          crm: "31213-ES",
          cpf: "509.084.080-64",
          email: "coco@gmail.com",
          specialty: "Neurologista"
        }
      }


      # Aqui, buscamos o último médico cadastrado no banco de dados
      doctor = Doctor.last

      # Aqui, garantimos que a resposta da requisição foi um redirecionamento para a página de visualização do médico recém criado, o que indica sucesso na criação
      assert_redirected_to doctor_path(doctor)

      # Nestas linhas abaixo, garantimos que todos os dados do médico recém criado batem com os mesmos dados que foram passados na requisição
      assert_equal users(:pending), doctor.user
      assert_equal "Coco", doctor.name
      assert_equal "Depolli", doctor.last_name
      assert_equal "31213-ES", doctor.crm
      assert_equal "509.084.080-64", doctor.cpf
      assert_equal "coco@gmail.com", doctor.email
      assert_equal "Neurologista", doctor.specialty
    end
  end

  test "create fail" do
    # Este teste verifica se o cadastro de um novo médico está falhando se falhar uma verificação no back-end

    # Aqui, como preparação, atualizamos o CRM da médica "Milena Regiani" para um CRM válido
    doctors(:milena).update_column :crm, "3102312-TO"

    # Aqui, logamos como o usuário "pending", que é um usuário com permissão para fazer uma requisição POST de criação de um novo médico
    sign_in users(:pending)

    # Neste assert queremos garantir que, ao final da execução do código do bloco dele(definido por tudo entre o "do" e "end"), a quantidade de médicos no banco de dados não tenha sido alterada
    assert_no_difference -> { Doctor.count } do
      # Aqui, simulamos uma requisição HTTP do tipo POST para a página de criação de um novo médico, passando parâmetros e um CRM repetido que já existe no banco de dados
      post doctors_path, params: {
        doctor: {
          name: "Coco",
          last_name: "Depolli",
          crm: "3102312-TO",
          cpf: "509.084.080-64",
          email: "coco@gmail.com"
        }
      }

      # Aqui, garantimos que a resposta foi do tipo "unprocessable_entity", que é o tipo de resposta que o Rails dá quando uma requisição falha
      assert_response :unprocessable_entity

      # Aqui, garantimos que um alerta com a mensagem "CRM já foi usado" está presente na página sendo mostrada para o usuário
      assert_select ".alert", text: "CRM já foi usado"
    end
  end

  test "update success" do
    # Este teste verifica se a atualização de um médico está funcionando corretamente

    # Aqui, logamos como o usuário "milena", que é um usuário com permissão para fazer uma requisição PATCH de atualização para atualizar seus dados como médica
    sign_in users(:milena)

    # Aqui, simulamos uma requisição HTTP do tipo PATCH para a página de atualização de dados de um médico, passando os parâmetros para atualizar o e-mail da mesma
    patch doctor_path(doctors(:milena)), params: {
      doctor: { email: "milena@gmail.com" }
    }

    # Aqui, garantimos que a resposta da requisição foi um redirecionamento para a página de visualização do médico recém atualizado, o que indica sucesso na atualização
    assert_redirected_to doctor_path(doctors(:milena))

    # Aqui, garantimos que o e-mail da médica da fixture "milena" foi atualizado para o e-mail passado na requisição
    assert_equal "milena@gmail.com", doctors(:milena).reload.email
  end

  test "update fail" do
    # Este teste verifica se a atualização de um médico está falhando se falhar uma verificação no back-end

    # Aqui, logamos como o usuário "milena", que é um usuário com permissão para fazer uma requisição PATCH de atualização para atualizar seus dados como médica
    sign_in users(:milena)

    # Aqui, simulamos uma requisição HTTP do tipo PATCH para a página de atualização de dados de um médico, passando os parâmetros para atualizar o e-mail da mesma com um e-mail inválido
    patch doctor_path(doctors(:milena)), params: {
      doctor: { email: "milenagmail.com" }
    }

    # Aqui, garantimos que a resposta foi do tipo "unprocessable_entity", que é o tipo de resposta que o Rails dá quando uma requisição falha
    assert_response :unprocessable_entity

    # Aqui, garantimos que um alerta com a mensagem "E-mail não é um email válido" está presente na página sendo mostrada para o usuário
    assert_select ".alert", text: "E-mail não é um email válido"
  end
end
