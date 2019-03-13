require_relative 'features_helper'

feature 'User can navigate through pages', %q{
  In order to find required information
  As an user
  I want to be able to see and use navigation bar
} do

  given(:user) { create :user }

  def expect_main_menu
    expect(page).to have_selector 'nav.navbar'
  end

  scenario 'User can see navigation bar and main links' do
    visit root_path

    expect_main_menu
    expect(page).to have_link 'Questions', href: questions_path
  end

  scenario 'Signed in user sees personal info and controls' do
    sign_in user
    visit root_path

    expect_main_menu
    expect(page).to have_content user.name
    expect(page).to have_link user.name, href: destroy_user_session_path
  end
end
