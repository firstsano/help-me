require_relative 'requests_helper'

RSpec.describe 'Profiles API', type: :request do
  describe 'GET /me' do
    let(:resource) { resource_uri('profiles/me') }

    context 'when unauthorized' do
      it 'responds with forbidden status without token' do
        get resource, params: { format: :json }
        expect(response).to have_http_status :unauthorized
      end

      it 'responds with forbidden status with incorrect token' do
        get resource, params: { format: :json, access_token: '123456' }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authorized' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      it 'responds with status ok' do
        get resource, params: { format: :json, access_token: access_token.token }
        expect(response).to have_http_status :ok
      end
    end
  end
end
