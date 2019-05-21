module Api
  module V1
    class ProfilesController < ActionController::API
      before_action :doorkeeper_authorize!
      respond_to :json

      def me
        respond_with nil
      end
    end
  end
end
