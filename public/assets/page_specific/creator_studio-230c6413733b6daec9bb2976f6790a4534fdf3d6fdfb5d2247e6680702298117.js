function initiate_plugins(random_id){
    // Initialize lightbox
    $('[data-popup="lightbox"]').fancybox({
        padding: 3
    });    
    //Clipboard
    new Clipboard('a');    
    //Switchery
    var elem2s = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));

    elem2s.forEach(function(html) {
      var switchery2 = new Switchery(html);
    });
    //Dropdown    
    $('.dropdown-toggle').dropdown();
	// Popover
    $('[data-popup="popover"]').popover();
    // Tooltip
    $('[data-popup="tooltip"]').tooltip();
    // Photoset
    $('.photoset-grid-lightbox').photosetGrid({
        highresLinks: true,
        rel: 'withhearts-gallery',
        gutter: '2px',
    onComplete: function(){
        $('.photoset-grid-lightbox').attr('style', '');
        $('.photoset-grid-lightbox a').colorbox({
            photo: true,
            scalePhotos: true,
            maxHeight:'90%',
            maxWidth:'90%'
            });
        }
    });
    //Update Videojs to show video
    $('.'+random_id).each(function() {
        videojs(this.id, {}, function(){
        // Player (this) is initialized and ready.
        });
    });        
    // Initialize Popup
    $('.open-popup-link').magnificPopup({type:'inline'});  
    // Sticky
    $("#sticker").sticky({topSpacing:0}); 
    // Resize sidebar to window height
    $('#sidebar-content').height($( window ).height());
    // Initiate Pagination
    if ($('.pagination').length) {
      $(window).scroll(function() {
        var url;
        url = $('.pagination .next_page').attr('href');
        if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
          $('.pagination').html("<i class=\"icon-spinner2 spinner text-blue\"></i>");
          return $.getScript(url);
        }
      });
      return $(window).scroll();
    }     
}
;
function refreshUsercard(popupclass){
    //Usercard
    var timer;
    $('.'+popupclass).popover({ 
        trigger: "manual" , 
        html: true, 
        animation:false,
        template:'<div class="popover"><div class="popover-content"></div><div class="usercard-profile"></div><div class="arrow"></div></div>'
    })
        .on("mouseenter",function(){
            $('.popover').hide();
            clearTimeout(timer);
            var that = this,
                timer = setTimeout(function() {
                    if($(that).is(':hover'))
                    {
                            user_uid = $(that).data("id"),
                        usercard_url = "/usercard/"+user_uid+"/profile";      
                        $.ajax({
                            url: usercard_url
                        });
                        $(that).popover("show");
                    }
                }, 400);
            $(".popover").on("mouseleave", function () {
                clearTimeout(timer);
                $('.popover').hide();
                $(that).popover('hide');
            });
        }).on("mouseleave",function () {
            var that = this;
            setTimeout(function () {
                if (!$(".popover:hover").length) {
                    clearTimeout(timer);
                    $('.popover').hide();
                    $(that).popover("hide");
                }
            }, 300);
        });  	
}
;
function turn_lights_off(block_id){
	$(block_id).addClass('above-blockui');
	$('.outer-space').block({
		message: null,
		overlayCSS: {
			cursor: 'default'
		}
	});	
}
function turn_lights_on(block_id){
	$('.outer-space').unblock();
	$(block_id).removeClass('above-blockui');
}
;
function initiate_audio_editor(){
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
    var validator = $("#audio-editor-form").validate({
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
;
function hide_editor_options(random_id){
	//Hide editor options
	$('#editor-options-holder').hide();
	//Move the editor to top
	$('#editor-holder').velocity('scroll',{
		duration:500,
		offset:-80,
		easing:'ease-in-out'
	});	
}

function initiate_editor(upload_url){
  
	//Block ui
	$('.fa-lightbulb-o').on('click', function(){
		return (this.tog = !this.tog) ? turn_lights_on('#above-blockui') : turn_lights_off('#above-blockui');
	});
	$('#editor-submition-block').block({message: null,overlayCSS: {
                backgroundColor: '#fff',
                opacity: 0.4,
                cursor: 'not-allowed'
            },});
	// Tooltip
	$('[data-popup="tooltip"]').tooltip();	
  	  		
}
;
function initiate_link_editor(){
    $('form input').on('keypress', function(e) {
        return e.which !== 13;
    });
	$('#link-url-input').donetyping(function(){
  		$('#link-form').submit();
	});
    var validator = $("#link-form").validate({
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
            'link[url]': {
                url: true
            },
        }
    });
}

(function($){
    $.fn.extend({
        donetyping: function(callback,timeout){
            timeout = timeout || 1e3; // 1 second default timeout
            var timeoutReference,
                doneTyping = function(el){
                    if (!timeoutReference) return;
                    timeoutReference = null;
                    callback.call(el);
                };
            return this.each(function(i,el){
                var $el = $(el);
                // Chrome Fix (Use keyup over keypress to detect backspace)
                // thank you @palerdot
                $el.is(':input') && $el.on('keyup keypress paste',function(e){
                    // This catches the backspace button in chrome, but also prevents
                    // the event from triggering too preemptively. Without this line,
                    // using tab/shift+tab will make the focused element fire the callback.
                    if (e.type=='keyup' && e.keyCode!=8) return;
                    
                    // Check if timeout has been set. If it has, "reset" the clock and
                    // start over again.
                    if (timeoutReference) clearTimeout(timeoutReference);
                    timeoutReference = setTimeout(function(){
                        // if we made it here, our timeout has elapsed. Fire the
                        // callback
                        doneTyping(el);
                    }, timeout);
                }).on('blur',function(){
                    // If we can, fire the event since we're leaving the field
                    doneTyping(el);
                });
            });
        }
    });
})(jQuery);

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
;
function initiate_profilecover_uploader(random_id){
  //majorpost video uploader  
    $('#s3_uploader_profilecover').S3Uploader(
      { 
        remove_completed_progress_bar: false,
        dropZone: $('#profilecover-dropzone'),
        progress_bar_target: $('#profilecover-progress-case'),
        additional_data: { "profilecover[user_uid]": $('#s3_uploader_profilecover').data('user-uid')},
    },"artwork"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
    $('#s3_uploader_profilecover').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });   
    $('#s3_uploader_profilecover').bind('s3_uploads_start', function(e, content) {
        $('#fpc_content').block({
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
            }
        });  
    });  
}
;
function initiate_profilephoto_uploader(random_id){
  //majorpost video uploader  
    $('#s3_uploader_profilephoto').S3Uploader(
      { 
        remove_completed_progress_bar: false,
        dropZone: $('#profilephoto-dropzone'),
        progress_bar_target: $('#profilephoto-progress-case'),
        additional_data: { "profilephoto[user_uid]": $('#s3_uploader_profilephoto').data('user-uid')},
    },"artwork"); //ratafire_file_type,content_temp_value,content_temp_video_value,tags_temp_video_value
    $('#s3_uploader_profilephoto').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });   
    $('#s3_uploader_profilephoto').bind('s3_uploads_start', function(e, content) {
    	$('.caption').hide();
        $('#cover-profilephoto-holder,#about-profilephoto-holder').block({
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
            }
        });  
    });  
}
;
function initiate_soundcloud_editor(){
    $('form input').on('keypress', function(e) {
        return e.which !== 13;
    });
	$('#soundcloud-url-input').donetyping(function(){
  		$('#soundcloud-form').submit();
	});
}

