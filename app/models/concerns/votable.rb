module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.sum(:value)
  end


  def vote(value:, user:)
    delete_previous_vote_if_already_voted(user)
    vote = votes.create(value: value, user: user, votable: self)
  end

  def undo_vote(user)
    vote = user.votes.find_by(votable: self)
    vote.destroy if vote
  end

  private

  def delete_previous_vote_if_already_voted(user)
    vote = Vote.find_by(user: user, votable: self)
    vote.destroy if vote
  end
end
