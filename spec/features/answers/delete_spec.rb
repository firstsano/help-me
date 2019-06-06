require_relative '../features_helper'

feature 'User can destroy an answer', %q{
  In order to remove wrong or deprecated answer
  As an user
  I want to be able to delete it
} do

  given(:question) { create :question }

  before { create_list :answer, 5, question: question }

  context 'When user is signed in' do
    login_user

    scenario 'Owner tries to destroy an anwer', js: true do
      answers = create_list :answer, 3, question: question, created_by: user
      answer = answers.first
      visit question_path(question)

      within("[data-answer-id='#{answer.id}']") do
        accept_confirm { click_on 'Delete' }
      end

      expect(current_path).to eq question_path(question)
      expect(page).not_to have_selector "[data-answer-id='#{answer.id}']"
    end

    scenario 'User tries to destroy someone else\'s answer' do
      visit question_path(question)

      within(".answers") do
        expect(page).not_to have_button "Delete"
      end
    end
  end

  context 'When user is not signed in' do
    scenario 'User tries to destroy an answer' do
      visit question_path(question)

      within(".answers") do
        expect(page).not_to have_button "Delete"
      end
    end
  end
end
