class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :load_question, only: :create
  before_action :load_answer, only: %i[show update destroy]
  before_action :authorize_resource!, only: %i[update destroy]

  def show
  end

  def create
    @answer = @question.answers.build answer_params
    @answer.created_by = current_user
    @answer.save
    render :create
  end

  def update
    @answer.update answer_params
    render :update
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
    params.require(:answer).permit(:body)
  end

  def authorize_resource!
    message = { alert: 'You are not permitted to perform this operation' }
    redirect_to question_answers_path(@answer.question), **message if @answer.created_by != current_user
  end
end
