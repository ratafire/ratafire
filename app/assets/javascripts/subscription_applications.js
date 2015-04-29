$(document).ready(function() {
	//Goals
	$("#subscription_application_goals_back").click(function() {
		$("#step_id").val("NULL");
		$("#subscription_application_form").submit();
	});
	//Project
	$("#subscription_application_project_back").click(function() {
		$("#step_id").val("1");
		$("#subscription_application_form").submit();
	});	
	//Discussion
	$("#subscription_application_discussions_back").click(function() {
		$("#step_id").val("2");
		$("#subscription_application_form").submit();
	});		
	//Discussion
	$("#subscription_application_video_back").click(function() {
		$("#step_id").val("2");
		$("#subscription_application_form").submit();
	});		
	//Payments
	$("#subscription_application_payments_back").click(function() {
		$("#step_id").val("3");
		$("#subscription_application_form").submit();
	});	
	//Identification
	$("#subscription_application_identification_back").click(function() {
		$("#step_id").val("4");
		$("#subscription_application_form").submit();
	});	
	//Apply
	$("#subscription_application_apply_back").click(function() {
		$("#step_id").val("5");
		$("#subscription_application_form").submit();
	});		
});