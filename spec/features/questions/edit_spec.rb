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

    context 'With valid attributes' do
      let(:question) { create :question, created_by: user }
      let(:new_question) { attributes_for :question }

      before { visit question_path(question) }

      scenario 'Owner tries to edit a question', js: true do
        expect(page).not_to have_selector '.question__form'

        click_on 'Edit'
        expect(current_path).to eq question_path(question)
        expect(page).to have_selector '.question__form'

        within('.question__form') do
          fill_in 'Title', with: new_question[:title]
          fill_in 'Body', with: new_question[:body]
          click_on 'Save'
        end

        expect(current_path).to eq question_path(question)
        expect(page).not_to have_selector '.question__form'
        expect(page).to have_content new_question[:title]
        expect(page).to have_content new_question[:body]
      end
    end

    context 'With invalid attributes' do
      let(:question) { create :question, created_by: user }
      let(:new_question) { attributes_for :question }

      before { visit question_path(question) }

      scenario 'Owner tries to edit a question', js: true do
        expect(page).not_to have_selector '.question__form'

        click_on 'Edit'
        expect(current_path).to eq question_path(question)
        expect(page).to have_selector '.question__form'

        within('.question__form') do
          fill_in 'Title', with: new_question[:title]
          fill_in 'Body', with: nil
          click_on 'Save'
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_selector '.question__form'
        expect(page).to have_content 'Body can\'t be blank'
      end
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
