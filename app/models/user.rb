class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

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

  def self.create_from_ouath(auth)
    password = Devise.friendly_token[0..20]
    User.create! email: auth.info[:email], name: auth.info[:name],
                 password: password, password_confirmation: password
  end
end
