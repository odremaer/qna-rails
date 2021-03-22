class Award < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :title, presence: true

  def give_award_to_user(user)
    user.awards.push(self)
  end
end
