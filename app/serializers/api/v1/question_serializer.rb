module Api
  module V1
    class QuestionSerializer < ::ActiveModel::Serializer
      attributes :id, :title, :body, :created_at, :updated_at
      has_many :answers
      has_many :attachments

      class AnswerSerializer < ::ActiveModel::Serializer
        attributes :id
      end

      class AttachmentSerializer < ::ActiveModel::Serializer
        attribute :url

        def url
          object.source.url
        end
      end
    end
  end
end
