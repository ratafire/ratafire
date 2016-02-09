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
	// Initialize multiple switches
	var elem = document.querySelector('.switchery'),
	    init = new Switchery(elem, { color: '#8BC34A'});
	    elem.addEventListener('click', function() {
	        if (elem.checked){
	            $('#editor-submition').val('Paid Creation').removeClass('btn-blue').addClass('bg-green');
	        }
	        else {
	            $('#editor-submition').val('Post Update').removeClass('bg-green').addClass('btn-blue');
	        }    
	    });
	// Tooltip
	$('[data-popup="tooltip"]').tooltip();	
 	//majorpost artwork uploader	
  	$('#s3_uploader_artwork').S3Uploader(
    	{ 
      	remove_completed_progress_bar: false,
      	dropZone: $('#artwork-dropzone'),
      	progress_bar_target: $('#artwork-progress-case'),
      	additional_data: { "artwork[majorpost_uuid]": $('#s3_uploader_artwork').data('majorpost-uuid')},
    },"artwork"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
  	$('#s3_uploader_artwork').bind('s3_upload_failed', function(e, content) {
    	return alert(content.filename + ' failed to upload');
  	});
    $('#s3_uploader_artwork').bind('s3_upload_complete', function(e, content) {
      $('#progress-words').html("Processing...meow");
    });    	
 	//majorpost audio uploader	
  	$('#s3_uploader_audio').S3Uploader(
    	{ 
      	remove_completed_progress_bar: false,
      	dropZone: $('#audio-dropzone'),
      	progress_bar_target: $('#audio-progress-case'),
      	additional_data: { "audio[majorpost_uuid]": $('#s3_uploader_audio').data('majorpost-uuid')},
    },"audio"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
  	$('#s3_uploader_audio').bind('s3_upload_failed', function(e, content) {
    	return alert(content.filename + ' failed to upload');
  	});	  
  	$('#s3_uploader_audio').bind('s3_uploads_start', function(e, content) {
    	$('#audio-embed-block').hide();
      $('#s3_direct_uploader_audio').removeClass('mb-20');
  	});	 
    $('#s3_uploader_audio').bind('s3_upload_complete', function(e, content) {
        $('#progress-words').html("Processing...meow");
    }); 
  //majorpost video uploader  
    $('#s3_uploader_video').S3Uploader(
      { 
        remove_completed_progress_bar: false,
        dropZone: $('#video-dropzone'),
        progress_bar_target: $('#video-progress-case'),
        additional_data: { "video[majorpost_uuid]": $('#s3_uploader_video').data('majorpost-uuid')},
    },"video"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
    $('#s3_uploader_video').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });   
    $('#s3_uploader_video').bind('s3_uploads_start', function(e, content) {
        $('#audio-embed-block').hide();
        $('#s3_direct_uploader_video').removeClass('mb-20');
        turn_lights_on('#above-blockui');
    });  
    $('#s3_uploader_video').bind('s3_upload_complete', function(e, content) {
        $('#progress-words').html("Processing...meow");
    });     	  		
}