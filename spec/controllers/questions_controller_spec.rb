require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create :question }
  let(:user) { create :user }

  describe 'GET #index' do
    let!(:questions) { create_list :question, 4 }

    before { get :index }

    it 'populates array of all questions' do
      expect(assigns(:questions)).to match_array questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { sign_in user }
    before { get :new }

    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    before { sign_in user }
    before { get :edit, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }

    context 'with valid attributes' do
      let(:new_attributes) { attributes_for(:question) }

      before do
        patch :update, params: { id: question, question: new_attributes }
        question.reload
      end

      it 'assigns requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'saves question\'s changes' do
        expect(question.title).to eq new_attributes[:title]
        expect(question.body).to eq new_attributes[:body]
      end

      it 'redirects to updated question' do
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, title: nil) } }

      it 'does not save question\'s changes' do
        question.reload
        expect(question.title).not_to be_nil
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid attributes' do
      it 'saves the new question to the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, title: nil) } }.not_to change(Question, :count)
      end

      it 'renders new view' do
        post :create, params: { question: attributes_for(:question, title: nil) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }
    before { question }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
