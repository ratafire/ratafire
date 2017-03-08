function initiate_audio_editor_edit(){
	//Unblock submit 
	$('#audio-title, #audio-composer, #audio-artist, #audio-genre').on('keyup',function(){
  		if ($('#audio-title').val().length > 0 && $('#audio-composer').val().length > 0 && $('#audio-artist').val().length > 0 && $('#audio-genre').val().length > 0){
  			$('#editor-submition-block').unblock();
  		} else {
    		var data = $('#editor-submition-block').data();
    		if (data["blockUI.isBlocked"] == 0) {
				$('#editor-submition-block').block({message: null,overlayCSS: {
	            backgroundColor: '#fff',
	            opacity: 0.4,
	            cursor: 'not-allowed'
	        	},});
    		}
  		}
	});
    $('#video-title').on('keyup',function(){
        if ($('#video-title').val().length > 0 ){
            $('#editor-submition-block').unblock();
        } else {
            var data = $('#editor-submition-block').data();
            if (data["blockUI.isBlocked"] == 0) {
                $('#editor-submition-block').block({message: null,overlayCSS: {
                backgroundColor: '#fff',
                opacity: 0.4,
                cursor: 'not-allowed'
                },});
            }
        }
    });
	//Validate Title
    var validator = $("#text-editor-form").validate({
        ignore: 'input[type=hidden], .select2-input', // ignore hidden fields
        errorClass: 'validation-error-label',
        successClass: 'validation-valid-label',
        highlight: function(element, errorClass) {
            $(element).removeClass(errorClass);
        },
        unhighlight: function(element, errorClass) {
            $(element).removeClass(errorClass);
        },

        // Different components require proper error label placement
        errorPlacement: function(error, element) {

            // Styled checkboxes, radios, bootstrap switch
            if (element.parents('div').hasClass("checker") || element.parents('div').hasClass("choice") || element.parent().hasClass('bootstrap-switch-container') ) {
                if(element.parents('label').hasClass('checkbox-inline') || element.parents('label').hasClass('radio-inline')) {
                    error.appendTo( element.parent().parent().parent().parent() );
                }
                 else {
                    error.appendTo( element.parent().parent().parent().parent().parent() );
                }
            }

            // Unstyled checkboxes, radios
            else if (element.parents('div').hasClass('checkbox') || element.parents('div').hasClass('radio')) {
                error.appendTo( element.parent().parent().parent() );
            }

            // Input with icons
            else if (element.parents('div').hasClass('has-feedback')) {
                error.appendTo( element.parent() );
            }

            // Inline checkboxes, radios
            else if (element.parents('label').hasClass('checkbox-inline') || element.parents('label').hasClass('radio-inline')) {
                error.appendTo( element.parent().parent() );
            }

            // Input group, styled file input
            else if (element.parent().hasClass('uploader') || element.parents().hasClass('input-group')) {
                error.appendTo( element.parent().parent() );
            }
            else {
                error.insertAfter(element);
            }
        },
        validClass: "validation-valid-label",
        rules: {
            'majorpost[title]': "required",
            'majorpost[composer]':'required',
            'majorpost[artist]':'required',
            'majorpost[genre]':'required',
        }
    });	

}