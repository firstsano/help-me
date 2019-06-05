require 'rails_helper'

describe Question, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many :answers }
    it { is_expected.to belong_to :created_by }
    it { is_expected.to have_many :attachments }
    it { is_expected.to have_many :votes }
    it { is_expected.to have_many :upvotes }
    it { is_expected.to have_many :downvotes }
    it { is_expected.to have_many :comments }
    it { is_expected.to accept_nested_attributes_for :attachments }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :created_by }
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
  end

  describe 'Instance_methods' do
    subject(:question) { create :question }

    describe '#set_best_answer' do
      let!(:answer) { create :answer, question: question }

      it { is_expected.to respond_to :set_best_answer }

      it 'raises error when wrong anwer is passed' do
        other_question = create :question
        other_answer = create :answer, question: other_question
        expect { question.set_best_answer(other_answer) }.to raise_error ArgumentError
      end

      context 'when there is the best answer' do
        let!(:best_answer) { create :answer, :best, question: question }

        before do
          create_list :answer, 5, question: question
          question.set_best_answer answer
          question.reload
        end

        it 'sets new best answer' do
          expect(question.best_answer).to eq answer
        end

        it 'sets same answer as the best' do
          question.set_best_answer answer
          question.reload
          expect(question.best_answer).to eq answer
        end

        it 'resets previous best answer' do
          expect(question.best_answer).not_to eq best_answer
        end
      end

      context 'when there is no best answer' do
        it 'sets best answer' do
          question.set_best_answer answer
          question.reload
          expect(question.best_answer).to eq answer
        end
      end
    end
  end

  describe 'Class methods' do
    subject(:questions) { described_class }

    describe '.digest', :with_timecop do
      it { is_expected.to respond_to :digest }

      it 'selects only digest questions' do
        outdated_questions = create_list :question, 20
        recent_time = Time.now + 1.day
        Timecop.freeze recent_time
        digest_questions = create_list :question, 10

        aggregate_failures "within 24 hours" do
          (1..24).each do |hours|
            Timecop.freeze(recent_time + hours.hours)
            expect(questions.digest).to match_array digest_questions
          end
        end
      end
    end
  end

  it_behaves_like 'votable model', 'question' do
    let(:question) { create :question }
  end
end
