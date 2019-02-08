require 'rails_helper'

feature 'User can create a question', %q{
  In order to get some knowledge
  As an user
  I want to be able to create a question
} do

  given(:user) { create :user }

  scenario 'User creates a question' do
    sign_in user

    visit questions_path
    click_on 'Create question'
    expect(current_path).to eq new_question_path

    fill_in 'Title', with: 'Awesome title'
    fill_in 'Body', with: 'Awesome Body'
    click_on 'Create'

    expect(page).to have_text 'Question created successfully'

    visit questions_path
    expect(page).to have_content 'Awesome title'
  end
end

feature 'User can view list of questions', %q{
  In order to find interesting questions
  As an user
  I want to be able to view a list of questions
} do

  given!(:questions) { create_list :question, 10 }

  scenario 'User sees a list of all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'User sees links to all of the questions'
end

feature 'User can post an answer to the question', %q{
  In order to share some knowledge
  As an user
  I want to be able to answer the question
} do

  given(:question) { create :question }
  given(:answer) { attributes_for :answer }

  scenario 'User posts an answer to the question' do
    visit questions_path(question)

    fill_in 'Title', with: answer[:title]
    fill_in 'Body', with: answer[:body]
    click_on 'Answer the question'

    expect(page).to have_text 'Answer created successfully'
    expect(page).to have_content answer[:title]
    expect(page).to have_content answer[:body]
  end

end

feature 'User can view a question', %q{
  In order to answer the question or to read others' answers
  As an user
  I want to be able to view the question
} do

  scenario 'User views a question'
end
