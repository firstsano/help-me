(function($) {
  const subscriptions = App.cable.subscriptions;
  const selectors = { answers: '.answers' };
  const question_id = _.get(gon, 'question.id');

  const subscribe = function() {
    if (!question_id) {
      return false;
    }

    const channel = {
      channel: 'AnswersChannel',
      question_id: question_id
    };
    const callbacks = {
      received(data) {
        console.log(data);
      }
    };
    subscriptions.create(channel, callbacks);
  }

  $(document).ready(subscribe);
})(jQuery);
