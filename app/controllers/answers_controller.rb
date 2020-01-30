class AnswersController < ApplicationController

  def show; end

  def new; end

  def create
    @answer = question.answers.create(answer_params)

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
