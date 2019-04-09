class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[show index]
  before_action :load_question, only: %i[show update destroy]
  before_action :authorize_resource!, only: %i[update destroy]
  before_action :set_gon_question, only: :show
  after_action :publish_question, only: :create

  respond_to :js, only: :update

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    @answer = Answer.new
  end

  def create
    @question = Question.new question_params
    @question.created_by = current_user
    @question.save
    respond_with @question
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

  def load_question
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :source, :_destroy])
  end

  def redirect_path(question)
    question_path question
  end

  def authorize_resource!
    message = { error: 'You are not permitted to perform this operation' }
    redirect_to questions_path, **message if @question.created_by != current_user
  end
end
