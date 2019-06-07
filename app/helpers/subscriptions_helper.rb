module SubscriptionsHelper
  def subscription_button(question)
    return unless user_signed_in?

    subscribed = current_user.subscribed? question
    icon = subscribed ? 'notifications_active' : 'notifications_none'
    link_to subscribe_question_path(question), remote: true, method: :put, class: 'question__subscription' do
      tag.i icon, class: 'material-icons', data: { 'subscribed': subscribed }
    end
  end
end
