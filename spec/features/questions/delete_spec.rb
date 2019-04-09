require_relative '../features_helper'

feature 'User can destroy a question', %q{
  In order to remove mistakes or deprecated questions
  As an user
  I want to be able to destroy a question
} do

  context 'When user is signed in' do
    given(:user) { create :user }

    before { sign_in user }

    scenario 'Owner of the answer tries to destroy it' do
      question = create :question, created_by: user
      visit question_path(question)

      expect(page).to have_link 'Delete'
      click_on 'Delete'

      expect(current_path).to eq questions_path
      expect(page).to have_content 'Question was successfully destroyed'
    end

    scenario 'User tries to destroy someone else\'s answer' do
      other_user = create :user
      question = create :question, created_by: other_user
      visit question_path(question)

      expect(page).not_to have_button 'Delete'
    end
  end

  context 'When user is not signed in' do
    scenario 'User tries to destroy an answer' do
      question = create :question
      visit question_path(question)

      expect(page).not_to have_button 'Delete'
    end
  end
end
