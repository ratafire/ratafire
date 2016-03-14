function initiate_profile_editor(){
	// Initialize select
	$(".simple-select").select2({
		minimumResultsForSearch: Infinity,
	});
	// Initialize Editor Tags
	$(".editor-tags").select2({
		containerCssClass : "form-detransparent",
	    width: '100%',
	    tags: []
	});

}