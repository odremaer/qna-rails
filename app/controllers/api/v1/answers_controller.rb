class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[ index create ]
  before_action :set_answer, only: %i[ show destroy update ]

  authorize_resource

  def index
    render json: @question.answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, serializer: AnswerSerializer
    else
      head :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
