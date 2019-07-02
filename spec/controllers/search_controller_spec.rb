require_relative 'controllers_helper'

describe SearchController, type: :controller do
  describe 'GET #index' do
    before { get :index }

    it 'responds with no content' do
      expect(response).to have_http_status :no_content
    end
  end
end
