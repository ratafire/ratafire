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
;
function refreshUsercard(popupclass){
    //Usercard
    var timer;
    $('.'+popupclass).popover({ 
        trigger: "manual" , 
        html: true, 
        animation:false,
        template:'<div class="popover"><div class="popover-content"></div><div class="usercard-profile"></div><div class="arrow"></div></div>'
    })
        .on("mouseenter",function(){
            $('.popover').hide();
            clearTimeout(timer);
            var that = this,
                timer = setTimeout(function() {
                    if($(that).is(':hover'))
                    {
                            user_uid = $(that).data("id"),
                        usercard_url = "/usercard/"+user_uid+"/profile";      
                        $.ajax({
                            url: usercard_url
                        });
                        $(that).popover("show");
                    }
                }, 400);
            $(".popover").on("mouseleave", function () {
                clearTimeout(timer);
                $('.popover').hide();
                $(that).popover('hide');
            });
        }).on("mouseleave",function () {
            var that = this;
            setTimeout(function () {
                if (!$(".popover:hover").length) {
                    clearTimeout(timer);
                    $('.popover').hide();
                    $(that).popover("hide");
                }
            }, 300);
        });  	
}
;
function turn_lights_off(block_id){
	$(block_id).addClass('above-blockui');
	$('.outer-space').block({
		message: null,
		overlayCSS: {
			cursor: 'default'
		}
	});	
}
function turn_lights_on(block_id){
	$('.outer-space').unblock();
	$(block_id).removeClass('above-blockui');
}
;
$(document).on('ready page:load', function(event) {
	initiate_profile_editor();
});


