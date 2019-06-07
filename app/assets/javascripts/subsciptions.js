(function($) {
  const s = {
    subscription: '.question__subscription',
    icons: {
      active: 'notifications_active',
      inactive: 'notifications_none'
    }
  };

  const initialize = function() {
    const notification = App.notification;

    $('body').on('ajax:success', s.subscription, function(event) {
      event.stopPropagation();

      const [{subscribed}, response, status] = event.detail;
      const $icon = $(this).find('i');
      if (subscribed) {
        $icon.text(s.icons.active);
        notification.display("Subscribed");
      } else {
        $icon.text(s.icons.inactive);
        notification.display("Unsubscribed");
      }
      $icon.attr('data-subscribed', subscribed)
    });
  };

  $(document).ready(initialize);
})(jQuery);
