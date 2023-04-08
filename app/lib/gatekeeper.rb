# frozen_string_literal: true

module Gatekeeper
  extend ActiveSupport::Autoload
  mattr_accessor :permissions

  def self.permission_for(user)
    [::Permission::VisitorPermission,
     ::Permission::AdminPermission,
     ::Permission::UserPermission].detect { _1.accept?(user) }.new(user)
  end
end
