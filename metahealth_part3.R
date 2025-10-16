## UI components

ma_input_tab <- tabItem(tabName = "ma_input",
                        fluidRow(
                          box(width = 12,
                              title = "Nhập dữ liệu cho phân tích gộp",
                              status = "primary", solidHeader = TRUE,
                              radioButtons("ma_data_mode", "Chọn dữ liệu:", 
                                           c("Dữ liệu mẫu"="sample","Dữ liệu tự nhập"="manual"), 
                                           inline=TRUE),
                              conditionalPanel(
                                condition = "input.ma_data_mode == 'manual'",
                                numericInput("ma_study_count", "Số lượng nghiên cứu:", 
                                             value = 5, min = 3, max = 100, step = 1),
                                actionButton("ma_generate_table", "Tạo bảng nhập liệu", 
                                             icon = icon("table"), class = "btn-primary")
                              ),
                              selectInput("ma_type", "Kiểu dữ liệu:", 
                                          c("Contrast-based" = "Contrast-based", 
                                            "Arm-based" = "Arm-based")),
                              selectInput("ma_outcome", "Kiểu kết quả:", 
                                          c("Biến liên tục" = "Biến liên tục", 
                                            "Biến phân loại" = "Biến phân loại")),
                              htmlOutput("ma_instr"),
                              rHandsontableOutput("ma_datatable"),
                              hr(),
                              fluidRow(
                                column(6, selectInput("ma_model", "Mô hình:", 
                                                      c("Tác động ngẫu nhiên (random-effects)",
                                                        "Tác động cố định (fixed-effects)"))),
                                column(6, actionButton("ma_run", "Chạy phân tích", 
                                                       icon = icon("play"), 
                                                       class = "btn-success", 
                                                       style = "margin-top: 25px;"))
                              )
                          )
                        )
)

ma_results_tab <- tabItem(tabName = "ma_results",
                          fluidRow(
                            box(width = 12, 
                                title = "Kết quả phân tích gộp", 
                                status = "success", solidHeader = TRUE,
                                verbatimTextOutput("ma_summary"),
                                meta_results_interpretation,
                                htmlOutput("ma_results_interpretation_actual")
                            )
                          )
)

ma_forest_tab <- tabItem(tabName = "ma_forest",
                         fluidRow(
                           box(width = 12, 
                               title = "Biểu đồ rừng (forest plot)", 
                               status = "info", solidHeader = TRUE,
                               plotOutput("ma_forest", height = 600),
                               forest_plot_interpretation,
                               htmlOutput("ma_forest_interpretation_actual")
                           )
                         )
)

ma_bias_tab <- tabItem(tabName = "ma_bias",
                       fluidRow(
                         box(width = 12, 
                             title = "Đánh giá sai lệch xuất bản", 
                             status = "warning", solidHeader = TRUE,
                             plotOutput("ma_funnel", height = 350),
                             verbatimTextOutput("ma_egger"),
                             plotOutput("ma_trimfill", height = 350),
                             publication_bias_interpretation,
                             htmlOutput("ma_bias_interpretation_actual")
                         )
                       )
)

ma_metareg_tab <- tabItem(tabName = "ma_metareg",
                          fluidRow(
                            box(width = 12, 
                                title = "Phân tích gộp hồi quy (Meta-regression)", 
                                status = "info", solidHeader = TRUE,
                                fluidRow(
                                  column(6,
                                         checkboxInput("ma_do_metareg", "Tiến hành phân tích gộp hồi quy", FALSE),
                                         conditionalPanel(
                                           condition = "input.ma_do_metareg == true",
                                           uiOutput("ma_metareg_var_selector")
                                         )
                                  ),
                                  column(6,
                                         conditionalPanel(
                                           condition = "input.ma_do_metareg == true",
                                           actionButton("ma_run_metareg", "Chạy phân tích hồi quy", 
                                                        icon = icon("calculator"), 
                                                        class = "btn-primary", 
                                                        style = "margin-top: 25px;")
                                         )
                                  )
                                ),
                                conditionalPanel(
                                  condition = "input.ma_do_metareg == true",
                                  verbatimTextOutput("ma_metareg_result"),
                                  plotOutput("ma_metareg_plot", height = 400),
                                  metareg_interpretation,
                                  htmlOutput("ma_metareg_interpretation_actual")
                                )
                            )
                          )
)

