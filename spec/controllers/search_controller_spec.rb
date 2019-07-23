require_relative 'controllers_helper'

describe SearchController, type: :controller do
  let!(:results) { create_list :answer, 10 }
  let(:query) { 'appl' }

  describe 'GET #index' do
    context 'when query is nil' do
      it 'redirects to root_path with error message' do
        expect { get :index }.to raise_error ActionController::ParameterMissing
      end
    end

    context 'when query is given' do
      context 'when rendering results' do
        before do
          allow(SphinxSearch).to receive(:search).with(query, nil, hash_including(:per_page, :star)).and_return(results)
          get :index, params: { search: { query: query } }
        end

        it 'assigns results to @results' do
          expect(assigns(:results)).to match_array results
        end

        it 'renders index view' do
          expect(response).to render_template :index
        end
      end

      it "calls SphinxSearch's search with query, category and query escaping", aggregate_failures: true do
        expect(ThinkingSphinx::Query).to receive(:escape).with(query).and_call_original
        expect(SphinxSearch).to receive(:search).with(query, 'question', hash_including(:per_page, :star))
        get :index, params: { search: { query: query, category: 'question' } }
      end
    end
  end
end
