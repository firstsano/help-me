require_relative 'requests_helper'

describe 'Answers API', type: :request do
  describe 'GET /questions/:question_id/answers' do
    let!(:question) { create :question }
    let!(:answers) { create_list :answer, 10, question: question }
    let!(:other_answers) { create_list :answer, 20 }
    let(:resource) { resource_uri("questions/#{question.id}/answers") }

    context 'when authorized' do
      login_user

      before { get resource, params: { format: :json, access_token: access_token.token } }

      it 'responds with status ok' do
        expect(response).to have_http_status :ok
      end

      it 'responds with answers to specific question only' do
        expect(response.body).to have_json_size(answers.count)
      end

      %w[id body created_at updated_at].each do |attribute|
        it "responds with answers and each answer has #{attribute} field" do
          answer = Answer.find_by id: JSON.parse(response.body)[0]["id"]
          expect(response.body).to be_json_eql(answer.send(attribute.to_sym).to_json).at_path("0/#{attribute}")
        end
      end
    end

    it_behaves_like 'authenticable request'
  end

  describe 'GET /answers/:id' do
    let!(:answer) { create :answer, comments: create_list(:answer_comment, 10), attachments: create_list(:answer_attachment, 3) }
    let(:resource) { resource_uri("answers/#{answer.id}") }

    context 'when authorized' do
      login_user
      let(:attachment) { answer.attachments.first }

      before { get resource, params: { format: :json, access_token: access_token.token } }

      it 'responds with status ok' do
        expect(response).to have_http_status :ok
      end

      %w[id body created_at updated_at].each do |attribute|
        it "responds with an answer with #{attribute} field" do
          attribute_field = answer.send(attribute.to_sym).to_json
          expect(response.body).to be_json_eql(attribute_field).at_path(attribute)
        end
      end

      it 'responds with comments to an answer' do
        expect(response.body).to have_json_size(answer.comments.count).at_path('comments')
      end

      %w[id author_name body].each do |attribute|
        it "responds with an answer with comments with #{attribute} field" do
          comment_id = JSON.parse(response.body)["comments"].first["id"]
          comment = answer.comments.find_by id: comment_id
          expect(response.body).to be_json_eql(comment.send(attribute.to_sym).to_json).at_path("comments/0/#{attribute}")
        end
      end

      it 'responds with attachments of an answer' do
        expect(response.body).to have_json_size(answer.attachments.count).at_path('attachments')
      end

      it "responds with an answer with attachments and each attachment has source_url only" do
        expect(response.body).to be_json_eql(attachment.source.url.to_json).at_path("attachments/0/source_url")
        expect(response.body).to have_json_size(1).at_path("attachments/0")
      end
    end

    it_behaves_like 'authenticable request'
  end

  describe 'POST /questions/:question_id/answers' do
    let!(:question) { create :question }
    let(:answer_params) { attributes_for(:answer).merge({ question_id: question.id }) }
    let(:resource) { resource_uri "questions/#{question.id}/answers" }

    context 'when authorized' do
      login_user

      context 'with invalid attributes' do
        let(:answer_params) { attributes_for :answer, body: nil }

        it 'responds with unprocessable_entity status' do
          post resource, params: { format: :json, access_token: access_token.token, answer: answer_params }
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does not create a question' do
          expect { post resource, params: { format: :json, access_token: access_token.token, answer: answer_params } }.not_to change(Answer, :count)
        end

        it 'returns errors' do
          post resource, params: { format: :json, access_token: access_token.token, answer: answer_params }
          expect(response.body).to have_json_path('errors')
        end
      end

      context 'with valid attributes' do
        it 'responds with created status' do
          post resource, params: { format: :json, access_token: access_token.token, answer: answer_params }
          expect(response).to have_http_status :created
        end

        it 'creates a question' do
          expect { post resource, params: { format: :json, access_token: access_token.token, answer: answer_params } }.to change(question.answers, :count).by(1)
        end

        %i[body].each do |attribute|
          it "responds with created question with attribute #{attribute}" do
            post resource, params: { format: :json, access_token: access_token.token, answer: answer_params }
            expect(response.body).to be_json_eql(answer_params[attribute].to_json).at_path("#{attribute}")
          end
        end
      end
    end

    it_behaves_like 'authenticable request'
  end
end
