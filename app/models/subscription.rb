class Subscription < ApplicationRecord
  scope :for, ->(user, question) { find_by(user: user, question: question) }

  belongs_to :user
  belongs_to :question
end
