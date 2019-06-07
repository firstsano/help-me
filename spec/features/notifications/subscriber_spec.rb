require_relative '../features_helper'

feature 'Subscriber receives notifications about the question', %q{
  In order to know if someone answered the question
  As a subscriber
  I want to be able to receive notifications
} do

  setup_user_mapping
  let!(:author) { create :user }
  let!(:subscriber) { create :user }
  let!(:nonsubscriber) { create :user }
  let!(:question) { create :question, created_by: author }
  let(:answer_params) { attributes_for :answer }

  before { subscriber.subscribe question }

  context 'When user adds an answer to the question', js: true do
    login_user

    background do
      visit question_path(question)

      within('.question-answer') do
        fill_in 'answer[body]', with: answer_params[:body]
        click_on 'Answer the question'
      end

      expect(page).to have_content answer_params[:body]
    end

    scenario 'subscribers receives notification by email' do
      expect(Sidekiq::Worker.jobs).not_to be_empty
      Sidekiq::Worker.drain_all

      [author, subscriber].each do |subscriber|
        open_email subscriber.email

        expect(current_email).to have_content 'There is a new answer to your question'
        expect(current_email).to have_content answer_params[:body]
      end
    end

    scenario 'non subscriber does not receive notifications' do
      [user, nonsubscriber].each do |user|
        open_email user.email
        expect(current_email).to be_nil
      end
    end
  end

  context 'When author of answer is a subscriber', js: true do
    background do
      sign_in answer_author
      visit question_path(question)

      within('.question-answer') do
        fill_in 'answer[body]', with: answer_params[:body]
        click_on 'Answer the question'
      end

      expect(page).to have_content answer_params[:body]
      Sidekiq::Worker.drain_all
    end

    context 'When user is an author of question' do
      let(:answer_author) { author }

      scenario 'user does not receive notification' do
        open_email author.email
        expect(current_email).to be_nil
      end
    end

    context 'When user is just a subscriber' do
      let(:answer_author) { subscriber }

      scenario 'user does not receive notification' do
        open_email subscriber.email
        expect(current_email).to be_nil
      end
    end
  end
end
