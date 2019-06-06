require_relative '../features_helper'

feature 'Choosing the best answer', %q{
  In order to let everyone know about the best solution
  As an authenticated user
  I want to be able to choose the best answer
} do

  login_user

  scenario 'Question\'s owner sets the best answer', js: true do
    question = create :question, created_by: user
    answers = create_list :answer, 10, question: question
    best_answers = answers.sample 3
    visit question_path(question)

    best_answers.each do |answer|
      within("[data-answer-id='#{answer.id}']") do
        click_on 'Best answer'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to have_selector ".answer_best", count: 1

      first_answer = ".answers .answer:first-child"
      required_answer = "[data-answer-id='#{answer.id}']"
      best_answer = ".answer_best"
      expect(page).to have_selector "#{first_answer}#{required_answer}#{best_answer}"
    end
  end

  scenario 'User tries to set the best answer for someone else\'s question' do
    question = create :question
    answers = create_list :answer, 10, question: question
    visit question_path(question)

    within(".answers") do
      expect(page).not_to have_button "Best answer"
    end
  end
end
