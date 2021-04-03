class User < ApplicationRecord
  scope :all_except, ->(user) { where.not(id: user) }

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy

  has_many :awards, dependent: :destroy

  has_many :votes, dependent: :destroy

  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(object)
    object.user_id == self.id
  end

  def admin?
    admin == true
  end

  def subscribed?(question)
    subscriptions.where(question: question).present?
  end
end
