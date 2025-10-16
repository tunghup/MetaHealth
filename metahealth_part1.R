# ---------- DỮ LIỆU MẪU ----------
get_ma_sample <- function(type, outcome) {
  if (type == "Contrast-based" && outcome == "Biến liên tục") {
    te_values <- rnorm(10, 0, 0.4)
    half_width <- runif(10, 0.3, 0.6)
    data.frame(
      Study = paste0("Nghiên cứu ", LETTERS[1:10]),
      ES = te_values,
      ll = te_values - half_width,
      ul = te_values + half_width,
      RegVar = sample(40:65, 10, replace=TRUE),
      stringsAsFactors = FALSE
    )
  } else if (type == "Contrast-based" && outcome == "Biến phân loại") {
    te_values <- log(runif(10, 0.5, 2))
    half_width <- runif(10, 0.3, 0.6)
    data.frame(
      Study = paste0("Nghiên cứu ", LETTERS[1:10]),
      ES = te_values,
      ll = te_values - half_width,
      ul = te_values + half_width,
      RegVar = sample(40:65, 10, replace=TRUE), # Thêm RegVar cho biến phân loại
      stringsAsFactors = FALSE
    )
  } else if (type == "Arm-based" && outcome == "Biến liên tục") {
    data.frame(
      Study = paste0("Nghiên cứu ", LETTERS[1:10]),
      Exp_N = sample(40:80, 10, replace=TRUE),
      Exp_Mean = rnorm(10, 1, 0.2),
      Exp_SD = runif(10, 0.3, 0.5),
      Ctrl_N = sample(40:80, 10, replace=TRUE),
      Ctrl_Mean = rnorm(10, 0.7, 0.2),
      Ctrl_SD = runif(10, 0.3, 0.5),
      RegVar = sample(40:65, 10, replace=TRUE),
      stringsAsFactors = FALSE
    )
  } else {
    data.frame(
      Study = paste0("Nghiên cứu ", LETTERS[1:10]),
      Exp_Event = sample(10:30, 10, TRUE), 
      Exp_N = sample(40:80, 10, TRUE),
      Ctrl_Event = sample(10:30, 10, TRUE), 
      Ctrl_N = sample(40:80, 10, TRUE),
      RegVar = sample(40:65, 10, replace=TRUE), # Thêm RegVar cho biến phân loại
      stringsAsFactors = FALSE
    )
  }
}

# Function to create empty data frame with specified number of rows
create_ma_empty_data <- function(type, outcome, n_studies) {
  if (type == "Contrast-based" && outcome == "Biến liên tục") {
    df <- data.frame(
      Study = paste0("Nghiên cứu ", 1:n_studies),
      ES = rep(NA_real_, n_studies),
      ll = rep(NA_real_, n_studies),
      ul = rep(NA_real_, n_studies),
      RegVar = rep(NA_real_, n_studies), # RegVar là tùy chọn
      stringsAsFactors = FALSE
    )
  } else if (type == "Contrast-based" && outcome == "Biến phân loại") {
    df <- data.frame(
      Study = paste0("Nghiên cứu ", 1:n_studies),
      ES = rep(NA_real_, n_studies),
      ll = rep(NA_real_, n_studies),
      ul = rep(NA_real_, n_studies),
      RegVar = rep(NA_real_, n_studies), # RegVar là tùy chọn
      stringsAsFactors = FALSE
    )
  } else if (type == "Arm-based" && outcome == "Biến liên tục") {
    df <- data.frame(
      Study = paste0("Nghiên cứu ", 1:n_studies),
      Exp_N = rep(NA_real_, n_studies),
      Exp_Mean = rep(NA_real_, n_studies),
      Exp_SD = rep(NA_real_, n_studies),
      Ctrl_N = rep(NA_real_, n_studies),
      Ctrl_Mean = rep(NA_real_, n_studies),
      Ctrl_SD = rep(NA_real_, n_studies),
      RegVar = rep(NA_real_, n_studies), # RegVar là tùy chọn
      stringsAsFactors = FALSE
    )
  } else {
    df <- data.frame(
      Study = paste0("Nghiên cứu ", 1:n_studies),
      Exp_Event = rep(NA_real_, n_studies),
      Exp_N = rep(NA_real_, n_studies),
      Ctrl_Event = rep(NA_real_, n_studies),
      Ctrl_N = rep(NA_real_, n_studies),
      RegVar = rep(NA_real_, n_studies), # RegVar là tùy chọn
      stringsAsFactors = FALSE
    )
  }
  
  return(df)
}

