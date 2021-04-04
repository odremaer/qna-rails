class Question < ApplicationRecord
  scope :recent_questions, -> { where("created_at > ?", 1.day.ago) }

  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many :subscriptions, dependent: :destroy

  has_one :award, dependent: :destroy

  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :subscribe_author_for_question

  def have_two_best_answers?
    true if answers.where(best_answer: true).count == 2
  end

  def previous_best_answer
    answers.find_by(best_answer: true)
  end

  private

  def subscribe_author_for_question
    subscriptions.create(user: user)
  end
end
