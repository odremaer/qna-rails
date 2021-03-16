class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def have_two_best_answers?
    count = 0
    self.answers.each do |answer|
      if answer.best_answer
        count += 1
      end
    end
    count == 2
  end

  def previous_best_answer
    @two_best_answers = []
    self.answers.each do |answer|
      if answer.best_answer
        @two_best_answers << answer
      end
    end
    @two_best_answers[0]
  end
end
