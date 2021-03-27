class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, only: %i[ destroy update choose_best ]

  after_action :publish_answer, only: %i[ create ]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    current_user.answers.push(@answer)
  end

  def destroy
    @question = @answer.question

    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    end

    @question = @answer.question
  end

  def choose_best
    @question = @answer.question

    if current_user.author_of?(@question)
      @answer.set_best_answer(params)
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :best_answer,
                                   files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("answers_#{@answer.question.id}", @answer)
      # ApplicationController.render(
      #   partial: 'questions/question',
      #   locals: { question: @question }
      # )

  end
end
