class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
    redirect_to root_path, notice: "Access denied" unless current_user.id == @question.user_id
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Question was successfully created'
    else
      render :new
    end
  end

  def update
    if current_user.id == @question.user_id && @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    if current_user.id == @question.user_id
      @question.destroy
      redirect_to questions_path, notice: 'Question was deleted'
    else
      redirect_to root_path, notice: 'You can delete only questions you own'
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
