class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[google_oauth2 twitter]

  has_many :authorizations

  validates :name, presence: true

  def to_s
    name
  end

  def self.find_for_oauth(auth)
    provider, uid = auth.provider, auth.uid.to_s
    authorization = Authorization.find_by provider: provider, uid: uid
    return authorization.user if authorization

    user = self.find_by(email: auth.info[:email]) || self.create_from_ouath(auth)
    user.authorizations.create provider: provider, uid: uid
    user
  end

  def self.find_by_auth(provider:, uid:)
    self.joins(:authorizations).where(authorizations: { provider: provider, uid: uid }).first
  end

  def self.create_from_ouath(auth)
    create_with_password email: auth.info[:email], name: auth.info[:name], confirmed_at: Date.today
  end

  def self.create_with_password(**attributes)
    password = Devise.friendly_token[0..20]
    attributes[:password] = password
    attributes[:password_confirmation] = password
    User.create **attributes
  end
end
