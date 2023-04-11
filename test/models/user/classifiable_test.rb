# frozen_string_literal: true

require "test_helper"

class User::ClassifiableTest < ActiveSupport::TestCase
  test "validate classifications" do
    assert_raise ArgumentError do
      users(:leo).update! classification: :batata
    end

    assert_nothing_raised do
      users(:leo).update! classification: :doctor

      assert users(:leo).doctor?
    end
  end

  test "public classifications" do
    assert_equal %w[patient doctor], User.public_classifications.keys
  end
end
