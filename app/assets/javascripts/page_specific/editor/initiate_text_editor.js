function initiate_text_editor(upload_url,subscribe){
	//Initiate Editor
	var MyAnchorExtension = MediumEditor.extensions.anchor.extend({
	    formSaveLabel: '<span class="ti-check"></span>',
	    formCloseLabel: '<span class="ti-close"></span>',
	    contentDefault: '<i class="fi-link"></i>',
	});	
	var editor = new MediumEditor('.medium-editor-textarea',{
		disableDoubleReturn: true,
		disableExtraSpaces: true,
		targetBlank: true,
        toolbar: {
            buttons: [{
                    name: 'bold',
                    contentDefault: 'B'
                },{ 
                    name: 'italic',
                    contentDefault: 'i'
                },{ 
                    name: 'anchor',
                    contentDefault: '<i class="fi-link"></i>'
                },{
                    name: 'quote',
                    contentDefault: '<i class="fi-quote"></i>', 
                },{
                    name: 'h3',
                    contentDefault: 'H'
                }
            ]
        },
		extensions: {
		    'anchor': new MyAnchorExtension()
		},        
		anchor: {
		    /* These are the default options for anchor form,
		       if nothing is passed this is what it used */
		    linkValidation: true,
		    placeholderText: 'Paste or type a link',
		},
		autoLink: true,
		imageDragging: false,        		
	});
	if (subscribe){
		editor.subscribe('editableInput', function (event, editable) {
	    	// Do some work
	    	if ($('#majorpost_content_textarea').val().length > 37){
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
	}
	$('.medium-editor-textarea').mediumInsert({
	    editor: editor, // (MediumEditor) Instance of MediumEditor
	    enabled: true, // (boolean) If the plugin is enabled
	    addons: { // (object) Addons configuration
	        images: { // (object) Image addon configuration
	            label: '<span class="fa fa-camera"></span>', // (string) A label for an image addon
		        uploadCompleted: function ($el, data) {
		        	var imageId = data.result.files[0].id;
		        	this.deleteScript = '/content/artworks/' + imageId;
		        	$('#editor-submition-block').unblock();
		        },
	            deleteMethod: 'DELETE',
	            fileDeleteOptions: {}, // (object) extra parameters send on the delete ajax request, see http://api.jquery.com/jquery.ajax/
	            preview: true, // (boolean) Show an image before it is uploaded (only in browsers that support this feature)
	            captions: false, // (boolean) Enable captions
	            captionPlaceholder: 'Type caption for image (optional)', // (string) Caption placeholder
	            autoGrid: 3, // (integer) Min number of images that automatically form a grid
	            fileUploadOptions: { // (object) File upload configuration. See https://github.com/blueimp/jQuery-File-Upload/wiki/Options
	                paramName: 'artwork[image]',
	                url: upload_url, // (string) A relative path to an upload script
	                acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i, // (regexp) Regexp of accepted file types
					change: function (e, data) {
				        $.each(data.files, function (index, file) {
							$('#editor-submition-block').block({message: null,
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
									},
								});
				        });
				    }
	            },
	            styles: { // (object) Available embeds styles configuration
	            },
	            actions: { // (object) Actions for an optional second toolbar
	                remove: { // (object) Remove action configuration
	                    label: '<span class="ti-close"></span>', // (string) Label for an action
	                    clicked: function ($el) { // (function) Callback function called when an action is selected
	                        var $event = $.Event('keydown');

	                        $event.which = 8;
	                        $(document).trigger($event);   
	                    }
	                }
	            }    
	        },	   	
	        embeds: { // (object) Embeds addon configuration
	            label: '<span class="fa fa-youtube-play"></span>', // (string) A label for an embeds addon
	            placeholder: 'Paste a YouTube, Vimeo, Facebook, Twitter or Instagram link and press Enter', // (string) Placeholder displayed when entering URL to embed
	            captions: false, // (boolean) Enable captions
	            captionPlaceholder: 'Type caption (optional)', // (string) Caption placeholder
	            oembedProxy: '//iframe.ly/api/oembed?api_key=12bc2af7bd7aa88c092437', // (string/null) URL to oEmbed proxy endpoint, such as Iframely, Embedly or your own. You are welcome to use "http://medium.iframe.ly/api/oembed?iframe=1" for your dev and testing needs, courtesy of Iframely. *Null* will make the plugin use pre-defined set of embed rules without making server calls.
	            styles: { // (object) Available embeds styles configuration
	            },
	            actions: { // (object) Actions for an optional second toolbar
	                remove: { // (object) Remove action configuration
	                    label: '<span class="ti-close"></span>', // (string) Label for an action
	                    clicked: function ($el) { // (function) Callback function called when an action is selected
	                        var $event = $.Event('keydown');

	                        $event.which = 8;
	                        $(document).trigger($event);   
	                    }
	                }
	            }   
	        },	        
	    }   
	});
	// Initialize Editor Tags
	$("select.editor-tags").select2({
	    width: '100%',
	    tags: []
	});

	$(".select2-drop").addClass('select2-editor-tags');	
}
