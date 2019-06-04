shared_examples 'votable model' do |resource|
  describe 'Instance methods' do
    let(:votable) { send resource }

    describe '#score' do
      it { is_expected.to respond_to :score }

      it "counts total votes for a #{resource}" do
        upvotes = create_list :upvote, 10, votable: votable
        downvotes = create_list :downvote, 3, votable: votable
        expect(votable.score).to eq 7
      end

      it 'returns 0 when there are no votes' do
        expect(votable.score).to eq 0
      end
    end

    describe '#upvoted_by_user?' do
      it { is_expected.to respond_to :upvoted_by_user? }

      it "returns true if #{resource} has upvote created by user and false otherwise" do
        user, other_user = create_list :user, 2
        create :upvote, votable: votable, user: user
        expect(votable.upvoted_by_user?(user)).to be_truthy
        expect(votable.upvoted_by_user?(other_user)).to be_falsey
      end
    end

    describe '#downvoted_by_user?' do
      it { is_expected.to respond_to :downvoted_by_user? }

      it "returns true if #{resource} has upvote created by user and false otherwise" do
        user, other_user = create_list :user, 2
        create :downvote, votable: votable, user: user
        expect(votable.downvoted_by_user?(user)).to be_truthy
        expect(votable.downvoted_by_user?(other_user)).to be_falsey
      end
    end
  end
end
