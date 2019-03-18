require_relative '../features_helper.rb'

feature 'User can vote for or against a question', %q{
  In order to show that a question is popular
  As a user
  I want to be able to vote for a question
} do

  context 'When question is someone else\'s' do
    given(:user) { create :user }
    given(:question) { create :question }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'User votes for a question', js: true do
      within('.question__score.vote') do
        within('.vote__score') { expect(page).to have_content '0' }
        click_on 'Vote up'
        expect(current_path).to eq question_path(question)
        within('.vote__score') { expect(page).to have_content '1' }
      end
    end

    scenario 'User votes against a question'
  end

  context 'When user is an author' do
    given(:user) { create :user }
    given(:question) { create :question, created_by: user }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'User cannot vote for own question' do
      expect(page).not_to have_link 'Vote up'
      expect(page).not_to have_link 'Vote down'
    end
  end

  context 'When user is not signed in' do
    given(:question) { create :question }

    scenario 'User cannot vote for a question' do
      visit question_path(question)

      expect(page).not_to have_link 'Vote up'
      expect(page).not_to have_link 'Vote down'
    end
  end
end
