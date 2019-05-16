require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }
    it { is_expected.to be_able_to :read, Attachment }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }

    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }
    it { is_expected.to be_able_to :create, Comment }
    it { is_expected.to be_able_to :create, Attachment }

    %i[update destroy].each do |do_action|
      it { is_expected.to be_able_to do_action, create(:question, created_by: user), created_by: user }
      it { is_expected.not_to be_able_to do_action, create(:question, created_by: other_user), created_by: user }
    end
  end
end
