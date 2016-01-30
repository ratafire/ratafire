function initiate_plugins(random_id){
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
     
}