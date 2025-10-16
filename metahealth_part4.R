# metahealth_part4_complete.r - Logic xử lý phân tích gộp MA

# Hàm module cho phân tích gộp (MA)
ma_server_module <- function(input, output, session) {
  # --------- MA DATA HANDLING ---------
  # Initialize with sample data
  ma_data <- reactiveVal(get_ma_sample("Contrast-based", "Biến liên tục"))
  
  # Update instructions based on selected data type
  output$ma_instr <- renderUI({
    key <- paste(input$ma_type, input$ma_outcome, sep=" - ")
    HTML(ma_instructions[[key]])
  })
  
  # Switch between sample and manual data when radio button changes
  observeEvent(input$ma_data_mode, {
    if (input$ma_data_mode == "sample") {
      ma_data(get_ma_sample(input$ma_type, input$ma_outcome))
    }
    # For manual data, we'll wait for the user to click "Tạo bảng nhập liệu" button
  })
  
  # Update sample data when type or outcome changes (only in sample mode)
  observeEvent(c(input$ma_type, input$ma_outcome), {
    if (input$ma_data_mode == "sample") {
      ma_data(get_ma_sample(input$ma_type, input$ma_outcome))
    }
  })
  
  # Generate table for manual input when button is clicked
  observeEvent(input$ma_generate_table, {
    req(input$ma_study_count)
    n_studies <- input$ma_study_count
    
    # Create empty table with specified number of rows
    df <- create_ma_empty_data(input$ma_type, input$ma_outcome, n_studies)
    ma_data(df)
  })
  
  # Render the data table using rHandsontable
  output$ma_datatable <- renderRHandsontable({
    rhandsontable(ma_data(), stretchH = "all", height = 300) %>%
      hot_table(highlightRow = TRUE, highlightCol = TRUE) %>%
      hot_context_menu(allowRowEdit = TRUE, allowColEdit = FALSE)
  })
  
  # Get updated data from the handsontable
  observe({
    if(!is.null(input$ma_datatable)){
      ma_data(hot_to_r(input$ma_datatable))
    }
  })
  
  # --------- MA ANALYSIS ---------
  meta_result <- eventReactive(input$ma_run, {
    updateTabItems(session, "sidebar", "ma_results")
    
    df <- ma_data()
    
    # Remove rows with NA values in essential columns (but keep RegVar even if NA)
    if(input$ma_type == "Contrast-based" && input$ma_outcome == "Biến liên tục") {
      df <- df[!is.na(df$Study) & !is.na(df$ES) & !is.na(df$ll) & !is.na(df$ul), ]
    } else if(input$ma_type == "Contrast-based" && input$ma_outcome == "Biến phân loại") {
      df <- df[!is.na(df$Study) & !is.na(df$ES) & !is.na(df$ll) & !is.na(df$ul), ]
    } else if(input$ma_type == "Arm-based" && input$ma_outcome == "Biến liên tục") {
      df <- df[!is.na(df$Study) & !is.na(df$Exp_N) & !is.na(df$Exp_Mean) & !is.na(df$Exp_SD) &
                 !is.na(df$Ctrl_N) & !is.na(df$Ctrl_Mean) & !is.na(df$Ctrl_SD), ]
    } else { # Arm-based & Biến phân loại
      df <- df[!is.na(df$Study) & !is.na(df$Exp_Event) & !is.na(df$Exp_N) & 
                 !is.na(df$Ctrl_Event) & !is.na(df$Ctrl_N), ]
    }
    
    if (nrow(df) < 3) {
      return(structure(list(error="Cần ít nhất 3 dòng dữ liệu đầy đủ!"), class="error"))
    }
    
    if (input$ma_type == "Contrast-based" && input$ma_outcome == "Biến liên tục") {
      # Calculate seTE from ll and ul
      df$TE <- df$ES
      df$seTE <- (df$ul - df$ll) / (2 * 1.96)
      
      tryCatch(
        meta::metagen(
          TE, seTE, 
          data = df, 
          studlab = Study, 
          sm = "SMD",
          common = (input$ma_model == "Tác động cố định (fixed-effects)"),
          random = (input$ma_model == "Tác động ngẫu nhiên (random-effects)")
        ),
        error = function(e) structure(list(error = e$message), class = "error")
      )
    } else if (input$ma_type == "Contrast-based" && input$ma_outcome == "Biến phân loại") {
      # Calculate seTE from ll and ul
      df$TE <- df$ES
      df$seTE <- (df$ul - df$ll) / (2 * 1.96)
      
      tryCatch(
        meta::metagen(
          TE, seTE, 
          data = df, 
          studlab = Study, 
          sm = "OR",
          common = (input$ma_model == "Tác động cố định (fixed-effects)"),
          random = (input$ma_model == "Tác động ngẫu nhiên (random-effects)")
        ),
        error = function(e) structure(list(error = e$message), class = "error")
      )
    } else if (input$ma_type == "Arm-based" && input$ma_outcome == "Biến liên tục") {
      tryCatch(
        meta::metacont(
          Exp_N, Exp_Mean, Exp_SD, 
          Ctrl_N, Ctrl_Mean, Ctrl_SD,
          data = df, 
          studlab = Study, 
          sm = "SMD",
          common = (input$ma_model == "Tác động cố định (fixed-effects)"),
          random = (input$ma_model == "Tác động ngẫu nhiên (random-effects)")
        ),
        error = function(e) structure(list(error = e$message), class = "error")
      )
    } else {
      tryCatch(
        meta::metabin(
          Exp_Event, Exp_N, 
          Ctrl_Event, Ctrl_N, 
          data = df, 
          studlab = Study, 
          sm = "OR",
          common = (input$ma_model == "Tác động cố định (fixed-effects)"),
          random = (input$ma_model == "Tác động ngẫu nhiên (random-effects)")
        ),
        error = function(e) structure(list(error = e$message), class = "error")
      )
    }
  })
  
  # Helper function to generate interpretation of meta-analysis results
  generate_ma_interpretation <- function(res) {
    # Check if result is valid
    if (inherits(res, "error")) {
      return("<div class='alert alert-danger'>Không thể tạo biện giải do lỗi phân tích.</div>")
    }
    
    # Extract key statistics
    effect_measure <- res$sm
    effect_type <- if(effect_measure == "SMD") "biến liên tục" else "biến phân loại"
    effect_size <- res$TE.random
    effect_lower <- res$lower.random
    effect_upper <- res$upper.random
    p_value <- res$pval.random
    i_squared <- res$I2 * 100
    q_p_value <- res$pval.Q
    n_studies <- length(res$TE)
    
    # Lấy đúng loại mô hình đang được sử dụng
    model <- ifelse(input$ma_model == "Tác động ngẫu nhiên (random-effects)", 
                    "tác động ngẫu nhiên", "tác động cố định")
    
    # Create interpretation
    html_content <- paste0(
      "<div style='margin-top: 20px; padding: 10px; background-color: #e6f7ff; border-left: 4px solid #1890ff;'>",
      "<h4 style='color: #1890ff;'>🔍 Biện giải kết quả cho dữ liệu hiện tại:</h4>"
    )
    
    # Number of studies
    html_content <- paste0(html_content,
                           "<p>Phân tích gộp bao gồm <b>", n_studies, " nghiên cứu</b> với mô hình <b>", model, "</b>.</p>"
    )
    
    # Effect size interpretation
    if (effect_measure == "SMD") {
      effect_strength <- ifelse(abs(effect_size) < 0.2, "không đáng kể",
                                ifelse(abs(effect_size) < 0.5, "nhỏ",
                                       ifelse(abs(effect_size) < 0.8, "trung bình", "lớn")))
      
      effect_direction <- ifelse(effect_size > 0, "thuận lợi cho nhóm can thiệp", "thuận lợi cho nhóm chứng")
      
      html_content <- paste0(html_content,
                             "<p><b>Mức độ ảnh hưởng gộp:</b> SMD = ", round(effect_size, 2), 
                             " (95% CI: ", round(effect_lower, 2), " đến ", round(effect_upper, 2), "), ",
                             "cho thấy mức độ ảnh hưởng <b>", effect_strength, "</b> và ", 
                             ifelse(p_value < 0.05, 
                                    paste0("<b>có ý nghĩa thống kê</b> (p = ", format(p_value, digits=3), "), "), 
                                    paste0("<b>không có ý nghĩa thống kê</b> (p = ", format(p_value, digits=3), "), ")),
                             "hướng ", effect_direction, ".</p>"
      )
    } else {
      # For OR interpretation
      or_value <- exp(effect_size)
      or_lower <- exp(effect_lower)
      or_upper <- exp(effect_upper)
      
      effect_direction <- ifelse(or_value > 1, "tăng", "giảm")
      
      html_content <- paste0(html_content,
                             "<p><b>Mức độ ảnh hưởng gộp:</b> OR = ", round(or_value, 2), 
                             " (95% CI: ", round(or_lower, 2), " đến ", round(or_upper, 2), "), ",
                             "cho thấy nhóm can thiệp có nguy cơ <b>", effect_direction, "</b> ",
                             abs(round((or_value - 1) * 100, 1)), "% so với nhóm chứng và kết quả này ",
                             ifelse(p_value < 0.05, 
                                    "<b>có ý nghĩa thống kê</b>", 
                                    "<b>không có ý nghĩa thống kê</b>"),
                             " (p = ", format(p_value, digits=3), ").</p>"
      )
    }
    
    # Heterogeneity interpretation
    het_level <- ifelse(i_squared < 25, "thấp",
                        ifelse(i_squared < 50, "trung bình",
                               ifelse(i_squared < 75, "đáng kể", "cao")))
    
    html_content <- paste0(html_content,
                           "<p><b>Tính bất đồng nhất:</b> I² = ", round(i_squared, 1), "%, cho thấy mức độ bất đồng nhất <b>", het_level, "</b> ",
                           "giữa các nghiên cứu. Kiểm định Q cho thấy sự bất đồng nhất ",
                           ifelse(q_p_value < 0.1, 
                                  paste0("<b>có ý nghĩa thống kê</b> (p = ", format(q_p_value, digits=3), ")."),
                                  paste0("<b>không có ý nghĩa thống kê</b> (p = ", format(q_p_value, digits=3), ").")),
                           "</p>"
    )
    
    # Model recommendation
    html_content <- paste0(html_content,
                           "<p><b>Gợi ý:</b> ", 
                           ifelse(i_squared > 50 || q_p_value < 0.1,
                                  "Với mức độ bất đồng nhất đáng kể, nên sử dụng mô hình <b>tác động ngẫu nhiên</b>.",
                                  "Với mức độ bất đồng nhất thấp, có thể xem xét sử dụng mô hình <b>tác động cố định</b>, nhưng mô hình tác động ngẫu nhiên vẫn thường được ưa chuộng hơn trong các nghiên cứu y học."),
                           "</p></div>"
    )
    
    return(html_content)
  }
  
  # Generate forest plot interpretation
  generate_forest_interpretation <- function(res) {
    if (inherits(res, "error")) {
      return("<div class='alert alert-danger'>Không thể tạo biện giải do lỗi phân tích.</div>")
    }
    
    # Extract information from results
    n_studies <- length(res$TE)
    n_significant <- sum((res$lower > 0 & res$TE > 0) | (res$upper < 0 & res$TE < 0))
    effect_size <- res$TE.random
    effect_lower <- res$lower.random
    effect_upper <- res$upper.random
    p_value <- res$pval.random
    i_squared <- res$I2 * 100
    
    # Create interpretation
    html_content <- paste0(
      "<div style='margin-top: 20px; padding: 10px; background-color: #e6f7ff; border-left: 4px solid #1890ff;'>",
      "<h4 style='color: #1890ff;'>🔍 Biện giải biểu đồ rừng cho dữ liệu hiện tại:</h4>"
    )
    
    # Distribution of studies
    html_content <- paste0(html_content,
                           "<p>Biểu đồ rừng trình bày kết quả từ ", n_studies, " nghiên cứu độc lập. ",
                           "Có ", n_significant, " nghiên cứu (", round(n_significant/n_studies*100), "%) ",
                           "cho thấy kết quả có ý nghĩa thống kê (khoảng tin cậy 95% không cắt qua đường không hiệu ứng).</p>"
    )
    
    # Overall effect interpretation
    sig_overall <- (effect_lower > 0 && effect_size > 0) || (effect_upper < 0 && effect_size < 0)
    html_content <- paste0(html_content,
                           "<p><b>Mức độ ảnh hưởng gộp (hình thoi ♦):</b> Mức độ ảnh hưởng gộp ",
                           ifelse(sig_overall, 
                                  "có ý nghĩa thống kê vì khoảng tin cậy 95% không cắt qua đường không hiệu ứng", 
                                  "không có ý nghĩa thống kê vì khoảng tin cậy 95% cắt qua đường không hiệu ứng"),
                           ".</p>"
    )
    
    # Variation in studies
    html_content <- paste0(html_content,
                           "<p><b>Biến thiên giữa các nghiên cứu:</b> Biểu đồ cho thấy ",
                           ifelse(i_squared < 25, "sự đồng nhất cao giữa các nghiên cứu", 
                                  ifelse(i_squared < 50, "sự biến thiên trung bình giữa các nghiên cứu", 
                                         "sự biến thiên lớn giữa các nghiên cứu")),
                           ", với I² = ", round(i_squared, 1), "%.</p>"
    )
    
    # Weights interpretation
    html_content <- paste0(html_content,
                           "<p><b>Trọng số nghiên cứu:</b> Kích thước của các hình vuông/hình tròn thể hiện trọng số của từng nghiên cứu. ",
                           "Nghiên cứu có cỡ mẫu lớn hơn và/hoặc độ biến thiên nhỏ hơn sẽ có trọng số lớn hơn và tác động nhiều hơn đến kết quả tổng hợp.</p>"
    )
    
    # Recommendation
    html_content <- paste0(html_content,
                           "<p><b>Kết luận:</b> Dựa trên biểu đồ rừng, có thể kết luận rằng mức độ ảnh hưởng gộp ",
                           ifelse(sig_overall, "đáng tin cậy", "cần được diễn giải thận trọng"),
                           " với mức độ bất đồng nhất ", 
                           ifelse(i_squared < 50, "chấp nhận được.", "đáng kể, có thể cần thêm phân tích gộp hồi quy để xác định nguồn gốc của sự bất đồng nhất."),
                           "</p></div>"
    )
    
    return(html_content)
  }
  
  # Generate publication bias interpretation
  generate_bias_interpretation <- function(res, egger_res) {
    if (inherits(res, "error")) {
      return("<div class='alert alert-danger'>Không thể tạo biện giải do lỗi phân tích.</div>")
    }
    
    # Extract information
    n_studies <- length(res$TE)
    egger_p <- NA
    egger_intercept <- NA
    
    if (!is.null(egger_res) && !inherits(egger_res, "error")) {
      if ("p.value" %in% names(egger_res)) {
        egger_p <- egger_res$p.value
      }
      if ("estimate" %in% names(egger_res)) {
        egger_intercept <- egger_res$estimate[1]
      }
    }
    
    # Interpret funnel plot based on visual examination and Egger's test
    html_content <- paste0(
      "<div style='margin-top: 20px; padding: 10px; background-color: #e6f7ff; border-left: 4px solid #1890ff;'>",
      "<h4 style='color: #1890ff;'>🔍 Biện giải sai lệch xuất bản cho dữ liệu hiện tại:</h4>"
    )
    
    # Number of studies interpretation
    html_content <- paste0(html_content,
                           "<p>Phân tích sai lệch xuất bản dựa trên ", n_studies, " nghiên cứu. ",
                           ifelse(n_studies < 10, 
                                  "<b>Lưu ý quan trọng:</b> Số lượng nghiên cứu nhỏ hơn 10 có thể làm giảm độ tin cậy của các phương pháp đánh giá sai lệch xuất bản.",
                                  ""),
                           "</p>"
    )
    
    # Egger's test interpretation
    if (!is.na(egger_p)) {
      html_content <- paste0(html_content,
                             "<p><b>Kiểm định Egger:</b> ",
                             ifelse(egger_p < 0.05,
                                    paste0("Kết quả có ý nghĩa thống kê (p = ", format(egger_p, digits=3), "), cho thấy có bằng chứng về sai lệch xuất bản."),
                                    paste0("Kết quả không có ý nghĩa thống kê (p = ", format(egger_p, digits=3), "), không phát hiện bằng chứng rõ ràng về sai lệch xuất bản.")),
                             "</p>"
      )
      
      if (!is.na(egger_intercept)) {
        bias_direction <- ifelse(egger_intercept > 0, "thiếu các nghiên cứu có kết quả âm tính", "thiếu các nghiên cứu có kết quả dương tính")
        html_content <- paste0(html_content,
                               "<p>Hệ số chặn (intercept) của Egger = ", round(egger_intercept, 2),
                               ", gợi ý khả năng ", bias_direction, ".</p>"
        )
      }
    } else {
      html_content <- paste0(html_content,
                             "<p><b>Kiểm định Egger:</b> Không thể thực hiện kiểm định Egger do số lượng nghiên cứu ít hoặc dữ liệu không phù hợp.</p>"
      )
    }
    
    # Trim-and-fill interpretation
    html_content <- paste0(html_content,
                           "<p><b>Phương pháp trim-and-fill:</b> Phương pháp này ước tính các nghiên cứu có thể bị thiếu (hiển thị bằng các điểm rỗng trên biểu đồ). ",
                           "Nếu mức độ ảnh hưởng gộp thay đổi đáng kể sau khi thêm các nghiên cứu ước tính, kết quả phân tích gộp có thể bị ảnh hưởng bởi sai lệch xuất bản.</p>"
    )
    
    # Overall assessment
    html_content <- paste0(html_content,
                           "<p><b>Đánh giá tổng thể:</b> ",
                           ifelse(is.na(egger_p) || n_studies < 10,
                                  "Cần thận trọng khi diễn giải kết quả do số lượng nghiên cứu hạn chế.",
                                  ifelse(egger_p < 0.05,
                                         "Có bằng chứng về sai lệch xuất bản, điều này có thể ảnh hưởng đến tính giá trị của kết quả phân tích gộp.",
                                         "Không có bằng chứng mạnh mẽ về sai lệch xuất bản, tăng độ tin cậy của kết quả phân tích gộp.")),
                           "</p></div>"
    )
    
    return(html_content)
  }
  
  # Generate meta-regression interpretation
  generate_metareg_interpretation <- function(mr_result) {
    # Kiểm tra xem kết quả có hợp lệ không
    if (is.null(mr_result) || inherits(mr_result, "try-error") || !inherits(mr_result, "rma")) {
      return("<div class='alert alert-danger'>Không thể tạo biện giải do lỗi phân tích.</div>")
    }
    
    # Trích xuất thông tin cơ bản và xử lý các giá trị NA hoặc NULL
    mod_name <- ifelse(is.null(mr_result$formula), "RegVar", names(mr_result$beta)[2])
    mod_coef <- tryCatch(mr_result$beta[2], error = function(e) NA)
    mod_p <- tryCatch(mr_result$pval[2], error = function(e) NA)
    mod_ci_lower <- tryCatch(mr_result$ci.lb[2], error = function(e) NA)
    mod_ci_upper <- tryCatch(mr_result$ci.ub[2], error = function(e) NA)
    r2_value <- tryCatch(mr_result$R2, error = function(e) 0)
    if (is.null(r2_value) || is.na(r2_value)) r2_value <- 0
    
    i2_before <- NA
    i2_after <- NA
    
    # Tính tỷ lệ giảm bất đồng nhất
    tryCatch({
      i2_before <- mr_result$I2
      i2_after <- ifelse(is.null(mr_result$I2.resid), NA, mr_result$I2.resid)
      if (is.na(i2_after)) i2_after <- i2_before  # Nếu không có I2 residual, dùng I2 ban đầu
    }, error = function(e) {
      i2_before <- NA
      i2_after <- NA
    })
    
    # Tạo nội dung HTML biện giải
    html_content <- paste0(
      "<div style='margin-top: 20px; padding: 15px; background-color: #f8f9fa; border-left: 4px solid #28a745;'>",
      "<h4 style='color: #28a745;'>🔍 Biện giải kết quả phân tích gộp hồi quy:</h4>"
    )
    
    # Thông tin về biến điều chỉnh và hướng tác động
    if (!is.na(mod_coef)) {
      html_content <- paste0(html_content,
                             "<p><b>1. Hệ số hồi quy</b> cho biến <i>", mod_name, "</i> là <b>", round(mod_coef, 3), "</b> ",
                             "(95% CI: ", round(mod_ci_lower, 3), " đến ", round(mod_ci_upper, 3), "). ",
                             "Điều này có nghĩa là ",
                             ifelse(mod_coef > 0,
                                    paste0("khi <i>", mod_name, "</i> tăng lên, mức độ ảnh hưởng của can thiệp có xu hướng <b>tăng</b>."),
                                    paste0("khi <i>", mod_name, "</i> tăng lên, mức độ ảnh hưởng của can thiệp có xu hướng <b>giảm</b>.")),
                             "</p>"
      )
    } else {
      html_content <- paste0(html_content,
                             "<p><b>1. Hệ số hồi quy:</b> Không thể trích xuất hệ số hồi quy từ kết quả.</p>"
      )
    }
    
    # Ý nghĩa thống kê
    if (!is.na(mod_p)) {
      html_content <- paste0(html_content,
                             "<p><b>2. Ý nghĩa thống kê:</b> Với giá trị p = ", round(mod_p, 3), ", ",
                             ifelse(mod_p < 0.05,
                                    paste0("biến <i>", mod_name, "</i> có <b>liên quan đáng kể</b> đến mức độ ảnh hưởng của can thiệp (p < 0.05)."),
                                    paste0("biến <i>", mod_name, "</i> <b>không có liên quan đáng kể</b> đến mức độ ảnh hưởng của can thiệp (p ≥ 0.05).")),
                             " Khoảng tin cậy 95% ",
                             ifelse(!is.na(mod_ci_lower) && !is.na(mod_ci_upper) && mod_ci_lower * mod_ci_upper <= 0,
                                    "<b>chứa giá trị 0</b>, xác nhận thêm rằng không có bằng chứng thống kê về mối liên hệ.",
                                    "<b>không chứa giá trị 0</b>, xác nhận thêm về ý nghĩa thống kê của mối liên hệ."
                             ),
                             "</p>"
      )
    } else {
      html_content <- paste0(html_content,
                             "<p><b>2. Ý nghĩa thống kê:</b> Không thể trích xuất giá trị p từ kết quả.</p>"
      )
    }
    
    # R² và tính bất đồng nhất còn lại - SỬA LỖI PHẦN NÀY
    r2_text <- ifelse(is.na(r2_value),
                      "Không thể trích xuất giá trị R² từ kết quả.",
                      paste0("Biến <i>", mod_name, "</i> giải thích <b>", round(r2_value, 1), 
                             "%</b> tính bất đồng nhất giữa các nghiên cứu. "))
    
    r2_interpretation <- ""
    if(!is.na(r2_value)) {
      if(r2_value < 10) {
        r2_interpretation <- "Đây là tỷ lệ <b>rất thấp</b>, cho thấy biến này giải thích được rất ít sự khác biệt giữa các nghiên cứu."
      } else if(r2_value < 30) {
        r2_interpretation <- "Đây là tỷ lệ <b>thấp đến trung bình</b>, cho thấy biến này giải thích được một phần nhỏ sự khác biệt giữa các nghiên cứu."
      } else if(r2_value < 60) {
        r2_interpretation <- "Đây là tỷ lệ <b>trung bình đến cao</b>, cho thấy biến này giải thích được một phần đáng kể sự khác biệt giữa các nghiên cứu."
      } else {
        r2_interpretation <- "Đây là tỷ lệ <b>rất cao</b>, cho thấy biến này giải thích được phần lớn sự khác biệt giữa các nghiên cứu."
      }
    }
    
    html_content <- paste0(html_content,
                           "<p><b>3. Khả năng giải thích tính bất đồng nhất (R²):</b> ",
                           r2_text,
                           r2_interpretation,
                           "</p>")
    
    # Tính bất đồng nhất trước và sau
    if (!is.na(i2_before)) {
      html_content <- paste0(html_content,
                             "<p><b>4. Tính bất đồng nhất:</b> ",
                             "I² ban đầu là <b>", round(i2_before, 1), "%</b>"
      )
      
      if (!is.na(i2_after)) {
        html_content <- paste0(html_content,
                               " và I² còn lại sau khi đưa biến <i>", mod_name, "</i> vào mô hình là <b>",
                               round(i2_after, 1), "%</b>. ",
                               ifelse(i2_before > i2_after,
                                      paste0("Điều này cho thấy biến này giúp giải thích được <b>", round(i2_before - i2_after, 1), 
                                             "% điểm</b> của tính bất đồng nhất."),
                                      "Không có sự giảm tính bất đồng nhất khi đưa biến này vào mô hình."
                               )
        )
      }
      
      html_content <- paste0(html_content, "</p>")
    }
    
    # Kết luận
    conclusion <- ""
    if(!is.na(mod_p) && !is.na(r2_value)) {
      if(mod_p < 0.05 && r2_value > 10) {
        conclusion <- paste0("Biến <i>", mod_name, "</i> có <b>tác động đáng kể</b> đến mức độ ảnh hưởng của can thiệp và giải thích được một phần tính bất đồng nhất giữa các nghiên cứu.")
      } else if(mod_p < 0.05 && r2_value <= 10) {
        conclusion <- paste0("Mặc dù biến <i>", mod_name, "</i> có <b>liên quan đáng kể về mặt thống kê</b> với mức độ ảnh hưởng, nhưng nó chỉ giải thích được rất ít tính bất đồng nhất giữa các nghiên cứu.")
      } else if(mod_p >= 0.05 && r2_value > 10) {
        conclusion <- paste0("Mặc dù biến <i>", mod_name, "</i> <b>không có liên quan đáng kể về mặt thống kê</b>, nhưng nó vẫn có thể giải thích một phần sự khác biệt giữa các nghiên cứu. Nên thận trọng khi diễn giải kết quả này.")
      } else {
        conclusion <- paste0("Biến <i>", mod_name, "</i> <b>không có liên quan đáng kể</b> đến mức độ ảnh hưởng của can thiệp và giải thích được rất ít tính bất đồng nhất giữa các nghiên cứu.")
      }
    } else {
      conclusion <- "Không đủ thông tin để đưa ra kết luận về mối liên hệ giữa biến và mức độ ảnh hưởng."
    }
    
    html_content <- paste0(html_content,
                           "<p><b>5. Kết luận:</b> ",
                           conclusion,
                           "</p>",
                           "<p><i>Lưu ý: Phân tích gộp hồi quy chỉ thiết lập mối liên quan, không chứng minh quan hệ nhân quả. Kết quả cần được diễn giải trong bối cảnh lâm sàng và ý nghĩa thực tiễn.</i></p>",
                           "</div>")
    
    return(html_content)
  }
  
  # Display results
  output$ma_summary <- renderPrint({
    res <- meta_result()
    if (inherits(res, "error")) {
      cat("Lỗi phân tích hoặc thiếu dữ liệu:", res$error)
    } else {
      print(res)
    }
  })
  
  # Generate interpretation of meta-analysis results
  output$ma_results_interpretation_actual <- renderUI({
    res <- meta_result()
    HTML(generate_ma_interpretation(res))
  })
  
  # Forest plot
  output$ma_forest <- renderPlot({
    res <- meta_result()
    if (!inherits(res, "error") && inherits(res, "meta")) {
      meta::forest(res, main = "Biểu đồ rừng (forest plot)")
    }
  })
  
  # Generate forest plot interpretation
  output$ma_forest_interpretation_actual <- renderUI({
    res <- meta_result()
    HTML(generate_forest_interpretation(res))
  })
  
  # Funnel plot
  output$ma_funnel <- renderPlot({
    res <- meta_result()
    if (!inherits(res, "error") && inherits(res, "meta")) {
      meta::funnel(res, main = "Biểu đồ phễu (funnel plot)")
    }
  })
  
  # Egger test result
  egger_result <- reactive({
    res <- meta_result()
    if (!inherits(res, "error") && inherits(res, "meta")) {
      tryCatch({
        egger <- meta::metabias(res, method.bias = "linreg")
        return(egger)
      }, error = function(e) NULL)
    } else {
      return(NULL)
    }
  })
  
  # Egger test
  output$ma_egger <- renderPrint({
    res <- meta_result()
    if (!inherits(res, "error") && inherits(res, "meta")) {
      cat("Kiểm định Egger cho sai lệch công bố:\n")
      egger_res <- tryCatch(meta::metabias(res, method.bias="linreg"), error=function(e) e)
      if (inherits(egger_res, "error")) {
        cat("Không thể thực hiện kiểm định Egger. Lỗi:", egger_res$message)
      } else {
        print(egger_res)
      }
    }
  })
  
  # Trim-and-fill plot
  output$ma_trimfill <- renderPlot({
    res <- meta_result()
    if (!inherits(res, "error") && inherits(res, "meta")) {
      tf <- tryCatch(meta::trimfill(res), error=function(e) NULL)
      if (!is.null(tf)) meta::funnel(tf, main = "Biểu đồ phễu hiệu chỉnh (trim-and-fill funnel plot)")
    }
  })
  
  # Generate publication bias interpretation
  output$ma_bias_interpretation_actual <- renderUI({
    res <- meta_result()
    egger <- egger_result()
    HTML(generate_bias_interpretation(res, egger))
  })
  
  # ----- META-REGRESSION -----
  output$ma_metareg_var_selector <- renderUI({
    df <- ma_data()
    
    # Kiểm tra xem có cột RegVar không
    if ("RegVar" %in% names(df)) {
      # Kiểm tra xem có dữ liệu RegVar không NA không
      if (any(!is.na(df$RegVar))) {
        selectInput("ma_metareg_var", "Chọn biến cho phân tích hồi quy:", 
                    choices = c("RegVar"), 
                    selected = "RegVar")
      } else {
        HTML("<div class='alert alert-warning'>Không có dữ liệu trong biến RegVar. Vui lòng nhập dữ liệu vào cột RegVar.</div>")
      }
    } else {
      HTML("<div class='alert alert-warning'>Không có biến RegVar trong dữ liệu. Vui lòng sử dụng cấu trúc dữ liệu có chứa cột RegVar.</div>")
    }
  })
  
  ma_metareg_result <- eventReactive(input$ma_run_metareg, {
    ma_res <- meta_result()
    
    if(inherits(ma_res, "error")) {
      return(structure(list(error="Cần chạy phân tích gộp trước!"), class="error"))
    }
    
    df <- ma_data()
    
    # Lọc các dòng thiếu dữ liệu cần thiết
    df <- df[!is.na(df$RegVar), ]
    
    if (!input$ma_do_metareg || is.null(input$ma_metareg_var)) {
      return(structure(list(error="Vui lòng chọn biến cho phân tích hồi quy"), class="error"))
    }
    
    if (nrow(df) < 3) {
      return(structure(list(error="Cần ít nhất 3 nghiên cứu có dữ liệu RegVar để thực hiện phân tích hồi quy"), class="error"))
    }
    
    # Kiểm tra xem biến đã chọn có tồn tại không
    if (!input$ma_metareg_var %in% names(df)) {
      return(structure(list(error=paste("Biến", input$ma_metareg_var, "không tồn tại trong dữ liệu")), class="error"))
    }
    
    # Thực hiện meta-regression với các nghiên cứu có dữ liệu RegVar
    tryCatch({
      mr <- meta::metareg(ma_res, formula = as.formula(paste("~", input$ma_metareg_var)))
      return(mr)
    }, error = function(e) {
      return(structure(list(error=paste("Lỗi phân tích hồi quy:", e$message)), class="error"))
    })
  })
  
  output$ma_metareg_result <- renderPrint({
    res <- ma_metareg_result()
    if (inherits(res, "error")) {
      cat("Lỗi phân tích gộp hồi quy:", res$error)
    } else {
      print(res)
    }
  })
  
  output$ma_metareg_plot <- renderPlot({
    res <- ma_metareg_result()
    if (!inherits(res, "error") && inherits(res, "metareg")) {
      meta::bubble(res, studlab = TRUE, main = "Biểu đồ nổi bọt phân tích gộp hồi quy")
    }
  })
  
  # Generate meta-regression interpretation
  output$ma_metareg_interpretation_actual <- renderUI({
    mr_result <- ma_metareg_result()
    if (!is.null(mr_result) && !inherits(mr_result, "try-error")) {
      tryCatch({
        HTML(generate_metareg_interpretation(mr_result))
      }, error = function(e) {
        HTML(paste0("<div class='alert alert-danger'>Lỗi khi biện giải: ", e$message, 
                    ". Vui lòng kiểm tra lại dữ liệu.</div>"))
      })
    } else {
      HTML("<div class='alert alert-danger'>Không thể tạo biện giải đầy đủ cho kết quả phân tích gộp hồi quy. Có thể do dữ liệu không đủ hoặc cấu trúc không phù hợp.</div>")
    }
  })
  
  # Trả về các reactive values để có thể dùng ở nơi khác nếu cần
  return(list(
    ma_data = ma_data,
    meta_result = meta_result,
    ma_metareg_result = ma_metareg_result
  ))
}