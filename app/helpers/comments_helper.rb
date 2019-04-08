module CommentsHelper
  def comment_path(resource)
    resource_path_name = resource.class.name.downcase
    send "comment_#{resource_path_name}_path", resource
  end
end
