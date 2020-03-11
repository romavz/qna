class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_author, except: %i[create mark_as_best]
  before_action :check_question_author, only: %i[mark_as_best]

  def create
    @answer = Answer.new(answer_params)
    @answer.question = question
    @answer.user = current_user
    @answer.save
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  def mark_as_best
    answer.mark_as_best unless answer.best?
    @best_answer = answer
    @answers = question.answers
  end

  def destroy
    answer.destroy
  end

  private

  def check_author
    render status: :forbidden unless current_user.author_of?(answer)
  end

  def check_question_author
    render status: :forbidden unless current_user.author_of?(answer.question)
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= params[:question_id].present? ? Question.find(params[:question_id]) : answer.question
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end

end
