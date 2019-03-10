require_relative '../features_helper'

def add_attachment(filename)
  click_on 'Add attachment'
  last_attachment = find_all('.attachment-fields').last
  expect(last_attachment).to be_present
  within(last_attachment) { attach_file 'File', filename }
end

def prepare_question
  visit new_question_path
  fill_in 'Title', with: new_question[:title]
  fill_in 'Body', with: new_question[:body]
end

feature 'Adding attachment to question', %q{
  In order to explain a question better
  As an author
  I want to be able to attach files
} do

  given(:user) { create :user }
  given(:new_question) { attributes_for :question }

  before do
    sign_in user
    prepare_question
  end

  scenario 'User creates a question with multiple attachments', js: true do
    within('.attachments-form') do
      add_attachment 'sample.txt'
      add_attachment 'sample2.txt'
    end

    click_on 'Save'

    question = Question.last
    expect(current_path).to eq question_path(question)
    expect(page).to have_link 'sample.txt'
    expect(page).to have_link 'sample2.txt'

    # check if links work
    visit question_path(question)
    expect { click_on 'sample.txt' }.to change { current_path }
    visit question_path(question)
    expect { click_on 'sample2.txt' }.to change { current_path }
  end
end

feature 'Removing attachment from question', %q{
  In order to remove falsey attachment
  As an author
  I want to be able to delete it
} do

  given(:user) { create :user }
  given(:new_question) { attributes_for :question }

  before do
    sign_in user
    prepare_question
    within('.attachments-form') do
      add_attachment 'sample.txt'
      add_attachment 'sample2.txt'
      add_attachment 'sample3.txt'
    end
    click_on 'Save'
  end

  scenario 'User deletes second attachment', js: true do
    question = Question.last
    visit question_path(question)

    within('.question-controls') { click_on 'Edit' }

    within('.question-form .attachments-form') do
      attachment = find_all('.attachment-fields')[1]
      expect(attachment).to be_present
      within(attachment) { click_on 'Remove attachment' }
    end

    click_on 'Save'

    expect(current_path).to eq question_path(question)
    expect(page).to have_link 'sample.txt'
    expect(page).to have_link 'sample3.txt'
  end
end
