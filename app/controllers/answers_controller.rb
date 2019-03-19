class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, only: %i[update destroy best upvote downvote]
  before_action :authorize_resource!, only: %i[update destroy]
  before_action :restrict_votes!, only: %i[upvote downvote]

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
      redirect_to question_path(question), alert: 'You are not permitted to perform this operation'
    else
      @previous_best_answer = question.best_answer
      question.set_best_answer @answer
      render :best
    end
  end

  def upvote
    previous_vote = @answer.votes.find_by(user: current_user)&.destroy
    @answer.upvotes.create user: current_user unless previous_vote&.upvote?
    render json: { score: @answer.score, upvoted: !previous_vote&.upvote? }
  end

  def downvote
    previous_vote = @answer.votes.find_by(user: current_user)&.destroy
    @answer.downvotes.create user: current_user unless previous_vote&.downvote?
    render json: { score: @answer.score, downvoted: !previous_vote&.downvote? }
  end

  private

  def load_question
    @question = Question.find params.require(:question_id)
  end

  def load_answer
    @answer = Answer.find params.require(:id)
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :source, :_destroy])
  end

  def restrict_votes!
    message = { error: 'Owner cannot vote' }
    redirect_to question_path(@answer.question), **message if @answer.created_by == current_user
  end

  def authorize_resource!
    message = { alert: 'You are not permitted to perform this operation' }
    redirect_to question_path(@answer.question), **message if @answer.created_by != current_user
  end
end
