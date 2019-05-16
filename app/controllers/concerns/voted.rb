module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_resource_for_votable, only: %i[upvote downvote]
  end

  def upvote
    votable = instance_variable_get "@#{votable_name}"
    previous_vote = votable.votes.find_by(user: current_user)&.destroy
    votable.upvotes.create user: current_user unless previous_vote&.upvote?
    render json: { score: votable.score, upvoted: !previous_vote&.upvote? }
  end

  def downvote
    votable = instance_variable_get "@#{votable_name}"
    previous_vote = votable.votes.find_by(user: current_user)&.destroy
    votable.downvotes.create user: current_user unless previous_vote&.downvote?
    render json: { score: votable.score, downvoted: !previous_vote&.downvote? }
  end

  private

  def load_resource_for_votable
    votable = instance_variable_get "@#{votable_name}"
    return if votable

    votable = votable_klass.find params.require(:id)
    instance_variable_set "@#{votable_name}", votable
  end

  def votable_klass
    params[:controller].classify.constantize
  end

  def votable_name
    params[:controller].singularize
  end
end
