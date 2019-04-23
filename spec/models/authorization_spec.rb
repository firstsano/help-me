require 'rails_helper'

RSpec.describe Authorization, type: :model do
  describe 'Validations' do
    subject { build :authorization }

    it { is_expected.to validate_uniqueness_of(:provider).scoped_to(:user_id) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to :user }
  end
end
