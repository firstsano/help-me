require_relative 'requests_helper'

describe 'Questions API', type: :request do
  describe 'GET /index' do
    let(:resource) { resource_uri 'questions' }
    let!(:questions) { create_list :question, 10 }

    context 'when authorized' do
      login_user

      before { get resource, params: { format: :json, access_token: access_token.token } }

      it 'responds with ok' do
        expect(response).to have_http_status :ok
      end

      it 'responds with questions' do
        expect(response.body).to have_json_size questions.count
      end

      %i[id title body created_at updated_at].each do |attribute|
        it "responds with questions and each question contains #{attribute} field" do
          question_id = JSON.parse(response.body).first["id"]
          question = Question.find_by id: question_id
          expect(response.body).to be_json_eql(question.send(attribute).to_json).at_path("0/#{attribute}")
        end
      end
    end

    it_behaves_like 'authenticable request'
  end

  describe 'GET /questions/:id' do
    let!(:question) { create :question, comments: create_list(:question_comment, 10), attachments: create_list(:question_attachment, 3) }
    let(:resource) { resource_uri "questions/#{question.id}" }
    let(:attachment) { question.attachments.first }

    context 'when authorized' do
      login_user

      before { get resource, params: { format: :json, access_token: access_token.token } }

      it 'responds with ok' do
        expect(response).to have_http_status :ok
      end

      %i[id title body created_at updated_at].each do |attribute|
        it "responds with question with #{attribute} field" do
          attribute_field = question.send(attribute).to_json
          expect(response.body).to be_json_eql(attribute_field).at_path("#{attribute}")
        end
      end

      it 'responds with comments to a question' do
        expect(response.body).to have_json_size(question.comments.count).at_path('comments')
      end

      %i[id author_name body].each do |attribute|
        it "responds with question with comments with #{attribute} field" do
          comment_id = JSON.parse(response.body)["comments"].first["id"]
          comment = question.comments.find_by id: comment_id
          expect(response.body).to be_json_eql(comment.send(attribute).to_json).at_path("comments/0/#{attribute}")
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

    it_behaves_like 'authenticable request'
  end

  describe 'POST /questions' do
    let(:resource) { resource_uri 'questions' }
    let(:question_params) { attributes_for :question }

    context 'when authorized' do
      login_user

      context 'with invalid attributes' do
        let(:question_params) { attributes_for :question, body: nil }

        it 'responds with unprocessable_entity status' do
          post resource, params: { format: :json, access_token: access_token.token, question: question_params }
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does not create a question' do
          expect { post resource, params: { format: :json, access_token: access_token.token, question: question_params } }.not_to change(Question, :count)
        end

        it 'returns errors' do
          post resource, params: { format: :json, access_token: access_token.token, question: question_params }
          expect(response.body).to have_json_path('errors')
        end
      end

      context 'with valid attributes' do
        it 'responds with created status' do
          post resource, params: { format: :json, access_token: access_token.token, question: question_params }
          expect(response).to have_http_status :created
        end

        it 'creates a question' do
          expect { post resource, params: { format: :json, access_token: access_token.token, question: question_params } }.to change(Question, :count).by(1)
        end

        %i[title body].each do |attribute|
          it "responds with created question with attribute #{attribute}" do
            post resource, params: { format: :json, access_token: access_token.token, question: question_params }
            expect(response.body).to be_json_eql(question_params[attribute].to_json).at_path("#{attribute}")
          end
        end
      end
    end

    it_behaves_like 'authenticable request'
  end
end
