require_relative '../features_helper'

feature 'Adding attachment to question', %q{
  In order to explain a question better
  As an author
  I want to be able to attach files
} do

  login_user
  given(:new_question) { attributes_for :question }
  given(:filenames) { %w[sample.txt sample2.txt sample3.txt] }

  before do
    visit new_question_path
    fill_in 'Title', with: new_question[:title]
    fill_in 'Body', with: new_question[:body]
  end

  scenario 'User creates a question with multiple attachments', js: true do
    within('.attachments-form') do
      filenames.each { |filename| add_attachment filename }
    end

    click_on 'Save'

    question = Question.last
    expect(current_path).to eq question_path(question)
    filenames.each { |filename| expect(page).to have_link filename }

    filenames.each do |filename|
      visit question_path(question)
      expect { click_on filename }.to change { current_path }
    end
  end
end

feature 'Removing attachment from question', %q{
  In order to remove falsey attachment
  As an author
  I want to be able to delete it
} do

  login_user
  given(:question) { create :question, created_by: user }
  given(:filenames) { %w[sample.txt sample2.txt sample3.txt] }

  before do
    filenames.each { |filename| create :attachment, attachable: question, filename: filename }
    visit question_path(question)
  end

  scenario 'User deletes second attachment', js: true do
    within('.question__controls') { click_on 'Edit' }

    within('.question__form .attachments-form') do
      attachment = find_all('.attachment-fields', count: 3)[1]
      within(attachment) { click_on 'Remove attachment' }
    end

    click_on 'Save'

    expect(current_path).to eq question_path(question)
    expect(page).to have_link 'sample.txt'
    expect(page).to have_link 'sample3.txt'
    expect(page).not_to have_link 'sample2.txt'
  end
end
