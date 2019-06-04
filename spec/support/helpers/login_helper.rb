module LoginHelper
  def login_user
    let(:user) { @user = create :user }

    before(type: :controller) { @request.env["devise.mapping"] = Devise.mappings[:user] }
    before(type: :feature) { Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] }
    before { sign_in user }
  end
end
