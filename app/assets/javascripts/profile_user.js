function profile_user_plugins(random_id){
	// Initialize Tab Specific Functions
	$('#tab-updates').on('click', function (e) {
	    $('#pledge-area').fadeIn();
	});
	$('#tab-friends').on('click', function (e) {
	    $('#pledge-area').fadeOut();
	});      
}