class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[ show destroy update ]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.build(question_params)
    if @question.save
      render json: @question, serializer: QuestionSerializer
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
  end

  def update
    if @question.update(question_params)
      render json: @question, serializer: QuestionSerializer
    else
      head :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
