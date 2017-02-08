function document_ready_plugins(random_id){
    //Socialsharekit
    /*!
     * Social Share Kit v1.0.8 (http://socialsharekit.com)
     * Copyright 2015 Social Share Kit / Kaspars Sprogis.
     * Licensed under Creative Commons Attribution-NonCommercial 3.0 license:
     * https://github.com/darklow/social-share-kit/blob/master/LICENSE
     * ---
     */

    //Signup Signin tab
    $('.login-open-popup').on('click', function(){
    	$('#login-popup li:eq(1) a').tab('show');//select the secrond tab
    });
    $('.signup-open-popup').on('click', function(){
    	$('#login-popup li:eq(0) a').tab('show');//select the first tab
    });  

	// Initialize MagnificPopup
	$('.open-popup-link').magnificPopup({type:'inline'});   
    // Initialize Nice Scroll
    $(".sidebar-fixed .sidebar-content").niceScroll({
        mousescrollstep: 100,
        cursorcolor: '#ccc',
        cursorborder: '',
        cursorwidth: 3,
        hidecursordelay: 100,
        autohidemode: 'scroll',
        horizrailenabled: false,
        preservenativescrolling: false,
        railpadding: {
        	right: 0.5,
        	top: 1.5,
        	bottom: 1.5
        }
    });      
    

}

