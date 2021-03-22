class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_question, only: %i[ show update ]

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
    if current_user.author_of?(question)
      flash[:notice] = 'Question deleted successfully'
      question.destroy
      redirect_to questions_path
    else
      flash[:notice] = 'You are not author of this question'
      redirect_to question_path(question)
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [], links_attributes: [:id, :name, :url, :_destroy],
                                     award_attributes: [:title, :image])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
