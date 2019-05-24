module Api
  module V1
    class AnswerSerializer < ::ActiveModel::Serializer
      attributes :id, :body, :created_at, :updated_at
      has_many :comments
      has_many :attachments

      class AttachmentSerializer < ::ActiveModel::Serializer
        attribute :source_url
      end
    end
  end
end
