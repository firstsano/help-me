require 'rails_helper'

describe OmniauthRequest, type: :model do
  context 'Validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :provider }
    it { is_expected.to validate_presence_of :uid }
  end

  context 'Callbacks' do
    it 'should set confirmation token on save' do
      omniauth_request = create :omniauth_request
      expect(omniauth_request.confirmation_token).not_to be_empty
    end
  end

  context 'Instance methods' do
    subject(:omniauth_request) { create :omniauth_request }

    describe '#send_confirmation' do
      it { is_expected.to respond_to :send_confirmation }
    end

    describe '#confirm' do
      it { is_expected.to respond_to :confirm }
    end
  end
end
