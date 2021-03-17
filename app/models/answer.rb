class Answer < ApplicationRecord
  default_scope { order(best_answer: :desc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  after_commit :after_commit_validate_that_second_best_answer_dont_exists

  def set_best_answer(params)
    transaction do
      update(params.permit(:best_answer))

      if question.have_two_best_answers?
        previous_best_answer = question.previous_best_answer
        previous_best_answer.update(best_answer: false)
      end
    end
  end

  private

  def after_commit_validate_that_second_best_answer_dont_exists
    errors.add(:question, "can't have more than one best answer") if question.have_two_best_answers?
  end
end
