(function($) {
  $(".toggle-password").click(function() {
      // Toggle the icon classes to switch between "eye" and "eye-off"
      $(this).toggleClass("zmdi-eye zmdi-eye-off");

      // Get the associated password input field
      var input = $($(this).attr("toggle"));

      // Check if the field is password type and toggle it
      if (input.attr("type") == "password") {
          input.attr("type", "text");
      } else {
          input.attr("type", "password");
      }
  });
})(jQuery);
