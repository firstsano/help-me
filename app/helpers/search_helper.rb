module SearchHelper
  def search_result_for(object, query, starred_query: starred_query)
    object_type = object.class.name.parameterize
    query = "*#{query}*" if starred_query
    excerpter = ThinkingSphinx::Excerpter.new "#{object_type}_core", query
    search_contents = send "search_result_for_#{object_type}", object, excerpter
    render '/search/search_result', **search_contents
  end

  def search_result_for_question(question, excerpter)
    {
      icon: 'live_help',
      title: 'question',
      content: search_highlight(excerpter, question.title) + search_highlight(excerpter, question.body),
      details: content_tag(:div, search_highlight(excerpter, question.created_by.name)),
      link: link_to('More...', question_path(question), class: 'search-result__link')
    }
  end

  def search_result_for_answer(answer, excerpter)
    {
      icon: 'reply',
      title: 'answer',
      content: search_highlight(excerpter, answer.body),
      details: search_highlight(excerpter, answer.created_by.name),
      link: link_to('More...', question_path(answer.question), class: 'search-result__link')
    }
  end

  def search_result_for_comment(comment, excerpter)
    {
      icon: 'chat',
      title: 'comment',
      content: search_highlight(excerpter, comment.body),
      details: search_highlight(excerpter, comment.author.name)
    }
  end

  def search_result_for_user(user, excerpter)
    {
      icon: 'account_circle',
      title: 'user',
      content: search_highlight(excerpter, user.name) + search_highlight(excerpter, user.email)
    }
  end

  def search_result_for_everything(object, excerpter)
    {
      icon: 'line_weight',
      title: 'other',
      content: search_highlight(excerpter, object.to_s)
    }
  end

  def search_highlight(excerpter, string)
    markup = raw excerpter.excerpt!(string)
    content_tag :div, markup
  end

  def method_missing(method, *args, &block)
    super unless method =~ /search_result_for_(\w+)/

    search_result_for_everything(*args)
  end
end
