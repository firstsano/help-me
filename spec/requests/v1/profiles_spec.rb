require_relative 'requests_helper'

describe 'Profiles API', type: :request do
  describe 'GET /me' do
    let(:resource) { resource_uri('profiles/me') }

    context 'when authorized' do
      login_user

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

    it_behaves_like 'authenticable request'
  end

  describe 'GET /index' do
    let(:resource) { resource_uri('profiles') }

    context 'when authorized' do
      login_user
      let!(:other_users) { create_list :user, 10 }

      before { get resource, params: { format: :json, access_token: access_token.token } }

      it 'responds with status ok' do
        expect(response).to have_http_status :ok
      end

      it "returns users as an array" do
        expect(response.body).to be_json_eql(other_users.to_json)
      end

      it "returns user's email" do
        expect(response.body).to have_json_path('0/email')
      end

      it "returns user's name" do
        expect(response.body).to have_json_path('0/name')
      end

      it "does not return user's passsword" do
        expect(response.body).not_to have_json_path('0/password')
        expect(response.body).not_to have_json_path('0/encrypted_password')
      end
    end

    it_behaves_like 'authenticable request'
  end
end
