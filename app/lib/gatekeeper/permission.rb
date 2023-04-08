# frozen_string_literal: true

module Gatekeeper
  class Permission
    def self.accept?
      false
    end

    def initialize(user = nil)
    end

    def allow_all
      @allow_all = true
    end

    def allow(controllers, actions, &block)
      @allowed_actions ||= {}
      Array(controllers).each do |controller|
        Array(actions).each do |action|
          @allowed_actions[[controller.to_s, action.to_s]] = block || true
        end
      end
    end

    def allow_param(resources, attributes)
      @allowed_params ||= {}
      Array(resources).each do |resource|
        @allowed_params[resource.to_s] ||= []
        @allowed_params[resource.to_s] += Array(attributes).map(&:to_s)
      end
    end

    def allow?(controller, action, resource = nil, auth_token: nil, permission: nil)
      allowed = (@allow_all && permission.nil?) || @allowed_actions[[controller.to_s, action.to_s]] || @allowed_actions[["*", "*"]]
      allowed && (allowed == true || (resource && allowed.call(resource, auth_token)))
    end

    def allow_param?(resource, attribute)
      if @allow_all
        true
      elsif @allowed_params && @allowed_params[resource.to_s]
        @allowed_params[resource.to_s].include? attribute.to_s
      end
    end

    def permit_params!(params)
      if @allow_all
        params.permit!
      elsif @allowed_params
        @allowed_params.each do |resource, attributes|
          if params[resource].respond_to? :permit
            params[resource] = params[resource].permit(*attributes)
          end
        end
      end
    end

    def log_access(controller, action, resource)
      allowed = (@allow_all && permission.nil?) || @allowed_actions[[controller.to_s, action.to_s]] || @allowed_actions[["*", "*"]]
      Rails.logger.info("Authorization for #{controller}/#{action} (#{resource.try(:id)}) uses: #{allowed}")
    end
  end
end
