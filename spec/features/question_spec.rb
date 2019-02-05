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

  scenario 'User sees a list of all questions'
end

feature 'User can post an answer to the question', %q{
  In order to share some knowledge
  As an user
  I want to be able to answer the question
} do

  scenario 'User posts an answer to the question'
end

feature 'User can view a question', %q{
  In order to answer the question or to read others' answers
  As an user
  I want to be able to view the question
} do

  scenario 'User views a question'
end