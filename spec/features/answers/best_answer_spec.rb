require_relative '../features_helper'

feature 'Choosing the best answer', %q{
  In order to let everyone know about the best solution
  As an authenticated user
  I want to be able to choose the best answer
} do

  let(:user) { create :user }

  before { sign_in user }

  scenario 'Question\'s owner sets the best answer' do
    question = create :question, created_by: user
    answers = create_list :answer, 10, question: question
    best_answers = answers.sample 3
    visit question_path(question)

    best_answers.each do |answer|
      within("[data-answer-id='#{answer.id}']") do
        click_on 'Best answer'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to have_selector ".answers__best-answer", count: 1

      first_answer = ".answers .answer:first-child"
      required_answer = "[data-answer-id='#{answer.id}']"
      best_answer = ".answers__best-answer"
      expect(page).to have_selector "#{first_answer}#{required_answer}#{best_answer}"
    end
  end

  scenario 'User tries to set the best answer for someone else\'s question'
end
