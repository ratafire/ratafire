$(document).ready(function() {

    //publish-button
    $('#project-publish-button').click(function() {
        showConfirmDialog3();
        return false;
    });

    //Publish confirmation
    showConfirmDialog3 = function() {   
  		html = "<div id=\"dialog-confirm\" title=\"Confirmation\">\n  <p>" + "You are publishing this discussion on Ratafire. We will review it." + "</p>\n</div>";
  		return $(html).dialog({
    	resizable: false,
    	modal: true,
    	buttons: {
        	Cancel: function() {
        	return $(this).dialog("close");
      	},
      		OK: function() {
                $("#project-published").val("t");
                $("#project-edit-permission").val("edit");
                $("#project-form").submit();
        		return $(this).dialog("close");
      			}
    		}
  		});
	};  

    //Best_in_place in place editing & hover
    $('.best_in_place').best_in_place();//init
    $('.best_title').hover(function() {
    	$("#best_title-edit").toggle();
    });

				
});//end docuemnt ready				