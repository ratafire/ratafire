function initiate_profile_editor(){
	// Initialize select
	$(".simple-select").select2({
		minimumResultsForSearch: Infinity,
	});
	$(".simple-select-search").select2({
	});
	// Initialize Editor Tags
	$(".editor-tags").select2({
		containerCssClass : "form-detransparent",
	    width: '100%',
	    tags: []
	});
	// Initialize radio button
    $(".control").uniform({
        radioClass: 'choice',
        wrapperClass: 'border-blue text-blue'
    });	
}