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

  scenario 'User creates a question with multiple attachments', js: true do
    number_of_attachments = 3
    new_question = attributes_for :question
    click_on 'Create question'

    fill_in 'Title', with: new_question[:title]
    fill_in 'Body', with: new_question[:body]

    within('.attachments-form') do
      number_of_attachments.times do
        click_on 'Add attachment'
        last_attachment = find_all('.attachment-fields').last
        within(last_attachment) { attach_file 'File', Rails.root.join('spec', 'fixtures', 'sample.txt') }
      end
    end

    click_on 'Save'
    expect(page).to have_link 'sample.txt', count: number_of_attachments

    last_attachment = find_all('.attachment').last
    expect { within(last_attachment) { click_on 'sample.txt' } }.to change { current_path }
  end
end
