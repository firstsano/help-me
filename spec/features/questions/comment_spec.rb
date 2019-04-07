require_relative '../features_helper'

feature 'User can comment a question', %q{
  In order to discuss a question
  As a user
  I want to be able to leave a comment
} do

  given(:user) { create :user }
  given!(:question) { create :question }
  given(:comment) { attributes_for :comment }

  context 'When user is signed in' do
    before do
      sign_in user
      visit question_path(question)
    end

    context 'With valid comment' do
      scenario 'User creates a comment', js: true do
        within('.question-comment') do
          fill_in 'comment[body]', with: comment[:body]
          click_on 'Save'
        end

        expect(current_path).to eq question_path(question)
        within('.question__comments') { expect(page).to have_content comment[:body] }
      end
    end
  end
end
