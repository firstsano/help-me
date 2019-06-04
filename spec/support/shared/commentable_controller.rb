shared_examples 'commentable controller' do |resource|
  describe 'POST #comment' do
    let(:commentable) { send resource }
    let(:comment_params) { attributes_for :comment }
    let(:controller_request) { post :comment, params: { id: commentable, format: 'js', comment: comment_params } }

    login_user

    it_behaves_like "authenticable controller"

    context 'with valid attributes' do
      it "creates a comment to the #{resource}" do
        expect { controller_request }.to change(commentable.comments, :count).by(1)
      end

      context 'after request' do
        before { controller_request }

        it 'sets an author of comment' do
          expect(commentable.comments.last.author).to eq user
        end

        it 'assigns created comment' do
          expect(assigns(:comment)).to eq commentable.comments.last
        end

        it 'renders comment view' do
          expect(response).to render_template :comment
        end
      end
    end

    context 'with invalid attributes' do
      let(:comment_params) { { body: nil } }

      it 'does not create a comment to the answer' do
        expect { controller_request }.not_to change(commentable.comments, :count)
      end

      it 'renders comment view' do
        controller_request
        expect(response).to render_template :comment
      end
    end
  end
end
