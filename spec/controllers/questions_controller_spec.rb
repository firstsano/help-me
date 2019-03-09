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

    it 'assigns new attachment to @question' do
      expect(assigns(:question).attachments.first).to be_a_new Attachment
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

  describe 'PATCH #update' do
    before { sign_in user }

    context 'when owner updates a question' do
      let(:question) { create :question, created_by: user }

      context 'with valid attributes' do
        let(:new_attributes) { attributes_for(:question) }

        before do
          patch :update, params: { id: question, question: new_attributes, format: 'js' }
          question.reload
        end

        it 'assigns requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'saves question\'s changes' do
          expect(question.title).to eq new_attributes[:title]
          expect(question.body).to eq new_attributes[:body]
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: { id: question, question: attributes_for(:question, title: nil), format: 'js' }
          question.reload
        end

        it 'does not save question\'s changes' do
          expect(question.title).not_to be_nil
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'when someone else updates a question' do
      let(:new_attributes) { attributes_for(:question) }

      it 'does not change the question title' do
        expect { patch :update, params: { id: question, question: new_attributes } }.not_to change(question, :title)
      end

      it 'does not change the question body' do
        expect { patch :update, params: { id: question, question: new_attributes } }.not_to change(question, :body)
      end

      it 'redirects to question with error message' do
        patch :update, params: { id: question, question: new_attributes }
        expect(response).to redirect_to questions_path
        expect(controller).to set_flash[:alert]
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
    context 'when owner deletes a question' do
      let!(:question) { create :question, created_by: user }

      before { sign_in user }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'when someone else deletes a question' do
      before { question }
      before { sign_in user }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end
    end
  end
end
