require_relative 'controllers_helper'

describe QuestionsController, type: :controller do
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
    login_user
    let(:controller_request) { get :new }

    context 'when question is rendered' do
      before { controller_request }

      it 'assigns new question to @question' do
        expect(assigns(:question)).to be_a_new Question
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    it_behaves_like "authenticable controller"
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new Answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'PATCH #update' do
    login_user
    let(:question_params) { attributes_for :question }
    let(:controller_request) { patch :update, params: { id: question, question: question_params, format: 'js' } }

    context 'when owner updates a question' do
      let(:question) { create :question, created_by: user }

      context 'with valid attributes' do
        before do
          controller_request
          question.reload
        end

        it 'assigns requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it "saves question's changes" do
          expect(question.title).to eq question_params[:title]
          expect(question.body).to eq question_params[:body]
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:question_params) { attributes_for :question, title: nil }

        before do
          controller_request
          question.reload
        end

        it "does not save question's changes" do
          expect(question.title).not_to be_nil
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'when someone else updates a question' do
      let(:controller_request) { patch :update, params: { id: question, question: question_params } }

      it 'does not change the question title' do
        expect { controller_request }.not_to change(question, :title)
      end

      it 'does not change the question body' do
        expect { controller_request }.not_to change(question, :body)
      end

      it 'redirects to question with error message' do
        controller_request
        expect(response).to redirect_to root_path
        expect(controller).to set_flash[:error]
      end
    end

    it_behaves_like "authenticable controller"
  end

  describe 'POST #create' do
    login_user
    let(:question_params) { attributes_for :question }
    let(:controller_request) { post :create, params: { question: question_params } }

    context 'with valid attributes' do
      it 'saves the new question to the database' do
        expect { controller_request }.to change(Question, :count).by(1)
      end

      it 'creates new question subscription' do
        expect { controller_request }.to change(user.subscriptions, :count).by(1)
      end

      it 'creates question subscription to created question' do
        controller_request
        user.reload
        expect(Question.last.subscribers).to include user
      end

      it 'redirects to show view' do
        controller_request
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:question_params) { attributes_for :question, title: nil }

      it 'does not save the question' do
        expect { controller_request }.not_to change(Question, :count)
      end

      it 'renders new view' do
        controller_request
        expect(response).to render_template :new
      end
    end

    it_behaves_like "authenticable controller"
  end

  describe 'DELETE #destroy' do
    login_user
    let(:controller_request) { delete :destroy, params: { id: question } }

    context 'when owner deletes a question' do
      let!(:question) { create :question, created_by: user }

      it 'deletes the question' do
        expect { controller_request }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        controller_request
        expect(response).to redirect_to questions_path
      end
    end

    context 'when someone else deletes a question' do
      before { question }

      it 'does not delete the question' do
        expect { controller_request }.not_to change(Question, :count)
      end
    end

    it_behaves_like "authenticable controller"
  end

  describe 'PUT #subscribe' do
    login_user
    let(:controller_request) { put :subscribe, params: { id: question } }

    before { question }

    context 'when user is not subscribed yet' do
      it 'properly creates a subscription' do
        expect { controller_request }.to change(user.subscriptions, :count).by(1)
      end

      it 'responds with a proper json' do
        controller_request
        expected_json = { subscribed: true }.to_json
        expect(response.body).to eq expected_json
      end
    end

    context 'when user is already subscribed' do
      before { user.subscribe question }

      it 'removes a subscription' do
        expect { controller_request }.to change(user.subscriptions, :count).by(-1)
      end

      it 'responds with a proper json' do
        controller_request
        expected_json = { subscribed: false }.to_json
        expect(response.body).to eq expected_json
      end
    end

    it_behaves_like "authenticable controller"
  end

  it_behaves_like 'votable controller', 'question'
  it_behaves_like 'commentable controller', 'question'
end
