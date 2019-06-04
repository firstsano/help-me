require_relative 'controllers_helper'

describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }

  before { create_list :answer, 10 }

  describe 'POST #create' do
    login_user
    let(:answer_params) { attributes_for :answer }
    let(:controller_request) { post :create, params: { question_id: question, answer: answer_params, format: 'js' } }

    context 'with valid attributes' do
      it 'saves the answer' do
        expect { controller_request }.to change(question.answers, :count).by(1)
      end

      it 'renders create view' do
        controller_request
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for :answer, body: nil }

      it 'assigns the answer to @answer' do
        controller_request
        expect(assigns(:answer)).to be_a_kind_of Answer
      end

      it 'does not save the answer' do
        expect { controller_request }.not_to change(Answer, :count)
      end

      it 'renders create view' do
        controller_request
        expect(response).to render_template :create
      end
    end

    it_behaves_like "authenticable controller"
  end

  describe 'PATCH #update' do
    login_user
    let(:answer_params) { attributes_for :answer }
    let(:controller_request) { patch :update, params: { id: answer, answer: answer_params, format: 'js' } }

    context 'when owner updates an answer' do
      let(:answer) { create :answer, question: question, created_by: user }

      context 'with valid attributes' do
        let(:answer_params) { attributes_for :answer }

        before do
          controller_request
          answer.reload
        end

        it 'saves the answer' do
          expect(answer.body).to eq answer_params[:body]
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:answer_params) {  attributes_for :answer, body: nil }

        before do
          controller_request
          answer.reload
        end

        it 'assigns the answer to @answer' do
          expect(assigns(:answer)).to be_a_kind_of Answer
        end

        it 'does not save the answer' do
          expect(answer.body).not_to be_nil
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'when someone else tries to update an answer' do
      it 'does not change answer\'s body' do
        expect { controller_request }.not_to change(answer, :body)
      end

      it 'redirects to question with error message' do
        controller_request
        expect(response).to have_http_status(:forbidden)
      end
    end

    it_behaves_like "authenticable controller"
  end

  describe 'DELETE #destroy' do
    login_user
    let(:controller_request) { delete :destroy, params: { id: answer, format: 'js' } }

    context 'when owner deletes an answer' do
      let!(:answer) { create :answer, question: question, created_by: user }

      it 'deletes the answer' do
        expect { controller_request }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        controller_request
        expect(response).to render_template :destroy
      end
    end

    context 'when someone else tries to delete an answer' do
      let(:controller_request) { delete :destroy, params: { id: answer } }
      before { answer }

      it 'does not delete the answer' do
        expect { controller_request }.not_to change(Answer, :count)
      end

      it 'redirects to question' do
        controller_request
        expect(response).to redirect_to root_path(question)
        expect(controller).to set_flash[:error]
      end
    end

    it_behaves_like "authenticable controller"
  end

  describe 'PUT #best' do
    login_user
    let(:controller_request) { put :best, params: { id: answer, format: 'js' } }

    it 'assigns the answer to @answer' do
      controller_request
      expect(assigns(:answer)).to eq answer
    end

    context 'when answer owner sets the best answer' do
      let(:question) { create :question, created_by: user }
      let!(:previous_best_answer) { create :answer, :best, question: question }

      before { controller_request }

      it 'assigns the previous best answer to @previous_best_answer' do
        expect(assigns(:previous_best_answer)).to eq previous_best_answer
      end

      it 'marks the answer as the best' do
        answer.reload
        expect(answer).to be_is_best
      end

      it 'renders best view' do
        expect(response).to render_template :best
      end
    end

    context 'when someone else tries to set the best answer' do
      it 'does not set an answer as the best' do
        controller_request
        answer.reload
        expect(answer).not_to be_is_best
      end

      it 'redirects to the question with error message' do
        controller_request
        expect(response).to have_http_status(:forbidden)
      end
    end

    it_behaves_like "authenticable controller"
  end

  it_behaves_like 'votable controller', 'answer'
  it_behaves_like 'commentable controller', 'answer'
end
