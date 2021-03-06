class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_question, only: %i[ show update ]

  after_action :publish_question, only: %i[ create ]

  expose :questions, ->{ Question.all }
  expose :question

  def index
    @questions = questions
  end

  def new
    @question = question
    @question.links.build
    @question.build_award
  end

  def show
    @answer = @question.answers.new
    @answer.links.build
  end

  def create
    @question = Question.new(question_params)
    current_user.questions.push(@question)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    authorize! :destroy, question
    question.destroy
    redirect_to questions_path, notice: 'Question deleted successfully'
  end

  def update
    authorize! :update, @question
    @question.update(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [], links_attributes: [:id, :name, :url, :_destroy],
                                     award_attributes: [:title, :image])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])

    gon.question_id = @question.id
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
     )
  end
end
