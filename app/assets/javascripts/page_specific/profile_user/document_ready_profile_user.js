function profile_user_plugins(user_id){
    // Initialize Tab Specific Functions
    $('#tab-updates').on('click', function (e) {
        $('#pledge-area').fadeIn();
        $('#side-area').show();
        $('#updates-main-area').addClass('col-xs-12, col-md-8');
    });
    $('#tab-friends,#tab-backers,#tab-backeds').on('click', function (e) {
        $('#pledge-area').fadeOut();
        $('#side-area').hide();
        $('#updates-main-area').removeClass('col-xs-12, col-md-8');
    });


    // Initiate Pagination
    $(window).scroll(function() {
        //Post
        if ($('.post-will-paginate').length) {
          var url = $('.post-will-paginate .next_page').attr('href');
          if (url && $(window).scrollTop() > $('.post-will-paginate').offset().top) {
            $('.post-will-paginate').html("<i class=\"icon-spinner2 spinner text-blue\"></i>");
            return $.getScript(url);        
          }
        }
        //Friend
        if ($('.friends-pagination').length) {
          var url_friends = $('.friends-pagination .next_page').attr('href');
          if (url_friends && $(window).scrollTop() > $('.backers-pagination').offset().top - 3000) {
            $('.friends-pagination').html("<i class=\"icon-spinner2 spinner text-blue\"></i>");
            return $.getScript(url_friends);        
          }
        }    
        //Backer
        if ($('.backers-pagination').length) {
          var url_friends = $('.backers-pagination .next_page').attr('href');
          if (url_friends && $(window).scrollTop() > $('.backers-pagination').offset().top - 3000) {
            $('.backers-pagination').html("<i class=\"icon-spinner2 spinner text-blue\"></i>");
            return $.getScript(url_friends);        
          }
        }     
        //Backed
        if ($('.backeds-pagination').length) {
          var url_friends = $('.backeds-pagination .next_page').attr('href');
          if (url_friends && $(window).scrollTop() > $('.backeds-pagination').offset().top - 3000) {
            $('.backeds-pagination').html("<i class=\"icon-spinner2 spinner text-blue\"></i>");
            return $.getScript(url_friends);        
          }
        }                    
    });       
}