module VotesHelper
  def vote_button(path, resource, type, &block)
    classes = ["vote__button"]
    case type
    when :upvote
      classes << "vote__button_upvote"
      classes << "vote__button_active" if resource.upvoted_by_user?(current_user)
    when :downvote
      classes << "vote__button_downvote"
      classes << "vote__button_active" if resource.downvoted_by_user?(current_user)
    end
    link_to path, remote: true, method: :post, class: classes.join(" "), &block
  end
end
