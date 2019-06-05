require_relative '../controllers_helper'

describe Users::OmniauthCallbacksController, :with_timecop, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'POST #register_auth' do
    let(:email) { generate :email }

    context 'when session data is missing' do
      it 'redirects to the root path with error message' do
        post :register_auth, params: { user: { email: email } }
        expect(response).to redirect_to root_path
        expect(controller).to set_flash[:error]
      end
    end

    context 'when session data presents' do
      let!(:session_data) { { "devise.provider_data": mock_auth('google_oauth2') } }

      context 'when provided email is invalid' do
        it "renders tempate" do
          post :register_auth, params: { user: { email: 'invalid email' } }, session: session_data
          expect(response).to render_template :new_auth
        end

        it "assigns errors to @errors" do
          post :register_auth, params: { user: { email: 'invalid email' } }, session: session_data
          expect(assigns(@errors)).not_to be_nil
          expect(assigns(@errors)).not_to be_empty
        end
      end

      context 'when user exists' do
        let(:session_data) { { "devise.provider_data": mock_auth('google_oauth2', user: user, authorization: authorization) } }

        let!(:user) { create :user }

        context 'when user has current provider authorization' do
          let(:authorization) { create :authorization, provider: 'google_oauth2', user: user }

          it 'redirects to the root path with error message' do
            post :register_auth, params: { user: { email: user.email } }, session: session_data
            expect(response).to redirect_to root_path
            expect(controller).to set_flash[:error]
          end
        end

        context 'when user has no current provider authorization' do
          let(:authorization) { create :authorization, provider: 'other_provider', user: user }

          it 'creates omniauth_request' do
            expect { post :register_auth, params: { user: { email: user.email } }, session: session_data }.to change(OmniauthRequest, :count).by(1)
          end

          it 'redirects to the root path with the notice' do
            post :register_auth, params: { user: { email: user.email } }, session: session_data
            expect(response).to redirect_to root_path
            expect(controller).to set_flash[:notice]
          end
        end
      end

      context 'when user does not exist' do
        it 'does not create user yet' do
          expect { post :register_auth, params: { user: { email: email } }, session: session_data }.not_to change(User, :count)
        end

        it 'creates omniauth_request' do
          expect { post :register_auth, params: { user: { email: email } }, session: session_data }.to change(OmniauthRequest, :count).by(1)
        end

        it 'redirects to the root path with the notice' do
          post :register_auth, params: { user: { email: email } }, session: session_data
          expect(response).to redirect_to root_path
          expect(controller).to set_flash[:notice]
        end
      end
    end
  end

  describe 'GET #confirm_auth' do
    context 'on invalid tokens' do
      let(:omniauth_requests) do
        [
          create(:omniauth_request, :overdue),
          create(:omniauth_request, :confirmed)
        ]
      end
      let!(:tokens) { omniauth_requests.map(&:confirmation_token) }

      it 'redirects to the root path with error message' do
        tokens.each do |token|
          get :confirm_auth, params: { token: token }
          expect(response).to redirect_to root_path
          expect(controller).to set_flash[:error]
        end
      end
    end

    context 'on valid token' do
      let(:omniauth_request) { create :omniauth_request, :confirmation_sent }
      let!(:token) { omniauth_request.confirmation_token }

      it 'confirms the token' do
        expect { get :confirm_auth, params: { token: token }; omniauth_request.reload }.to change(omniauth_request, :confirmed_at)
      end

      context 'when user exists' do
        let!(:user) { create :user, email: omniauth_request.email }

        context 'when user has current provider authorization' do
          let!(:authorization) { create :authorization, provider: omniauth_request.provider, user: user }

          it 'redirects to the root path with error message' do
            get :confirm_auth, params: { token: token }
            expect(response).to redirect_to root_path
            expect(controller).to set_flash[:error]
          end
        end

        context 'when user has no current provider authorization' do
          it 'creates authorization' do
            expect { get :confirm_auth, params: { token: token } }.to change(user.authorizations, :count).by(1)
          end

          it 'redirects to the new_user_session_path with the notice' do
            get :confirm_auth, params: { token: token }
            expect(response).to redirect_to new_user_session_path
            expect(controller).to set_flash[:notice]
          end
        end
      end

      context 'when user does not exist' do
        it 'creates a user' do
          expect { get :confirm_auth, params: { token: token } }.to change(User, :count)
        end

        it 'creates an authorization' do
          expect { get :confirm_auth, params: { token: token } }.to change(Authorization, :count).by(1)
        end

        it 'redirects to the new_user_session_path with the notice' do
          get :confirm_auth, params: { token: token }
          expect(response).to redirect_to new_user_session_path
          expect(controller).to set_flash[:notice]
        end
      end
    end
  end
end
