module Api
  module V1
    class AnswersController < ::Api::V1::ApplicationController
      load_and_authorize_resource :question, only: :index
      load_and_authorize_resource :answer, through: :question, only: :index
      load_and_authorize_resource except: :index

      def index
        respond_with @answers
      end

      def show
        respond_with @answer
      end
    end
  end
end
