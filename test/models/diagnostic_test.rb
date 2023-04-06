# frozen_string_literal: true

require "test_helper"

class DiagnosticTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert diagnostics.all?(&:valid?)
  end

  test "database defaults are set" do
    assert diagnostics(:leo_flu).active?
  end

  test "mandatory attributes are validated" do
    blank = Diagnostic.new

    assert blank.invalid?
    assert_equal 3, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:disease]
    assert_equal ["obrigatório"], blank.errors[:patient]
    assert_equal ["obrigatório"], blank.errors[:diagnosed_at]
  end

  test "that a patient's disease does not repeat with the same status" do
    new_disease = diagnostics(:leo_flu).dup

    assert new_disease.invalid?
    assert_equal 1, new_disease.errors.count
    assert_equal ["O paciente já tem essa doença com este mesmo status!"], new_disease.errors[:status]

    new_disease.inactive!

    assert new_disease.valid?
  end
end
