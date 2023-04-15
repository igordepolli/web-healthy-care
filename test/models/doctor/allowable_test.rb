# frozen_string_literal: true

require "test_helper"

class Doctor::AllowableTest < ActiveSupport::TestCase
  test "allowed by?" do
    assert_not doctors(:milena).allowed_by?(patients(:leo))

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now + 2.hours
    assert doctors(:milena).allowed_by?(patients(:leo))

    access_controls(:milena_leo).update_column :expires_at, Time.zone.now - 1.minute
    assert_not doctors(:milena).allowed_by?(patients(:leo))

    access_controls(:milena_leo).delete
    assert_not doctors(:milena).allowed_by?(patients(:leo))
  end
end
