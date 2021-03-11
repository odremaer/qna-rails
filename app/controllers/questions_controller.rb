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
      current_user.questions.push(@question)
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user.is_author?(question)
      flash[:notice] = 'Question deleted successfully'
      question.destroy
      redirect_to questions_path
    else
      flash[:notice] = 'You are not author of this question'
      redirect_to question_path(question)
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
