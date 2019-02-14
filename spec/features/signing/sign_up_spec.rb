require 'rails_helper'

feature 'User can sign up', %q{
  In order to be able to create questions and answers
  As an user
  I want to be able to sign up
} do

  context 'When user is already registered' do
    given(:user) { create :user }

    scenario 'Signed user tries to register' do
      sign_in user

      visit new_user_registration_path
      expect(current_path).to eq root_path
      expect(page).to have_content 'You are already signed in.'
    end

    scenario 'Unsigned user tries to register' do
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

  scenario 'Non-registered user tries to sign up' do
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
