module Api
  module V1
    class UsersController < ApplicationController
      def index
        other_users = User.all - [current_resource_owner]
        response = { users: other_users }
        respond_with response
      end
    end
  end
end
