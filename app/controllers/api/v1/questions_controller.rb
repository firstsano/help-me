module Api
  module V1
    class QuestionsController < ::Api::V1::ApplicationController
      load_and_authorize_resource class: Question

      def index
        respond_with @questions
      end

      def show
        respond_with @question
      end

      def create
        @question.created_by = current_user
        @question.save
        respond_with @question
      end

      private

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
