# metahealth_part4_nma.r - Logic xử lý phân tích tổng hợp mạng lưới NMA

# Hàm module cho phân tích tổng hợp mạng lưới (NMA)
nma_server_module <- function(input, output, session) {
  # Hàm tính P-scores thủ công khi netrank() không hoạt động
  calculate_p_scores <- function(res, small.values = "bad") {
    # Kiểm tra đầu vào
    if (!inherits(res, "netmeta")) {
      stop("Đối tượng đầu vào không phải là netmeta")
    }
    
    # Lấy ma trận hiệu ứng và sai số chuẩn
    TE <- res$TE.random
    seTE <- res$seTE.random
    
    # Kiểm tra ma trận có phải là numeric không
    if (!is.numeric(TE) || !is.numeric(seTE)) {
      # Chuyển đổi sang numeric nếu cần
      TE <- matrix(as.numeric(TE), nrow = nrow(TE))
      seTE <- matrix(as.numeric(seTE), nrow = nrow(seTE))
      
      # Đảm bảo tên được giữ nguyên
      dimnames(TE) <- dimnames(res$TE.random)
      dimnames(seTE) <- dimnames(res$seTE.random)
    }
    
    # Lấy tên các điều trị
    trts <- res$trts
    n_trts <- length(trts)
    
    # Khởi tạo mảng p_scores
    p_scores <- numeric(n_trts)
    names(p_scores) <- trts
    
    # Tính P-scores
    for (i in 1:n_trts) {
      p_sum <- 0
      count <- 0
      
      for (j in 1:n_trts) {
        if (i != j) {
          # Bỏ qua các giá trị NA
          if (!is.na(TE[i,j]) && !is.na(seTE[i,j]) && seTE[i,j] > 0) {
            # Điều trị i tốt hơn j nếu:
            # - small.values = "bad": TE[i,j] > 0
            # - small.values = "good": TE[i,j] < 0
            if (small.values == "bad") {
              p <- pnorm(as.numeric(TE[i,j]) / as.numeric(seTE[i,j]))
            } else {
              p <- pnorm(-as.numeric(TE[i,j]) / as.numeric(seTE[i,j]))
            }
            p_sum <- p_sum + p
            count <- count + 1
          }
        }
      }
      
      if (count > 0) {
        p_scores[i] <- p_sum / count # Trung bình xác suất
      } else {
        p_scores[i] <- NA
      }
    }
    
    return(p_scores)
  }
  
  # Tạo UI động cho số arms mỗi nghiên cứu
  output$nma_study_arms_inputs <- renderUI({
    req(input$nma_study_count_flex)
    n_studies <- input$nma_study_count_flex
    
    div_list <- lapply(1:n_studies, function(i) {
      div(
        style = "display: inline-block; margin-right: 15px; margin-bottom: 10px;",
        numericInput(
          inputId = paste0("nma_study_", i, "_arms"),
          label = paste("NC", i),
          value = 2,  # Mặc định là 2 nhóm
          min = 2,
          max = 10,
          width = "80px"
        )
      )
    })
    
    do.call(tagList, div_list)
  })
  
  # Initialize with sample data
  nma_data <- reactiveVal(get_nma_sample("Contrast-based", "Biến liên tục"))
  
  # Update instructions based on selected data type
  output$nma_instr <- renderUI({
    key <- paste(input$nma_type, input$nma_outcome, sep = " - ")
    nma_instructions[[key]]
  })
  
  # Switch between sample and manual data when radio button changes
  observeEvent(input$nma_data_mode, {
    if (input$nma_data_mode == "sample") {
      nma_data(get_nma_sample(input$nma_type, input$nma_outcome))
    }
    # For manual data, we'll wait for the user to click "Tạo bảng nhập liệu" button
  })
  
  # Update sample data when type or outcome changes (only in sample mode)
  observeEvent(c(input$nma_type, input$nma_outcome), {
    if (input$nma_data_mode == "sample") {
      nma_data(get_nma_sample(input$nma_type, input$nma_outcome))
    }
  })
  
  # Generate table for manual input when button is clicked
  observeEvent(input$nma_generate_table, {
    if (input$nma_input_mode == "fixed") {
      # Cố định số nhóm cho mỗi nghiên cứu
      req(input$nma_study_count, input$nma_arms_per_study)
      study_arms <- rep(input$nma_arms_per_study, input$nma_study_count)
    } else {
      # Linh hoạt số nhóm cho mỗi nghiên cứu
      req(input$nma_study_count_flex)
      study_arms <- sapply(1:input$nma_study_count_flex, function(i) {
        as.numeric(input[[paste0("nma_study_", i, "_arms")]])
      })
    }
    
    # Tạo bảng dữ liệu trống
    df <- create_nma_empty_data(input$nma_type, input$nma_outcome, study_arms)
    nma_data(df)
  })
  
  # Render the NMA data table using rHandsontable
  output$nma_datatable <- renderRHandsontable({
    rhandsontable(nma_data(), stretchH = "all", height = 300) %>%
      hot_table(highlightRow = TRUE, highlightCol = TRUE) %>%
      hot_context_menu(allowRowEdit = TRUE, allowColEdit = FALSE)
  })
  
  # Get updated NMA data from the handsontable
  observe({
    if (!is.null(input$nma_datatable)) {
      nma_data(hot_to_r(input$nma_datatable))
    }
  })
  
  # --------- NMA ANALYSIS ---------
  nma_result <- eventReactive(input$nma_run, {
    # Đổi hướng điều hướng sang tab "nma_network" thay vì "nma_results"
    updateTabItems(session, "sidebar", "nma_network")
    
    df <- nma_data()
    
    # Remove rows with NA values in essential columns
    if (input$nma_type == "Contrast-based" && (input$nma_outcome == "Biến liên tục" || input$nma_outcome == "Biến phân loại")) {
      df <- df[!is.na(df$Study) & !is.na(df$Treat1) & !is.na(df$Treat2) & 
                 !is.na(df$ES) & !is.na(df$ll) & !is.na(df$ul), ]
    } else if (input$nma_type == "Arm-based" && input$nma_outcome == "Biến liên tục") {
      df <- df[!is.na(df$Study) & !is.na(df$Treatment) & !is.na(df$N) & 
                 !is.na(df$Mean) & !is.na(df$SD), ]
    } else { # Arm-based & Biến phân loại
      df <- df[!is.na(df$Study) & !is.na(df$Treatment) & !is.na(df$Event) & !is.na(df$N), ]
    }
    
    type <- input$nma_type
    outcome <- input$nma_outcome
    tol_val <- input$nma_tol
    
    # CONTRAST-BASED CONTINUOUS
    if (type == "Contrast-based" && outcome == "Biến liên tục") {
      # Validate data
      if (!all(c("Study", "Treat1", "Treat2", "ES", "ll", "ul") %in% names(df))) {
        return(structure(list(error = "Thiếu cột dữ liệu cần thiết!"), class = "error"))
      }
      
      df <- df[df$Treat1 != df$Treat2, ]
      
      if (nrow(df) < 3) {
        return(structure(list(error = "Cần ít nhất 3 so sánh hợp lệ!"), class = "error"))
      }
      
      # Rename ES to TE and calculate seTE
      df$TE <- df$ES
      df$seTE <- (df$ul - df$ll) / (2 * 1.96)
      
      tryCatch({
        result <- netmeta(
          TE = df$TE, 
          seTE = df$seTE, 
          treat1 = df$Treat1, 
          treat2 = df$Treat2, 
          studlab = df$Study,
          sm = "SMD", 
          random = TRUE,
          tol.multiarm = tol_val
        )
        
        # Kiểm tra kết quả có phải là đối tượng netmeta hợp lệ không
        if (!is.null(result) && inherits(result, "netmeta")) {
          return(result)
        } else {
          return(structure(list(error = "Kết quả không phải là đối tượng netmeta hợp lệ"), class = "error"))
        }
      }, error = function(e) {
        return(structure(list(error = e$message), class = "error"))
      })
    }
    
    # CONTRAST-BASED COUNT
    else if (type == "Contrast-based" && outcome == "Biến phân loại") {
      # Validate data
      if (!all(c("Study", "Treat1", "Treat2", "ES", "ll", "ul") %in% names(df))) {
        return(structure(list(error = "Thiếu cột dữ liệu cần thiết!"), class = "error"))
      }
      
      df <- df[df$Treat1 != df$Treat2, ]
      
      if (nrow(df) < 3) {
        return(structure(list(error = "Cần ít nhất 3 so sánh hợp lệ!"), class = "error"))
      }
      
      # Rename ES to TE and calculate seTE
      df$TE <- df$ES
      df$seTE <- (df$ul - df$ll) / (2 * 1.96)
      
      tryCatch({
        result <- netmeta(
          TE = df$TE, 
          seTE = df$seTE, 
          treat1 = df$Treat1, 
          treat2 = df$Treat2, 
          studlab = df$Study,
          sm = "OR", 
          random = TRUE,
          tol.multiarm = tol_val
        )
        
        # Kiểm tra kết quả
        if (!is.null(result) && inherits(result, "netmeta")) {
          return(result)
        } else {
          return(structure(list(error = "Kết quả không phải là đối tượng netmeta hợp lệ"), class = "error"))
        }
      }, error = function(e) {
        return(structure(list(error = e$message), class = "error"))
      })
    }
    
    # ARM-BASED CONTINUOUS
    else if (type == "Arm-based" && outcome == "Biến liên tục") {
      # Validate data
      if (!all(c("Study", "Treatment", "N", "Mean", "SD") %in% names(df))) {
        return(structure(list(error = "Thiếu cột dữ liệu cần thiết!"), class = "error"))
      }
      
      if (nrow(df) < 4) {
        return(structure(list(error = "Cần ít nhất 2 nghiên cứu, mỗi nghiên cứu ít nhất 2 arm!"), class = "error"))
      }
      
      # Check that each study has at least 2 arms
      studies <- table(df$Study)
      if (any(studies < 2)) {
        bad_studies <- names(studies[studies < 2])
        return(structure(list(error = paste0("Các nghiên cứu sau có ít hơn 2 nhóm: ", 
                                             paste(bad_studies, collapse = ", "))), class = "error"))
      }
      
      # Check for duplicate treatments within studies
      duplicates <- check_duplicated_treatments(df)
      if (length(duplicates) > 0) {
        return(structure(list(error = paste0("Tên nhóm điều trị bị trùng trong các nghiên cứu: ", 
                                             paste(duplicates, collapse = ", "))), class = "error"))
      }
      
      tryCatch({
        pw <- pairwise(
          treat = Treatment, 
          mean = Mean, 
          sd = SD, 
          n = N, 
          studlab = Study, 
          data = df
        )
        
        result <- netmeta(
          TE = pw$TE, 
          seTE = pw$seTE, 
          treat1 = pw$treat1, 
          treat2 = pw$treat2, 
          studlab = pw$studlab,
          sm = "SMD", 
          random = TRUE,
          tol.multiarm = tol_val
        )
        
        # Kiểm tra kết quả
        if (!is.null(result) && inherits(result, "netmeta")) {
          return(result)
        } else {
          return(structure(list(error = "Kết quả không phải là đối tượng netmeta hợp lệ"), class = "error"))
        }
      }, error = function(e) {
        return(structure(list(error = e$message), class = "error"))
      })
    }
    
    # ARM-BASED COUNT
    else {
      # Validate data
      if (!all(c("Study", "Treatment", "Event", "N") %in% names(df))) {
        return(structure(list(error = "Thiếu cột dữ liệu cần thiết!"), class = "error"))
      }
      
      if (nrow(df) < 4) {
        return(structure(list(error = "Cần ít nhất 2 nghiên cứu, mỗi nghiên cứu ít nhất 2 arm!"), class = "error"))
      }
      
      # Check that each study has at least 2 arms
      studies <- table(df$Study)
      if (any(studies < 2)) {
        bad_studies <- names(studies[studies < 2])
        return(structure(list(error = paste0("Các nghiên cứu sau có ít hơn 2 nhóm: ", 
                                             paste(bad_studies, collapse = ", "))), class = "error"))
      }
      
      # Check for duplicate treatments within studies
      duplicates <- check_duplicated_treatments(df)
      if (length(duplicates) > 0) {
        return(structure(list(error = paste0("Tên nhóm điều trị bị trùng trong các nghiên cứu: ", 
                                             paste(duplicates, collapse = ", "))), class = "error"))
      }
      
      tryCatch({
        pw <- pairwise(
          treat = Treatment, 
          event = Event, 
          n = N, 
          studlab = Study, 
          data = df
        )
        
        result <- netmeta(
          TE = pw$TE, 
          seTE = pw$seTE, 
          treat1 = pw$treat1, 
          treat2 = pw$treat2, 
          studlab = pw$studlab,
          sm = "OR", 
          random = TRUE,
          tol.multiarm = tol_val
        )
        
        # Kiểm tra kết quả
        if (!is.null(result) && inherits(result, "netmeta")) {
          return(result)
        } else {
          return(structure(list(error = "Kết quả không phải là đối tượng netmeta hợp lệ"), class = "error"))
        }
      }, error = function(e) {
        return(structure(list(error = e$message), class = "error"))
      })
    }
  })
  
  # Hàm biện giải sơ đồ mạng lưới
  generate_network_interpretation <- function(res) {
    if (inherits(res, "error")) {
      return("<div class='alert alert-danger'>Không thể tạo biện giải do lỗi phân tích.</div>")
    }
    
    # Lấy thông tin về mạng lưới
    treatments <- res$trts
    n_treatments <- length(treatments)
    n_studies <- length(unique(res$studlab))
    
    # Tính toán số cặp so sánh trực tiếp từ thông tin trong đối tượng netmeta
    direct_comparisons <- 0
    
    # Cách đúng để lấy thông tin về các cặp so sánh trực tiếp từ đối tượng netmeta
    if (!is.null(res$A.matrix)) {
      # Đếm số cặp điều trị có so sánh trực tiếp
      comp_matrix <- res$A.matrix != 0
      direct_comparisons <- sum(comp_matrix[lower.tri(comp_matrix)])
    } else {
      # Phương pháp dự phòng - giả định có các so sánh trực tiếp dựa trên dữ liệu mẫu
      # cho các mạng lưới đầy đủ 3 điều trị
      if (n_treatments == 3) direct_comparisons <- 3
    }
    
    # Tỷ lệ kết nối (mật độ mạng lưới)
    max_comparisons <- (n_treatments * (n_treatments - 1)) / 2
    density <- direct_comparisons / max_comparisons
    
    # Kiểm tra cấu trúc mạng lưới
    is_connected <- TRUE # Giả sử mạng lưới liên kết đầy đủ
    has_loops <- FALSE
    
    # Tính số lượng vòng khép kín có thể có
    possible_loops <- max(0, direct_comparisons - n_treatments + 1)
    if (possible_loops > 0) {
      has_loops <- TRUE
    }
    
    # Tạo nội dung HTML biện giải
    html_content <- paste0(
      "<div style='margin-top: 20px; padding: 10px; background-color: #e6f7ff; border-left: 4px solid #1890ff;'>",
      "<h4 style='color: #1890ff;'>🔍 Biện giải sơ đồ mạng lưới cho dữ liệu hiện tại:</h4>"
    )
    
    # Thông tin cơ bản
    html_content <- paste0(html_content,
                           "<p><b>Cấu trúc mạng lưới:</b> Mạng lưới bao gồm <b>", n_treatments, " phương pháp điều trị</b> từ <b>", 
                           n_studies, " nghiên cứu</b>. Có <b>", direct_comparisons, "/", max_comparisons, 
                           " cặp so sánh trực tiếp</b> (", round(density*100), "% mật độ mạng lưới).</p>"
    )
    
    # Đánh giá cấu trúc mạng
    network_structure <- ifelse(density < 0.3, "hình sao hoặc tuyến tính", 
                                ifelse(density < 0.6, "mạng lưới trung bình", "mạng lưới đầy đủ"))
    
    html_content <- paste0(html_content,
                           "<p><b>Đặc điểm mạng lưới:</b> Mạng lưới có cấu trúc <b>", network_structure, "</b>",
                           ifelse(has_loops, 
                                  " và có các vòng khép kín, cho phép đánh giá tính nhất quán.", 
                                  " và không có nhiều vòng khép kín, hạn chế khả năng đánh giá tính nhất quán."),
                           "</p>"
    )
    
    # Đánh giá bằng chứng
    html_content <- paste0(html_content,
                           "<p><b>Đánh giá bằng chứng:</b> ",
                           ifelse(density > 0.5, 
                                  "Mạng lưới có nhiều so sánh trực tiếp, giúp tăng độ tin cậy của các ước lượng.", 
                                  ifelse(density > 0.3,
                                         "Mạng lưới có số lượng trung bình các so sánh trực tiếp, các ước lượng có độ tin cậy khá.", 
                                         "Mạng lưới có ít so sánh trực tiếp, nhiều ước lượng dựa vào bằng chứng gián tiếp có độ không chắc chắn cao hơn.")),
                           "</p>"
    )
    
    # Khuyến nghị
    html_content <- paste0(html_content,
                           "<p><b>Khuyến nghị:</b> ",
                           ifelse(density < 0.3 && !has_loops, 
                                  "Cần thận trọng khi diễn giải kết quả do cấu trúc mạng lưới hạn chế và thiếu các vòng khép kín để đánh giá tính nhất quán.", 
                                  ifelse(density < 0.5,
                                         "Nên ưu tiên xem xét các so sánh có bằng chứng trực tiếp và đánh giá kỹ tính nhất quán khi diễn giải kết quả.", 
                                         "Mạng lưới có cấu trúc tốt, có thể tin tưởng vào kết quả nếu tính nhất quán được đảm bảo.")),
                           "</p></div>"
    )
    
    return(html_content)
  }
  
  # Hàm biện giải kết quả chính NMA
  generate_nma_results_interpretation <- function(res) {
    if (inherits(res, "error")) {
      return("<div class='alert alert-danger'>Không thể tạo biện giải do lỗi phân tích.</div>")
    }
    
    # Lấy thông tin cơ bản
    treatments <- res$trts
    n_treatments <- length(treatments)
    effect_measure <- res$sm
    tau2 <- res$tau
    i2 <- res$I2 * 100
    
    # Tìm điều trị tốt nhất và tệ nhất (dựa trên xếp hạng P-score)
    tryCatch({
      p_scores <- netrank(res, small.values = "bad")
      best_treatment <- names(p_scores)[which.max(p_scores)]
      worst_treatment <- names(p_scores)[which.min(p_scores)]
      
      # Lấy thông tin so sánh giữa điều trị tốt nhất và tệ nhất
      if (best_treatment != worst_treatment) {
        best_vs_worst <- NULL
        
        # Trích xuất dữ liệu từ đối tượng netmeta
        league_table <- as.data.frame(res)
        # Tìm hàng và cột cho best_treatment và worst_treatment
        for (i in 1:nrow(league_table)) {
          for (j in 1:ncol(league_table)) {
            if (rownames(league_table)[i] == best_treatment && 
                colnames(league_table)[j] == worst_treatment) {
              best_vs_worst <- league_table[i, j]
            }
          }
        }
        
        if (is.null(best_vs_worst)) {
          for (i in 1:nrow(league_table)) {
            for (j in 1:ncol(league_table)) {
              if (rownames(league_table)[i] == worst_treatment && 
                  colnames(league_table)[j] == best_treatment) {
                # Nếu chiều ngược lại, đảo ngược hiệu ứng
                if (effect_measure == "SMD") {
                  parts <- strsplit(as.character(league_table[i, j]), " ")[[1]]
                  effect <- as.numeric(parts[1]) * -1
                  ci_lower <- as.numeric(gsub("\\(", "", parts[2])) * -1
                  ci_upper <- as.numeric(gsub("\\)", "", parts[3])) * -1
                  best_vs_worst <- paste(effect, "(", ci_upper, ci_lower, ")")
                } else { # OR
                  parts <- strsplit(as.character(league_table[i, j]), " ")[[1]]
                  effect <- 1 / as.numeric(parts[1])
                  ci_lower <- 1 / as.numeric(gsub("\\)", "", parts[3]))
                  ci_upper <- 1 / as.numeric(gsub("\\(", "", parts[2]))
                  best_vs_worst <- paste(effect, "(", ci_lower, ci_upper, ")")
                }
              }
            }
          }
        }
      }
    }, error = function(e) {
      best_treatment <- "không xác định"
      worst_treatment <- "không xác định"
      best_vs_worst <- NULL
    })
    
    # Tạo nội dung HTML biện giải
    html_content <- paste0(
      "<div style='margin-top: 20px; padding: 10px; background-color: #e6f7ff; border-left: 4px solid #1890ff;'>",
      "<h4 style='color: #1890ff;'>🔍 Biện giải kết quả chính cho dữ liệu hiện tại:</h4>"
    )
    
    # Thông tin cơ bản
    html_content <- paste0(html_content,
                           "<p><b>Tổng quan:</b> Phân tích tổng hợp mạng lưới bao gồm <b>", n_treatments, 
                           " phương pháp điều trị</b> với chỉ số đánh giá là <b>", 
                           ifelse(effect_measure == "SMD", "Khác biệt trung bình chuẩn hóa (SMD)", 
                                  "Tỷ suất chênh (OR)"), "</b>.</p>"
    )
    
    # Tính bất đồng nhất
    html_content <- paste0(html_content,
                           "<p><b>Tính bất đồng nhất:</b> I² = ", round(i2, 1), "%, cho thấy mức độ bất đồng nhất ",
                           ifelse(i2 < 25, "thấp", 
                                  ifelse(i2 < 50, "trung bình", 
                                         ifelse(i2 < 75, "đáng kể", "cao"))),
                           " giữa các nghiên cứu. Tau² = ", round(tau2, 4), 
                           " (ước lượng phương sai giữa các nghiên cứu).</p>"
    )
    
    # Kết quả xếp hạng (nếu có)
    if (exists("best_treatment") && best_treatment != "không xác định") {
      html_content <- paste0(html_content,
                             "<p><b>Xếp hạng điều trị:</b> Dựa trên P-scores, <b>", best_treatment, 
                             "</b> có khả năng là điều trị hiệu quả nhất, trong khi <b>", worst_treatment, 
                             "</b> có khả năng là điều trị kém hiệu quả nhất.</p>"
      )
      
      # So sánh điều trị tốt nhất và tệ nhất (nếu có thông tin)
      if (!is.null(best_vs_worst)) {
        html_content <- paste0(html_content,
                               "<p><b>So sánh chính:</b> So sánh giữa điều trị hiệu quả nhất và kém nhất (", 
                               best_treatment, " vs ", worst_treatment, ") cho thấy ", 
                               ifelse(effect_measure == "SMD", "SMD", "OR"), " = ", best_vs_worst, ".</p>"
        )
      }
    }
    
    # Giải thích Bảng League
    html_content <- paste0(html_content,
                           "<p><b>Bảng League:</b> Bảng League trình bày tất cả các so sánh cặp đôi giữa các điều trị. ",
                           "Các giá trị trên đường chéo là ước lượng hiệu ứng với khoảng tin cậy 95%. ",
                           "Kết quả in đậm có ý nghĩa thống kê (p < 0.05). Các giá trị dương ", 
                           ifelse(effect_measure == "SMD", "(SMD > 0)", "(OR > 1)"), 
                           " cho thấy điều trị ở hàng ngang có hiệu quả hơn điều trị ở cột dọc.</p></div>"
    )
    
    return(html_content)
  }
  
  # Hàm biện giải tính nhất quán
  generate_consistency_interpretation <- function(global_result, local_result) {
    if (is.null(global_result) || is.null(local_result)) {
      return("<div class='alert alert-danger'>Không thể tạo biện giải tính nhất quán do thiếu dữ liệu hoặc lỗi phân tích.</div>")
    }
    
    # Trích xuất thông tin từ kiểm định tính nhất quán toàn cục
    global_p <- NA
    global_Q <- NA
    
    tryCatch({
      if (inherits(global_result, "decomp.design")) {
        # Thêm kiểm tra các trường hợp giá trị NULL hoặc NA
        global_Q <- ifelse(is.null(global_result$Q.inc.random), NA, global_result$Q.inc.random)
        global_p <- ifelse(is.null(global_result$pval.inc.random), NA, global_result$pval.inc.random)
      }
    }, error = function(e) {
      # Xử lý lỗi nếu có
    })
    
    # Trích xuất thông tin từ kiểm định tính nhất quán cục bộ
    local_issues <- FALSE
    n_loops <- 0
    problematic_loops <- character(0)
    
    tryCatch({
      if (inherits(local_result, "netsplit")) {
        # Kiểm tra cấu trúc đối tượng netsplit
        if (!is.null(local_result$direct.random) && is.data.frame(local_result$direct.random) && 
            nrow(local_result$direct.random) > 0) {
          n_loops <- nrow(local_result$direct.random)
          
          # Kiểm tra có compare.random không và có cột p không
          if (!is.null(local_result$compare.random) && is.data.frame(local_result$compare.random) &&
              "p" %in% names(local_result$compare.random) && 
              "treat1" %in% names(local_result$compare.random) &&
              "treat2" %in% names(local_result$compare.random)) {
            
            for (i in 1:n_loops) {
              if (i <= nrow(local_result$compare.random)) {
                p_value <- local_result$compare.random$p[i]
                if (!is.na(p_value) && p_value < 0.05) {
                  local_issues <- TRUE
                  comp <- paste(local_result$compare.random$treat1[i], 
                                "vs", 
                                local_result$compare.random$treat2[i])
                  problematic_loops <- c(problematic_loops, comp)
                }
              }
            }
          }
        }
      }
    }, error = function(e) {
      # Xử lý lỗi nếu có
    })
    
    # Tạo nội dung HTML biện giải
    html_content <- paste0(
      "<div style='margin-top: 20px; padding: 10px; background-color: #e6f7ff; border-left: 4px solid #1890ff;'>",
      "<h4 style='color: #1890ff;'>🔍 Biện giải tính nhất quán cho dữ liệu hiện tại:</h4>"
    )
    
    # Biện giải tính nhất quán toàn cục
    if (!is.na(global_p)) {
      html_content <- paste0(html_content,
                             "<p><b>Tính nhất quán toàn cục:</b> Kiểm định chi-squared cho tính không nhất quán có Q = ", 
                             round(global_Q, 2), " với giá trị p = ", format(global_p, digits=3), ". ",
                             ifelse(global_p < 0.05,
                                    "<b>Có bằng chứng thống kê về sự không nhất quán trong mạng lưới</b> (p < 0.05). Điều này có nghĩa là bằng chứng trực tiếp và gián tiếp không hoàn toàn phù hợp với nhau.",
                                    "<b>Không có bằng chứng thống kê về sự không nhất quán trong mạng lưới</b> (p ≥ 0.05). Điều này cho thấy bằng chứng trực tiếp và gián tiếp nhìn chung phù hợp với nhau."),
                             "</p>"
      )
    } else {
      html_content <- paste0(html_content,
                             "<p><b>Tính nhất quán toàn cục:</b> Không thể đánh giá tính nhất quán toàn cục do thiếu dữ liệu hoặc cấu trúc mạng lưới không phù hợp.</p>"
      )
    }
    
    # Biện giải tính nhất quán cục bộ
    if (n_loops > 0) {
      html_content <- paste0(html_content,
                             "<p><b>Tính nhất quán cục bộ:</b> Đã kiểm tra ", n_loops, " vòng khép kín trong mạng lưới. ",
                             ifelse(local_issues && length(problematic_loops) > 0,
                                    paste0("<b>Phát hiện sự không nhất quán</b> trong ", length(problematic_loops), 
                                           " vòng khép kín (p < 0.05): ", paste(problematic_loops, collapse=", "), "."),
                                    "<b>Không phát hiện sự không nhất quán đáng kể</b> trong bất kỳ vòng khép kín nào (tất cả p ≥ 0.05)."),
                             "</p>"
      )
    } else {
      html_content <- paste0(html_content,
                             "<p><b>Tính nhất quán cục bộ:</b> Không thể đánh giá tính nhất quán cục bộ do không có đủ vòng khép kín trong mạng lưới.</p>"
      )
    }
    
    # Đánh giá tổng thể và khuyến nghị
    html_content <- paste0(html_content,
                           "<p><b>Đánh giá tổng thể:</b> ",
                           ifelse(is.na(global_p) || (global_p >= 0.05 && !local_issues),
                                  "Mạng lưới nhìn chung đáp ứng giả định tính nhất quán. Kết quả phân tích tổng hợp mạng lưới đáng tin cậy.",
                                  ifelse(global_p < 0.05 && local_issues,
                                         "Phát hiện sự không nhất quán cả ở mức độ toàn cục và cục bộ. <b>Cần thận trọng khi diễn giải kết quả</b>. Nên xem xét phân tích phân nhóm hoặc meta-regression để giải thích sự không nhất quán.",
                                         "Có một số bằng chứng về sự không nhất quán. <b>Nên thận trọng</b> khi diễn giải kết quả, đặc biệt là các so sánh dựa nhiều vào bằng chứng gián tiếp.")),
                           "</p></div>"
    )
    
    return(html_content)
  }
  
  # Hàm biện giải xếp hạng điều trị
  generate_ranking_interpretation <- function(res, small_values) {
    if (inherits(res, "error")) {
      return("<div class='alert alert-danger'>Không thể tạo biện giải do lỗi phân tích.</div>")
    }
    
    # Thử tính P-scores và xử lý lỗi nếu có
    p_scores <- NULL
    best_treatment <- "không xác định"
    worst_treatment <- "không xác định"
    
    tryCatch({
      # Sử dụng hàm tính P-scores thủ công
      p_scores <- calculate_p_scores(res, small.values = small_values)
      
      if (!is.null(p_scores) && length(p_scores) > 0 && !all(is.na(p_scores))) {
        best_treatment <- names(p_scores)[which.max(p_scores)]
        worst_treatment <- names(p_scores)[which.min(p_scores)]
      }
    }, error = function(e) {
      p_scores <- NULL
    })
    
    # Tạo nội dung HTML biện giải
    html_content <- paste0(
      "<div style='margin-top: 20px; padding: 10px; background-color: #e6f7ff; border-left: 4px solid #1890ff;'>",
      "<h4 style='color: #1890ff;'>🔍 Biện giải xếp hạng điều trị cho dữ liệu hiện tại:</h4>"
    )
    
    if (is.null(p_scores) || length(p_scores) == 0 || all(is.na(p_scores))) {
      html_content <- paste0(html_content,
                             "<p><b>Lưu ý quan trọng:</b> Không thể tính toán P-scores cho mạng lưới này. Nguyên nhân có thể do:</p>",
                             "<ul>",
                             "<li>Mạng lưới không liên kết đầy đủ (có các 'đảo' riêng biệt)</li>",
                             "<li>Số lượng nghiên cứu quá ít hoặc cấu trúc mạng lưới quá đơn giản</li>",
                             "<li>Mâu thuẫn hoặc không nhất quán cao trong dữ liệu</li>",
                             "<li>Vấn đề về định dạng dữ liệu (trùng lặp tên điều trị, v.v.)</li>",
                             "</ul>",
                             "<p>Hãy kiểm tra lại dữ liệu đầu vào và cấu trúc mạng lưới.</p></div>"
      )
      return(html_content)
    }
    
    # Biện giải tham số small.values
    html_content <- paste0(html_content,
                           "<p><b>Hướng đánh giá:</b> Bạn đã chọn <b>",
                           ifelse(small_values == "bad", 
                                  "giá trị hiệu ứng nhỏ hơn là kết quả xấu hơn", 
                                  "giá trị hiệu ứng nhỏ hơn là kết quả tốt hơn"),
                           "</b>. Do đó, ",
                           ifelse(small_values == "bad",
                                  "điều trị với P-score/SUCRA cao hơn được xem là tốt hơn.",
                                  "điều trị với P-score/SUCRA thấp hơn được xem là tốt hơn."),
                           "</p>"
    )
    
    # Biện giải kết quả xếp hạng
    html_content <- paste0(html_content,
                           "<p><b>Xếp hạng điều trị:</b> Dựa trên phân tích P-score:</p>",
                           "<ul>",
                           "<li><b>Điều trị hiệu quả nhất:</b> ", best_treatment, " (P-score = ", round(max(p_scores, na.rm=TRUE), 3), ", SUCRA = ", round(max(p_scores, na.rm=TRUE)*100, 1), "%)</li>",
                           "<li><b>Điều trị kém hiệu quả nhất:</b> ", worst_treatment, " (P-score = ", round(min(p_scores, na.rm=TRUE), 3), ", SUCRA = ", round(min(p_scores, na.rm=TRUE)*100, 1), "%)</li>",
                           "</ul>"
    )
    
    # Thêm cảnh báo về cách biện giải P-score
    html_content <- paste0(html_content,
                           "<p><b>Lưu ý quan trọng:</b> P-scores và SUCRA chỉ cung cấp xếp hạng tương đối giữa các điều trị. Điều trị xếp hạng cao hơn không nhất thiết có ý nghĩa lâm sàng nếu sự chênh lệch mức độ ảnh hưởng (effect size) là nhỏ. Nên kết hợp xếp hạng này với thông tin từ bảng league và đánh giá tính nhất quán của mạng lưới.</p></div>"
    )
    
    return(html_content)
  }
  
  # Các output cho NMA
  
  # Display NMA results
  output$nma_summary <- renderPrint({
    res <- nma_result()
    if (inherits(res, "error")) {
      cat("Lỗi phân tích mạng lưới:", res$error)
    } else {
      print(summary(res))
    }
  })
  
  # Network plot
  output$nma_netplot <- renderPlot({
    res <- nma_result()
    if (!inherits(res, "error")) {
      netgraph(res, points = TRUE, cex.points = 2, cex = 1.3, 
               col = "blue", plastic = FALSE, multiarm = TRUE, 
               thickness = "number.of.studies", number.of.studies = TRUE, 
               main = "Sơ đồ mạng lưới")
    }
  })
  
  # Output cho biện giải sơ đồ mạng lưới
  output$nma_network_interpretation_actual <- renderUI({
    res <- nma_result()
    HTML(generate_network_interpretation(res))
  })
  
  # League table title
  output$nma_league_title <- renderUI({
    res <- nma_result()
    if (!inherits(res, "error")) {
      HTML("<h4><strong>Bảng League - Các so sánh cặp đôi</strong></h4>")
    }
  })
  
  # League table
  output$nma_league <- renderPrint({
    res <- nma_result()
    if (!inherits(res, "error")) {
      cat("Bảng League (các so sánh cặp đôi):\n\n")
      print(res)
    }
  })
  
  # Output cho biện giải kết quả chính NMA
  output$nma_results_interpretation_actual <- renderUI({
    res <- nma_result()
    HTML(generate_nma_results_interpretation(res))
  })
  
  # Tách kiểm định tính nhất quán thành hai phần
  # Global consistency test
  output$nma_global_consistency <- renderPrint({
    res <- nma_result()
    if (!inherits(res, "error") && inherits(res, "netmeta")) {
      cat("Kiểm định tính nhất quán toàn cục:\n")
      tryCatch({
        global_result <- decomp.design(res)
        print(global_result)
      }, error = function(e) {
        cat("Lỗi khi phân tích tính nhất quán toàn cục:", e$message, "\n")
        cat("Có thể do cấu trúc mạng lưới không phù hợp hoặc thiếu vòng khép kín.")
      })
    } else if (inherits(res, "error")) {
      cat("Lỗi phân tích NMA:", res$error)
    }
  })
  
  # Local consistency test (node-splitting)
  output$nma_local_consistency <- renderPrint({
    res <- nma_result()
    if (!inherits(res, "error") && inherits(res, "netmeta")) {
      cat("Kiểm định tính nhất quán cục bộ (node-splitting):\n")
      tryCatch({
        local_result <- netsplit(res)
        print(local_result)
      }, error = function(e) {
        cat("Lỗi khi phân tích tính nhất quán cục bộ:", e$message, "\n")
        cat("Có thể do thiếu vòng khép kín trong mạng lưới.")
      })
    } else if (inherits(res, "error")) {
      cat("Lỗi phân tích NMA:", res$error)
    }
  })
  
  # Output cho biện giải tính nhất quán
  output$nma_consistency_interpretation_actual <- renderUI({
    res <- nma_result()
    if (!inherits(res, "error") && inherits(res, "netmeta")) {
      tryCatch({
        global_res <- decomp.design(res)
        local_res <- netsplit(res)
        HTML(generate_consistency_interpretation(global_res, local_res))
      }, error = function(e) {
        HTML(paste0(
          "<div class='alert alert-warning'>",
          "<p><strong>Không thể phân tích tính nhất quán:</strong> ", e$message, "</p>",
          "<p>Nguyên nhân có thể là: (1) Mạng lưới không đủ các vòng khép kín, (2) Số lượng nghiên cứu quá ít, hoặc (3) Cấu trúc dữ liệu không phù hợp.</p>",
          "</div>"
        ))
      })
    } else {
      HTML("<div class='alert alert-danger'>Không thể phân tích tính nhất quán do chưa có kết quả NMA hợp lệ.</div>")
    }
  })
  
  # Cập nhật xếp hạng điều trị khi nhấn nút
  observeEvent(input$nma_update_ranking, {
    output$nma_ranking <- renderRHandsontable({
      res <- nma_result()
      if (!inherits(res, "error") && inherits(res, "netmeta")) {
        tryCatch({
          # Sử dụng hàm thủ công của chúng ta
          p_scores <- calculate_p_scores(res, small.values = input$nma_small_values)
          
          # Tạo bảng xếp hạng
          rank_df <- data.frame(
            Điều_trị = names(p_scores),
            P_score = round(as.numeric(p_scores), 3),
            SUCRA = round(as.numeric(p_scores) * 100, 1)
          )
          
          # Sắp xếp theo P-score giảm dần
          rank_df <- rank_df[order(-rank_df$P_score), ]
          
          rhandsontable(rank_df, readOnly = TRUE, stretchH = "all") %>%
            hot_cols(colWidths = c(150, 100, 100))
        }, error = function(e) {
          rhandsontable(data.frame(
            Thông_báo = paste("Không thể tạo bảng xếp hạng:", e$message)
          ), readOnly = TRUE)
        })
      } else {
        rhandsontable(data.frame(
          Thông_báo = "Chạy phân tích NMA trước khi xem xếp hạng"
        ), readOnly = TRUE)
      }
    })
  })
  
  # Cập nhật mặc định cho bảng xếp hạng
  output$nma_ranking <- renderRHandsontable({
    res <- nma_result()
    if (!inherits(res, "error") && inherits(res, "netmeta")) {
      tryCatch({
        # Thử dùng hàm thủ công của chúng ta thay vì netrank()
        p_scores <- calculate_p_scores(res, small.values = input$nma_small_values)
        
        # Kiểm tra kết quả có hợp lệ không
        if (any(is.na(p_scores)) || length(p_scores) == 0) {
          return(rhandsontable(data.frame(
            Thông_báo = "Không thể tính P-scores do cấu trúc ma trận không phù hợp"
          ), readOnly = TRUE))
        }
        
        # Tạo bảng xếp hạng
        rank_df <- data.frame(
          Điều_trị = names(p_scores),
          P_score = round(as.numeric(p_scores), 3),
          SUCRA = round(as.numeric(p_scores) * 100, 1)
        )
        
        # Sắp xếp theo P-score giảm dần
        rank_df <- rank_df[order(-rank_df$P_score), ]
        
        rhandsontable(rank_df, readOnly = TRUE, stretchH = "all") %>%
          hot_cols(colWidths = c(150, 100, 100))
      }, error = function(e) {
        # Log chi tiết lỗi
        message("Lỗi khi tính P-scores: ", e$message)
        
        # Hiển thị thông báo lỗi
        rhandsontable(data.frame(
          Thông_báo = paste("Không thể tạo bảng xếp hạng:", e$message)
        ), readOnly = TRUE)
      })
    } else {
      rhandsontable(data.frame(
        Thông_báo = "Chạy phân tích NMA trước khi xem xếp hạng"
      ), readOnly = TRUE)
    }
  })
  
  # Output cho biện giải xếp hạng điều trị
  output$nma_ranking_interpretation_actual <- renderUI({
    res <- nma_result()
    HTML(generate_ranking_interpretation(res, input$nma_small_values))
  })
  
  # Debug panel cho xếp hạng điều trị
  output$nma_ranking_debug <- renderPrint({
    res <- nma_result()
    if (!inherits(res, "error")) {
      cat("=== THÔNG TIN MẠNG LƯỚI ===\n")
      cat("Số điều trị:", length(res$trts), "\n")
      cat("Tên các điều trị:", paste(res$trts, collapse=", "), "\n")
      cat("Loại hiệu ứng:", res$sm, "\n")
      cat("Số nghiên cứu:", length(unique(res$studlab)), "\n")
      cat("Phiên bản netmeta:", packageVersion("netmeta"), "\n")
      cat("Phiên bản R:", paste(R.Version()$major, R.Version()$minor, sep="."), "\n")
      
      # Thử tính P-scores với hàm tự viết
      cat("\n=== THỬ TÍNH P-SCORES VỚI HÀM TỰ VIẾT ===\n")
      tryCatch({
        p_scores <- calculate_p_scores(res, small.values = input$nma_small_values)
        cat("Thành công! P-scores từ hàm thủ công:\n")
        print(p_scores)
      }, error = function(e) {
        cat("Lỗi khi tính P-scores bằng hàm thủ công:", e$message, "\n")
      })
      
      # Thử với netrank() gốc
      cat("\n=== THỬ TÍNH P-SCORES VỚI NETRANK() ===\n")
      tryCatch({
        p_scores_netrank <- netrank(res, small.values = input$nma_small_values)
        cat("Thành công! P-scores từ netrank():\n")
        print(p_scores_netrank)
      }, error = function(e) {
        cat("Lỗi khi tính P-scores với netrank():", e$message, "\n")
        
        # Thử xem chi tiết hơn về lỗi
        cat("\nThử phân tích lỗi chi tiết hơn:\n")
        tryCatch({
          # Phân tích từng bước của netrank()
          cat("1. Kiểm tra các thành phần của đối tượng netmeta:\n")
          for (name in names(res)) {
            cat("  -", name, ":", class(res[[name]]), "\n")
          }
          
          cat("\n2. Kiểm tra các giá trị cụ thể để phát hiện dữ liệu không hợp lệ:\n")
          cat("  - TE.random có chứa NA:", any(is.na(res$TE.random)), "\n")
          cat("  - seTE.random có chứa NA:", any(is.na(res$seTE.random)), "\n")
          cat("  - seTE.random có chứa 0:", any(res$seTE.random == 0, na.rm=TRUE), "\n")
          if (any(res$seTE.random == 0, na.rm=TRUE)) {
            cat("    Vị trí seTE.random = 0:\n")
            zero_indices <- which(res$seTE.random == 0, arr.ind=TRUE)
            print(zero_indices)
          }
        }, error = function(e2) {
          cat("Lỗi khi phân tích chi tiết:", e2$message, "\n")
        })
      })
    } else {
      cat("Chưa có kết quả NMA hoặc có lỗi trong phân tích.\n")
      if (!is.null(res$error)) cat("Lỗi:", res$error)
    }
  })
  
  # Điều hướng tab sau khi chạy NMA
  observeEvent(input$nma_run, {
    if (!inherits(nma_result(), "error")) {
      # Chuyển đến tab sơ đồ mạng lưới thay vì kết quả chính
      updateTabItems(session, "sidebar", "nma_network")
      
      # Tự động cập nhật bảng xếp hạng khi chạy phân tích mới
      tryCatch({
        res <- nma_result()
        
        if (!is.null(res) && inherits(res, "netmeta")) {
          # Cập nhật xếp hạng điều trị và biện giải tính nhất quán
          output$nma_ranking <- renderRHandsontable({
            tryCatch({
              # Sử dụng hàm thủ công của chúng ta
              p_scores <- calculate_p_scores(res, small.values = input$nma_small_values)
              
              # Tạo bảng xếp hạng
              rank_df <- data.frame(
                Điều_trị = names(p_scores),
                P_score = round(as.numeric(p_scores), 3),
                SUCRA = round(as.numeric(p_scores) * 100, 1)
              )
              
              # Sắp xếp theo P-score giảm dần
              rank_df <- rank_df[order(-rank_df$P_score), ]
              
              rhandsontable(rank_df, readOnly = TRUE, stretchH = "all") %>%
                hot_cols(colWidths = c(150, 100, 100))
            }, error = function(e) {
              rhandsontable(data.frame(
                Thông_báo = paste("Không thể tạo bảng xếp hạng:", e$message)
              ), readOnly = TRUE)
            })
          })
          
          output$nma_consistency_interpretation_actual <- renderUI({
            tryCatch({
              global_res <- decomp.design(res)
              local_res <- netsplit(res)
              HTML(generate_consistency_interpretation(global_res, local_res))
            }, error = function(e) {
              HTML(paste0(
                "<div class='alert alert-warning'>",
                "<p><strong>Không thể phân tích tính nhất quán:</strong> ", e$message, "</p>",
                "<p>Nguyên nhân có thể là: (1) Mạng lưới không đủ các vòng khép kín, (2) Số lượng nghiên cứu quá ít, hoặc (3) Cấu trúc dữ liệu không phù hợp.</p>",
                "</div>"
              ))
            })
          })
        }
      }, error = function(e) {
        # Ghi log lỗi để debug
        cat("Lỗi khi cập nhật kết quả:", e$message, "\n")
      })
    }
  })
  
  # Hỗ trợ xử lý dữ liệu cho nghiên cứu có số nhóm khác nhau
  check_nma_data_structure <- function(df, type) {
    problems <- character(0)
    
    if (type == "Contrast-based") {
      # Kiểm tra Contrast-based data
      studies <- unique(df$Study)
      for (study in studies) {
        study_data <- df[df$Study == study, ]
        treatments <- unique(c(study_data$Treat1, study_data$Treat2))
        n_arms <- length(treatments)
        n_comparisons <- nrow(study_data)
        expected_comparisons <- n_arms * (n_arms - 1) / 2
        
        if (n_comparisons != expected_comparisons) {
          problems <- c(problems, paste0("Nghiên cứu '", study, 
                                         "' có ", n_arms, " nhóm điều trị nhưng chỉ có ", 
                                         n_comparisons, "/", expected_comparisons, " so sánh. 
                                       Cần bổ sung đầy đủ các cặp so sánh."))
        }
      }
    } else { # Arm-based
      # Kiểm tra Arm-based data
      studies <- unique(df$Study)
      for (study in studies) {
        study_data <- df[df$Study == study, ]
        n_arms <- nrow(study_data)
        
        if (n_arms < 2) {
          problems <- c(problems, paste0("Nghiên cứu '", study, "' chỉ có ", n_arms, 
                                         " nhóm điều trị. Cần ít nhất 2 nhóm mỗi nghiên cứu."))
        }
        
        # Kiểm tra tên điều trị trùng lặp
        treatments <- study_data$Treatment
        if (any(duplicated(treatments))) {
          problems <- c(problems, paste0("Nghiên cứu '", study, 
                                         "' có tên nhóm điều trị trùng lặp. 
                                      Mỗi nhóm trong một nghiên cứu phải có tên duy nhất."))
        }
      }
    }
    
    return(problems)
  }
  
  # Hiển thị cảnh báo khi phát hiện vấn đề với dữ liệu
  observeEvent(input$nma_run, {
    df <- nma_data()
    if (!is.null(df) && nrow(df) > 0) {
      problems <- check_nma_data_structure(df, input$nma_type)
      if (length(problems) > 0) {
        showNotification(
          HTML(paste0("<strong>Cảnh báo dữ liệu:</strong><br>", 
                      paste(problems[1:min(length(problems), 2)], collapse="<br>"),
                      ifelse(length(problems) > 2, "<br>...", ""))),
          type = "warning",
          duration = 10
        )
      }
    }
  })
  
  # Trả về các reactive values để có thể dùng ở nơi khác nếu cần
  return(list(
    nma_data = nma_data,
    nma_result = nma_result
  ))
}
                                
                                
                                
                                
                                