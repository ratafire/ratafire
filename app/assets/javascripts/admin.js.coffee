jQuery ->
  $('#staffpicks').dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#staffpicks').data('source')