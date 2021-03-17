class Answer < ApplicationRecord
  default_scope { order(best_answer: :desc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def change_best_answer
    if self.question.have_two_best_answers?
      previous_best_answer = self.question.previous_best_answer
      previous_best_answer.update(best_answer: false)
    end
  end
end
