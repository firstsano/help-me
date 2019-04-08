module CommentsHelper
  def comment_path(resource)
    resource_path_name = resource.class.name.downcase
    send "comment_#{resource_path_name}_path", resource
  end

  def comments_of(commentable)
    commentable.comments.select(&:persisted?)
  end
end
