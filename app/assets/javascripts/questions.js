(function($) {
  let initialize = function() {
    $('body').on('click', '[data-remote-form]', function(e) {
      e.preventDefault();
      $($(this).data('remote-form')).show();
      $(this).hide();
    });
  };

  $(document).ready(initialize);
})(jQuery);
