class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_one :award, dependent: :destroy

  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  def have_two_best_answers?
    true if answers.where(best_answer: true).count == 2
  end

  def previous_best_answer
    answers.find_by(best_answer: true)
  end
end
