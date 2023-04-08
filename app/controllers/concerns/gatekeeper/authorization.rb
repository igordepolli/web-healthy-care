# frozen_string_literal: true

module Gatekeeper
  module Authorization
    extend ActiveSupport::Concern

    included do
      delegate :allow?, to: :current_permission
      helper_method :allow?

      delegate :allow_param?, to: :current_permission
      helper_method :allow_param?

      before_action do
        if current_permission.allow?(params[:controller], params[:action], current_resource, auth_token: params[:auth_token])
          current_permission.permit_params! params
        else
          current_permission.log_access(params[:controller], params[:action], current_resource)
          unauthorized_access
        end
      end
    end

    private
      def current_resource
        @model
      end

      def current_permission
        @permission = Gatekeeper.permission_for(current_user)
      end

      def unauthorized_access
        if user_signed_in?
          redirect_to dispatches_path
        else
          authenticate_user!
        end
      end
  end
end
