module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[ upvote downvote undo_vote ]
  end


  def upvote
    vote = current_user.vote(value: 1, votable: @votable)

    respond_to do |format|
      if vote.nil? || vote.save
        format.json {
          render json: {
            obj_id: @votable.id,
            obj: @votable.class.to_s,
            rating: @votable.rating
          }
        }
      else
        format.json {
          render json: {
            error: vote.errors.full_messages,
            obj_id: @votable.id,
            obj: @votable.class.to_s
          }, status: :unprocessable_entity
        }
      end
    end
  end

  def downvote
    vote = current_user.vote(value: -1, votable: @votable)

    respond_to do |format|
      if vote.nil? || vote.save
        format.json {
          render json: {
            obj_id: @votable.id,
            obj: @votable.class.to_s,
            rating: @votable.rating
          }
        }
      else
        format.json {
          render json: {
            error: vote.errors.full_messages,
            obj_id: @votable.id,
            obj: @votable.class.to_s,
          }, status: :unprocessable_entity
        }
      end
    end
  end

  def undo_vote
    current_user.undo_vote(@votable)

    respond_to do |format|
      format.json {
        render json: {
          obj_id: @votable.id,
          obj: @votable.class.to_s,
          rating: @votable.rating
        }
      }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
