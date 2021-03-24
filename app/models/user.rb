class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy

  has_many :awards, dependent: :destroy

  has_many :votes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(object)
    object.user_id == self.id
  end

  def vote(value:, votable:)
    delete_previous_vote_if_already_voted(votable)
    votes.create(value: value, user: self, votable: votable)
  end

  def undo_vote(votable)
    vote = votes.find_by(votable: votable)
    vote.destroy if vote
  end

  private

  def delete_previous_vote_if_already_voted(votable)
    vote = Vote.find_by(user: self, votable: votable)
    vote.destroy if vote
  end
end
