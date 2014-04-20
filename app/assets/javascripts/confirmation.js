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
  var html, message;
  message = link.attr('data-confirm');
  html = "<div id=\"dialog-confirm\" title=\"Confirmation\">\n  <p>" + message + "</p>\n</div>";
  return $(html).dialog({
    resizable: false,
    modal: true,
    buttons: {
        Cancel: function() {
        return $(this).dialog("close");
      },
      OK: function() {
        confirmed(link);
        return $(this).dialog("close");
      }

    }
  });

};