(function($){
    $.fn.extend({
        donetyping: function(callback,timeout){
            timeout = timeout || 1e3; // 1 second default timeout
            var timeoutReference,
                doneTyping = function(el){
                    if (!timeoutReference) return;
                    timeoutReference = null;
                    callback.call(el);
                };
            return this.each(function(i,el){
                var $el = $(el);
                // Chrome Fix (Use keyup over keypress to detect backspace)
                // thank you @palerdot
                $el.is(':input') && $el.on('keyup keypress paste',function(e){
                    // This catches the backspace button in chrome, but also prevents
                    // the event from triggering too preemptively. Without this line,
                    // using tab/shift+tab will make the focused element fire the callback.
                    if (e.type=='keyup' && e.keyCode!=8) return;
                    
                    // Check if timeout has been set. If it has, "reset" the clock and
                    // start over again.
                    if (timeoutReference) clearTimeout(timeoutReference);
                    timeoutReference = setTimeout(function(){
                        // if we made it here, our timeout has elapsed. Fire the
                        // callback
                        doneTyping(el);
                    }, timeout);
                }).on('blur',function(){
                    // If we can, fire the event since we're leaving the field
                    doneTyping(el);
                });
            });
        }
    });
})(jQuery);

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
	            oembedProxy: 'http://medium.iframe.ly/api/oembed?iframe=1', // (string/null) URL to oEmbed proxy endpoint, such as Iframely, Embedly or your own. You are welcome to use "http://medium.iframe.ly/api/oembed?iframe=1" for your dev and testing needs, courtesy of Iframely. *Null* will make the plugin use pre-defined set of embed rules without making server calls.
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
	$(".editor-tags").select2({
	    width: '100%',
	    tags: []
	});

	$(".select2-drop").addClass('select2-editor-tags');	
}
;



