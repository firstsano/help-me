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
  end
end
