require 'rails_helper'

describe MailDigestJob, type: :job do
  let!(:predefined_users) { create_list :user, 10 }
  let!(:questions) { create_list :question, 10 }
  let(:users_and_question_authors) { User.all }

  before { ActiveJob::Base.queue_adapter = :test }

  it 'calls DigestMailer with proper arguments' do
    expect(Question).to receive(:digest).and_return questions
    users_and_question_authors.each { |user| expect(DigestMailer).to receive(:digest).with(user, questions).and_call_original }
    MailDigestJob.perform_now
  end

  it 'calls DigestMailer with proper arguments' do
    expect(Question).to receive(:digest).and_return questions
    expect { MailDigestJob.perform_now }.to have_enqueued_job.exactly(users_and_question_authors.count).times
  end
end
