require 'rails_helper'

feature 'User can sign in', %q{
  In order to answer and ask question
  As an user
  I want to be able to sign in
} do

  given(:user) { create :user }

  scenario 'Registered user tries to sign in' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Non-registered user tries to sign in' do
    user = attributes_for :user

    visit new_user_session_path

    fill_in 'Email', with: user[:email]
    fill_in 'Password', with: user[:password]
    click_on 'Log in'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Invalid Email or password.'
  end
end

feature 'User can sign out', %q{
  In order to provide safety for my profile
  As an user
  I want to be able to sign out
} do

  given(:user) { create :user }

  scenario 'Signed in user tries to sign out' do
    sign_in user

    visit root_path
    click_on 'Log out'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'
  end
end

feature 'User can register', %q{
  In order to be able to create questions and answers
  As an user
  I want to be able to register
} do

  context 'When user is already registered' do
    given(:user) { create :user }

    scenario 'Signed-in user tries to register' do
      sign_in user

      visit new_user_registration_path
      expect(current_path).to eq root_path
      expect(page).to have_content 'You are already signed in.'
    end

    scenario 'Not signed in user tries to register' do
      visit new_user_registration_path

      fill_in 'Email', with: user.email
      fill_in 'Name', with: user.name
      fill_in 'user[password]', with: user.password
      fill_in 'user[password_confirmation]', with: user[:password]
      click_on 'Sign up'

      expect(current_path).to eq user_registration_path
      expect(page).to have_content 'Email has already been taken'
    end
  end

  scenario 'Non-registered user tries to register' do
    user = attributes_for :user

    visit new_user_registration_path

    fill_in 'Email', with: user[:email]
    fill_in 'Name', with: user[:name]
    fill_in 'user[password]', with: user[:password]
    fill_in 'user[password_confirmation]', with: user[:password]
    click_on 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
