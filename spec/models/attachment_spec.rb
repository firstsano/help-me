require 'rails_helper'

describe Attachment, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :attachable }
    it { is_expected.to validate_presence_of :attachable }
  end

  describe 'Instance methods' do
    subject(:attachment) { build :attachment }

    describe '#source' do
      it { is_expected.to respond_to :source }
    end
  end
end
