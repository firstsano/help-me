(function($) {
  const subscriptions = App.cable.subscriptions;
  const selectors = {
    question: { comments: ".question__comments .comments__list" },
    answer: { comments: (id) => `.answer[data-answer-id="${id}"] .answer__comments .comments__list` }
  };
  const currentUser = _.get(gon, 'user');

  const subscribeOnQuestionComments = function() {
    const questionId = _.get(gon, 'question.id');
    if (!questionId) {
      return false;
    }

    const callbacks = {
      received(data) {
        if (data.created_by === currentUser) {
          return false;
        }

        $(selectors.question.comments).append(data.comment);
      }
    };
    App.subscribeOnComments(questionId, 'question', callbacks);
  }

  const subscribeOnAnswersComments = function() {
    const answersIds = _.get(gon, 'question.answers');
    const callbacks = {
      received(data) {
        if (data.created_by === currentUser) {
          return false;
        }

        $(selectors.answer.comments(data.commentable_id)).append(data.comment);
      }
    };
    App.subscribeOnComments(answersIds, 'answer', callbacks);
  }

  $(document).ready(function() {
    subscribeOnAnswersComments();
    subscribeOnQuestionComments();
  });
})(jQuery);
