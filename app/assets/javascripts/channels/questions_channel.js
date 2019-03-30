(function($) {
  const subscriptions = App.cable.subscriptions;
  const s = { questions: '.questions' };

  const subscribe = function() {
    $questions = $(s.questions);
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
