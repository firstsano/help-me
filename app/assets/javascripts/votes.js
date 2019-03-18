(function($) {
  const initialize = function() {
    $('body').on('ajax:success', '.vote', function(event) {
      const [{score}, response, status] = event.detail;
      $(this).find('.vote__score').text(score);
    });
  };

  $(document).ready(initialize);
})(jQuery);
