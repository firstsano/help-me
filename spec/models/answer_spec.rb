require 'rails_helper'

describe Answer, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :question }
    it { is_expected.to belong_to :created_by }
    it { is_expected.to have_many :attachments }
    it { is_expected.to accept_nested_attributes_for :attachments }
    it { is_expected.to have_many :comments }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :created_by }
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :question }
  end

  describe 'Callbacks' do
    describe '#after_commit' do
      let(:answer) { build :answer }

      it 'calls notificates question subscribers', :aggregate_failures do
        expect(answer).to receive(:notificate_question_subscribers).and_call_original
        expect(NotificateQuestionSubscriberJob).to receive(:perform_later).with(answer).and_call_original
        answer.save
      end
    end
  end

  describe 'Instance methods' do
    subject(:answer) { create :answer }

    describe '#best!' do
      let!(:answer) { create :answer, is_best: false }

      it { is_expected.to respond_to :best! }

      it 'sets is_best to true' do
        expect { answer.best! }.to change(answer, :is_best?).to true
      end
    end

    describe '#unbest!' do
      let!(:answer) { create :answer, :best }

      it { is_expected.to respond_to :unbest! }

      it 'sets is_best to false' do
        expect { answer.unbest! }.to change(answer, :is_best?).to false
      end
    end

    describe '#can_be_best_for?' do
      let(:user) { create :user }

      it { is_expected.to respond_to :can_be_best_for? }

      context 'when passed user is an author of question' do
        let(:question) { create :question, created_by: user }

        it 'returns false if answer is already the best' do
          answer = create :answer, :best, question: question
          expect(answer.can_be_best_for?(user)).to be_falsey
        end

        it 'returns true if answer is not the best' do
          answer = create :answer, question: question
          expect(answer.can_be_best_for?(user)).to be_truthy
        end
      end

      context 'when passed user is not an author of question' do
        let(:question) { create :question }

        it 'returns false for any type of answer' do
          answer = create :answer, question: question
          best_answer = create :answer, :best, question: question
          expect(answer.can_be_best_for?(user)).to be_falsey
          expect(best_answer.can_be_best_for?(user)).to be_falsey
        end
      end
    end
  end

  describe 'Class methods' do
    subject { described_class }

    describe '.best' do
      it { is_expected.to respond_to :best }

      it 'should return only best answers' do
        create_list :answer, 20
        best_answers = create_list :answer, 5, :best
        expect(subject.best).to match_array best_answers
      end
    end
  end

  it_behaves_like 'votable model', 'answer' do
    let(:answer) { create :answer }
  end
end
