module Api
  module V1
    class QuestionSerializer < ::ActiveModel::Serializer
      attributes :id, :title, :body, :created_at, :updated_at
    end
  end
end
