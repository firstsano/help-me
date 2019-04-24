require_relative '../../features_helper'

feature 'User can sign in with twitter', %q{
  In order to be able to work with project as signed in user
  As a user
  I want to be able to sign in with twitter
} do

  background do
    clear_emails
    reset_auth :twitter
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
  end

  context 'When user has an authorization' do
    given!(:user) { create :user }
    given!(:authorization) { create :authorization, provider: 'twitter', user: user }
    background { mock_twitter_auth user: user, authorization: authorization }

    scenario 'User signs in' do
      visit new_user_session_path
      expect(page).to have_link 'Sign in with Twitter', href: user_twitter_omniauth_authorize_path

      click_on 'Sign in with Twitter'
      expect(current_path).to eq root_path
      expect(page).to have_content 'Successfully authenticated from Twitter account'
    end
  end

  context 'When user has no authorization' do
    context 'When user exists' do
      given!(:user) { create :user }
      background { mock_twitter_auth user: user }

      scenario 'User is asked to enter his email for confirmation' do
        visit new_user_session_path
        expect(page).to have_link 'Sign in with Twitter', href: user_twitter_omniauth_authorize_path

        click_on 'Sign in with Twitter'
        expect(current_path).to eq auth_email_path

        fill_in 'email', with: user.email
        click_on 'Submit'

        expect(page).to have_content 'Follow email link to confirm your account'
      end

      context 'When user enters his email' do
        background do
          visit new_user_session_path
          click_on 'Sign in with Twitter'
          fill_in 'email', with: user.email
          click_on 'Submit'
        end

        context 'When user is not yet approved' do
          scenario 'Until user is approved he is redirected to enter email page' do
            visit new_user_session_path
            click_on 'Sign in with Twitter'
            expect(current_path).to eq auth_email_path
          end
        end

        context 'When user is approved' do
          scenario 'Authorization is created and user signs in' do
            open_email user.email
            current_email.click 'Confirm my account'
            expect(page).to have_content 'Your email address has been successfully confirmed.'

            visit new_user_session_path
            click_on 'Sign in with Twitter'
            expect(page).to have_content 'Successfully authenticated from Twitter account'
          end
        end
      end

      context 'When user enters someone else\'s email' do
        context 'When other user already has twitter authorization' do
          given!(:authorization) { create :authorization, provider: 'twitter', user: user }
          background do
            mock_twitter_auth
            visit new_user_session_path
            click_on 'Sign in with Twitter'
            fill_in 'email', with: user.email
            click_on 'Submit'
          end

          scenario 'Other user mistakenly approves another twitter account' do
            open_email user.email
            current_email.click 'Confirm my account'
            expect(page).to have_content 'You already have another twitter account linked.'
          end
        end
      end
    end

    context 'When user does not exist' do
      let(:email) { Faker::Internet.email }
      background { mock_twitter_auth }

      scenario 'User is created and signs in' do
        visit new_user_session_path
        expect(page).to have_link 'Sign in with Twitter', href: user_google_oauth2_omniauth_authorize_path

        click_on 'Sign in with Twitter'
        expect(current_path).to eq auth_email_path

        fill_in 'email', with: email
        click_on 'Submit'

        expect(page).to have_content 'Follow email link to confirm your account'

        open_email email
        current_email.click 'Confirm my account'
        expect(page).to have_content 'Your email address has been successfully confirmed.'

        visit new_user_session_path
        click_on 'Sign in with Twitter'
        expect(page).to have_content 'Successfully authenticated from Twitter account'
      end
    end
  end
end
