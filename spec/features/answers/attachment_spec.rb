require_relative '../features_helper'

feature 'Adding attachment to answer', %q{
  In order to explain answer better
  As an answer owner
  I want to be able to attach files
} do

  given(:user) { create :user }
  given(:question) { create :question }

  before do
    sign_in user
    visit question_path(question)
  end

  scenario 'User tries to attach file to an answer', js: true do
    within('.question-answer') do
      fill_in 'Body', with: answer[:body]
      attach_file 'File', Rails.root.join('spec', 'fixtures', 'sample.txt')
      click_on 'Answer the question'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'sample.txt'
  end
end
