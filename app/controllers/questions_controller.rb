class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :check_author, only: %i[mark_answer update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = question.answers
  end

  def new; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
  end

  private

  def check_author
    render status: :forbidden unless current_user.author_of?(question)
  end

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
