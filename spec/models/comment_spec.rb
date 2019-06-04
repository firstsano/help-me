require 'rails_helper'

describe Comment, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :commentable }
    it { is_expected.to belong_to :author }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :author }
    it { is_expected.to validate_presence_of :commentable }
  end
end
