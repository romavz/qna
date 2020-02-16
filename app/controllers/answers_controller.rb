class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path question
    else
      render 'questions/show'
    end
  end

  def destroy
    answer = Answer.includes(:user).find(params[:id])
    if current_user.author_of?(answer)
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
