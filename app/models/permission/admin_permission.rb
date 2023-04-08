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
      def owner?(model, user)
        true
      end
  end
end
