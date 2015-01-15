$(function() {

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

  //Tutorial
  //Tutorial Step 1
  $('#profile-tutorial-step1').on('mouseover', function (){
    $("#tutorial-fog").hide("fade", {}, 500);
    $("#profile-tutorial-step1").hide("fade", {}, 1000);
    $("#profile-totorial-dialog1").hide("fade", {}, 1000);
    $("#profile-tutorial-step1-link")[0].click();
  });

  //Tutorial Step 2
  $("#profile-name-background").click(function (){
    $("#profile-totorial-dialog2").hide("fade", {}, 1000);
    $("#profile-tutorial-step2-link")[0].click();
  });

  //Tutorial Step 3
  $("#edit-profile-photo").on("mouseover", function(){
    $("#profile-tutorial-step3").hide("fade", {}, 1000);
    $("#profile-totorial-dialog3").show("fade", {}, 1000);
  });

  $("#edit-profile-photo").click(function (){
    $("#profile-totorial-dialog3").hide("fade", {}, 1000);
    $("#profile-tutorial-step3-link")[0].click();
  });

  //Tutorial Step 4
  $("#profile-tutorial-step4").on("mouseover", function(){
    $("#profile-tutorial-step4").hide("fade", {}, 1000);
    $("#profile-totorial-dialog4").show("fade", {}, 1000);
  });

  $("#bio-edit-case").click(function (){
    $("#profile-totorial-dialog4").hide("fade", {}, 1000);
    $("#profile-tutorial-step4-link")[0].click();
  });

  //Sidebar Profile Create Button
      $("#sidebar-profile-create-button").hover(
          function () {
            $('#sidebar-profile-slide-down').slideDown('medium');
            $("#sidebar-profile-create-button-main").addClass("btn-medium-darkblue");
            $("#sidebar-profile-create-button-main").removeClass("btn-medium-white");   
          }, 
          function () {
            $('#sidebar-profile-slide-down').slideUp('medium');
            $("#sidebar-profile-create-button-main").addClass("btn-medium-white");
            $("#sidebar-profile-create-button-main").removeClass("btn-medium-darkblue");               
          }
      );
      $("#sidebar-profile-create-project").hover(
          function (){
            $("#sidebar-profile-create-project").addClass("btn-sidebar-profile-active");
            $("#sidebar-profile-create-discussion").removeClass("btn-sidebar-profile-active");
          }      
        );
      $("#sidebar-profile-create-discussion").hover(
          function (){
            $("#sidebar-profile-create-discussion").addClass("btn-sidebar-profile-active");
            $("#sidebar-profile-create-project").removeClass("btn-sidebar-profile-active");
          }      
        );
      $("#sidebar-profile-create-project").click(function (){
        $("#sidebar-profile-create-button-main")[0].click();
      });
});	