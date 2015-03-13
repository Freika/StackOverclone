class AnswersController < ApplicationController

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)

    if @answer.save
      flash[:notice] = 'Answer was added'
    else
      flash[:notice] = 'Something goes wrong'
    end
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
