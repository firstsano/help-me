require 'rails_helper'

feature 'User can view list of questions', %q{
  In order to find interesting questions
  As an user
  I want to be able to view a list of questions
} do

  scenario 'User sees a list of all questions' do
    questions = create_list :question, 10
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_link href: question_path(question)
    end
  end
end

feature 'User can view a question', %q{
  In order to answer the question or to read others' answers
  As an user
  I want to be able to view the question
} do

  scenario 'User views a question' do
    question = create :question
    answers = create_list :answer, 5, question: question
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    within('.answers') do
      answers.each do |answer|
        expect(page).to have_content answer.title
        expect(page).to have_content answer.body
      end
    end
  end
end
