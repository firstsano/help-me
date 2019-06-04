require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'For guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }
    it { is_expected.to be_able_to :read, Attachment }
  end

  describe 'For user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }

    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }
    it { is_expected.to be_able_to :create, Comment }
    it { is_expected.to be_able_to :create, Attachment }

    it { is_expected.to be_able_to :comment, Question }
    it { is_expected.to be_able_to :comment, Answer }

    describe 'setting best answer' do
      let(:answer) { create :answer, question: question }

      context 'when user is an author of a question' do
        let(:question) { create :question, created_by: user }

        it { is_expected.to be_able_to :best, answer }
      end

      context 'when user is not an author of a question' do
        let(:question) { create :question, created_by: other_user }

        it { is_expected.not_to be_able_to :best, answer }
      end
    end


    %i[update destroy].each do |do_action|
      it { is_expected.to be_able_to do_action, create(:question, created_by: user) }
      it { is_expected.not_to be_able_to do_action, create(:question, created_by: other_user) }
    end

    %i[upvote downvote].each do |do_action|
      it { is_expected.not_to be_able_to do_action, create(:question, created_by: user) }
      it { is_expected.to be_able_to do_action, create(:question, created_by: other_user) }
    end

    %i[update destroy].each do |do_action|
      it { is_expected.to be_able_to do_action, create(:answer, created_by: user) }
      it { is_expected.not_to be_able_to do_action, create(:answer, created_by: other_user) }
    end
  end
end
