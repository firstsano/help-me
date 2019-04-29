module OmniauthHelper
  def mock_auth(provider, user: nil, authorization: nil)
    user ||= build :user
    authorization ||= build :authorization
    auth_hash = {
      'provider' => provider,
      'uid' => authorization.uid,
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    }
    provider_hash = send "#{provider}_auth_hash", user
    auth_hash.merge! provider_hash
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(auth_hash)
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
  end

  def google_oauth2_auth_hash(user)
    {
      'info' => {
        "name" => user.name,
        "email" => user.email,
        "email_verified" => true,
        "image" => "mock_image",
      }
    }
  end

  def twitter_auth_hash(user)
    {
      'info' => {
        "name" => user.name,
        "image" => "mock_image",
      }
    }
  end

  def reset_auth(provider)
    OmniAuth.config.mock_auth[provider] = nil
  end

  def mock_failure_auth(provider)
    OmniAuth.config.mock_auth[provider] = :invalid_credentials
  end
end
