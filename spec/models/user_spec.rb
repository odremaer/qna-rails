require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  it 'should return true if user is author' do
    user.questions.push(question)

    expect(user).to be_author_of(question)
  end

  it 'should return false if user is not an author' do
    expect(user).to_not be_author_of(question)
  end

  describe '#vote' do
    it 'should create a vote' do
      expect { user.vote(value: 1, votable: question) }.to change(user.votes, :count).by(1)
    end
  end

  describe '#undo_vote' do
    context 'user voted before' do
      it 'should delete his vote' do
        user.vote(value: 1, votable: question)
        expect{ user.undo_vote(question) }.to change(user.votes, :count).by(-1)
      end
    end

    context "user didn't voted before" do
      it "shouldn't any vote" do
        expect{ user.undo_vote(question) }.to_not change(user.votes, :count)
      end
    end
  end

  describe '#delete_previous_vote_if_already_voted' do
    it 'should delete previous vote' do
      user.vote(value: 1, votable: question)

      expect{ user.vote(value: -1, votable: question) }.to_not change(user.votes, :count)
      expect(user.votes.first.value).to eq (-1)
    end
  end
end
