require 'rails_helper'

RSpec.describe Vote, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to :votable }
    it { is_expected.to belong_to :user }
  end

  context 'Validations' do
    subject { build :question_vote }

    it { is_expected.to validate_presence_of :votable }
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_inclusion_of(:value).in_array([1, -1]) }
    it { is_expected.to validate_uniqueness_of(:votable_id).scoped_to(:user_id, :votable_type) }
  end

  context 'Instance methods' do
    subject(:vote) { create :question_vote }

    describe '#upvote?' do
      it { is_expected.to respond_to :upvote? }

      it 'returns true when vote\'s value is 1 and false otherwise' do
        vote.value = 1
        expect(vote).to be_upvote
        vote.value = -1
        expect(vote).not_to be_upvote
      end
    end

    describe '#downvote?' do
      it { is_expected.to respond_to :downvote? }

      it 'returns true when vote\'s value is -1 and false otherwise' do
        vote.value = -1
        expect(vote).to be_downvote
        vote.value = 1
        expect(vote).not_to be_downvote
      end
    end
  end
end
