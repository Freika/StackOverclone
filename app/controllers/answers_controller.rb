class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, only: :destroy

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.id == @answer.user_id
      @answer.destroy
      redirect_to @question, notice: 'Answer was successfully deleted'
    else
      redirect_to @question, notice: 'You can delete only questions you own'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

end
