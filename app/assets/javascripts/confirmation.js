$.rails.allowAction = function(link) {
  if (!link.attr('data-confirm')) {
   return true;
  }
  showConfirmDialog(link);
  return false;
};

confirmed = function(link) {
  link.removeAttr('data-confirm');
  return link.trigger('click.rails');
};

showConfirmDialog = function(link) {
  var number, message;
  number = Math.floor((Math.random() * 1000) + 1);
  message = link.attr('data-confirm');
  $.magnificPopup.open({
    items: {
      src: '<div id="signup-popup" class="text-center"><div class="pb-15">'+ message + '</div><div class="btn bg-rainbow btn-float btn-float-lg btn-rounded '+number+'"><i class="ti-check"></i></div></div>',
      type: 'inline'
    }
  });  
  $('.'+number).click(function(){
    confirmed(link);
    $.magnificPopup.instance.close();
  });
};