# Hàm tạo dữ liệu mẫu contrast-based với số nhóm linh hoạt
create_contrast_nma_data <- function(outcome) {
  set.seed(123)  # Để kết quả reproducible
  
  # Tạo dữ liệu mẫu với cấu trúc đa dạng: 
  # - Nghiên cứu 1: 2 nhóm (A-B)
  # - Nghiên cứu 2: 3 nhóm (A-B-C) => 3 so sánh
  # - Nghiên cứu 3: 2 nhóm (B-C)
  if (outcome == "Biến liên tục") {
    # Định nghĩa dữ liệu cho biến liên tục
    data.frame(
      Study = c("Nghiên cứu 1", "Nghiên cứu 2", "Nghiên cứu 2", "Nghiên cứu 2", "Nghiên cứu 3"),
      Treat1 = c("A", "A", "A", "B", "B"),
      Treat2 = c("B", "B", "C", "C", "C"),
      ES = c(0.5, 0.4, 0.8, 0.3, 0.6),  # SMD values
      ll = c(0.2, 0.1, 0.5, 0.0, 0.3),
      ul = c(0.8, 0.7, 1.1, 0.6, 0.9),
      stringsAsFactors = FALSE
    )
  } else {
    # Định nghĩa dữ liệu cho biến phân loại (log odds ratios)
    data.frame(
      Study = c("Nghiên cứu 1", "Nghiên cứu 2", "Nghiên cứu 2", "Nghiên cứu 2", "Nghiên cứu 3"),
      Treat1 = c("A", "A", "A", "B", "B"),
      Treat2 = c("B", "B", "C", "C", "C"),
      ES = c(0.3, 0.2, 0.5, 0.25, 0.4),  # log(OR) values
      ll = c(0.1, 0.0, 0.3, 0.0, 0.2),
      ul = c(0.5, 0.4, 0.7, 0.5, 0.6),
      stringsAsFactors = FALSE
    )
  }
}

# Hàm tạo dữ liệu mẫu arm-based với số nhóm linh hoạt
create_arm_nma_data <- function(outcome) {
  set.seed(123)
  
  # Tạo dữ liệu mẫu với cấu trúc đa dạng:
  # - Nghiên cứu 1: 2 nhóm (A, B)
  # - Nghiên cứu 2: 3 nhóm (A, B, C)
  # - Nghiên cứu 3: 2 nhóm (B, C)
  if (outcome == "Biến liên tục") {
    data.frame(
      Study = c("Nghiên cứu 1", "Nghiên cứu 1", 
                "Nghiên cứu 2", "Nghiên cứu 2", "Nghiên cứu 2",
                "Nghiên cứu 3", "Nghiên cứu 3"),
      Treatment = c("A", "B", "A", "B", "C", "B", "C"),
      N = c(60, 65, 70, 72, 68, 80, 75),
      Mean = c(9.8, 8.9, 10.2, 9.1, 8.5, 9.3, 8.7),
      SD = c(1.5, 1.6, 1.4, 1.5, 1.3, 1.7, 1.6),
      stringsAsFactors = FALSE
    )
  } else {
    data.frame(
      Study = c("Nghiên cứu 1", "Nghiên cứu 1", 
                "Nghiên cứu 2", "Nghiên cứu 2", "Nghiên cứu 2",
                "Nghiên cứu 3", "Nghiên cứu 3"),
      Treatment = c("A", "B", "A", "B", "C", "B", "C"),
      Event = c(15, 20, 14, 18, 22, 19, 24),
      N = c(60, 65, 70, 72, 68, 80, 75),
      stringsAsFactors = FALSE
    )
  }
}

