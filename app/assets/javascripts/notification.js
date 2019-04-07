(function($) {
  const selectors = {
    notification: '.notification',
    message: '.notification__message',
    button: '.notification__close'
  };

  class Notification {
    constructor() {
      this.$element = $(selectors.notification);
      this.$button = this.$element.find(selectors.button);
      this.$message = this.$element.find(selectors.message);
      this.$button.on('click', () => this.close());
      this.isOpened = false;
    }

    display(message) {
      this.$message.html(message);
      this._show();
    }

    close() {
      this._hide(() => this.$message.html(''));
    }

    _show() {
      if (this.isOpened) {
        return false;
      }

      this.$element.fadeIn();
      this.isOpened = true;
    }

    _hide(callback) {
      if (!this.isOpened) {
        return false;
      }

      this.$element.fadeOut(callback);
      this.isOpened = false;
    }
  }

  $(document).ready(function() {
    App.notification = new Notification();
  });
})(jQuery);
