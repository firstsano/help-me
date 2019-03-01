require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to :question }
  it { is_expected.to belong_to :created_by }
  it { is_expected.to validate_presence_of :created_by }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :question }

  describe 'instance_methods' do
    subject(:answer) { create :answer }

    describe '#best?' do
      it { is_expected.to respond_to :best? }
    end

    describe '#best!' do
      let!(:answer) { create :answer, is_best: false }

      it { is_expected.to respond_to :best! }

      it 'sets is_best to true' do
        expect { answer.best! }.to change(answer, :best?).to(true)
      end
    end

    describe '#unbest!' do
      let!(:answer) { create :answer, is_best: true }

      it { is_expected.to respond_to :unbest! }

      it 'sets is_best to false' do
        expect { answer.unbest! }.to change(answer, :best?).to(false)
      end
    end
  end

  describe 'class methods' do
    subject { described_class }

    describe '.best' do
      it { is_expected.to respond_to :best }

      it 'should return only best answers' do
        create_list :answer, 20
        best_answers = create_list :answer, 5, :best
        expect(subject.best).to match_array best_answers
      end
    end
  end
end
