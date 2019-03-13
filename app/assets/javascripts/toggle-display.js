(function($) {
  let initialize = function() {
    $('body').on('click', '[data-toggle-display]', function(e) {
      e.preventDefault();
      $parent = $(this).closest($(this).data('parent'));
      $parent.find($(this).data('show')).show();
      $parent.find($(this).data('hide')).hide();
    });
  };

  $(document).ready(initialize);
})(jQuery);
