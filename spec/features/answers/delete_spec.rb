require 'rails_helper'

feature 'User can destroy an answer', %q{
  In order to remove wrong or deprecated answer
  As an user
  I want to be able to delete it
} do

  context 'When user is signed in' do
    given(:user) { create :user }

    scenario 'Owner tries to destroy an anwer' do
      sign_in user
      answer = create :answer, created_by: user
      question = answer.question
      visit answer_path(answer)

      click_on 'Delete'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer successfully destroyed'
    end

    scenario 'User tries to destroy someone else\'s answer' do
      sign_in user
      other_user = create :user
      answer = create :answer, created_by: other_user
      visit answer_path(answer)

      expect(page).not_to have_button 'Delete'
    end
  end

  context 'When user is not signed in' do
    scenario 'User tries to destroy an answer' do
      answer = create :answer
      visit answer_path(answer)

      expect(page).not_to have_button 'Delete'
    end
  end
end
