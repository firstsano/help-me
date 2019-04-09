require_relative '../features_helper'

feature 'User gets notifications about new answers', %q{
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

feature 'User gets notifications about comments to the answer', %q{
  In order to know if there are new comments to the answer
  As an any user
  I want to be notified
} do

  given(:user) { create :user }
  given(:author) { create :user }
  given(:question) { create :question }
  given!(:answer) { create :answer, question: question }
  given(:comment) { attributes_for :comment }
  given(:answer_comments_el) { ".answer[data-answer-id='#{answer.id}'] .answer__comments" }

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
    scenario %q{
        When author creates a comment to the answer
        user gets notification
        and author does not
      }, cable: true, js: true do
      Capybara.using_session(author.name) do
        within(answer_comments_el) do
          fill_in 'comment[body]', with: comment[:body]
          click_on 'Add comment'
        end

        expect(current_path).to eq question_path(question)
        within(answer_comments_el) { expect(page).to have_content comment[:body], count: 1 }
        within(".answers") { expect(page).to have_content comment[:body], count: 1 }
      end

      Capybara.using_session(user.name) do
        within(answer_comments_el) { expect(page).to have_content comment[:body], count: 1 }
      end
    end
  end

  context 'With invalid attributes' do
    scenario 'There should not be any notifications for anyone', cable: true, js: true do
      Capybara.using_session(author.name) do
        within(answer_comments_el) do
          fill_in 'comment[body]', with: nil
          click_on 'Add comment'

          expect(page).to have_content 'Body can\'t be blank'
        end
      end

      Capybara.using_session(user.name) do
        within(answer_comments_el, visible: false) { expect(page).not_to have_selector '.comment' }
      end
    end
  end
end
