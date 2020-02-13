class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
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

  def destroy
    question = Question.find(params[:id])
    if current_user.author?(question)
      question.destroy
      flash.notice = 'Your question successfully deleted'
      redirect_to questions_path and return
    end

    flash.notice = 'You can delete only your own questions.'
    redirect_back fallback_location: question_path(question)
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
