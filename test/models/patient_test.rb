# frozen_string_literal: true

require "test_helper"

class PatientTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    # Este teste verifica se as fixtures são válidas, fixtures em testes no rails são mock's de instâncias persistidas no banco de teste que são utilizadas para testar o comportamento do sistema

    # Aqui ocorre um assert que garante que todas as fixtures são válidas, ou seja, passaram nas validações
    assert patients.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    # Este teste verifica se todos os atributos obrigatórios são validados

    # O método `new` cria uma instância de `Patient` com os atributos passados, neste caso vazio para verificarmos os atributos obrigatórios
    blank = Patient.new

    # Aqui ocorre um assert que garante que a instância criada é inválida, ou seja, não passou nas validações
    assert blank.invalid?

    # Aqui ocorre um assert que garante que a instância criada possui 6 erros de validação
    assert_equal 6, blank.errors.count

    # Aqui ocorre um assert que garante que os erros de validação são os esperados
    assert_equal ["obrigatório"], blank.errors[:name]
    assert_equal ["obrigatório"], blank.errors[:last_name]
    assert_equal ["obrigatório"], blank.errors[:user]
    assert_equal ["obrigatório"], blank.errors[:city]
    assert_equal ["obrigatório", "não é uma opção válida"], blank.errors[:state]
  end

  test "email validator" do
    # Este teste verifica se o validador de email está funcionando corretamente

    # Aqui é setado um e-mail inválido para uma instância de `Patient`
    patients(:leo).email = "leozin.com.br"

    # Aqui ocorre um assert que garante que a instância criada é inválida, ou seja, não passou nas validações
    assert patients(:leo).invalid?

    # Aqui ocorre um assert que garante que a instância criada possui 1 erro de validação
    assert_equal 1, patients(:leo).errors.count

    # Aqui ocorre um assert que garante que o erro de validação é o esperado
    assert_equal ["não é um email válido"], patients(:leo).errors[:email]

    # Aqui é setado um e-mail válido para uma instância de `Patient`
    patients(:leo).email = "leozin@gmail.com"

    # Aqui ocorre um assert que garante que a instância criada é válida, ou seja, passou nas validações
    assert patients(:leo).valid?
  end

  test "cpf validator" do
    # Este teste verifica se o validador de cpf está funcionando corretamente

    # Aqui é setado um cpf inválido para uma instância de `Patient`
    patients(:leo).cpf = "12345678910"

    # Aqui ocorre um assert que garante que a instância criada é inválida, ou seja, não passou nas validações
    assert patients(:leo).invalid?

    # Aqui ocorre um assert que garante que a instância criada possui 1 erro de validação
    assert_equal 1, patients(:leo).errors.count

    # Aqui ocorre um assert que garante que o erro de validação é o esperado
    assert_equal ["inválido"], patients(:leo).errors[:cpf]

    # Aqui é setado um cpf válido para uma instância de `Patient`
    patients(:leo).cpf = "153.316.417-76"

    # Aqui ocorre um assert que garante que a instância criada é válida, ou seja, passou nas validações
    assert patients(:leo).valid?
  end

  test "uniqueness cpf" do
    # Este teste busca garantir que um CPF seja único no escopo de `Patient`

    # Aqui é feita uma preparação, onde é setado um CPF para um paciente
    patients(:leo).update_column :cpf, "153.316.417-76"

    # Aqui é criado uma nova instância de `Patient` com o mesmo CPF do paciente criado anteriormente
    new_patient = patients(:leo).dup

    # Aqui ocorre um assert que garante que a instância criada é inválida, ou seja, não passou nas validações
    assert new_patient.invalid?

    # Aqui ocorre um assert que garante que a instância criada possui 1 erro de validação
    assert_equal 1, new_patient.errors.count

    # Aqui ocorre um assert que garante que o erro de validação é o esperado
    assert_equal ["já foi usado"], new_patient.errors[:cpf]
  end

  test "uniqueness email" do
    # Este teste busca garantir que um email seja único no escopo de `Patient`

    # Aqui é feita uma preparação, onde é setado um email para um paciente
    patients(:leo).update_column :email, "leo@gmail.com"

    # Aqui é criado uma nova instância de `Patient` com o mesmo email do paciente criado anteriormente
    new_patient = patients(:leo).dup

    # Aqui ocorre um assert que garante que a instância criada é inválida, ou seja, não passou nas validações
    assert new_patient.invalid?

    # Aqui ocorre um assert que garante que a instância criada possui 1 erro de validação
    assert_equal 1, new_patient.errors.count

    # Aqui ocorre um assert que garante que o erro de validação é o esperado
    assert_equal ["já foi usado"], new_patient.errors[:email]
  end

  test "state validate" do
    # Este teste busca garantir que o estado seja válido

    # Aqui é setado um estado inválido para uma instância de `Patient`
    patients(:leo).state = "SJ"

    # Aqui ocorre um assert que garante que a instância criada é inválida, ou seja, não passou nas validações
    assert patients(:leo).invalid?

    # Aqui ocorre um assert que garante que a instância criada possui 1 erro de validação
    assert_equal 1, patients(:leo).errors.count

    # Aqui ocorre um assert que garante que o erro de validação é o esperado
    assert_equal ["não é uma opção válida"], patients(:leo).errors[:state]

    # Aqui é setado um estado válido para uma instância de `Patient`
    patients(:leo).state = "SP"

    # Aqui ocorre um assert que garante que a instância criada é válida, ou seja, passou nas validações
    assert patients(:leo).valid?
  end

  test "full name" do
    # Este teste busca garantir que o método `full_name` retorne o nome completo do paciente

    # Aqui ocorre um assert que garante que o método `full_name` retorna o nome completo do paciente
    assert_equal "Leonardo Maralha", patients(:leo).full_name
  end
end
