// assets/javascripts/documents.js

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

 	//project artwork uploader	
  $('#s3_uploader_artwork').S3Uploader(
    { 
      remove_completed_progress_bar: false,
      progress_bar_target: $('#artwork-progress-case'),
      dropZone: $('#nodropzone')
    }
  ,"artwork"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
  $('#s3_uploader_artwork').bind('s3_upload_failed', function(e, content) {
    return alert(content.filename + ' failed to upload');
  });

  //project icon uploader  
  $('#s3_uploader_icon').S3Uploader(
    { 
      remove_completed_progress_bar: false,
      progress_bar_target: $('#icon-progress-case'),
      dropZone: $('#nodropzone')
    }
  ,"icon"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
  $('#s3_uploader_icon').bind('s3_upload_failed', function(e, content) {
    return alert(content.filename + ' failed to upload');
  });  

  //project audio uploader  
  $('#s3_uploader_audio').S3Uploader(
    { 
      remove_completed_progress_bar: false,
      progress_bar_target: $('#audio-progress-case'),
      dropZone: $('#nodropzone')
    }
  ,"audio"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
  $('#s3_uploader_audio').bind('s3_upload_failed', function(e, content) {
    return alert(content.filename + ' failed to upload');
  });  

  //project pdf uploader  
  $('#s3_uploader_pdf').S3Uploader(
    { 
      remove_completed_progress_bar: false,
      progress_bar_target: $('#pdf-progress-case'),
      dropZone: $('#nodropzone')
    }
  ,"pdf"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
  $('#s3_uploader_pdf').bind('s3_upload_failed', function(e, content) {
    return alert(content.filename + ' failed to upload');
  });  

  $('#to-recommanded').click(function() {


    });

});