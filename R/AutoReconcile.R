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
#' AutoReconcileViewServer()
AutoReconcileViewServer <- function(input, output, session, dms_token, erp_token) {

  shiny::observeEvent(input$btn_AutoReconcile_view, {



    text_AutoReconcile_YearMonth = tsui::var_text("text_AutoReconcile_YearMonth")
    text_AutoReconcile_Customer = tsui::var_text("text_AutoReconcile_Customer")
    text_AutoReconcile_BillNo = tsui::var_text("text_AutoReconcile_BillNo")



    FYearMonth=text_AutoReconcile_YearMonth()
    FCustomer=text_AutoReconcile_Customer()
    FBillNo=text_AutoReconcile_BillNo()


    data = mdlVMAutoReconcilePkg::AutoReconcile_view(erp_token = erp_token,FYearMonth = FYearMonth,FCustomer = FCustomer,FBillNo = FBillNo)

    tsui::run_dataTable2(id = 'AutoReconcile_resultView',data = data)

    tsui::run_download_xlsx(id = 'dl_AutoReconcile_view',data = data,filename='勾稽结果.xlsx')



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
#' AutoReconcileUpdateServer()
AutoReconcileUpdateServer <- function(input, output, session, dms_token, erp_token) {

  #操作

  shiny::observeEvent(input$btn_AutoReconcile_Operation, {

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


  AutoReconcileViewServer(input = input, output = output, session = session, dms_token = dms_token, erp_token = erp_token)

  AutoReconcileUpdateServer(input = input, output = output, session = session, dms_token = dms_token, erp_token = erp_token)
}
