class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true

  def have_two_best_answers?
    true if answers.where(best_answer: true).count == 2
  end

  def previous_best_answer
    answers.find_by(best_answer: true)
  end
end
