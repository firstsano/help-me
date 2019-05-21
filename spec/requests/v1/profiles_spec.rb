require_relative 'requests_helper'

RSpec.describe 'Profiles API', type: :request do
  describe 'GET /me' do
    context 'when unauthorized' do
      it 'responds with forbidden without token' do
        get resource_uri('profiles/me'), params: { format: :json }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
