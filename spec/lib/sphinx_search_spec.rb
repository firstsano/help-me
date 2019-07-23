require 'rails_helper'

describe SphinxSearch, type: :module do
  describe 'Module methods' do
    subject(:sphinx_search) { described_class }
    let(:query) { 'search query' }

    describe '.search' do
      it { is_expected.to respond_to :search }

      context 'when category is in list' do
        before { stub_const("SphinxSearch::CATEGORIES", ['question']) }

        it 'calls Sphinx search on specified classes' do
          expect(ThinkingSphinx).to receive(:search).with(query, hash_including(classes: Question))
          sphinx_search.search query, 'question'
        end
      end

      context 'when category is unknown' do
        before { stub_const("SphinxSearch::CATEGORIES", []) }

        it 'calls Sphinx common search' do
          expect(ThinkingSphinx).to receive(:search).with(query, {})
          sphinx_search.search query, 'question'
        end
      end
    end
  end
end
