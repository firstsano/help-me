module OmniauthHelper
  def mock_google_hash(user: nil, authorization: nil)
    user = user || build(:user)
    authorization = authorization || build(:authorization)
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      'provider' => authorization.provider,
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
end
