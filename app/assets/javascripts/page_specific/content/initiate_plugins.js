function initiate_plugins(random_id){
    // Initialize lightbox
    $('[data-popup="lightbox"]').fancybox({
        padding: 3
    });    
    //Clipboard
    new Clipboard('a');    
    //Switchery
    var elem2s = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));

    elem2s.forEach(function(html) {
      var switchery2 = new Switchery(html);
    });
    //Dropdown    
    $('.dropdown-toggle').dropdown();
	// Popover
    $('[data-popup="popover"]').popover();
    // Tooltip
    $('[data-popup="tooltip"]').tooltip();
    // Photoset
    $('.photoset-grid-lightbox').photosetGrid({
        highresLinks: true,
        rel: 'withhearts-gallery',
        gutter: '2px',
    onComplete: function(){
        $('.photoset-grid-lightbox').attr('style', '');
        $('.photoset-grid-lightbox a').colorbox({
            photo: true,
            scalePhotos: true,
            maxHeight:'90%',
            maxWidth:'90%'
            });
        }
    });
    //Update Videojs to show video
    $('.'+random_id).each(function() {
        videojs(this.id, {}, function(){
        // Player (this) is initialized and ready.
        });
    });        
    // Initialize Popup
    $('.open-popup-link').magnificPopup({type:'inline'});  
    // Sticky
    $("#sticker").sticky({topSpacing:0}); 
    // Resize sidebar to window height
    $('#sidebar-content').height($( window ).height());
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