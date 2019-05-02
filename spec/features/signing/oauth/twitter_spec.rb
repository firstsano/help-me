require_relative '../../features_helper'

feature 'User can sign in with twitter', %q{
  In order to be able to work with project as signed in user
  As a user
  I want to be able to sign in with twitter
} do

  background do
    clear_emails
    reset_auth :twitter
  end

  context 'When user has an authorization' do
    context 'When user uses registered twitter account' do
      given!(:user) { create :user }
      given!(:authorization) { create :authorization, provider: 'twitter', user: user }
      background { mock_auth :twitter, user: user, authorization: authorization }

      scenario 'User signs in' do
        visit new_user_session_path
        expect(page).to have_link 'Sign in with Twitter', href: user_twitter_omniauth_authorize_path

        click_on 'Sign in with Twitter'
        expect(current_path).to eq root_path
        expect(page).to have_content 'Successfully authenticated from twitter account'
      end
    end

    context 'When user uses another twitter account' do
      given!(:user) { create :user }
      given!(:user_authorization) { create :authorization, provider: 'twitter', user: user }
      given(:authorization) { build :authorization, provider: 'twitter', user: user }
      background { mock_auth :twitter, user: user, authorization: authorization }

      scenario 'User is redirected to the root_path with error message' do
        visit new_user_session_path

        click_on 'Sign in with Twitter'
        fill_in 'Email', with: user.email
        click_on 'Submit'

        expect(current_path).to eq root_path
        expect(page).to have_content 'You already have another twitter account.'
      end
    end
  end

  context 'When user has an authorization through other provider' do
    context 'When user tries to sign in with Twitter' do
      given!(:user) { create :user }
      given!(:authorization) { create :authorization, provider: 'google', user: user }
      background do
        reset_auth :google_oauth2
        mock_auth :twitter, user: user

        visit new_user_session_path
        click_on 'Sign in with Twitter'
        fill_in 'Email', with: user.email
        click_on 'Submit'
      end

      scenario 'User is still able to sign in with Google' do
        mock_auth :google_oauth2, user: user, authorization: authorization

        visit new_user_session_path
        click_on 'Sign in with Google'
        expect(current_path).to eq root_path
        expect(page).to have_content 'Successfully authenticated from google_oauth2 account'
      end
    end
  end

  context 'When user has no authorization' do
    context 'When user exists' do
      given!(:user) { create :user }
      background { mock_auth :twitter, user: user }

      scenario 'User is asked to enter his email for confirmation' do
        visit new_user_session_path
        click_on 'Sign in with Twitter'
        expect(current_path).to eq users_auth_email_confirmation_path

        fill_in 'Email', with: user.email
        click_on 'Submit'

        expect(page).to have_content 'Follow email link to confirm your account'
        open_email user.email
        expect(current_email).not_to be_nil
      end

      scenario 'User is shown an error message on invalid email' do
        visit new_user_session_path
        click_on 'Sign in with Twitter'
        expect(current_path).to eq users_auth_email_confirmation_path

        fill_in 'Email', with: 'invalid_email'
        click_on 'Submit'

        expect(page).to have_content 'Invalid email'
      end

      context 'When user enters his email' do
        background do
          visit new_user_session_path
          click_on 'Sign in with Twitter'
          fill_in 'Email', with: user.email
          click_on 'Submit'
        end

        context 'Until user is approved' do
          scenario 'User is redirected to email page on sign in tries' do
            visit new_user_session_path
            click_on 'Sign in with Twitter'
            expect(current_path).to eq users_auth_email_confirmation_path
          end
        end

        context 'When user is approved' do
          scenario 'Authorization is created and user signs in' do
            open_email user.email
            current_email.click_link 'Confirm your authorization'
            expect(page).to have_content 'Your email address has been successfully confirmed.'

            visit new_user_session_path
            click_on 'Sign in with Twitter'
            expect(page).to have_content 'Successfully authenticated from twitter account'
          end

          scenario 'User cannot use same link again' do
            open_email user.email
            current_email.click_link 'Confirm your authorization'
            expect(page).to have_content 'Your email address has been successfully confirmed.'

            open_email user.email
            current_email.click_link 'Confirm your authorization'
            expect(page).to have_content 'Request token does not exist or has already been used.'
          end
        end
      end
    end

    context 'When user does not exist' do
      let(:email) { Faker::Internet.email }
      background { mock_auth :twitter }

      scenario 'User is created and signs in' do
        visit new_user_session_path
        expect(page).to have_link 'Sign in with Twitter', href: user_twitter_omniauth_authorize_path

        click_on 'Sign in with Twitter'
        expect(current_path).to eq users_auth_email_confirmation_path

        fill_in 'Email', with: email
        click_on 'Submit'

        expect(page).to have_content 'Follow email link to confirm your account'

        open_email email
        current_email.click_link 'Confirm your authorization'
        expect(page).to have_content 'Your email address has been successfully confirmed.'

        visit new_user_session_path
        click_on 'Sign in with Twitter'
        expect(page).to have_content 'Successfully authenticated from twitter account'
      end
    end
  end
end
