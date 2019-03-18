(function($) {
  const selectors = s = {
    vote: '.vote',
    score: '.vote__score',
    button: {
      active: '.vote__button_active',
      upvote: '.vote__button_upvote',
      downvote: '.vote__button_downvote',
    }
  };

  const initialize = function() {
    $('body').on('ajax:success', s.vote, function(event) {
      event.stopPropagation();

      const [{score, upvoted, downvoted}, response, status] = event.detail;
      $(this).find(s.score).text(score);
      $(this).find(s.button.active).removeClass('vote__button_active');
      if (upvoted === true) $(this).find(s.button.upvote).addClass('vote__button_active');
      if (downvoted === true) $(this).find(s.button.downvote).addClass('vote__button_active');
    });
  };

  $(document).ready(initialize);
})(jQuery);
