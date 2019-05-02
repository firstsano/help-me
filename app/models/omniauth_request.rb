class OmniauthRequest < ApplicationRecord
  CONFIRMATION_PERIOD = 1.day

  validates :provider, :uid, :name, presence: true
  validates :email, presence: true, format: { with: Devise.email_regexp }
  before_create :generate_token, unless: proc { |request| request.confirmation_token.present? }

  scope :unconfirmed, -> { where confirmed_at: nil }

  def send_confirmation
    self.update_attributes! confirmation_sent_at: DateTime.now
    OmniauthRequestMailer.confirmation_instructions(email, confirmation_token).deliver_later
  end

  def self.actual
    actualization_time = DateTime.now - CONFIRMATION_PERIOD
    self.where "confirmation_sent_at > ?", actualization_time
  end

  def confirm
    self.update_attributes! confirmed_at: DateTime.now
  end

  private

  def generate_token
    self.confirmation_token = SecureRandom.uuid
  end
end
