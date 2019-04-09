class CommentsChannel < ApplicationCable::Channel
  def subscribed
    @commentable = commentable_klass.find params[:commentable_id]
    stream_for @commentable
  end

  private

  def commentable_klass
    params[:commentable_type].classify.constantize
  end
end
