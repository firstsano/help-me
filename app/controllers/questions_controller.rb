class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[show index]
  before_action :load_question, only: %i[show update destroy]
  before_action :authorize_resource!, only: %i[update destroy]
  after_action :publish_question, only: :create

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
    @question = Question.new(question_params)
    @question.created_by = current_user

    if @question.save
      redirect_to @question, notice: 'Question created successfully'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'The question was successfully deleted'
  end

  private

  def publish_question
    return unless @question.valid?

    template = ApplicationController.render partial: 'questions/question_row',
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
