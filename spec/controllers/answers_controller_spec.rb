require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }

  before { create_list :answer, 10 }

  describe 'GET #index' do
    let(:answers) { create_list :answer, 4, question: question }

    before { get :index, params: { question_id: question } }

    it 'populates array of the question\'s answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index page' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the answer to @answer' do
      expect(assigns(:answer)).to eq(answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    before { sign_in user }
    before { get :edit, params: { id: answer } }

    it 'assigns the answer to @answer' do
      expect(assigns(:answer)).to eq(answer)
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'GET #new' do
    before { sign_in user }
    before { get :new, params: { question_id: question } }

    it 'assigns new answer for the question to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid attributes' do
      it 'saves the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirects to the answer' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer_path(assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      it 'assigns the answer to @answer' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, title: nil) }
        expect(assigns(:answer)).to be_a_kind_of Answer
      end

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, title: nil) } }.not_to change(Answer, :count)
      end

      it 'renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, title: nil) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }

    context 'with valid attributes' do
      let(:new_attributes) { attributes_for(:answer) }

      before do
        patch :update, params: { id: answer, answer: new_attributes }
        answer.reload
      end

      it 'saves the answer' do
        expect(answer.title).to eq new_attributes[:title]
        expect(answer.body).to eq new_attributes[:body]
      end

      it 'redirects to the answer' do
        expect(response).to redirect_to answer_path(answer)
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, params: { id: answer, answer: attributes_for(:answer, title: nil) }
        answer.reload
      end

      it 'assigns the answer to @answer' do
        expect(assigns(:answer)).to be_a_kind_of Answer
      end

      it 'does not save the answer' do
        expect(answer.title).not_to be_nil
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when owner deletes an answer' do
      let!(:answer) { create :answer, question: question, created_by: user }

      before { sign_in user }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'when someone else deletes a question' do
      before { sign_in user }
      before { answer }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end
    end
  end
end
