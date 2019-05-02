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

  context 'Instance methods' do
    subject(:user) { create :user }

    describe '#has_provider?' do
      let(:provider) { 'test_provider' }
      before { create_list :authorization, 5, user: user }

      it { is_expected.to respond_to :has_provider? }

      context "when user has an authorization with specified provider" do
        before { create :authorization, provider: provider, user: user }

        it 'returns true' do
          expect(user.has_provider?(provider)).to be true
        end
      end

      context "when user has no authorization with specified provider" do
        it 'returns false' do
          expect(user.has_provider?(provider)).to be false
        end
      end
    end

    describe '#generate_auth' do
      it { is_expected.to respond_to :generate_auth }
    end
  end

  context 'Class methods' do
    subject(:users) { described_class }

    describe '.generate_for_oauth' do
      it { is_expected.to respond_to :generate_for_oauth }

      context 'when user does not exist' do
        it 'creates a user' do
          user = users.generate_for_oauth Faker::Name.name, Faker::Internet.email
          expect(user).to be_a_kind_of(users)
          expect(user.password).to be_present
          expect(user).to be_confirmed
        end

        it 'raises error on invalid params' do
          expect { users.generate_for_oauth Faker::Name.name, 'invalid email' }.to raise_error ActiveRecord::RecordInvalid
        end
      end

      context 'when user exists' do
        let(:user) { create :user }

        it 'returns the user' do
          expect(users.generate_for_oauth(user.name, user.email)).to eq user
        end
      end
    end

    describe '.create_confirmed' do
      it { is_expected.to respond_to :create_confirmed }

      it 'creates a user' do
        user = users.create_confirmed Faker::Name.name, Faker::Internet.email
        expect(user).to be_a_kind_of(users)
        expect(user.password).to be_present
        expect(user).to be_confirmed
      end
    end

    describe '.find_by_auth' do
      let(:user) { create :user }
      let!(:authorization) { create :authorization, provider: 'provider', uid: '123456', user: user }

      it { is_expected.to respond_to :find_by_auth }

      it 'returns user if found' do
        expect(users.find_by_auth('provider', '123456')).to eq user
      end

      it 'returns nil if auth not found' do
        expect(users.find_by_auth('other_provider', '123456')).to be_nil
      end
    end
  end
end
