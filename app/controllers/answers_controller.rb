class AnswersController < ApplicationController

  def show; end

  def new; end

  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
          .merge(question_id: params[:question_id])
  end

end
