require_relative '../features_helper'

feature 'User can create a question', %q{
  In order to get some knowledge
  As an user
  I want to be able to create a question
} do

  given(:user) { create :user }
  given(:question) { attributes_for :question }

  context 'When user is signed in' do
    context 'With invalid attributes' do
      scenario 'User tries to create a question' do
        sign_in user
        visit questions_path

        click_on 'Create question'
        expect(current_path).to eq new_question_path

        fill_in 'Title', with: question[:title]
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content 'Body can\'t be blank'
      end
    end

    context 'With valid attributes' do
      scenario 'User creates a question' do
        sign_in user
        visit questions_path

        click_on 'Create question'
        expect(current_path).to eq new_question_path

        fill_in 'Title', with: question[:title]
        fill_in 'Body', with: question[:body]
        click_on 'Save'

        expect(page).to have_text 'Question was successfully created'

        visit questions_path
        expect(page).to have_content question[:title]
      end
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
