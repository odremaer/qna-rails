class CommentsController < ApplicationController

  before_action :authenticate_user!

  before_action :find_commentable_klass, only: :create

  after_action :publish_comment, only: %i[ create ]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
    if @commentable.is_a?(Question)
      redirect_to @commentable
    else
      redirect_to @commentable.question
    end
  end


  private

  def find_commentable_klass
    # request returns smth like /questions/18/comments
    klass = request.path.split('/')[1].classify.constantize
    klass_id = request.path.split('/')[2]
    @commentable = klass.find(klass_id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = @commentable.is_a?(Question) ? @commentable.id : @commentable.question_id
    ActionCable.server.broadcast("comments_#{question_id}", comment: @comment)
  end
end
