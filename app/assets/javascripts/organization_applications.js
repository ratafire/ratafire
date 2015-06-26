$(document).ready(function() {
	//Videos
	$("#organization_application_video_back").click(function() {
		$("#step_id").val("1");
		$("#organization_application_form").submit();
	});	
	//Payments
	$("#organization_application_payments_back").click(function() {
		$("#step_id").val("2");
		$("#organization_application_form").submit();
	});			
});