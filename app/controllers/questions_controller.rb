class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :load_question, only: %i[show update destroy upvote downvote]
  before_action :authorize_resource!, only: %i[update destroy]
  before_action :restrict_votes!, only: %i[upvote downvote]

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

  def upvote
    vote = @question.votes.find_by user: current_user
    vote.destroy if vote
    @question.upvotes.create user: current_user unless vote&.upvote?
    render json: @question
  end

  def downvote
    vote = @question.votes.find_by user: current_user
    vote.destroy if vote
    @question.downvotes.create user: current_user unless vote&.downvote?
    render json: @question
  end

  private

  def load_question
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :source, :_destroy])
  end

  def restrict_votes!
    message = { error: 'Owner cannot vote' }
    redirect_to question_path(@question), **message if @question.created_by == current_user
  end

  def authorize_resource!
    message = { error: 'You are not permitted to perform this operation' }
    redirect_to questions_path, **message if @question.created_by != current_user
  end
end
