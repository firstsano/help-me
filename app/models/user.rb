class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[google_oauth2 twitter]

  has_many :authorizations

  validates :name, presence: true

  def to_s
    name
  end

  def has_provider?(provider)
    authorizations.where(provider: provider).any?
  end

  def generate_auth(provider, uid)
    self.authorizations.create! provider: provider, uid: uid
  end

  def self.get_by_oauth(name, email)
    self.find_by(email: email) || self.create_confirmed(name, email)
  end

  def self.find_by_auth(provider, uid)
    self.joins(:authorizations).where(authorizations: { provider: provider, uid: uid }).first
  end

  def self.create_confirmed(name, email)
    password = Devise.friendly_token[0..20]
    User.create! name: name, email: email, password: password,
                 password_confirmation: password, confirmed_at: Date.today
  end
end
