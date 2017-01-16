var $;

$ = jQuery;

$.fn.S3Uploader = function(options, ratafire_file_type) {
  var $uploadForm, build_content_object, build_relativePath, current_files, forms_for_submit, has_relativePath, setUploadForm, settings;
  if (this.length > 1) {
    this.each(function() {
      return $(this).S3Uploader(options);
    });
    return this;
  }
  $uploadForm = this;
  settings = {
    path: '',
    additional_data: null,
    before_add: null,
    dropZone: null,
    remove_completed_progress_bar: true,
    remove_failed_progress_bar: false,
    progress_bar_target: null,
    click_submit_target: null,
    allow_multiple_files: true
  };
  $.extend(settings, options);
  current_files = [];
  forms_for_submit = [];
  if (settings.click_submit_target) {
    settings.click_submit_target.click(function() {
      var form, i, len;
      for (i = 0, len = forms_for_submit.length; i < len; i++) {
        form = forms_for_submit[i];
        form.submit();
      }
      return false;
    });
  }
  setUploadForm = function() {
    return $uploadForm.fileupload({
      add: function(e, data) {
        var audio_types, file, file_name, image_types, pdf_types, this_type, video_types, zip_types;
        file = data.files[0];
        file.unique_id = Math.random().toString(36).substr(2, 16);
        video_types = /(\.|\/)(avi|mp4|mov|mpeg4|m4v|wmv|flv|3gpp|webm)$/i;
        image_types = /(\.|\/)(jpe?g|png|psd|bmp)$/i;
        audio_types = /(\.|\/)(mp3)$/i;
        pdf_types = /(\.|\/)(pdf)$/i;
        zip_types = /(\.|\/)(zip)$/i;
        file_name = /^[a-z\d\-_\s]+$/i;
        if (ratafire_file_type === "video") {
          this_type = video_types;
        } else {
          if (ratafire_file_type === "artwork") {
            this_type = image_types;
          } else {
            if (ratafire_file_type === "icon") {
              this_type = image_types;
            } else {
              if (ratafire_file_type === "audio") {
                this_type = audio_types;
              } else {
                if (ratafire_file_type === "pdf") {
                  this_type = pdf_types;
                } else {
                  if (ratafire_file_type === "zip") {
                    this_type = zip_types;
                  }
                }
              }
            }
          }
        }
        if (!(settings.before_add && !settings.before_add(file))) {
          if (!file_name.test(file.name)) {
            current_files.push(data);
            if (this_type.test(file.type) || this_type.test(file.name)) {
              if (ratafire_file_type === "video") {
                if ($('#template-upload-video').length > 0) {
                  data.context = $($.trim(tmpl("template-upload-video", file)));
                  $(data.context).appendTo(settings.progress_bar_target || $uploadForm);
                } else if (!settings.allow_multiple_files) {
                  data.context = settings.progress_bar_target;
                }
                if (settings.click_submit_target) {
                  if (settings.allow_multiple_files) {
                    return forms_for_submit.push(data);
                  } else {
                    return forms_for_submit = [data];
                  }
                } else {
                  return data.submit();
                }
              } else {
                if (ratafire_file_type === "artwork") {
                  if ($('#template-upload-artwork').length > 0) {
                    data.context = $($.trim(tmpl("template-upload-artwork", file)));
                    $(data.context).appendTo(settings.progress_bar_target || $uploadForm);
                  } else if (!settings.allow_multiple_files) {
                    data.context = settings.progress_bar_target;
                  }
                  if (settings.click_submit_target) {
                    if (settings.allow_multiple_files) {
                      return forms_for_submit.push(data);
                    } else {
                      return forms_for_submit = [data];
                    }
                  } else {
                    return data.submit();
                  }
                } else {
                  if (ratafire_file_type === "icon") {
                    if ($('#template-upload-icon').length > 0) {
                      data.context = $($.trim(tmpl("template-upload-icon", file)));
                      $(data.context).appendTo(settings.progress_bar_target || $uploadForm);
                    } else if (!settings.allow_multiple_files) {
                      data.context = settings.progress_bar_target;
                    }
                    if (settings.click_submit_target) {
                      if (settings.allow_multiple_files) {
                        forms_for_submit.push(data);
                      } else {

                      }
                      return forms_for_submit = [data];
                    } else {
                      return data.submit();
                    }
                  } else {
                    if (ratafire_file_type === "audio") {
                      if ($('#template-upload-audio').length > 0) {
                        data.context = $($.trim(tmpl("template-upload-audio", file)));
                        $(data.context).appendTo(settings.progress_bar_target || $uploadForm);
                      } else if (!settings.allow_multiple_files) {
                        data.context = settings.progress_bar_target;
                      }
                      if (settings.click_submit_target) {
                        if (settings.allow_multiple_files) {
                          forms_for_submit.push(data);
                        } else {

                        }
                        return forms_for_submit = [data];
                      } else {
                        return data.submit();
                      }
                    } else {
                      if (ratafire_file_type === "pdf") {
                        if ($('#template-upload-pdf').length > 0) {
                          data.context = $($.trim(tmpl("template-upload-pdf", file)));
                          $(data.context).appendTo(settings.progress_bar_target || $uploadForm);
                        } else if (!settings.allow_multiple_files) {
                          data.context = settings.progress_bar_target;
                        }
                        if (settings.click_submit_target) {
                          if (settings.allow_multiple_files) {
                            forms_for_submit.push(data);
                          } else {

                          }
                          return forms_for_submit = [data];
                        } else {
                          return data.submit();
                        }
                      } else {
                        if (ratafire_file_type === "zip") {
                          if ($('#template-upload-zip').length > 0) {
                            data.context = $($.trim(tmpl("template-upload-zip", file)));
                            $(data.context).appendTo(settings.progress_bar_target || $uploadForm);
                          } else if (!settings.allow_multiple_files) {
                            data.context = settings.progress_bar_target;
                          }
                          if (settings.click_submit_target) {
                            if (settings.allow_multiple_files) {
                              forms_for_submit.push(data);
                            } else {

                            }
                            return forms_for_submit = [data];
                          } else {
                            return data.submit();
                          }
                        }
                      }
                    }
                  }
                }
              }
            } else {
              if (ratafire_file_type === "video") {
                alert("" + file.name + " is not a avi, mp4, m4v, mov, mpeg4, wmv, flv, 3gpp or a webm video file.");
              } else {
                if (ratafire_file_type === "artwork" || ratafire_file_type === "icon") {
                  return;
                  return alert("" + file.name + " is not a jpg, png, bmp, or psd image file");
                } else {
                  if (ratafire_file_type === "audio") {
                    return;
                    return alert("" + file.name + " is not a mp3 file.");
                  } else {
                    if (ratafire_file_type === "pdf") {
                      return;
                      return alert("" + file.name + " is not a pdf file.");
                    } else {
                      if (ratafire_file_type === "zip") {
                        return;
                        return alert("" + file.name + " is not a zip file.");
                      }
                    }
                  }
                }
              }
            }
          } else {
            alert("Alphanumerics,-,_,and space only in filename.");
          }
        }
      },
      start: function(e) {
        $uploadForm.trigger("s3_uploads_start", [e]);
        if (ratafire_file_type === "video") {
          return $("#video-upload-box").hide();
        } else {
          if (ratafire_file_type === "artwork") {
            return $("#artwork-upload-box").hide();
          } else {
            if (ratafire_file_type === "audio") {
              return $("#audio-upload-box").hide();
            } else {
              if (ratafire_file_type === "pdf") {
                return $("#pdf-upload-box").hide();
              } else {
                if (ratafire_file_type === "zip") {
                  return $("#zip-upload-box").hide();
                }
              }
            }
          }
        }
      },
      progress: function(e, data) {
        var progress;
        if (data.context) {
          progress = parseInt(data.loaded / data.total * 100, 10);
          if (ratafire_file_type === "video") {
            return data.context.find('.bar-video').css('width', progress + '%');
          } else {
            if (ratafire_file_type === "artwork") {
              return data.context.find('.bar-artwork').css('width', progress + '%');
            } else {
              if (ratafire_file_type === "icon") {
                return data.context.find('.bar-icon').css('width', progress + '%');
              } else {
                if (ratafire_file_type === "audio") {
                  return data.context.find('.bar-audio').css('width', progress + '%');
                } else {
                  if (ratafire_file_type === "pdf") {
                    return data.context.find('.bar-pdf').css('width', progress + '%');
                  } else {
                    if (ratafire_file_type === "zip") {
                      return data.context.find('.bar-zip').css('width', progress + '%');
                    }
                  }
                }
              }
            }
          }
        }
      },
      done: function(e, data) {
        var callback_url, content;
        content = build_content_object($uploadForm, data.files[0], data.result);
        callback_url = $uploadForm.data('callback-url');
        if (callback_url) {
          content[$uploadForm.data('callback-param')] = content.url;
          $.ajax({
            type: $uploadForm.data('callback-method'),
            url: callback_url,
            data: content,
            beforeSend: function(xhr, settings) {
              var event;
              event = $.Event('ajax:beforeSend');
              $uploadForm.trigger(event, [xhr, settings]);
              return event.result;
            },
            complete: function(xhr, status) {
              var event;
              event = $.Event('ajax:complete');
              $uploadForm.trigger(event, [xhr, status]);
              return event.result;
            },
            success: function(data, status, xhr) {
              var event;
              event = $.Event('ajax:success');
              $uploadForm.trigger(event, [data, status, xhr]);
              return event.result;
            },
            error: function(xhr, status, error) {
              var event;
              event = $.Event('ajax:error');
              $uploadForm.trigger(event, [xhr, status, error]);
              return event.result;
            }
          });
        }
        if (data.context && settings.remove_completed_progress_bar) {
          data.context.remove();
        }
        $uploadForm.trigger("s3_upload_complete", [content]);
        current_files.splice($.inArray(data, current_files), 1);
        if (!current_files.length) {
          return $uploadForm.trigger("s3_uploads_complete", [content]);
        }
      },
      fail: function(e, data) {
        var content;
        content = build_content_object($uploadForm, data.files[0], data.result);
        content.error_thrown = data.errorThrown;
        if (data.context && settings.remove_failed_progress_bar) {
          data.context.remove();
        }
        return $uploadForm.trigger("s3_upload_failed", [content]);
      },
      formData: function(form) {
        var data, fileType, key, key_field;
        data = form.serializeArray();
        fileType = "";
        if ("type" in this.files[0]) {
          fileType = this.files[0].type;
        }
        data.push({
          name: "content-type",
          value: fileType
        });
        key = $uploadForm.data("key").replace('{timestamp}', new Date().getTime()).replace('{unique_id}', this.files[0].unique_id).replace('{extension}', this.files[0].name.split('.').pop());
        key_field = $.grep(data, function(n) {
          if (n.name === "key") {
            return n;
          }
        });
        if (key_field.length > 0) {
          key_field[0].value = settings.path + key;
        }
        if (!('FormData' in window)) {
          $uploadForm.find("input[name='key']").val(settings.path + key);
        }
        return data;
      }
    });
  };
  build_content_object = function($uploadForm, file, result) {
    var content, domain;
    content = {};
    if (result) {
      content.url = $(result).find("Location").text();
      content.filepath = $('<a />').attr('href', content.url)[0].pathname;
    } else {
      domain = $uploadForm.attr('action');
      content.filepath = $uploadForm.find('input[name=key]').val().replace('/${filename}', '');
      content.url = domain + content.filepath + '/' + encodeURIComponent(file.name);
    }
    content.filename = file.name;
    if ('size' in file) {
      content.filesize = file.size;
    }
    if ('lastModifiedDate' in file) {
      content.lastModifiedDate = file.lastModifiedDate;
    }
    if ('type' in file) {
      content.filetype = file.type;
    }
    if ('unique_id' in file) {
      content.unique_id = file.unique_id;
    }
    if (has_relativePath(file)) {
      content.relativePath = build_relativePath(file);
    }
    if (settings.additional_data) {
      content = $.extend(content, settings.additional_data);
    }
    return content;
  };
  has_relativePath = function(file) {
    return file.relativePath || file.webkitRelativePath;
  };
  build_relativePath = function(file) {
    return file.relativePath || (file.webkitRelativePath ? file.webkitRelativePath.split("/").slice(0, -1).join("/") + "/" : void 0);
  };
  this.initialize = function() {
    $uploadForm.data("key", $uploadForm.find("input[name='key']").val());
    setUploadForm();
    return this;
  };
  this.path = function(new_path) {
    return settings.path = new_path;
  };
  this.additional_data = function(new_data) {
    return settings.additional_data = new_data;
  };
  return this.initialize();
};

// ---
// generated by coffee-script 1.9.2
