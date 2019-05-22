require 'rails_helper'

<<<<<<< HEAD
RSpec.describe Authorization, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :user }
  end

=======
describe Authorization, type: :model do
>>>>>>> Refactor
  describe 'Validations' do
    subject { build :authorization }

    it { is_expected.to validate_presence_of :provider }
    it { is_expected.to validate_presence_of :uid }
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_uniqueness_of(:provider).scoped_to(:user_id) }
  end
end
