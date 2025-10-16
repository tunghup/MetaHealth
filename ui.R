# ---------- UI ----------

ui <- dashboardPage(
  dashboardHeader(title = "MetaHealth"),
  dashboardSidebar(
    sidebarMenu(id = "sidebar",
                menuItem("Phân tích gộp", tabName = "ma", icon = icon("chart-bar"),
                         menuSubItem("Nhập dữ liệu", tabName = "ma_input"),
                         menuSubItem("Kết quả chính", tabName = "ma_results"),
                         menuSubItem("Biểu đồ rừng", tabName = "ma_forest"),
                         menuSubItem("Sai lệch xuất bản", tabName = "ma_bias"),
                         menuSubItem("Phân tích gộp hồi quy", tabName = "ma_metareg")
                ),
                menuItem("Phân tích tổng hợp mạng lưới", tabName = "nma", icon = icon("project-diagram"),
                         menuSubItem("Nhập dữ liệu", tabName = "nma_input"),
                         # Đổi thứ tự tab - sơ đồ mạng lưới lên trước
                         menuSubItem("Sơ đồ mạng lưới", tabName = "nma_network"),
                         menuSubItem("Kết quả chính", tabName = "nma_results"),
                         # Thêm tab tính nhất quán tách riêng
                         menuSubItem("Tính nhất quán", tabName = "nma_consistency"),
                         menuSubItem("Xếp hạng điều trị", tabName = "nma_ranking")
                )
    )
  ),
  dashboardBody(
    tabItems(ma_input_tab,ma_results_tab,ma_forest_tab,ma_bias_tab,ma_metareg_tab,
             nma_input_tab,nma_network_tab,nma_results_tab,nma_consistency_tab,nma_ranking_tab
    )
  )
)
