# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Gatekeeper::Authorization
  include SetVariant

  skip_before_action :verify_authenticity_token # temporary, until we have a proper authentication system

  private
    def after_sign_in_path_for(resource)
      dispatches_path
    end

    def after_sign_out_path_for(resource)
      root_path
    end

    def generic_response(params = {})
      respond_to do |format|
        format.html
        format.json { render json: { user: current_user, **params } }
      end
    end
end
