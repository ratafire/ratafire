jQuery ->
  $('#applied_users').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#applied_users').data('source')

  $('#approved_users').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#approved_users').data('source')   

  $('#ignored_users').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#ignored_users').data('source')     