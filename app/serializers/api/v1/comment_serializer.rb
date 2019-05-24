module Api
  module V1
    class CommentSerializer < ::ActiveModel::Serializer
      attributes :id, :body, :author_name
    end
  end
end
