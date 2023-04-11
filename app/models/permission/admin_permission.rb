# frozen_string_literal: true

module Permission
  class AdminPermission < UserPermission
    def self.accept?(user)
      user.admin?
    end

    def initialize(user)
      super
    end

    private
      def user_custom_permission(user)
        allow "*", ["*"]
      end
  end
end
