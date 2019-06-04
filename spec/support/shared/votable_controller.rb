shared_examples 'votable controller' do |resource|
  describe 'POST #upvote' do
    let(:votable) { send resource }
    let(:controller_request) { post :upvote, params: { id: votable, format: 'json' } }

    login_user

    it_behaves_like "authenticable controller"

    context "when owner upvotes an #{resource}" do
      let!(:votable) { create resource.to_sym, created_by: user }

      before { sign_in user }

      it 'redirects to a question with error message' do
        controller_request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when someone else upvotes an #{resource}" do
      before { votable }

      context "when user has already upvoted an #{resource}" do
        before { create :upvote, votable: votable, user: user }

        it 'removes upvote' do
          expect { controller_request }.to change(votable.upvotes, :count).by(-1)
        end

        it 'responds with a proper json' do
          controller_request
          expected_json = { score: votable.score, upvoted: false }.to_json
          expect(response.body).to eq expected_json
        end
      end

      context "when user has already downvoted an #{resource}" do
        before { create :downvote, votable: votable, user: user }

        it 'removes downvote' do
          expect { controller_request }.to change(votable.downvotes, :count).by(-1)
        end

        it 'adds upvote' do
          expect { controller_request }.to change(votable.upvotes, :count).by(1)
        end

        it 'responds with a proper json' do
          controller_request
          expected_json = { score: votable.score, upvoted: true }.to_json
          expect(response.body).to eq expected_json
        end
      end

      context "when user upvotes an #{resource} for the first time" do
        it 'adds upvote' do
          expect { controller_request }.to change(votable.upvotes, :count).by(1)
        end

        it 'responds with a proper json' do
          controller_request
          expected_json = { score: votable.score, upvoted: true }.to_json
          expect(response.body).to eq expected_json
        end
      end
    end
  end

  describe 'POST #downvote' do
    let(:votable) { send resource }
    let(:controller_request) { post :downvote, params: { id: votable, format: 'json' } }

    login_user

    it_behaves_like "authenticable controller"

    context "when owner downvotes an #{resource}" do
      let!(:votable) { create resource.to_sym, created_by: user }

      it "redirects to an #{resource} with error message" do
        controller_request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when someone else downvotes an #{resource}" do
      before { votable }

      context "when user has already downvoted an #{resource}" do
        before { create :downvote, votable: votable, user: user }

        it 'removes downvote' do
          expect { controller_request }.to change(votable.downvotes, :count).by(-1)
        end

        it 'responds with a proper json' do
          controller_request
          expected_json = { score: votable.score, downvoted: false }.to_json
          expect(response.body).to eq expected_json
        end
      end

      context "when user has already upvoted an #{resource}" do
        before { create :upvote, votable: votable, user: user }

        it 'removes upvote' do
          expect { controller_request }.to change(votable.upvotes, :count).by(-1)
        end

        it 'adds downvote' do
          expect { controller_request }.to change(votable.downvotes, :count).by(1)
        end

        it 'responds with a proper json' do
          controller_request
          expected_json = { score: votable.score, downvoted: true }.to_json
          expect(response.body).to eq expected_json
        end
      end

      context "when user downvotes an #{resource} for the first time" do
        it 'adds downvote' do
          expect { controller_request }.to change(votable.downvotes, :count).by(1)
        end

        it 'responds with a proper json' do
          controller_request
          expected_json = { score: votable.score, downvoted: true }.to_json
          expect(response.body).to eq expected_json
        end
      end
    end
  end
end