nma_input_tab <- tabItem(tabName = "nma_input",
                         fluidRow(
                           box(width = 12,
                               title = "Nhập dữ liệu cho phân tích tổng hợp mạng lưới",
                               status = "primary", solidHeader = TRUE,
                               
                               # Chọn dữ liệu mẫu hoặc tự nhập
                               radioButtons("nma_data_mode", "Dữ liệu:", 
                                            c("Dữ liệu mẫu"="sample", "Dữ liệu tự nhập"="manual"), 
                                            inline=TRUE),
                               
                               # Cài đặt kiểu dữ liệu
                               fluidRow(
                                 column(6, selectInput("nma_type", "Kiểu dữ liệu:", 
                                                       c("Contrast-based" = "Contrast-based", 
                                                         "Arm-based" = "Arm-based"))),
                                 column(6, selectInput("nma_outcome", "Kiểu kết quả:", 
                                                       c("Biến liên tục" = "Biến liên tục", 
                                                         "Biến phân loại" = "Biến phân loại")))
                               ),
                               
                               # Hiển thị hướng dẫn nhập liệu
                               htmlOutput("nma_instr"),
                               
                               # Panel hiển thị khi chọn dữ liệu tự nhập
                               conditionalPanel(
                                 condition = "input.nma_data_mode == 'manual'",
                                 
                                 # Chọn cách nhập dữ liệu
                                 radioButtons("nma_input_mode", "Cách nhập dữ liệu:",
                                              choices = c(
                                                "Số lượng nhóm cố định" = "fixed",
                                                "Số nhóm linh hoạt theo nghiên cứu" = "flexible"
                                              ),
                                              selected = "flexible"
                                 ),
                                 
                                 # Nếu chọn số lượng nhóm cố định
                                 conditionalPanel(
                                   condition = "input.nma_input_mode == 'fixed'",
                                   fluidRow(
                                     column(6, numericInput("nma_study_count", "Số lượng nghiên cứu:", 
                                                            value = 3, min = 2, max = 20, step = 1)),
                                     column(6, numericInput("nma_arms_per_study", "Số nhóm mỗi nghiên cứu:", 
                                                            value = 3, min = 2, max = 10, step = 1))
                                   )
                                 ),
                                 
                                 # Nếu chọn số nhóm linh hoạt
                                 conditionalPanel(
                                   condition = "input.nma_input_mode == 'flexible'",
                                   fluidRow(
                                     column(4, numericInput("nma_study_count_flex", "Số lượng nghiên cứu:", 
                                                            value = 3, min = 2, max = 20, step = 1)),
                                     column(8, 
                                            tags$div(
                                              style = "max-height: 150px; overflow-y: auto; padding: 5px; border: 1px solid #ddd;",
                                              tags$p("Số nhóm cho mỗi nghiên cứu:"),
                                              uiOutput("nma_study_arms_inputs")
                                            )
                                     )
                                   )
                                 ),
                                 
                                 # Nút tạo bảng nhập liệu
                                 actionButton("nma_generate_table", "Tạo bảng nhập liệu", 
                                              icon = icon("table"), class = "btn-primary")
                               ),
                               
                               # Bảng nhập liệu
                               br(),
                               rHandsontableOutput("nma_datatable"),
                               
                               # Tùy chọn phân tích và nút chạy
                               hr(),
                               fluidRow(
                                 column(6, 
                                        sliderInput("nma_tol", "Độ chấp nhận sai lệch:", 
                                                    min=0.01, max=1, value=0.5, step=0.01),
                                        tags$small("Độ chấp nhận sai lệch trong multi-arm studies. Giá trị càng cao càng linh hoạt nhưng có thể làm giảm độ chính xác.")
                                 ),
                                 column(6, actionButton("nma_run", "Chạy phân tích", 
                                                        icon = icon("play"), 
                                                        class = "btn-success", 
                                                        style = "margin-top: 25px;"))
                               )
                           )
                         )
)

