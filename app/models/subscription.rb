class Subscription < ApplicationRecord
  scope :certain_user_and_question, ->(user, question) { find_by(user: user, question: question) }

  belongs_to :user
  belongs_to :question
end
