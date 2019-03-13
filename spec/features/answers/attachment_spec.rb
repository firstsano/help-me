require_relative '../features_helper'

def add_attachment(filename)
  click_on 'Add attachment'
  last_attachment = find_all('.attachment-fields').last
  expect(last_attachment).to be_present
  within(last_attachment) { attach_file 'File', filename }
end

feature 'Adding attachment to an answer', %q{
  In order to explain answer better
  As an answer owner
  I want to be able to attach files
} do

  given(:user) { create :user }
  given(:question) { create :question }
  given(:answer) { attributes_for :answer }

  before do
    sign_in user
    visit question_path(question)
  end

  scenario 'User tries to attach multiple files to an answer', js: true do
    number_of_attachments = 3

    within('.question-answer') do
      fill_in 'answer[body]', with: answer[:body]
      within('.attachments-form') do
        number_of_attachments.times { add_attachment 'sample.txt' }
      end
    end

    click_on 'Answer the question'
    expect(current_path).to eq question_path(question)
    expect(page).to have_link 'sample.txt', count: number_of_attachments

    last_attachment = find_all('.answers .attachment').last
    expect { within(last_attachment) { click_on 'sample.txt' } }.to change { current_path }
  end
end

feature 'Removing attachment from an answer', %q{
  In order to remove falsey attachment
  As an answer author
  I want to be able to delete an attachment
} do
  given(:user) { create :user }
  given(:question) { create :question }
  given(:answer) { attributes_for :answer }

  before do
    sign_in user
    visit question_path(question)
    within('.question-answer') do
      fill_in 'answer[body]', with: answer[:body]
      within('.attachments-form') do
        add_attachment 'sample.txt'
        add_attachment 'sample2.txt'
        add_attachment 'sample3.txt'
      end
    end
    click_on 'Answer the question'
  end

  scenario 'User tries to attach multiple files to an answer', js: true do
    within('.answers') do
      click_on 'Edit'

      within('.attachments-form') do
        attachment = find_all('.attachment-fields')[1]
        expect(attachment).to be_present
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
