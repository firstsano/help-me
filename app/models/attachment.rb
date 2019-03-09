class Attachment < ApplicationRecord
  mount_uploader :source, AttachmentUploader

  belongs_to :attachable, polymorphic: true
end
