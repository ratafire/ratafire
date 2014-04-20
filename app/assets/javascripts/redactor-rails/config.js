$(document).ready(mainActions);
$(document).on('ajaxify:content_loaded', function(){

  //alert("here");mainActions();alert("done")

});

  function mainActions(){
  var csrf_token = $('meta[name=csrf-token]').attr('content');
  var csrf_param = $('meta[name=csrf-param]').attr('content');
  var params;
  if (csrf_param !== undefined && csrf_token !== undefined) {
    params = csrf_param + "=" + encodeURIComponent(csrf_token);
  }
  //--- Comment ---
  $('#redactor_comment').redactor(
    {toolbarFixedBox: true,
      "imageUpload":"/redactor_rails/pictures?" + params,
      "imageGetJson":"/redactor_rails/pictures",
      "fileUpload":"/redactor_rails/documents?" + params,
      "fileGetJson":"/redactor_rails/documents",
      "path":"/assets/redactor-rails",
      "css":"style.css",
      plugins: ['fullscreen','quote','advanced'],
      minHeight: 111,
      buttons: ['formatting','unorderedlist', '|','bold', 'italic', 'deleted', '|', 'link','quote','code', 'equation', '|', 'image', '|' 
      ],
      buttonsCustom: {
        quote: {
          title: 'Quote',
          callback: formatQuote
        }

      } 

    } // end of redactor
  );

    $('#redactor_project_comment').redactor(
    {toolbarFixedBox: true,
      "imageUpload":"/redactor_rails/pictures?" + params,
      "imageGetJson":"/redactor_rails/pictures",
      "fileUpload":"/redactor_rails/documents?" + params,
      "fileGetJson":"/redactor_rails/documents",
      "path":"/assets/redactor-rails",
      "css":"style.css",
      plugins: ['fullscreen','quote','advanced'],
      minHeight: 111,
      buttons: ['formatting','unorderedlist', '|','bold', 'italic', 'deleted', '|', 'link','quote','code', 'equation', '|', 'image', '|' 
      ],
      buttonsCustom: {
        quote: {
          title: 'Quote',
          callback: formatQuote
        }

      } 

    } // end of redactor
  );

  //--- Majorpost ---
  $('#redactor_majorpost').redactor(
    { toolbarFixedBox: true,
      "imageUpload":"/redactor_rails/pictures?" + params,
      "imageGetJson":"/redactor_rails/pictures",
      "fileUpload":"/redactor_rails/documents?" + params,
      "fileGetJson":"/redactor_rails/documents",
      "path":"/assets/redactor-rails",
      "css":"style.css",
      plugins: ['fullscreen','quote','advanced'],
      minHeight: 430,
      buttons: ['formatting','unorderedlist', '|', 'bold', 'italic', 'deleted', '|', 'link','quote','code', 'equation', '|', 'image','painting', 'video2', '|' 
      ],
      buttonsCustom: {
        quote: {
          title: 'Quote',
          callback: formatQuote
        },
        painting: {
          title: 'Upload Artwork',
          callback: uploadOriginal
        },
        video2: {
          title: 'Video',
          callback: VideoCase
        },
      } 

    } // end of redactor
  );

}



// Quote ---------------------------------------------------------
function formatQuote(){
        this.bufferSet();

      if (this.opts.linebreaks === false)
      {
        this.selectionSave();

        var blocks = this.getBlocks();
        if (blocks)
        {
          $.each(blocks, $.proxy(function(i,s)
          {
            if (s.tagName === 'BLOCKQUOTE')
            {
              this.formatBlock('p', s, false);
            }
            else if (s.tagName !== 'LI')
            {
              this.formatBlock('blockquote', s, false);
            }

          }, this));
        }

        this.selectionRestore();
      }
      // linebreaks
      else
      {
        var block = this.getBlock();
        if (block.tagName === 'BLOCKQUOTE')
        {
          this.selectionSave();

          $(block).replaceWith($(block).html() + '<br>');

          this.selectionRestore();
        }
        else
        {
          var wrapper = this.selectionWrap('blockquote');
          var html = $(wrapper).html();

          var blocksElemsRemove = ['ul', 'ol', 'table', 'tr', 'tbody', 'thead', 'tfoot', 'dl'];
          $.each(blocksElemsRemove, function(i,s)
          {
            html = html.replace(new RegExp('<' + s + '(.*?)>', 'gi'), '');
            html = html.replace(new RegExp('</' + s + '>', 'gi'), '');
          });

          var blocksElems = this.opts.blockLevelElements;
          blocksElems.push('td');
          $.each(blocksElems, function(i,s)
          {
            html = html.replace(new RegExp('<' + s + '(.*?)>', 'gi'), '');
            html = html.replace(new RegExp('</' + s + '>', 'gi'), '<br>');
          });

          $(wrapper).html(html);
          this.selectionElement(wrapper);
          var next = $(wrapper).next();
          if (next[0].tagName === 'BR') next.remove();

        }
      }

      this.sync();
}// end of Quote --------------------------------------------------------


//Video ---------------------------------------------------
function VideoCase(){
    $('#image-case').hide();
    $('#original-placer').hide();
    $('#video-case').toggle();
}

//Original Image ------------------------------------------
    //Upload Original Image
function uploadOriginal(){
      $('#video-case').hide();
      $('#image-case').toggle();
      $('#original-placer').toggle();
    }