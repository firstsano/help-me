require_relative '../features_helper'

feature 'User can sign in', %q{
  In order to answer and ask question
  As an user
  I want to be able to sign in
} do

  scenario 'Registered user tries to sign in' do
    user = create :user
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
