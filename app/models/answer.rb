class Answer < ApplicationRecord
  include Votable
  include Commentable

  default_scope { order(best_answer: :desc) }

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_commit :validate_that_second_best_answer_dont_exists

  after_commit :notify_subscribers

  def set_best_answer(params)
    transaction do
      update!(params.permit(:best_answer))

      if question.have_two_best_answers?
        previous_best_answer = question.previous_best_answer
        previous_best_answer.update!(best_answer: false)
      end

      if question.award
        question.award.give_award_to_user(user)
      end
    end
  end

  private

  def validate_that_second_best_answer_dont_exists
    errors.add(:question, "can't have more than one best answer") if question.have_two_best_answers?
  end

  def notify_subscribers
    NotificationAboutNewAnswerJob.perform_later(question)
  end
end
