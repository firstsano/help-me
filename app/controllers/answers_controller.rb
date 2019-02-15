class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[index new create]
  before_action :load_answer, only: %i[show edit update destroy]
  before_action :authorize_resource!, only: :destroy

  def index
    @answers = @question.answers.all
  end

  def new
    @answer = Answer.new
  end

  def show
  end

  def edit
  end

  def create
    @answer = Answer.new answer_params
    @answer.assign_attributes question: @question, created_by: current_user

    if @answer.save
      redirect_to answer_path(@answer), notice: 'Answer created successfully'
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to answer_path(@answer)
    else
      render :edit
    end
  end

  def destroy
    question = @answer.question
    @answer.destroy
    redirect_to question_path(question), notice: 'Answer successfully destroyed'
  end

  private

  def load_question
    @question = Question.find params.require(:question_id)
  end

  def load_answer
    @answer = Answer.find params.require(:id)
  end

  def answer_params
    params.require(:answer).permit(:title, :body)
  end

  def authorize_resource!
    message = { error: 'You are not permitted to perform this operation' }
    redirect_to answer_path(@answer), **message if @answer.created_by != current_user
  end
end
