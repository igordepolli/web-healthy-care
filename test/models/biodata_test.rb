# frozen_string_literal: true

require "test_helper"

class BiodataTest < ActiveSupport::TestCase
  test "that fixtures are valid" do
    assert biodatas.all?(&:valid?)
  end

  test "mandatory attributes are validated" do
    blank = Biodata.new

    assert blank.invalid?
    assert_equal 2, blank.errors.count
    assert_equal ["obrigatório"], blank.errors[:source]
    assert_equal ["Pelo menos um dos biodados deve ter resultados!"], blank.errors[:base]
  end
end
