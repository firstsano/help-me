require 'application_responder'

module Api
  module V1
    class ApplicationController < ActionController::API
      self.responder = ApplicationResponder

      before_action :doorkeeper_authorize!
      check_authorization
      respond_to :json

      protected

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      alias_method :current_user, :current_resource_owner
    end
  end
end
