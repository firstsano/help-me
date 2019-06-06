module LoginHelper
  module Controller
    def login_user
      let(:user) { @user = create :user }

      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end
    end
  end

  module Request
    def login_user
      let(:user) { @user = create :user }
      let!(:access_token) { create :access_token, resource_owner_id: user.id }
    end
  end

  module Feature
    def login_user
      setup_user_mapping

      let(:user) { @user = create :user }

      before { sign_in user }
    end

    def setup_user_mapping
      before { Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] }
    end
  end
end
