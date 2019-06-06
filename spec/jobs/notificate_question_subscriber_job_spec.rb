require_relative 'jobs_helper'

describe NotificateQuestionSubscriberJob, type: :job do
  let(:users) { create_list :user, 10 }
  let(:question) { create :question }
  let(:author) { question.created_by }
  let(:subscribers) { create_list(:user, 10) + [author] }
  let!(:answer) { create :answer, question: question }

  before { subscribers.each { |user| user.subscribe question } }

  it 'calls QuestionMailer with proper arguments' do
    subscribers.each { |subscriber| expect(QuestionMailer).to receive(:answer_added).with(subscriber, answer).and_call_original }
    NotificateQuestionSubscriberJob.perform_now answer
  end

  it 'properly enqueues jobs' do
    expect { NotificateQuestionSubscriberJob.perform_now(answer) }.to have_enqueued_job.exactly(subscribers.count).on_queue('mailers').times
  end
end
