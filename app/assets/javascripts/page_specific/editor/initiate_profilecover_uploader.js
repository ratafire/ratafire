function initiate_profilecover_uploader(random_id){
  //majorpost video uploader  
    $('#s3_uploader_profilecover').S3Uploader(
      { 
        remove_completed_progress_bar: false,
        dropZone: $('#profilecover-dropzone'),
        progress_bar_target: $('#profilecover-progress-case'),
        additional_data: { "profilecover[user_uid]": $('#s3_uploader_profilecover').data('user-uid')},
    },"artwork"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
    $('#s3_uploader_profilecover').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });   
    $('#s3_uploader_profilecover').bind('s3_uploads_start', function(e, content) {
        $('#fpc_content').block({
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