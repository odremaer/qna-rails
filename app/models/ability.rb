# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      user_abilities(user)
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities(user)
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id

    can [:upvote, :downvote, :undo_vote], [Question, Answer] do |votable|
      true unless user.author_of?(votable)
    end

    can :choose_best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.author_of?(file.record)
    end

    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end
  end
end
