#= require jquery-fileupload/basic
#= require jquery-fileupload/vendor/tmpl

$ = jQuery

$.fn.S3Uploader = (options,ratafire_file_type) ->

  # support multiple elements
  if @length > 1
    @each ->
      $(this).S3Uploader options

    return this

  $uploadForm = this

  settings =
    path: ''
    additional_data: null
    before_add: null
    dropZone: null
    remove_completed_progress_bar: true
    remove_failed_progress_bar: false
    progress_bar_target: null
    click_submit_target: null
    allow_multiple_files: true

  $.extend settings, options

  current_files = []
  forms_for_submit = []
  if settings.click_submit_target
    settings.click_submit_target.click ->
      form.submit() for form in forms_for_submit
      false

  setUploadForm = ->
    $uploadForm.fileupload

      add: (e, data) ->
        file = data.files[0]
        file.unique_id = Math.random().toString(36).substr(2,16)
        video_types = /(\.|\/)(avi|mp4|mov|mpeg4|m4v|wmv|flv|3gpp|webm)$/i
        image_types = /(\.|\/)(jpe?g|png|psd|bmp)$/i
        audio_types = /(\.|\/)(mp3)$/i
        pdf_types = /(\.|\/)(pdf)$/i
        zip_types = /(\.|\/)(zip)$/i
        file_name = /^[a-z\d\-_\s]+$/i
        if ratafire_file_type == "video" 
          this_type = video_types
        else 
          if ratafire_file_type == "artwork"
            this_type = image_types
          else
            if ratafire_file_type == "icon"
              this_type = image_types
            else
              if ratafire_file_type == "audio"
                this_type = audio_types
              else
                if ratafire_file_type == "pdf"
                  this_type = pdf_types
                else
                  if ratafire_file_type == "zip"
                    this_type = zip_types

        unless settings.before_add and not settings.before_add(file)
          unless file_name.test(file.name)
            current_files.push data
            if this_type.test(file.type) or this_type.test(file.name)
              if ratafire_file_type == "video"
                if $('#template-upload-video').length > 0
                  data.context = $($.trim(tmpl("template-upload-video", file)))
                  $(data.context).appendTo(settings.progress_bar_target || $uploadForm)
                else if !settings.allow_multiple_files
                  data.context = settings.progress_bar_target
                if settings.click_submit_target
                  if settings.allow_multiple_files
                   forms_for_submit.push data
                  else
                    forms_for_submit = [data]
                else
                  data.submit()
              else 
                if ratafire_file_type == "artwork"
                  if $('#template-upload-artwork').length > 0
                    data.context = $($.trim(tmpl("template-upload-artwork", file)))
                    $(data.context).appendTo(settings.progress_bar_target || $uploadForm)
                  else if !settings.allow_multiple_files
                    data.context = settings.progress_bar_target
                  if settings.click_submit_target
                    if settings.allow_multiple_files
                      forms_for_submit.push data
                    else
                     forms_for_submit = [data]
                  else
                    data.submit()   
                else
                  if ratafire_file_type == "icon"
                    if $('#template-upload-icon').length > 0   
                      data.context = $($.trim(tmpl("template-upload-icon", file)))  
                      $(data.context).appendTo(settings.progress_bar_target || $uploadForm)
                    else if !settings.allow_multiple_files
                      data.context = settings.progress_bar_target
                    if settings.click_submit_target
                      if settings.allow_multiple_files
                        forms_for_submit.push data
                      else
                      forms_for_submit = [data]
                    else
                      data.submit() 
                  else
                    if ratafire_file_type == "audio"
                      if $('#template-upload-audio').length > 0
                        data.context = $($.trim(tmpl("template-upload-audio", file))) 
                        $(data.context).appendTo(settings.progress_bar_target || $uploadForm)
                      else if !settings.allow_multiple_files
                        data.context = settings.progress_bar_target
                      if settings.click_submit_target
                        if settings.allow_multiple_files
                          forms_for_submit.push data
                        else
                        forms_for_submit = [data]
                      else
                        data.submit()  
                    else
                      if ratafire_file_type == "pdf"
                        if $('#template-upload-pdf').length > 0
                          data.context = $($.trim(tmpl("template-upload-pdf", file))) 
                          $(data.context).appendTo(settings.progress_bar_target || $uploadForm)
                        else if !settings.allow_multiple_files
                          data.context = settings.progress_bar_target
                        if settings.click_submit_target
                          if settings.allow_multiple_files
                            forms_for_submit.push data
                          else
                          forms_for_submit = [data]
                        else
                          data.submit()   
                      else
                        if ratafire_file_type == "zip"
                          if $('#template-upload-zip').length > 0
                            data.context = $($.trim(tmpl("template-upload-zip", file))) 
                            $(data.context).appendTo(settings.progress_bar_target || $uploadForm)
                          else if !settings.allow_multiple_files
                            data.context = settings.progress_bar_target
                          if settings.click_submit_target
                            if settings.allow_multiple_files
                              forms_for_submit.push data
                            else
                            forms_for_submit = [data]
                          else
                            data.submit()  
            else
              if ratafire_file_type == "video"
                alert "" + file.name + " is not a avi, mp4, m4v, mov, mpeg4, wmv, flv, 3gpp or a webm video file."
                return
              else 
                if ratafire_file_type == "artwork" || ratafire_file_type == "icon"
                  return
                  alert "" + file.name + " is not a jpg, png, bmp, or psd image file"
                else
                  if ratafire_file_type == "audio"
                    return
                    alert "" + file.name + " is not a mp3 file."
                  else
                    if ratafire_file_type == "pdf"
                      return
                      alert "" + file.name + " is not a pdf file."
                    else
                      if ratafire_file_type == "zip"
                        return
                        alert "" + file.name + " is not a zip file."
          else
            alert "Alphanumerics,-,_,and space only in filename." 
            return

      start: (e) ->
        $uploadForm.trigger("s3_uploads_start", [e])
        if ratafire_file_type == "video" 
          $("#video-upload-box").hide()
        else 
          if ratafire_file_type == "artwork"
            $("#artwork-upload-box").hide()
          else
            if ratafire_file_type == "audio"
              $("#audio-upload-box").hide()
            else
              if ratafire_file_type == "pdf"
                $("#pdf-upload-box").hide()
              else
                if ratafire_file_type == "zip"
                  $("#zip-upload-box").hide()

      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          if ratafire_file_type == "video"
            data.context.find('.bar-video').css('width', progress + '%')
          else 
            if ratafire_file_type == "artwork"
              data.context.find('.bar-artwork').css('width', progress + '%')
            else
              if ratafire_file_type == "icon"
                data.context.find('.bar-icon').css('width', progress + '%')
              else
                if ratafire_file_type == "audio"
                  data.context.find('.bar-audio').css('width', progress + '%')
                else
                  if ratafire_file_type == "pdf"
                    data.context.find('.bar-pdf').css('width', progress + '%')
                  else
                    if ratafire_file_type == "zip"
                      data.context.find('.bar-zip').css('width', progress + '%')

      done: (e, data) ->
        content = build_content_object $uploadForm, data.files[0], data.result

        callback_url = $uploadForm.data('callback-url')
        if callback_url
          content[$uploadForm.data('callback-param')] = content.url

          $.ajax
            type: $uploadForm.data('callback-method')
            url: callback_url
            data: content
            beforeSend: ( xhr, settings )       ->
              event = $.Event('ajax:beforeSend')
              $uploadForm.trigger(event, [xhr, settings])
              return event.result
            complete:   ( xhr, status )         ->
              event = $.Event('ajax:complete')
              $uploadForm.trigger(event, [xhr, status])
              return event.result
            success:    ( data, status, xhr )   ->
              event = $.Event('ajax:success')
              $uploadForm.trigger(event, [data, status, xhr])
              return event.result
            error:      ( xhr, status, error )  ->
              event = $.Event('ajax:error')
              $uploadForm.trigger(event, [xhr, status, error])
              return event.result

        data.context.remove() if data.context && settings.remove_completed_progress_bar # remove progress bar
        $uploadForm.trigger("s3_upload_complete", [content])

        current_files.splice($.inArray(data, current_files), 1) # remove that element from the array
        $uploadForm.trigger("s3_uploads_complete", [content]) unless current_files.length

      fail: (e, data) ->
        content = build_content_object $uploadForm, data.files[0], data.result
        content.error_thrown = data.errorThrown

        data.context.remove() if data.context && settings.remove_failed_progress_bar # remove progress bar
        $uploadForm.trigger("s3_upload_failed", [content])

      formData: (form) ->
        data = form.serializeArray()
        fileType = ""
        if "type" of @files[0]
          fileType = @files[0].type
        data.push
          name: "content-type"
          value: fileType

        key = $uploadForm.data("key")
          .replace('{timestamp}', new Date().getTime())
          .replace('{unique_id}', @files[0].unique_id)
          .replace('{extension}', @files[0].name.split('.').pop())

        # substitute upload timestamp and unique_id into key
        key_field = $.grep data, (n) ->
          n if n.name == "key"

        if key_field.length > 0
          key_field[0].value = settings.path + key

        # IE <= 9 doesn't have XHR2 hence it can't use formData
        # replace 'key' field to submit form
        unless 'FormData' of window
          $uploadForm.find("input[name='key']").val(settings.path + key)
        data

  build_content_object = ($uploadForm, file, result) ->
    content = {}
    if result # Use the S3 response to set the URL to avoid character encodings bugs
      content.url            = $(result).find("Location").text()
      content.filepath       = $('<a />').attr('href', content.url)[0].pathname
    else # IE <= 9 retu      rn a null result object so we use the file object instead
      domain                 = $uploadForm.attr('action')
      content.filepath       = $uploadForm.find('input[name=key]').val().replace('/${filename}', '')
      content.url            = domain + content.filepath + '/' + encodeURIComponent(file.name)

    content.filename         = file.name
    content.filesize         = file.size if 'size' of file
    content.lastModifiedDate = file.lastModifiedDate if 'lastModifiedDate' of file
    content.filetype         = file.type if 'type' of file
    content.unique_id        = file.unique_id if 'unique_id' of file
    content.relativePath     = build_relativePath(file) if has_relativePath(file)
    content = $.extend content, settings.additional_data if settings.additional_data
    content

  has_relativePath = (file) ->
    file.relativePath || file.webkitRelativePath

  build_relativePath = (file) ->
    file.relativePath || (file.webkitRelativePath.split("/")[0..-2].join("/") + "/" if file.webkitRelativePath)

  #public methods
  @initialize = ->
    # Save key for IE9 Fix
    $uploadForm.data("key", $uploadForm.find("input[name='key']").val())

    setUploadForm()
    this

  @path = (new_path) ->
    settings.path = new_path

  @additional_data = (new_data) ->
    settings.additional_data = new_data

  @initialize()
