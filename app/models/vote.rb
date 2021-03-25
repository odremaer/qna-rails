class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validate :validate_author_of_votable

  private

  def validate_author_of_votable
    errors.add(:vote, "You can't vote for this because you are author") if votable && user.author_of?(votable)
  end
end
