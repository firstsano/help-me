require_relative '../features_helper.rb'

feature 'User can vote for or against a question', %q{
  In order to show that a question is popular
  As a user
  I want to be able to vote for a question
} do

  context 'When question is someone else\'s' do
    login_user
    given(:question) { create :question }

    before do
      create_list :upvote, 5, votable: question
      visit question_path(question)
    end

    scenario 'User votes for a question', js: true do
      within('.question__score.vote') do
        within('.vote__score') { expect(page).to have_content 5 }

        page.find('.vote__button_upvote').click
        within('.vote__score') { expect(page).to have_content 6 }
        expect(page).to have_selector '.vote__button_upvote.vote__button_active'

        page.find('.vote__button_upvote').click
        within('.vote__score') { expect(page).to have_content 5 }
        expect(page).not_to have_selector '.vote__button_upvote.vote__button_active'
      end

      expect(current_path).to eq question_path(question)
    end

    scenario 'User votes against a question', js: true do
      within('.question__score.vote') do
        within('.vote__score') { expect(page).to have_content 5 }

        page.find('.vote__button_downvote').click
        within('.vote__score') { expect(page).to have_content 4 }
        expect(page).to have_selector '.vote__button_downvote.vote__button_active'

        page.find('.vote__button_downvote').click
        within('.vote__score') { expect(page).to have_content 5 }
        expect(page).not_to have_selector '.vote__button_downvote.vote__button_active'
      end

      expect(current_path).to eq question_path(question)
    end

    scenario 'User changes mind and after downvoting votes for a question', js: true do
      within('.question__score.vote') do
        within('.vote__score') { expect(page).to have_content 5 }

        page.find('.vote__button_downvote').click
        within('.vote__score') { expect(page).to have_content 4 }
        expect(page).to have_selector '.vote__button_downvote.vote__button_active'

        page.find('.vote__button_upvote').click
        within('.vote__score') { expect(page).to have_content 6 }
        expect(page).to have_selector '.vote__button_upvote.vote__button_active'
        expect(page).not_to have_selector '.vote__button_downvote.vote__button_active'
      end

      expect(current_path).to eq question_path(question)
    end
  end

  context 'When user is an author' do
    login_user
    given(:question) { create :question, created_by: user }

    before { visit question_path(question) }

    scenario 'User cannot vote for own question' do
      expect(page).not_to have_selector '.vote__button_upvote'
      expect(page).not_to have_selector '.vote__button_downvote'
    end
  end

  context 'When user is not signed in' do
    given(:question) { create :question }

    scenario 'User cannot vote for a question' do
      visit question_path(question)

      expect(page).not_to have_selector '.vote__button_upvote'
      expect(page).not_to have_selector '.vote__button_downvote'
    end
  end
end
