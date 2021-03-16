class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    current_user.answers.push(@answer)
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question

    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
    if @question.have_two_best_answers?
      previous_best_answer = @question.previous_best_answer
      previous_best_answer.best_answer = false
      previous_best_answer.save
    end
    @question.reload
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :best_answer)
  end
end
