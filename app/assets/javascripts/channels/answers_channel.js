(function($) {
  const subscriptions = App.cable.subscriptions;
  const selectors = { answers: '.answers' };
  const newAnswers = [];
  const maxAnswersToShow = 4;

  const generateAnswersTooltip = function(answers) {
    const displayAnswers = _.take(answers, maxAnswersToShow);
    const answersList = displayAnswers.map(answer => `<li>${answer}</li>`);
    if (answers.length > maxAnswersToShow) {
      answersList.push('<li>...</li>');
    }
    return `
      <div data-toggle="tooltip"
            data-html="true"
            title="<ul class='simple-list'>${answersList.join('')}</ul>"
            class="badge badge-pill badge-success">
        ${answers.length}
      </div>
    `;
  };

  const subscribe = function() {
    const notification = App.notification;
    const questionId = _.get(gon, 'question');
    const currentUser = _.get(gon, 'user');
    if (!questionId) {
      return false;
    }

    const channel = {
      channel: 'AnswersChannel',
      question_id: questionId
    };
    const callbacks = {
      received(data) {
        if (data.created_by === currentUser) {
          return false;
        }

        newAnswers.push(data.body);
        if (newAnswers.length > 0) {
          const answerBadge = generateAnswersTooltip(newAnswers);
          const reloadPage = '<a href="">reload page</a>';
          notification.display(`${answerBadge} new answers, ${reloadPage}`);
        }
      }
    };
    subscriptions.create(channel, callbacks);
  }

  $(document).ready(subscribe);
})(jQuery);