# Hàm để lấy dữ liệu mẫu NMA dựa trên loại dữ liệu
get_nma_sample <- function(type, outcome) {
  if (type == "Contrast-based") {
    return(create_contrast_nma_data(outcome))
  } else {
    return(create_arm_nma_data(outcome))
  }
}

# Hàm để tạo bảng dữ liệu NMA trống với số lượng arms linh hoạt theo nghiên cứu
create_nma_empty_data <- function(type, outcome, study_arms) {
  # Kiểm tra đầu vào
  if (!is.numeric(study_arms) || any(study_arms < 2)) {
    stop("study_arms phải là một vector số nguyên với mỗi giá trị >= 2")
  }
  
  # Khởi tạo data frame trống tùy thuộc vào loại dữ liệu
  if (type == "Contrast-based") {
    # Tính tổng số so sánh cần thiết
    total_comparisons <- sum(sapply(study_arms, function(n) n * (n - 1) / 2))
    
    result <- data.frame(
      Study = character(total_comparisons),
      Treat1 = character(total_comparisons),
      Treat2 = character(total_comparisons),
      ES = numeric(total_comparisons),
      ll = numeric(total_comparisons),
      ul = numeric(total_comparisons),
      stringsAsFactors = FALSE
    )
    
    # Điền dữ liệu
    index <- 1
    for (i in 1:length(study_arms)) {
      study_name <- paste("Nghiên cứu", i)
      n_arms <- study_arms[i]
      
      # Tạo tên các nhóm điều trị (A, B, C, ...)
      treatments <- LETTERS[1:n_arms]
      
      # Tạo tất cả các cặp so sánh có thể
      if (n_arms >= 2) {
        for (j in 1:(n_arms - 1)) {
          for (k in (j + 1):n_arms) {
            result$Study[index] <- study_name
            result$Treat1[index] <- treatments[j]
            result$Treat2[index] <- treatments[k]
            result$ES[index] <- NA
            result$ll[index] <- NA
            result$ul[index] <- NA
            index <- index + 1
          }
        }
      }
    }
    
    # Cắt bỏ các dòng thừa (nếu có)
    if(index > 1) {
      result <- result[1:(index - 1), ]
    }
    
  } else { # Arm-based data
    # Tính tổng số dòng cần thiết
    total_rows <- sum(study_arms)
    
    # Tạo data frame trống
    if (outcome == "Biến liên tục") {
      result <- data.frame(
        Study = character(total_rows),
        Treatment = character(total_rows),
        N = numeric(total_rows),
        Mean = numeric(total_rows),
        SD = numeric(total_rows),
        stringsAsFactors = FALSE
      )
    } else {
      result <- data.frame(
        Study = character(total_rows),
        Treatment = character(total_rows),
        Event = numeric(total_rows),
        N = numeric(total_rows),
        stringsAsFactors = FALSE
      )
    }
    
    # Điền dữ liệu
    index <- 1
    for (i in 1:length(study_arms)) {
      study_name <- paste("Nghiên cứu", i)
      n_arms <- study_arms[i]
      
      # Tạo tên các nhóm điều trị (A, B, C, ...)
      treatments <- LETTERS[1:n_arms]
      
      for (j in 1:n_arms) {
        result$Study[index] <- study_name
        result$Treatment[index] <- treatments[j]
        
        if (outcome == "Biến liên tục") {
          result$N[index] <- NA
          result$Mean[index] <- NA
          result$SD[index] <- NA
        } else {
          result$Event[index] <- NA
          result$N[index] <- NA
        }
        
        index <- index + 1
      }
    }
  }
  
  return(result)
}

# Hàm để kiểm tra các nhóm điều trị trùng lặp
check_duplicated_treatments <- function(df) {
  duplicates <- character(0)
  for (study in unique(df$Study)) {
    treatments <- df$Treatment[df$Study == study]
    if (any(duplicated(treatments))) {
      duplicates <- c(duplicates, study)
    }
  }
  return(duplicates)
}