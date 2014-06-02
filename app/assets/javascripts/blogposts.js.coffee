jQuery ->
  $('#blogposts').dataTable
    sPaginationType: "full_numbers"
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#blogposts').data('source')