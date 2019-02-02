require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    it 'populates array of all questions' do
      questions = create_list :question, 4
      get :index
      expect(assigns(:questions)).to match_array questions
    end

    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    it 'assigns new question to @question' do
      get :new
      expect(assigns(:question)).to be_a_new Question
    end

    it 'renders new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    it 'assigns requested question to @question' do
      question = create :question
      get :show, params: { id: question }
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      question = create :question
      get :show, params: { id: question }
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    it 'assigns requested question to @question' do
      question = create :question
      get :edit, params: { id: question }
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      question = create :question
      get :edit, params: { id: question }
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns requested question to @question' do
        question = create :question
        patch :update, params: { id: question, question: { title: 'MyTitle', body: 'MyBody' } }
        question.reload
        expect(assigns(:question)).to eq question
      end

      it 'saves question\'s changes' do
        question = create :question
        patch :update, params: { id: question, question: { title: 'MyTitle', body: 'MyBody' } }
        question.reload
        expect(question.title).to eq 'MyTitle'
        expect(question.body).to eq 'MyBody'
      end

      it 'redirects to updated question' do
        question = create :question
        patch :update, params: { id: question, question: { title: 'MyTitle', body: 'MyBody' } }
        question.reload
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save question\'s changes' do
        question = create :question
        patch :update, params: { id: question, question: { title: nil, body: nil } }
        question.reload
        expect(question.title).to be_present
        expect(question.body).to be_present
      end

      it 'renders edit view' do
        question = create :question
        patch :update, params: { id: question, question: { title: nil, body: nil } }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #create' do
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
    it 'deletes the question' do
      question = create :question
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      question = create :question
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end