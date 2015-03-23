class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: :destroy

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Answer was added'
    else
      flash[:notice] = 'Something goes wrong'
    end
    redirect_to @question
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question, notice: 'Answer was successfully deleted'
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

end
