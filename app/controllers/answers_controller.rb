class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, only: [:destroy, :update, :mark_as_solution]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy if current_user.id == @answer.user_id
  end

  def update
    @question = @answer.question
    if current_user.id == @answer.user_id
      @answer.update(answer_params)
    else
      redirect_to @question, notice: 'Access denied'
    end
  end

  def mark_as_solution
    @question = @answer.question
    @answer.mark_as_solution if @question.user_id == current_user.id
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id, :is_solution, attachments_attributes: [:file, :id, :_destroy])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

end
