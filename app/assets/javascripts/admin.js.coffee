jQuery ->
  $('#users').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#users').data('source') 

  $('#staffpicks').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#staffpicks').data('source')

  $('#staffpicks_majorposts').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#staffpicks_majorposts').data('source')

   $('#deleted_project').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#deleted_project').data('source')   

   $('#deleted_majorpost').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#deleted_majorpost').data('source')   

  $('#deleted_comment').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#deleted_comment').data('source')   
    
  $('#deleted_project_comment').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#deleted_project_comment').data('source')    

  $('#test_projects').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#test_projects').data('source')

  $('#test_majorposts').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#test_majorposts').data('source')     

  $('#pending_discussions').dataTable
    sPaginationType: "full_numbers"
    #bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#pending_discussions').data('source')                        
    