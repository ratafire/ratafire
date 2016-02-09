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