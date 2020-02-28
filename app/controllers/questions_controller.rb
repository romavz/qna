class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @best_answer = question.answers.find_by(id: question.best_answer_id)
    @answers = question.answers.where.not(id: question.best_answer_id)
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
    if current_user.author_of?(question)
      question.update(question_params)
    else
      render status: :forbidden
    end
  end

  def mark_answer
    @question = Question.find(params[:id])
    @answer = Answer.find(params[:answer_id])

    if current_user.author_of?(question) && @answer.question_id == question.id
      question.update(best_answer_id: @answer.id)
    else
      render status: :forbidden
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
    else
      render status: :forbidden
    end
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
