require_relative 'requests_helper'

describe 'Answers API', type: :request do
  describe 'GET /questions/:id/answers' do
    let!(:question) { create :question }
    let(:resource) { resource_uri("questions/#{question.id}/answers") }

    context 'when unauthorized' do
      it 'responds with unauthorized without token' do
        get resource, params: { format: :json }
        expect(response).to have_http_status :unauthorized
      end

      it 'responds with unauthorized with incorrect token' do
        get resource, params: { format: :json, access_token: '123456' }
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
