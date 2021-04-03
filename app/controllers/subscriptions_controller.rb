class SubscriptionsController < ApplicationController
  before_action :set_question, only: %i[ create ]

  def create
    authorize! :create, Subscription
    @subscription = Subscription.new(question: @question, user: current_user)

    @subscription.save
    redirect_to @subscription.question
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    
    authorize! :destroy, @subscription
    @subscription.destroy

    redirect_to @subscription.question
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:question_id])
  end
end
