require_relative '../../features_helper'

feature 'User can sign in with google', %q{
  In order to be able to work with project as signed in user
  As a user
  I want to be able to sign in with google
} do

  background do
    clear_emails
    reset_auth :google_oauth2
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  context 'When user has an authorization' do
    given!(:user) { create :user }
    given!(:authorization) { create :authorization, provider: 'google_oauth2', user: user }
    before { mock_google_auth user: user, authorization: authorization }

    scenario 'User signs in' do
      visit new_user_session_path
      expect(page).to have_link 'Sign in with Google', href: user_google_oauth2_omniauth_authorize_path

      click_on 'Sign in with Google'
      expect(current_path).to eq root_path
      expect(page).to have_content 'Successfully authenticated from Google account'
    end
  end

  context 'When user has no authorization' do
    context 'When user exists' do
      given!(:user) { create :user }
      before { mock_google_auth user: user }

      scenario 'User signs in and authorization is created' do
        visit new_user_session_path
        expect(page).to have_link 'Sign in with Google', href: user_google_oauth2_omniauth_authorize_path

        click_on 'Sign in with Google'
        expect(current_path).to eq root_path
        expect(page).to have_content 'Successfully authenticated from Google account'
      end
    end

    context 'When user does not exist' do
      before { mock_google_auth }

      scenario 'User is created and signs in' do
        visit new_user_session_path
        expect(page).to have_link 'Sign in with Google', href: user_google_oauth2_omniauth_authorize_path

        click_on 'Sign in with Google'
        expect(current_path).to eq root_path
        expect(page).to have_content 'Successfully authenticated from Google account'
      end
    end
  end

  context 'When user triggered omniauth error' do
    before { mock_failure_auth :google_oauth2 }

    scenario 'User is redirected to root_path' do
      visit new_user_session_path
      expect(page).to have_link 'Sign in with Google', href: user_google_oauth2_omniauth_authorize_path

      click_on 'Sign in with Google'
      expect(current_path).to eq root_path
      expect(page).to have_content 'Unable to sign in with provider'
    end
  end
end
