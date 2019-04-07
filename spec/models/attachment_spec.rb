require 'rails_helper'

RSpec.describe Attachment, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to :attachable }
    it { is_expected.to validate_presence_of :attachable }
  end

  context 'instance methods' do
    subject(:attachment) { build :attachment }

    describe '#source' do
      it { is_expected.to respond_to :source }
    end
  end
end
