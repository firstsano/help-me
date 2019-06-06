require 'rails_helper'

describe QuestionSubscription, type: :model do
  describe 'Validations' do
    subject { create :question_subscription }

    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :question }
    it { is_expected.to validate_uniqueness_of(:question_id).scoped_to(:user_id) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :question }
  end
end
