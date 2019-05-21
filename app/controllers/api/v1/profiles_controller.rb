module Api
  module V1
    class ProfilesController < Api::V1::ApplicationController
      def index
        other_users = User.all - [current_resource_owner]
        response = { users: other_users }
        respond_with response
      end

      def me
        respond_with current_resource_owner
      end
    end
  end
end
