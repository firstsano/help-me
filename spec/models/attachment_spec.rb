require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { is_expected.to belong_to(:attachable) }

  describe 'instance methods' do
    subject(:attachment) { build :attachment }

    describe '#source' do
      it { is_expected.to respond_to :source }
    end
  end
end
