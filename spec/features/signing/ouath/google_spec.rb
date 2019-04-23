require_relative '../../features_helper'

feature 'User can sign in with google', %q{
  In order to be able to work with project as signed in user
  As a user
  I want to be able to sign in with google
} do

  context 'When user has an account' do
    given!(:user) { create :user }

    scenario 'User signs in' do
      visit new_user_session_path
      expect(page).to have_link 'Sign in with Google', href: user_google_oauth2_omniauth_authorize_path

      click_on 'Sign in with Google'
      expect(current_path).to eq root_path
      expect(page).to have_content 'Signed in successfully.'
    end
  end

  context 'When user does not have an account' do
    scenario 'User signs in'
  end
end
