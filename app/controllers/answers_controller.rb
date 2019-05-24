class AnswersController < ::ApplicationController
  include Voted
  include Commented

  load_and_authorize_resource :question, only: :create
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
    @previous_best_answer = question.best_answer
    question.set_best_answer @answer
  end

  private

  def publish_answer
    return unless @answer.persisted?

    answer_body = @answer.body.truncate 20
    message = { body: answer_body, created_by: current_user.id }
    AnswersChannel.broadcast_to @answer.question, message
  end

  def redirect_path(answer)
    question_path answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :source, :_destroy])
  end
end
