require 'rails_helper'

feature 'User can create an answer to the question', %q{
  In order to share some knowledge
  As an user
  I want to be able to answer the question
} do

  given(:question) { create :question }
  given(:answer) { attributes_for :answer }

  context 'When user is signed in' do
    scenario 'User creates an answer to the question', js: true do
      user = create :user
      sign_in user
      visit question_path(question)

      within('.answer') do
        fill_in 'Title', with: answer[:title]
        fill_in 'Body', with: answer[:body]
        click_on 'Answer the question'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to have_content answer[:title]
      expect(page).to have_content answer[:body]
    end
  end

  context 'When user is not signed in' do
    scenario 'User tries to create an answer to the question' do
      visit question_path(question)

      within('.answer') do
        fill_in 'Title', with: answer[:title]
        fill_in 'Body', with: answer[:body]
        click_on 'Answer the question'
      end

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'You need to sign in'
    end
  end
end
