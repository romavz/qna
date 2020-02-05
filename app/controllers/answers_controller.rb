class AnswersController < ApplicationController

  def show; end

  def create
    @answer = question.answers.create(answer_params)

    if @answer.save
      redirect_to question_path question
    else
      flash.notice = @answer.errors.full_messages
      redirect_to question_path question
    end
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
