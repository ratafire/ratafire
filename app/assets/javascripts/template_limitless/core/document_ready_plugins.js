function document_ready_plugins(random_id){
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
    // Flash Message
    $(window).bind('rails:flash', function(e, params) {
        new PNotify({
            title: params.type,
            text: params.message,
            type: params.type
        });
    });  	      
}