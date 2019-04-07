require_relative '../features_helper'

feature 'User gets notifications', %q{
  In order to know if there are new answers
  As an any user
  I want to be notified
} do

  given(:user) { create :user }
  given(:author) { create :user }
  given(:question) { create :question }

  before do
    create_list :answer, 5, question: question

    Capybara.using_session(user.name) do
      visit question_path(question)
    end

    Capybara.using_session(author.name) do
      sign_in author
      visit question_path(question)
    end
  end

  context 'With valid attributes' do
    scenario 'User should get notification while author should not', cable: true, js: true do
      Capybara.using_session(author.name) do
        answer = attributes_for :answer
        within('.question-answer') do
          fill_in 'answer[body]', with: answer[:body]
          click_on 'Answer the question'
        end

        within('.answers') { expect(page).to have_content answer[:body] }
      end

      Capybara.using_session(user.name) do
        within('.notification') do
          expect(page).to have_content 'new answers'
          expect(page).to have_content '1'
        end
      end

      Capybara.using_session(author.name) do
        answer = attributes_for :answer
        within('.question-answer') do
          fill_in 'answer[body]', with: answer[:body]
          click_on 'Answer the question'
        end

        within('.answers') { expect(page).to have_content answer[:body] }
        expect(page).not_to have_selector '.notification'
      end

      Capybara.using_session(user.name) do
        within('.notification') do
          expect(page).to have_content 'new answers'
          expect(page).to have_content '2'
        end
      end
    end
  end

  context 'With invalid attributes' do
    scenario 'There should not be any notifications for anyone', cable: true, js: true do
      Capybara.using_session(author.name) do
        within('.question-answer') do
          fill_in 'answer[body]', with: ''
          click_on 'Answer the question'

          expect(page).to have_content 'Body can\'t be blank'
        end
      end

      Capybara.using_session(user.name) do
        expect(page).not_to have_selector '.notification'
      end
    end
  end
end
