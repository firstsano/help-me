require_relative '../features_helper'

feature 'Adding attachment to answer', %q{
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
      fill_in 'Body', with: answer[:body]
      within('.attachments-form') do
        number_of_attachments.times do
          click_on 'Add attachment'
          last_attachment = find_all('.attachment-fields').last
          within(last_attachment) { attach_file 'File', Rails.root.join('spec', 'fixtures', 'sample.txt') }
        end
      end
    end

    click_on 'Answer the question'
    expect(current_path).to eq question_path(question)
    expect(page).to have_link 'sample.txt', count: number_of_attachments

    last_attachment = find_all('.answers .attachment').last
    expect { within(last_attachment) { click_on 'sample.txt' } }.to change { current_path }
  end
end
