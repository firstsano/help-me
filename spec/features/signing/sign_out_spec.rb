require_relative '../features_helper'

feature 'User can sign out', %q{
  In order to provide safety for my profile
  As an user
  I want to be able to sign out
} do

  scenario 'Signed user tries to sign out' do
    user = create :user
    sign_in user

    visit root_path
    within('.navigation__signing') { click_on user.name }

    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'
  end
end
