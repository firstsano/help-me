require 'rails_helper'

RSpec.describe 'Profiles API', type: :request do
  describe 'GET /me' do
    context 'when unauthorized' do
      it 'responds with forbidden without token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
