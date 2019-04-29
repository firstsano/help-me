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
    subject(:users) { described_class }

    describe '.create_with_password' do
      it { is_expected.to respond_to :create_with_password }

      it 'creates a user' do
        user = users.create_with_password name: Faker::Name.name, email: Faker::Internet.email
        expect(user).to be_a_kind_of(users)
        expect(user.password).to be_present
      end
    end

    describe '.find_by_auth' do
      let(:user) { create :user }
      let!(:authorization) { create :authorization, provider: 'provider', uid: '123456', user: user }

      it { is_expected.to respond_to :find_by_auth }

      it 'returns user if found' do
        expect(users.find_by_auth(provider: 'provider', uid: '123456')).to eq user
      end

      it 'returns nil if auth not found' do
        expect(users.find_by_auth(provider: 'other_provider', uid: '123456')).to be_nil
      end
    end

    describe '.find_for_oauth' do
      let(:email) { Faker::Internet.email }
      let(:auth) { OmniAuth::AuthHash.new provider: 'provider', uid: '123456', info: { email: email, name: Faker::Name.name } }

      it { is_expected.to respond_to :find_for_oauth }

      context 'user already has an authorization' do
        it 'returns the user' do
          user = create :user
          user.authorizations.create provider: 'provider', uid: '123456'
          expect(users.find_for_oauth(auth)).to eq user
        end
      end

      context 'user has no authorization' do
        context 'user already exists' do
          let!(:user) { create :user, email: email }

          it 'does not create new user' do
            expect { users.find_for_oauth(auth) }.not_to change(users, :count)
          end

          it 'creates an authorization' do
            expect { users.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
            authorization = user.authorizations.first
            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'returns the user' do
            expect(users.find_for_oauth(auth)).to eq user
          end
        end

        context 'user does not exist' do
          it 'creates a user' do
            expect { users.find_for_oauth(auth) }.to change(users, :count).by(1)
          end

          it 'creates an authorization' do
            expect { users.find_for_oauth(auth) }.to change(Authorization, :count).by(1)
          end

          it 'creates an authorization with appropriate provider and uid' do
            user = users.find_for_oauth(auth)
            authorization = user.authorizations.first
            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'returns the user' do
            expect(users.find_for_oauth(auth)).to be_an_instance_of(users)
          end
        end
      end
    end
  end
end
