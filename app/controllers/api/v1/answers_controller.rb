module Api
  module V1
    class AnswersController < ::Api::V1::ApplicationController
      load_and_authorize_resource :question
      load_and_authorize_resource :answer, through: :question

      def index
        respond_with @answers
      end
    end
  end
end
