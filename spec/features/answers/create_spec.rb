require_relative '../features_helper'

feature 'User can create an answer to the question', %q{
  In order to share some knowledge
  As an user
  I want to be able to answer the question
} do

  given(:question) { create :question }
  given(:answer) { attributes_for :answer }

  context 'When user is signed in' do
    before do
      create_list :answer, 5, question: question
      user = create :user
      sign_in user
      visit question_path(question)
    end

    context 'With valid attributes' do
      scenario 'User creates an answer to the question', js: true do
        within('.question-answer') do
          fill_in 'Body', with: answer[:body]
          click_on 'Answer the question'
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_content answer[:body]
      end
    end

    context 'With invalid attributes' do
      scenario 'User tries to create an answer', js: true do
        within('.question-answer') do
          fill_in 'Body', with: ''
          click_on 'Answer the question'
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  context 'When user is not signed in' do
    scenario 'User tries to create an answer to the question' do
      visit question_path(question)

      within('.question-answer') do
        fill_in 'Body', with: answer[:body]
        click_on 'Answer the question'
      end

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'You need to sign in'
    end
  end
end
