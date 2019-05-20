class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, :user, presence: true
  validates :provider, uniqueness: { scope: :user_id }
end
