require_relative '../features_helper'

feature 'User can create an answer to the question', %q{
  In order to share some knowledge
  As an user
  I want to be able to answer the question
} do

  given(:question) { create :question }
  given(:answer) { attributes_for :answer }

  context 'When user is signed in' do
    login_user

    before do
      create_list :answer, 5, question: question
      visit question_path(question)
    end

    context 'With valid attributes' do
      scenario 'User creates an answer to the question', js: true do
        within('.question-answer') do
          fill_in 'answer[body]', with: answer[:body]
          click_on 'Answer the question'
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_content answer[:body]
      end
    end

    context 'With invalid attributes' do
      scenario 'User tries to create an answer', js: true do
        within('.question-answer') do
          fill_in 'answer[body]', with: nil
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

      expect(page).not_to have_selector '.question-answer'
    end
  end
end
