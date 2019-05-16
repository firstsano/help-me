class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :load_question, only: :create
  load_and_authorize_resource

  after_action :publish_answer

  respond_to :js, only: %i[best create destroy update]

  def create
    @answer = @question.answers.build answer_params
    @answer.created_by = current_user
    @answer.save
  end

  def update
    @answer.update answer_params
  end

  def destroy
    @answer.destroy
  end

  def best
    question = @answer.question
    if question.created_by != current_user
      redirect_to redirect_path(@answer), error: 'You are not permitted to perform this operation'
    else
      @previous_best_answer = question.best_answer
      question.set_best_answer @answer
      render :best
    end
  end

  private

  def publish_answer
    return unless @answer.persisted?

    answer_body = @answer.body.truncate 20
    message = { body: answer_body, created_by: current_user.id }
    AnswersChannel.broadcast_to @answer.question, message
  end

  def load_question
    @question = Question.find params.require(:question_id)
  end

  def redirect_path(answer)
    question_path answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :source, :_destroy])
  end
end
