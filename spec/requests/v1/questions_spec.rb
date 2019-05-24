require_relative 'requests_helper'

describe 'Questions API', type: :request do
  describe 'GET /index' do
    let(:resource) { resource_uri 'questions' }
    let!(:questions) { create_list :question, 10 }

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
      let!(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }
      let(:question) { questions.first }

      before { get resource, params: { format: :json, access_token: access_token.token } }

      it 'responds with ok' do
        expect(response).to have_http_status :ok
      end

      it 'responds with questions' do
        expect(response.body).to have_json_size questions.count
      end

      %w[id title body created_at updated_at].each do |attribute|
        it "responds with questions and each question contains #{attribute} field" do
          attribute_field = question.send(attribute.to_sym).to_json
          expect(response.body).to be_json_eql(attribute_field).at_path("0/#{attribute}")
        end
      end
    end
  end

  describe 'GET /questions/:id' do
    let!(:question) { create :question, comments: create_list(:question_comment, 10), attachments: create_list(:question_attachment, 3) }
    let(:resource) { resource_uri "questions/#{question.id}" }
    let(:attachment) { question.attachments.first }

    context 'when unauthorized' do
      it 'responds with unauthorized without token' do
        get resource, params: { format: :json }
        expect(response).to have_http_status :unauthorized
      end

      it 'responds with unauthorized with invalid token' do
        get resource, params: { format: :json, access_token: '123456' }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authorized' do
      let!(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      before { get resource, params: { format: :json, access_token: access_token.token } }

      it 'responds with ok' do
        expect(response).to have_http_status :ok
      end

      %w[id title body created_at updated_at].each do |attribute|
        it "responds with question with #{attribute} field" do
          attribute_field = question.send(attribute.to_sym).to_json
          expect(response.body).to be_json_eql(attribute_field).at_path(attribute)
        end
      end

      it 'responds with comments to a question' do
        expect(response.body).to have_json_size(question.comments.count).at_path('comments')
      end

      %w[id author_name body].each do |attribute|
        it "responds with question with comments with #{attribute} field" do
          comment_id = JSON.parse(response.body)["comments"].first["id"]
          comment = question.comments.find_by id: comment_id
          expect(response.body).to be_json_eql(comment.send(attribute.to_sym).to_json).at_path("comments/0/#{attribute}")
        end
      end



      it 'responds with attachments of question' do
        expect(response.body).to have_json_size(question.attachments.count).at_path('attachments')
      end

      it "responds with question with attachments and each attachment has source_url only" do
        expect(response.body).to be_json_eql(attachment.source.url.to_json).at_path("attachments/0/source_url")
        expect(response.body).to have_json_size(1).at_path("attachments/0")
      end
    end
  end
end
