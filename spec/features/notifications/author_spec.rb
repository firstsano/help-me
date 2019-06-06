require_relative '../features_helper'

feature 'Author receives notifications about the question', %q{
  In order to know if someone answered the question
  As an author
  I want to be able to receive notifications
} do

  login_user
  let(:author) { create :user }
  let!(:question) { create :question, created_by: author }
  let(:answer_params) { attributes_for :answer }

  context 'When user adds an answer to the question', js: true do
    background do
      visit question_path(question)

      within('.question-answer') do
        fill_in 'answer[body]', with: answer_params[:body]
        click_on 'Answer the question'
      end

      expect(page).to have_content answer_params[:body]
    end

    scenario 'author receives notification by email' do
      expect(Sidekiq::Worker.jobs.size).to eq 1

      Sidekiq::Worker.drain_all
      open_email author.email

      expect(current_email).to have_content 'There is a new answer to your question'
      expect(current_email).to have_content answer_params[:body]
    end
  end
end
