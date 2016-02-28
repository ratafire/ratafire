function initiate_profilephoto_uploader(random_id){
  //majorpost video uploader  
    $('#s3_uploader_profilephoto').S3Uploader(
      { 
        remove_completed_progress_bar: false,
        dropZone: $('#profilephoto-dropzone'),
        progress_bar_target: $('#profilephoto-progress-case'),
        additional_data: { "profilephoto[user_uid]": $('#s3_uploader_profilephoto').data('user-uid')},
    },"artwork"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
    $('#s3_uploader_profilephoto').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });   
    $('#s3_uploader_profilephoto').bind('s3_uploads_start', function(e, content) {
    	$('.caption').hide();
        $('#cover-profilephoto-holder,#about-profilephoto-holder').block({
            message: '<i class="icon-spinner2 spinner text-blue"></i>',
            overlayCSS: {
            	backgroundColor: '#fff',
                opacity: 0.4,
                cursor: 'wait'
            },
            css: {
                border: 0,
                padding: 0,
                backgroundColor: 'transparent'
            }
        });  
    });  
}