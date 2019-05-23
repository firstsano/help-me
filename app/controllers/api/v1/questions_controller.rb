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
    end
  end
end
