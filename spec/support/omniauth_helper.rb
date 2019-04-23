module OmniauthHelper
  def mock_google_auth(user: nil, authorization: nil)
    user = user || build(:user)
    authorization = authorization || build(:authorization)
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      'provider' => 'google_oauth2',
      'uid' => authorization.uid,
      'info' => {
        "name" => user.name,
        "email" => user.email,
        "email_verified" => true,
        "image" => "mock_image",
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end

  def reset_auth(provider)
    OmniAuth.config.mock_auth[provider] = nil
  end

  def mock_failure_auth(provider)
    OmniAuth.config.mock_auth[provider] = :invalid_credentials
  end
end
