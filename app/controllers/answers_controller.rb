class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def show; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    flash.notice = @answer.errors.full_messages unless @answer.save

    redirect_to question_path question
  end

  def destroy
    answer = Answer.find(params[:id])
    if current_user.author?(answer)
      answer.destroy
      flash.notice = 'Your answer successfully deleted'
    else
      flash.notice = 'You can delete only your own answers'
    end

    redirect_to question_path answer.question
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end

end
