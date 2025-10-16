# server.r - File tích hợp server

server <- function(input, output, session) {
  # Gọi module phân tích gộp (MA)
  ma_server_module(input, output, session)
  
  # Gọi module phân tích tổng hợp mạng lưới (NMA)
  nma_server_module(input, output, session)
  
  # Điều hướng giữa các tab NMA
  observeEvent(input$goto_nma_consistency, {
    updateTabItems(session, "sidebar", "nma_consistency")
  })
  
  observeEvent(input$goto_nma_ranking, {
    updateTabItems(session, "sidebar", "nma_ranking")
  })
  
  # Thêm xử lý cho trường hợp đặc biệt: khi một nghiên cứu chỉ có 2 nhóm
  observe({
    if (!is.null(input$nma_input_mode) && input$nma_input_mode == "flexible") {
      # Tạo vector study_arms động
      n_studies <- input$nma_study_count_flex
      if (!is.null(n_studies) && n_studies > 0) {
        # Kiểm tra xem tất cả các input cho số arms có tồn tại chưa
        all_inputs_exist <- TRUE
        for (i in 1:n_studies) {
          if (is.null(input[[paste0("nma_study_", i, "_arms")]])) {
            all_inputs_exist <- FALSE
            break
          }
        }
        
        # Nếu tất cả inputs tồn tại, tạo cảnh báo cho các nghiên cứu có < 2 arms
        if (all_inputs_exist) {
          invalid_studies <- c()
          for (i in 1:n_studies) {
            arms <- input[[paste0("nma_study_", i, "_arms")]]
            if (!is.na(arms) && arms < 2) {
              invalid_studies <- c(invalid_studies, i)
            }
          }
          
          if (length(invalid_studies) > 0) {
            showNotification(
              paste0("Nghiên cứu ", paste(invalid_studies, collapse=", "), 
                     " cần có ít nhất 2 nhóm. Đã tự động điều chỉnh."),
              type = "warning",
              duration = 5
            )
          }
        }
      }
    }
  })
}