module Commented
  extend ActiveSupport::Concern

  included do
    before_action :load_resource_for_commentable, only: :comment
    before_action :authenticate_user!, only: :comment
  end

  def comment
    commentable = instance_variable_get "@#{commentable_name}"
    @comment = commentable.comments.build comment_params
    @comment.author = current_user
    @comment.save
    render :comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_resource_for_commentable
    commentable = instance_variable_get "@#{commentable_name}"
    return if commentable

    commentable = commentable_klass.find params.require(:id)
    instance_variable_set "@#{commentable_name}", commentable
  end

  def commentable_klass
    params[:controller].classify.constantize
  end

  def commentable_name
    params[:controller].singularize
  end
end
