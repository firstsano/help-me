module Api
  module V1
    class AnswersController < ::Api::V1::ApplicationController
      load_and_authorize_resource :question, only: %i[index create]
      load_and_authorize_resource :answer, through: :question, only: %i[index create]
      load_and_authorize_resource except: %i[index create]

      def index
        respond_with @answers
      end

      def show
        respond_with @answer
      end

      def create
        @answer.created_by = current_user
        @answer.save
        respond_with @answer
      end

      private

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
