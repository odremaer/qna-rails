class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]

  expose :questions, ->{ Question.all }
  expose :question

  def index
    @questions = questions
  end

  def new
    @question = question
  end

  def show
    @question = question
    @answer = question.answers.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
