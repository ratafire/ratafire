function hide_editor_options(random_id){
	//Hide editor options
	$('#editor-options-holder').hide();
	//Move the editor to top
	$('#editor-holder').velocity('scroll',{
		duration:500,
		offset:-80,
		easing:'ease-in-out'
	});	
}

function initiate_editor(upload_url){
  
	//Block ui
	$('.fa-lightbulb-o').on('click', function(){
		return (this.tog = !this.tog) ? turn_lights_on('#above-blockui') : turn_lights_off('#above-blockui');
	});
	$('#editor-submition-block').block({message: null,overlayCSS: {
                backgroundColor: '#fff',
                opacity: 0.4,
                cursor: 'not-allowed'
            },});
	// Tooltip
	$('[data-popup="tooltip"]').tooltip();	
  	  		
}