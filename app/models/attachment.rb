class Attachment < ApplicationRecord
  mount_uploader :source, AttachmentUploader

  belongs_to :attachable, polymorphic: true

  validates :attachable, presence: true

  delegate :url, to: :source, prefix: true
end
