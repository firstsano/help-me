require_relative '../features_helper'

feature 'User can upvote or downvote an answer', %q{
  In order to mark correct answer
  As a user
  I want to be able to vote for a question
} do

  context 'When answer is someone else\'s' do
    given(:answer) { create :answer }

    login_user

    before do
      create_list :upvote, 5, votable: answer
      visit question_path(answer.question)
    end

    scenario 'User votes for an answer', js: true do
      within('.answers .answer__score.vote') do
        within('.vote__score') { expect(page).to have_content 5 }

        page.find('.vote__button_upvote').click
        within('.vote__score') { expect(page).to have_content 6 }
        expect(page).to have_selector '.vote__button_upvote.vote__button_active'

        page.find('.vote__button_upvote').click
        within('.vote__score') { expect(page).to have_content 5 }
        expect(page).not_to have_selector '.vote__button_upvote.vote__button_active'
      end

      expect(current_path).to eq question_path(answer.question)
    end

    scenario 'User votes against an answer', js: true do
      within('.answers .answer__score.vote') do
        within('.vote__score') { expect(page).to have_content 5 }

        page.find('.vote__button_downvote').click
        within('.vote__score') { expect(page).to have_content 4 }
        expect(page).to have_selector '.vote__button_downvote.vote__button_active'

        page.find('.vote__button_downvote').click
        within('.vote__score') { expect(page).to have_content 5 }
        expect(page).not_to have_selector '.vote__button_downvote.vote__button_active'
      end

      expect(current_path).to eq question_path(answer.question)
    end

    scenario 'User changes mind and after downvoting votes for an answer', js: true do
      within('.answers .answer__score.vote') do
        within('.vote__score') { expect(page).to have_content 5 }

        page.find('.vote__button_downvote').click
        within('.vote__score') { expect(page).to have_content 4 }
        expect(page).to have_selector '.vote__button_downvote.vote__button_active'

        page.find('.vote__button_upvote').click
        within('.vote__score') { expect(page).to have_content 6 }
        expect(page).to have_selector '.vote__button_upvote.vote__button_active'
        expect(page).not_to have_selector '.vote__button_downvote.vote__button_active'
      end

      expect(current_path).to eq question_path(answer.question)
    end
  end

  context 'When user is an author' do
    login_user
    given(:answer) { create :answer, created_by: user }

    before { visit question_path(answer.question) }

    scenario 'User cannot vote for own answer' do
      within('.answers') do
        expect(page).not_to have_selector '.vote__button_upvote'
        expect(page).not_to have_selector '.vote__button_downvote'
      end
    end
  end

  context 'When user is not signed in' do
    given(:answer) { create :answer }

    scenario 'User cannot vote for a question' do
      visit question_path(answer.question)

      within('.answers') do
        expect(page).not_to have_selector '.vote__button_upvote'
        expect(page).not_to have_selector '.vote__button_downvote'
      end
    end
  end
end
