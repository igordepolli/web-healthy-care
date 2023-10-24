# frozen_string_literal: true

require "test_helper"

class AccessControl::AllowableTest < ActiveSupport::TestCase
  test "allow!" do
    assert_nil access_controls(:milena_leo).expires_at

    access_controls(:milena_leo).allow!

    assert_not_nil access_controls(:milena_leo).expires_at
    assert_equal "authorized", access_controls(:milena_leo).status
  end
end
