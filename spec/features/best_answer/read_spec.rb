require_relative '../features_helper'

feature 'User can view the best answer', %q{
  In order to read the best solution
  As an user
  I want to be able to view the best answer
} do

  let(:user) { create :user }

  before { sign_in user }

  scenario 'User sees best the best answer as the first and with special highlight' do
    question = create :question, created_by: user
    answers = create_list :answer, 10, question: question
    best_answer = create :answer, :best, question: question
    visit question_path(question)

    expect(page).to have_selector ".answers__best-answer", count: 1

    first_answer = ".answers .answer:first-child"
    required_answer = "[data-answer-id='#{best.id}']"
    best_answer = ".answers__best-answer"
    expect(page).to have_selector "#{first_answer}#{required_answer}#{best_answer}"
  end
end
