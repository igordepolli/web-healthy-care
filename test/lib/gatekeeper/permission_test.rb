# frozen_string_literal: true

require "test_helper"

class Gatekeeper::PermissionTest < ActiveSupport::TestCase
  setup do
    @permission = Gatekeeper::Permission.new
  end

  test "false by default" do
    @permission.allow("users", "edit")
    @permission.allow("sessions", "new")

    assert_not @permission.allow?("users", "new")
  end

  test "allow all" do
    @permission.allow_all
    assert @permission.allow?("users", "new")
  end

  test "allow a controller and action" do
    @permission.allow("users", "new")
    @permission.allow("users", "create")

    assert @permission.allow?("users", "new")
    assert @permission.allow?("users", "create")
  end

  test "allow multiple actions at once" do
    @permission.allow("users", ["new", "create"])
    assert @permission.allow?("users", "new")
    assert @permission.allow?("users", "create")
  end
end
