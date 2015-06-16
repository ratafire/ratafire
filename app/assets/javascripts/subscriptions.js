$(function() {
 	//project video uploader	
  	$('#s3_uploader_video').S3Uploader(
    	{ 
      		remove_completed_progress_bar: false,
      		progress_bar_target: $('#video-progress-case'),
      		dropZone: $('#nodropzone')
    	}
  		,"video"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
  	
  	$('#s3_uploader_video').bind('s3_upload_failed', function(e, content) {
    	return alert(content.filename + ' failed to upload');
  	});	
});	