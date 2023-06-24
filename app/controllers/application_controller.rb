# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Gatekeeper::Authorization
  include SetVariant

  private
    def after_sign_in_path_for(resource)
      dispatches_path
    end

    def after_sign_out_path_for(resource)
      root_path
    end
end
