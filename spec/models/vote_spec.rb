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
end
