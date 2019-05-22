module Api
  module V1
    class ProfilesController < Api::V1::ApplicationController
      def index
        other_users = User.all - [current_resource_owner]
        authorize! :read, other_users
        respond_with other_users
      end

      def me
        authorize! :read, current_resource_owner
        respond_with current_resource_owner
      end
    end
  end
end
