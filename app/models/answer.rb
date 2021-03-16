class Answer < ApplicationRecord
  default_scope { order(best_answer: :desc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true
end
