require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :password }
  end

  context 'Associations' do
    it { is_expected.to have_many :authorizations }
  end

  context 'Class methods' do
    subject { described_class }

    describe '.find_for_oauth' do
      let!(:user) { create :user }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'provider', uid: '123456') }

      it { is_expected.to respond_to :find_for_oauth }

      context 'user already has an authorization' do
        it 'returns the user' do
          user.authorizations.create(provider: 'provider', uid: '123456')
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user has no authorization' do
        context 'user already exists' do

        end

        context 'user does not exist' do

        end
      end
    end
  end
end
