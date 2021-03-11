class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to question_path(@question), notice: 'Answer created successfully'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
