require_relative '../features_helper'

feature 'Adding attachment to an answer', %q{
  In order to explain answer better
  As an answer owner
  I want to be able to attach files
} do

  given(:user) { create :user }
  given(:question) { create :question }
  given(:answer) { attributes_for :answer }
  given(:filenames) { %w[sample.txt sample2.txt sample3.txt] }

  before do
    sign_in user
    visit question_path(question)
  end

  scenario 'User tries to attach multiple files to an answer', js: true do
    within('.question-answer') do
      fill_in 'answer[body]', with: answer[:body]
      within('.attachments-form') do
        filenames.each { |filename| add_attachment filename }
      end
    end

    click_on 'Answer the question'
    expect(current_path).to eq question_path(question)
    filenames.each do |filename|
      visit question_path(question)
      expect(page).to have_link filename
      expect { click_on filename }.to change { current_path }
    end
  end
end

feature 'Removing attachment from an answer', %q{
  In order to remove falsey attachment
  As an answer author
  I want to be able to delete an attachment
} do

  given(:user) { create :user }
  given(:question) { create :question }
  given(:answer) { create :answer, question: question, created_by: user }
  given(:filenames) { %w[sample.txt sample2.txt sample3.txt] }

  before do
    sign_in user
    filenames.each { |filename| create :attachment, attachable: answer, filename: filename }
    visit question_path(question)
  end

  scenario 'User deletes some of attachments to an answer', js: true do
    within('.answers') do
      click_on 'Edit'

      within('.attachments-form') do
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
end
