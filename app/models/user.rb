class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[google_oauth2 twitter]

  has_many :authorizations
  has_many :subscriptions, class_name: 'QuestionSubscription', dependent: :destroy

  validates :name, presence: true

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

  def to_s
    name
  end

  def has_provider?(provider)
    authorizations.where(provider: provider).any?
  end

  def generate_auth(provider, uid)
    self.authorizations.create! provider: provider, uid: uid
  end

  def subscribe(question)
    self.subscriptions.create user: self, question: question
  end

  def unsubscribe(question)
    self.subscriptions.where(question_id: question).destroy_all
  end

  def subscribed?(question)
    subscriptions.where(question_id: question).any?
  end
end
