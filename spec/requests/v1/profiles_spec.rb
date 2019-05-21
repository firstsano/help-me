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

      before { get resource, params: { format: :json, access_token: access_token.token } }

      it 'responds with status ok' do
        expect(response).to have_http_status :ok
      end

      it "returns user's email" do
        expect(response.body).to be_json_eql(user.email.to_json).at_path('email')
      end

      it "returns user's name" do
        expect(response.body).to be_json_eql(user.name.to_json).at_path('name')
      end

      it "does not return user's passsword" do
        expect(response.body).not_to have_json_path('password')
        expect(response.body).not_to have_json_path('encrypted_password')
      end
    end
  end
end
