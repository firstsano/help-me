(function($) {
  const subscriptions = App.cable.subscriptions;
  const selectors = { questions: '.questions' };

  const subscribe = function() {
    $questions = $(selectors.questions);
    if (!$questions.length) {
      return false;
    }

    subscriptions.create('QuestionsChannel', {
      received(data) {
        $questions.append(data);
      }
    });
  };

  $(document).ready(subscribe);
})(jQuery);
