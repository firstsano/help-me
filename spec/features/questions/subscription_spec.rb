require_relative '../features_helper'

feature 'User can subscribe to a question', %q{
  In order to get notifications about new answers to the question
  As a user
  I want to be able to subscribe to a question
} do

  let!(:question) { create :question }

  context 'When user is signed in' do
    login_user

    scenario 'User subscribes to a question', js: true do
      visit question_path(question)
      find('.question__subscription').click

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Subscribed'
      expect(page).to have_css 'i[data-subscribed="true"]'
      expect(page).not_to have_css 'i[data-subscribed="false"]'
    end
  end

  context 'When user is not signed' do
    scenario 'User does not see subscribe button', js: true do
      visit question_path(question)
      expect(page).not_to have_css '.question__subscription'
    end
  end
end


feature 'User can unsubscribe from a question', %q{
  In order to stop getting notifications about new answers to the question
  As an authenticated user
  I want to be able to unsubscribe from a question
} do

  let!(:question) { create :question }

  context 'When user is signed in' do
    login_user

    background { user.subscribe question }

    scenario 'User subscribes to a question', js: true do
      visit question_path(question)
      find('.question__subscription').click

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Unsubscribed'
      expect(page).to have_css 'i[data-subscribed="false"]'
      expect(page).not_to have_css 'i[data-subscribed="true"]'
    end
  end

  context 'When user is not signed' do
    scenario 'User does not see subscribe button', js: true do
      visit question_path(question)
      expect(page).not_to have_css '.question__subscription'
    end
  end
end
