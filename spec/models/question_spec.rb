require 'rails_helper'

describe Question, type: :model do
  context 'Associations' do
    it { is_expected.to have_many :answers }
    it { is_expected.to belong_to :created_by }
    it { is_expected.to have_many :attachments }
    it { is_expected.to have_many :votes }
    it { is_expected.to have_many :upvotes }
    it { is_expected.to have_many :downvotes }
    it { is_expected.to have_many :comments }
    it { is_expected.to accept_nested_attributes_for :attachments }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of :created_by }
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
  end

  context 'Instance_methods' do
    subject(:question) { create :question }

    describe '#score' do
      it { is_expected.to respond_to :score }

      it 'counts total votes for a question' do
        upvotes = create_list :upvote, 10, votable: question
        downvotes = create_list :downvote, 3, votable: question
        expect(question.score).to eq 7
      end

      it 'returns 0 when there are no votes' do
        expect(question.score).to eq 0
      end
    end

    describe '#upvoted_by_user?' do
      it { is_expected.to respond_to :upvoted_by_user? }

      it 'returns true if question has upvote created by user and false otherwise' do
        user, other_user = create_list :user, 2
        create :upvote, votable: question, user: user
        expect(question.upvoted_by_user?(user)).to be_truthy
        expect(question.upvoted_by_user?(other_user)).to be_falsey
      end
    end

    describe '#downvoted_by_user?' do
      it { is_expected.to respond_to :downvoted_by_user? }

      it 'returns true if question has upvote created by user and false otherwise' do
        user, other_user = create_list :user, 2
        create :downvote, votable: question, user: user
        expect(question.downvoted_by_user?(user)).to be_truthy
        expect(question.downvoted_by_user?(other_user)).to be_falsey
      end
    end

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
end
