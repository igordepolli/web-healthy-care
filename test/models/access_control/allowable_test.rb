# frozen_string_literal: true

require "test_helper"

class AccessControl::AllowableTest < ActiveSupport::TestCase
  test "allowed?" do
    assert_not access_controls(:milena_leo).allowed?

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    assert access_controls(:milena_leo).allowed?

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute

    assert_not access_controls(:milena_leo).allowed?
  end

  test "waiting allow?" do
    assert access_controls(:milena_leo).waiting_allow?

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours

    assert_not access_controls(:milena_leo).waiting_allow?
  end

  test "allow!" do
    assert_nil access_controls(:milena_leo).expires_at

    access_controls(:milena_leo).allow!

    assert_not_nil access_controls(:milena_leo).expires_at
  end
end
