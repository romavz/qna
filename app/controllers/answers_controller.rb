class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_author, except: %i[create]

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

  def destroy
    answer.destroy
  end

  private

  def check_author
    render status: :forbidden unless current_user.author_of?(answer)
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end

end
