require_relative '../features_helper'

feature 'User can create a question', %q{
  In order to get some knowledge
  As an user
  I want to be able to create a question
} do

  given(:user) { create :user }

  context 'When user is signed in' do
    scenario 'User creates a question' do
      sign_in user
      visit questions_path

      click_on 'Create question'
      expect(current_path).to eq new_question_path

      fill_in 'Title', with: 'Awesome title'
      fill_in 'Body', with: 'Awesome Body'
      click_on 'Save'

      expect(page).to have_text 'Question created successfully'

      visit questions_path
      expect(page).to have_content 'Awesome title'
    end
  end

  context 'When user is not signed in' do
    scenario 'User tries to create a question' do
      visit questions_path
      click_on 'Create question'

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'You need to sign in'
    end
  end
end
