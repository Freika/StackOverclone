class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    find_question
  end

  def new
    @question = Question.new
  end

  def edit
    find_question
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Question was successfully created'
    else
      render :new
    end
  end

  def update
    find_question

    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    find_question
    @question.destroy
    redirect_to questions_path, notice: 'Question was deleted'
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
