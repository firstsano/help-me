class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :authorize_resource!, only: :destroy

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    @answer = Answer.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.created_by = current_user

    if @question.save
      redirect_to @question, notice: 'Question created successfully'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'The question was successfully deleted'
  end

  private

  def load_question
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def authorize_resource!
    message = { error: 'You are not permitted to perform this operation' }
    redirect_to questions_path, **message if @question.created_by != current_user
  end
end
