# frozen_string_literal: true

module Permission
  class VisitorPermission < Gatekeeper::Permission
    def self.accept?(user)
      user.nil?
    end

    def initialize(_)
      visitor_basic_permission
    end

    private
      def visitor_basic_permission
        allow "home", [:show]
        allow "users/registrations", [:new, :edit, :create, :update, :destroy, :cancel]
        allow "devise/sessions", [:new, :create]
        allow "devise/passwords", [:edit, :update, :create]
      end
  end
end
