require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }


  let(:votable) { create(described_class.name.underscore.to_sym) }
  let(:user) { create(:user) }

  describe '#vote' do
    it 'should create a vote' do
      expect { votable.vote(value: 1, user: user) }.to change(user.votes, :count).by(1)
    end
  end

  describe '#undo_vote' do
    context 'user voted before' do
      it 'should delete his vote' do
        votable.vote(value: 1, user: user)
        expect{ votable.undo_vote(user) }.to change(user.votes, :count).by(-1)
      end
    end

    context "user didn't voted before" do
      it "shouldn't any vote" do
        expect{ votable.undo_vote(user) }.to_not change(user.votes, :count)
      end
    end
  end

  describe '#delete_previous_vote_if_already_voted' do
    it 'should delete previous vote' do
      votable.vote(value: 1, user: user)

      expect{ votable.vote(value: -1, user: user) }.to_not change(user.votes, :count)
      expect( user.votes.first.value ).to eq (-1)
    end
  end
end
