class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    current_user.answers.push(@answer)
    
    if @answer.save
      redirect_to question_path(@question), notice: 'Answer created successfully'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.is_author?(@answer)
      flash[:notice] = 'Answer deleted successfully'
      @answer.destroy
    else
      flash[:notice] = 'You are not author of this answer'
    end

    redirect_to question_path(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
