# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private
    def after_sign_in_path_for(resource)
      if resource.is_a?(User)
        # TODO
      else
        super
      end
    end

    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
end
