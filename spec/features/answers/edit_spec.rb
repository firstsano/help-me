require_relative '../features_helper'

feature 'Editing answer', %q{
  To be able to fix some typos
  As an user
  I want to be able to edit an answer
} do

  given(:question) { create :question }
  before { create_list :answer, 5, question: question }

  context 'When user is signed' do
    given(:user) { create :user }
    before { sign_in user }

    scenario 'User tries to edit someone else\'s answer' do
      visit question_path(question)

      within('.answers') do
        expect(page).not_to have_link 'Edit'
      end
    end

    context 'With valid attributes' do
      scenario 'Owner tries to edit an answer', js: true do
        answer = create :answer, question: question, created_by: user
        new_answer = attributes_for :answer
        visit question_path(question)

        within("[data-answer-id='#{answer.id}']") do
          expect(page).not_to have_selector '.answer-form'

          click_on 'Edit'
          expect(current_path).to eq question_path(question)

          within('.answer-form') do
            fill_in 'Body', with: new_answer[:body]
            click_on 'Save'
          end

          expect(current_path).to eq question_path(question)
          expect(page).to have_content new_answer[:body]
          expect(page).not_to have_selector '.answer-form'
        end
      end
    end

    context 'With invalid attributes' do
      scenario 'Owner tries to edit an answer', js: true do
        answer = create :answer, question: question, created_by: user
        visit question_path(question)

        within("[data-answer-id='#{answer.id}']") do
          expect(page).not_to have_selector '.answer-form'

          click_on 'Edit'
          expect(current_path).to eq question_path(question)

          within('.answer-form') do
            fill_in 'Body', with: nil
            click_on 'Save'
          end

          expect(current_path).to eq question_path(question)
          expect(page).to have_selector '.answer-form'
          expect(page).to have_content 'Body can\'t be blank'
        end
      end
    end
  end

  context 'When user is unsigned' do
    scenario 'User tries to edit an answer' do
      visit question_path(question)

      within('.answers') do
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end
