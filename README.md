# MetaHealth
Phân tích gộp và phân tích tổng hợp mạng lưới

# MetaHealth

![MetaHealth Logo](path/to/logo.png) *(nếu có)*

## Giới thiệu

MetaHealth là công cụ phân tích gộp (meta-analysis) và phân tích tổng hợp mạng lưới (network meta-analysis) được phát triển dựa trên R và Shiny. Ứng dụng này giúp các nhà nghiên cứu y học thực hiện phân tích dữ liệu, tạo biểu đồ và biện giải kết quả một cách trực quan và dễ sử dụng.

## Tính năng

- **Phân tích gộp (Meta-Analysis)**
  - Hỗ trợ dữ liệu Arm-based và Contrast-based
  - Phân tích cho biến liên tục và biến phân loại
  - Tạo biểu đồ rừng (forest plot) và biểu đồ phễu (funnel plot)
  - Đánh giá sai lệch xuất bản với kiểm định Egger
  - Phân tích gộp hồi quy (meta-regression)

- **Phân tích tổng hợp mạng lưới (Network Meta-Analysis)**
  - Xây dựng và trực quan hóa mạng lưới các nghiên cứu
  - Tạo bảng league table cho so sánh cặp đôi
  - Đánh giá tính nhất quán của mạng lưới
  - Xếp hạng các phương pháp điều trị với P-scores/SUCRA

- **Các tính năng khác**
  - Biện giải tự động kết quả bằng tiếng Việt
  - Giao diện dễ sử dụng, không yêu cầu kiến thức lập trình
  - Hỗ trợ nhập liệu qua bảng tính tương tác

## Cài đặt và sử dụng

```r
# Cài đặt các thư viện cần thiết
install.packages(c("shiny", "shinydashboard", "meta", "netmeta", "rhandsontable", "DT"))

# Clone repository
# git clone https://github.com/tunghup/MetaHealth.git
# hoặc tải về từ Releases

# Chạy ứng dụng
shiny::runApp("đường-dẫn-đến-thư-mục-MetaHealth")
