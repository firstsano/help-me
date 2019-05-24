require_relative 'requests_helper'

describe 'Answers API', type: :request do
  describe 'GET /questions/:id/answers' do
    let!(:question) { create :question }
    let!(:answers) { create_list :answer, 10, question: question }
    let!(:other_answers) { create_list :answer, 20 }
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

    context 'when authorized' do
      let(:user) { create :user }
      let!(:access_token) { create :access_token, resource_owner_id: user.id }

      before { get resource, params: { format: :json, access_token: access_token.token } }

      it 'responds with status ok' do
        expect(response).to have_http_status :ok
      end

      it 'responds with answers to specific question only' do
        expect(response.body).to have_json_size(answers.count)
      end

      attributes = %w[id body created_at updated_at]
      attributes.each do |attribute|
        it "responds with answers and each answer has #{attribute} field" do
          answer = Answer.find_by id: JSON.parse(response.body)[0]["id"]
          expect(response.body).to be_json_eql(answer.send(attribute.to_sym).to_json).at_path("0/#{attribute}")
        end
      end

      it "responds with answers and each answer specific number of fields" do
        expect(response.body).to have_json_size(attributes.count).at_path("0")
      end
    end
  end
end
