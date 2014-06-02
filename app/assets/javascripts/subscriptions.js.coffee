jQuery ->
  $('#receiving_transactions').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#receiving_transactions').data('source')

  $('#paying_transactions').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#paying_transactions').data('source')    