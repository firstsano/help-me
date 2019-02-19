require_relative '../features_helper'

feature 'Editing the question', %q{
  In order to fix any typos
  As an user
  I want to be able to edit a question
} do

  context 'When user is signed' do
    given(:user) { create :user }
    before { sign_in user }

    scenario 'User tries to edit someone else\'s question' do
      question = create :question
      visit question_path(question)

      expect(page).not_to have_link 'Edit', href: edit_question_path(question)
    end

    scenario 'Owner tries to edit a question', js: true do
      question = create :question, created_by: user
      new_question = attributes_for :question

      visit question_path(question)
      expect(page).not_to have_selector '.question-form'

      click_on 'Edit'
      expect(current_path).to eq question_path(question)
      expect(page).to have_selector '.question-form'

      within('.question-form') do
        fill_in 'Title', with: new_question[:title]
        fill_in 'Body', with: new_question[:body]
        click_on 'Save'
      end

      expect(current_path).to eq question_path(question)
      expect(page).not_to have_selector '.question-form'
      expect(page).to have_content new_question[:title]
      expect(page).to have_content new_question[:body]
    end
  end

  context 'When user is unsigned' do
    scenario 'User tries to edit a question' do
      question = create :question
      visit question_path(question)

      expect(page).not_to have_link 'Edit', href: edit_question_path(question)
    end
  end
end
