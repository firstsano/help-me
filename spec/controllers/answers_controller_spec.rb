require_relative 'controllers_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }

  before { create_list :answer, 10 }

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid attributes' do
      it 'saves the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: 'js' } }.to change(question.answers, :count).by(1)
      end

      it 'renders create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: 'js' }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'assigns the answer to @answer' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, body: nil), format: 'js' }
        expect(assigns(:answer)).to be_a_kind_of Answer
      end

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, body: nil), format: 'js' } }.not_to change(Answer, :count)
      end

      it 'renders create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, body: nil), format: 'js' }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) { attributes_for(:answer) }
    before { sign_in user }

    context 'when owner updates an answer' do
      let(:answer) { create :answer, question: question, created_by: user }

      context 'with valid attributes' do
        before do
          patch :update, params: { id: answer, answer: new_attributes, format: 'js' }
          answer.reload
        end

        it 'saves the answer' do
          expect(answer.body).to eq new_attributes[:body]
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: { id: answer, answer: attributes_for(:answer, body: nil), format: 'js' }
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
        expect { patch :update, params: { id: answer, answer: new_attributes, format: 'js' } }.not_to change(answer, :body)
      end

      it 'redirects to question with error message' do
        patch :update, params: { id: answer, answer: new_attributes, format: 'js' }
        expect(response).to redirect_to question_path(question)
        expect(controller).to set_flash[:alert]
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when owner deletes an answer' do
      let!(:answer) { create :answer, question: question, created_by: user }

      before { sign_in user }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, format: 'js' } }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer, format: 'js' }
        expect(response).to render_template :destroy
      end
    end

    context 'when someone else tries to delete an answer' do
      before { sign_in user }
      before { answer }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
        expect(controller).to set_flash[:alert]
      end
    end
  end

  describe 'PUT #best' do
    before { sign_in user }

    it 'assigns the answer to @answer' do
      put :best, params: { id: answer, format: 'js' }
      expect(assigns(:answer)).to eq answer
    end

    context 'when answer owner sets the best answer' do
      let(:question) { create :question, created_by: user }
      let!(:previous_best_answer) { create :answer, :best, question: question }

      before { put :best, params: { id: answer, format: 'js' } }

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
        put :best, params: { id: answer, format: 'js' }
        answer.reload
        expect(answer).not_to be_is_best
      end

      it 'redirects to the question with error message' do
        put :best, params: { id: answer, format: 'js' }
        expect(response).to redirect_to question_path(question)
        expect(controller).to set_flash[:alert]
      end
    end
  end

  describe 'POST #upvote' do
    context 'when owner upvotes an answer' do
      let!(:answer) { create :answer, created_by: user }

      before { sign_in user }

      it 'redirects to a question with error message' do
        post :upvote, params: { id: answer, format: 'json' }
        expect(response).to redirect_to question_path(answer.question)
        expect(controller).to set_flash[:error]
      end
    end

    context 'when someone else upvotes an answer' do
      before do
        answer
        sign_in user
      end

      context 'when user has already upvoted an answer' do
        before { create :upvote, votable: answer, user: user }

        it 'removes upvote' do
          expect { post :upvote, params: { id: answer, format: 'json' } }.to change(answer.upvotes, :count).by(-1)
        end

        it 'assigns a proper hash' do
          post :upvote, params: { id: answer, format: 'json' }
          expected_json = { score: answer.score, upvoted: false }.to_json
          expect(response.body).to eq expected_json
        end
      end

      context 'when user has already downvoted an answer' do
        before { create :downvote, votable: answer, user: user }

        it 'removes downvote' do
          expect { post :upvote, params: { id: answer, format: 'json' } }.to change(answer.downvotes, :count).by(-1)
        end

        it 'adds upvote' do
          expect { post :upvote, params: { id: answer, format: 'json' } }.to change(answer.upvotes, :count).by(1)
        end

        it 'assigns a proper hash' do
          post :upvote, params: { id: answer, format: 'json' }
          expected_json = { score: answer.score, upvoted: true }.to_json
          expect(response.body).to eq expected_json
        end
      end

      context 'when user upvotes an answer for the first time' do
        it 'adds upvote' do
          expect { post :upvote, params: { id: answer, format: 'json' } }.to change(answer.upvotes, :count).by(1)
        end

        it 'assigns a proper hash' do
          post :upvote, params: { id: answer, format: 'json' }
          expected_json = { score: answer.score, upvoted: true }.to_json
          expect(response.body).to eq expected_json
        end
      end
    end
  end

  describe 'POST #downvote' do
    context 'when owner downvotes an answer' do
      let!(:answer) { create :answer, created_by: user }

      before { sign_in user }

      it 'redirects to an answer with error message' do
        post :downvote, params: { id: answer, format: 'json' }
        expect(response).to redirect_to question_path(answer.question)
        expect(controller).to set_flash[:error]
      end
    end

    context 'when someone else downvotes an answer' do
      before do
        answer
        sign_in user
      end

      context 'when user has already downvoted an answer' do
        before { create :downvote, votable: answer, user: user }

        it 'removes downvote' do
          expect { post :downvote, params: { id: answer, format: 'json' } }.to change(answer.downvotes, :count).by(-1)
        end

        it 'assigns a proper hash' do
          post :downvote, params: { id: answer, format: 'json' }
          expected_json = { score: answer.score, downvoted: false }.to_json
          expect(response.body).to eq expected_json
        end
      end

      context 'when user has already upvoted an answer' do
        before { create :upvote, votable: answer, user: user }

        it 'removes upvote' do
          expect { post :downvote, params: { id: answer, format: 'json' } }.to change(answer.upvotes, :count).by(-1)
        end

        it 'adds downvote' do
          expect { post :downvote, params: { id: answer, format: 'json' } }.to change(answer.downvotes, :count).by(1)
        end

        it 'assigns a proper hash' do
          post :downvote, params: { id: answer, format: 'json' }
          expected_json = { score: answer.score, downvoted: true }.to_json
          expect(response.body).to eq expected_json
        end
      end

      context 'when user downvotes an answer for the first time' do
        it 'adds downvote' do
          expect { post :downvote, params: { id: answer, format: 'json' } }.to change(answer.downvotes, :count).by(1)
        end

        it 'assigns a proper hash' do
          post :downvote, params: { id: answer, format: 'json' }
          expected_json = { score: answer.score, downvoted: true }.to_json
          expect(response.body).to eq expected_json
        end
      end
    end
  end
end
