require_relative '../features_helper'

feature 'User gets notifications about new questions', %q{
  In order to know if there are new answers
  As an any user
  I want to be notified
} do

  given(:user) { create :user }
  given(:author) { create :user }
  given(:question) { attributes_for :question }

  before do
    Capybara.using_session(user.name) do
      visit questions_path
    end

    Capybara.using_session(author.name) do
      sign_in author
      visit new_question_path
    end
  end

  context 'With valid attributes' do
    scenario 'When author creates a question user gets notification', cable: true, js: true do
      Capybara.using_session(author.name) do
        fill_in 'Title', with: question[:title]
        fill_in 'Body', with: question[:body]
        click_on 'Save'

        expect(page).to have_text 'Question created successfully'
      end

      created_question = Question.last

      Capybara.using_session(user.name) do
        expect(page).to have_selector '.question', count: 1
        expect(page).to have_link created_question.title,
                                  href: question_path(created_question)
      end
    end
  end

  context 'With invalid attributes' do
    scenario 'There should not be any notifications for anyone', cable: true, js: true do
      Capybara.using_session(author.name) do
        fill_in 'Title', with: nil
        fill_in 'Body', with: nil
        click_on 'Save'

        expect(page).to have_content 'Body can\'t be blank'
      end

      Capybara.using_session(user.name) do
        expect(page).not_to have_selector '.question'
      end
    end
  end
end

feature 'User gets notifications about comments to the question', %q{
  In order to know if there are new comments to the question
  As an any user
  I want to be notified
} do

  given(:user) { create :user }
  given(:author) { create :user }
  given!(:question) { create :question }
  given(:comment) { attributes_for :comment }

  before do
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
        When author creates a comment to the question
        user gets notification
        and author does not
      }, cable: true, js: true do
      Capybara.using_session(author.name) do
        within('.question__comments') do
          fill_in 'comment[body]', with: comment[:body]
          click_on 'Add comment'
        end

        expect(current_path).to eq question_path(question)
        within('.question__comments') { expect(page).to have_content comment[:body], count: 1 }
      end

      Capybara.using_session(user.name) do
        within('.question__comments') { expect(page).to have_content comment[:body], count: 1 }
      end
    end
  end

  context 'With invalid attributes' do
    scenario 'There should not be any notifications for anyone', cable: true, js: true do
      Capybara.using_session(author.name) do
        within('.question__comments') do
          fill_in 'comment[body]', with: nil
          click_on 'Add comment'

          expect(page).to have_content 'Body can\'t be blank'
        end
      end

      Capybara.using_session(user.name) do
        within('.question__comments') { expect(page).not_to have_selector '.comment' }
      end
    end
  end
end
