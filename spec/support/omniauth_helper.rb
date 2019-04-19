module OmniauthHelper
  def mock_google_hash(name:, email:)
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      'provider' => 'google_oauth2',
      'uid' => '123545',
      'info' => {
        "name" => name,
        "email" => email,
        "email_verified" => true,
        "first_name" => name,
        "last_name" => name,
        "image" => "mock_image",
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end
end
