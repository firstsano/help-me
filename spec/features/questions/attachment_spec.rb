require_relative '../features_helper'

feature 'Adding attachment to question', %q{
  In order to explain a question better
  As an author
  I want to be able to attach files
} do

  given(:user) { create :user }

  before do
    sign_in user
    visit questions_path
  end

  scenario 'User creates a question with attachment' do
    new_question = attributes_for :question
    click_on 'Create question'

    fill_in 'Title', with: new_question[:title]
    fill_in 'Body', with: new_question[:body]
    attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')
    click_on 'Save'

    expect(page).to have_content 'spec_helper.rb'
  end
end
