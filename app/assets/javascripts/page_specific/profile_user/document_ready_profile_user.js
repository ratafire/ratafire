function profile_user_plugins(user_id){
    // Initiate Pagination
    if ($('.pagination').length) {
      $(window).scroll(function() {
        var url;
        url = $('.pagination .next_page').attr('href');
        if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
          $('.pagination').html("<i class=\"icon-spinner2 spinner text-blue\"></i>");
          return $.getScript(url);
        }
      });
      return $(window).scroll();
    }    

}