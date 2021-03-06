module Api
  module V1
    class QuestionSerializer < ::ActiveModel::Serializer
      attributes :id, :title, :body, :created_at, :updated_at
      has_many :comments
      has_many :attachments

      class AttachmentSerializer < ::ActiveModel::Serializer
        attribute :source_url
      end
    end
  end
end
