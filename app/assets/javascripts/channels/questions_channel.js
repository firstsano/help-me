(function($) {
  const subscriptions = App.cable.subscriptions;
  const subscribe = subscriptions.create('QuestionsChannel', {
    received(data) {
      $(".questions").append(data);
    }
  });

  $(document).ready(subscribe);
})(jQuery);
