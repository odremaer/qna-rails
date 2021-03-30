require 'rails_helper'

shared_examples_for 'voted' do
  let!(:user) { create(:user) }
  let!(:votable) { create(described_class.controller_name.classify.underscore.to_sym) }
  let!(:vote) { create(:vote, described_class.controller_name.classify.underscore.to_sym ) }

  describe 'POST #upvote' do
    context 'Authenticated user' do
      context 'not author' do
        before { login(user) }

        it 'creates a new vote' do
          expect{ post :upvote, params: { id: votable }, format: :json }.to change(user.votes, :count).by(1)
        end

        it 'sets vote value to 1' do
          post :upvote, params: { id: votable }, format: :json
          expect(user.votes.first.value).to eq 1
        end

        it 'respond with json' do
          post :upvote, params: { id: votable }, format: :json
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

      context 'author' do
        before { login(votable.user) }

        it "can't create a new vote" do
          expect{ post :upvote, params: { id: votable }, format: :json }.to_not change(user.votes, :count)
        end

        it 'responds with json' do
          post :upvote, params: { id: votable }, format: :json
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end

    context 'Unauthencticated user' do
      it "can't create a new vote" do
        expect{ post :upvote, params: { id: votable }, format: :json }.to_not change(user.votes, :count)
      end

      it 'responds with json' do
        post :upvote, params: { id: votable }, format: :json
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "POST #downvote" do
    context 'Authenticated user' do
      context 'not author' do
        before { login(user) }

        it 'creates a new vote' do
          expect{ post :downvote, params: { id: votable }, format: :json }.to change(user.votes, :count).by(1)
        end

        it 'sets vote value to 1' do
          post :downvote, params: { id: votable }, format: :json
          expect(user.votes.first.value).to eq (-1)
        end

        it 'respond with json' do
          post :downvote, params: { id: votable }, format: :json
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

      context 'author' do
        before { login(votable.user) }

        it "can't create a new vote" do
          expect{ post :downvote, params: { id: votable }, format: :json }.to_not change(user.votes, :count)
        end

        it 'responds with json' do
          post :downvote, params: { id: votable }, format: :json
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end

    context 'Unauthencticated user' do
      it "can't create a new vote" do
        expect{ post :downvote, params: { id: votable }, format: :json }.to_not change(user.votes, :count)
      end

      it 'responds with json' do
        post :downvote, params: { id: votable }, format: :json
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #undo_vote' do
    context 'Authenticated user' do
      context 'author of vote' do
        before { login(vote.user) }

        it 'deletes a vote' do
          expect{ delete :undo_vote, params: { id: vote.votable }, format: :json }.to change(vote.user.votes, :count).by(-1)
        end

        it 'responds with json' do
          delete :undo_vote, params: { id: votable }, format: :json
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'not author of vote' do
        before { login(user) }

        it "doesn't delete a vote" do
          expect{ delete :undo_vote, params: { id: vote.votable }, format: :json }.to_not change(Vote, :count)
        end

        it 'responds with json' do
          delete :undo_vote, params: { id: votable }, format: :json
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    context 'Unauthencticated use' do
      it "doesn't delete a vote" do
        expect{ delete :undo_vote, params: { id: vote.votable }, format: :json }.to_not change(Vote, :count)
      end

      it 'responds with json' do
        delete :undo_vote, params: { id: votable }, format: :json
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
