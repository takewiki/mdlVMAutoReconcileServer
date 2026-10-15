#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param erp_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' AutoReconcileUpdateServer()
AutoReconcileUpdateServer <- function(input, output, session, dms_token, erp_token) {

  data_object = shiny::eventReactive(input$btn_AutoReconcile_view,{

    text_AutoReconcile_YearMonth = tsui::var_text("text_AutoReconcile_YearMonth")
    text_AutoReconcile_DeliveryLocation = tsui::var_text("text_AutoReconcile_DeliveryLocation")
    text_AutoReconcile_BillNo = tsui::var_text("text_AutoReconcile_BillNo")

    FYearMonth=text_AutoReconcile_YearMonth()
    FDeliveryLocation=text_AutoReconcile_DeliveryLocation()
    FBillNo=text_AutoReconcile_BillNo()


    data = mdlVMAutoReconcilePkg::AutoReconcile_view(erp_token = erp_token,FYearMonth = FYearMonth,FDeliveryLocation = FDeliveryLocation,FBillNo = FBillNo)

    return(data)
  })




  shiny::observeEvent(input$btn_AutoReconcile_view, {


    data = data_object()

    output$AutoReconcile_object_dt <- DT::renderDataTable(data,selection = 'single')

    tsui::run_download_xlsx(id = 'dl_AutoReconcile_view',data = data,filename='勾稽结果.xlsx')



  })




  #设置内容
  object_selected  <- reactive({

    shiny::validate(
      need(length(input$AutoReconcile_object_dt_rows_selected) > 0, "请从对照列表中选中任意一行")
    )
    data_detail <- data_object()


    FBillNo  <- data_detail[as.integer(input$AutoReconcile_object_dt_rows_selected), '出库单号']

    FSeq <- data_detail[as.integer(input$AutoReconcile_object_dt_rows_selected), '行号']

    res = data.frame(FBillNo,FSeq)



    return(res)

  })



  #手动勾稽
  text_AutoReconcile_InvoiceNo = tsui::var_text('text_AutoReconcile_InvoiceNo')

  shiny::observeEvent(input$btn_AutoReconcile_Operation,{

    FInvoiceNo = text_AutoReconcile_InvoiceNo()
    flag =input$AutoReconcile_object_dt_rows_selected


    print("----------flag-------")
    print(flag)

    if(is.null(flag)){

      tsui::pop_notice("请在列表中选中一行!")

    }else{

      data = object_selected()

      FBillNo =data$FBillNo
      FSeq = data$FSeq

      #更新销售出库摘要

      data1 = mdlVMAutoReconcilePkg::AutoReconcile_update(erp_token = erp_token,FBillNo = FBillNo,FNote =FInvoiceNo )

      data_res = mdlVMAutoReconcilePkg::AutoReconcile_res_select(erp_token = erp_token,FBillNo = FBillNo,FNote = FInvoiceNo,FSeq = FSeq)




      output$AutoReconcile_object_dt <- DT::renderDataTable(data_res,selection = 'single')



    }




  })










  #展开套件

  shiny::observeEvent(input$btn_AutoReconcile_IsExpandKit, {

  })


}




#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param erp_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' AutoReconcileServer()
AutoReconcileServer <- function(input, output, session, dms_token, erp_token) {



  AutoReconcileUpdateServer(input = input, output = output, session = session, dms_token = dms_token, erp_token = erp_token)
}
