class QuestionsController < ::ApplicationController
  include Voted
  include Commented

  skip_before_action :authenticate_user!, only: %i[show index]

  load_and_authorize_resource

  before_action :set_gon_question, only: :show
  after_action :publish_question, only: :create

  respond_to :html
  respond_to :js, only: :update

  def index
  end

  def new
  end

  def show
    @answer = Answer.new
  end

  def create
    @question.created_by = current_user
    @question.save
    respond_with @question
  end

  def subscribe
    subscribe_method = current_user.subscribed?(@question) ? :unsubscribe : :subscribe
    current_user.send subscribe_method, @question

    render json: { subscribed: current_user.subscribed?(@question) }
  end

  def update
    @question.update question_params
  end

  def destroy
    respond_with @question.destroy
  end

  private

  def set_gon_question
    gon.question = { id: @question.id, answers: @question.answers.pluck(:id) }
  end

  def publish_question
    return unless @question.persisted?

    template = ApplicationController.render partial: 'questions/question-row',
                                            locals: { question: @question }
    ActionCable.server.broadcast 'questions', template
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :source, :_destroy])
  end

  def redirect_path(question)
    question_path question
  end
end