nma_network_tab <- tabItem(tabName = "nma_network",
                           fluidRow(
                             box(width = 12, 
                                 title = "Sơ đồ mạng lưới", 
                                 status = "info", solidHeader = TRUE,
                                 plotOutput("nma_netplot", height = 500),
                                 # Thêm hướng dẫn biện giải và biện giải thực tế
                                 network_plot_interpretation,
                                 htmlOutput("nma_network_interpretation_actual")
                             )
                           )
)

nma_results_tab <- tabItem(tabName = "nma_results",
                           fluidRow(
                             box(width = 12, 
                                 title = "Kết quả phân tích tổng hợp mạng lưới", 
                                 status = "success", solidHeader = TRUE,
                                 verbatimTextOutput("nma_summary"),
                                 br(),
                                 htmlOutput("nma_league_title"),
                                 verbatimTextOutput("nma_league"),
                                 # Thêm hướng dẫn biện giải và biện giải thực tế
                                 nma_results_interpretation,
                                 htmlOutput("nma_results_interpretation_actual")
                             )
                           )
)

nma_consistency_tab <- tabItem(tabName = "nma_consistency",
                               fluidRow(
                                 box(width = 12, 
                                     title = "Kiểm định tính nhất quán (consistency)", 
                                     status = "danger", solidHeader = TRUE,
                                     h4("Kiểm định tính nhất quán tổng thể (Global consistency)"),
                                     verbatimTextOutput("nma_global_consistency"),
                                     h4("Kiểm định tính nhất quán cục bộ (Local consistency)"),
                                     verbatimTextOutput("nma_local_consistency"),
                                     # Thêm hướng dẫn biện giải và biện giải thực tế
                                     nma_consistency_interpretation,
                                     htmlOutput("nma_consistency_interpretation_actual")
                                 )
                               )
)

nma_ranking_tab <- tabItem(tabName = "nma_ranking",
                           fluidRow(
                             box(width = 12, 
                                 title = "Bảng xếp hạng can thiệp", 
                                 status = "warning", solidHeader = TRUE,
                                 # Thêm lựa chọn small.values
                                 fluidRow(
                                   column(6,
                                          radioButtons("nma_small_values", "Giá trị nhỏ hơn là:", 
                                                       c("Kết quả xấu hơn (giá trị nhỏ = xấu)" = "bad",
                                                         "Kết quả tốt hơn (giá trị nhỏ = tốt)" = "good"), 
                                                       inline = TRUE)
                                   ),
                                   column(6,
                                          actionButton("nma_update_ranking", "Cập nhật xếp hạng", 
                                                       icon = icon("sync"), class = "btn-info",
                                                       style = "margin-top: 5px;")
                                   )
                                 ),
                                 
                                 br(),
                                 rHandsontableOutput("nma_ranking"),
                                 
                                 # Thêm debug panel
                                 br(),
                                 checkboxInput("show_nma_debug", "Hiển thị thông tin debug", value = FALSE),
                                 conditionalPanel(
                                   condition = "input.show_nma_debug == true",
                                   box(
                                     width = NULL,
                                     title = "Debug info", 
                                     status = "primary",
                                     verbatimTextOutput("nma_ranking_debug")
                                   )
                                 ),
                                 
                                 # Thêm hướng dẫn biện giải và biện giải thực tế
                                 nma_ranking_interpretation,
                                 htmlOutput("nma_ranking_interpretation_actual")
                             )
                           )
)




