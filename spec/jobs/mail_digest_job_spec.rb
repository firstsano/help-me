require_relative 'jobs_helper'

describe MailDigestJob, type: :job do
  let!(:predefined_users) { create_list :user, 10 }
  let!(:questions) { create_list :question, 10 }
  let(:users_and_question_authors) { User.all }

  it 'calls QuestionMailer with proper arguments' do
    expect(Question).to receive(:digest).and_return questions
    users_and_question_authors.each { |user| expect(QuestionMailer).to receive(:digest).with(user, questions).and_call_original }
    MailDigestJob.perform_now
  end

  it 'properly enqueues jobs' do
    allow(Question).to receive(:digest).and_return questions
    expect { MailDigestJob.perform_now }.to have_enqueued_job.exactly(users_and_question_authors.count).on_queue('mailers').times
  end
end
