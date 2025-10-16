# ---------- HƯỚNG DẪN NHẬP LIỆU ----------
ma_instructions <- list(
  "Contrast-based - Biến liên tục" = HTML(
    "<b>📘 Hướng dẫn nhập liệu cho Contrast-based – Dữ liệu liên tục:</b><br>
    <p><i>(Contrast-based data: dữ liệu thể hiện mức độ ảnh hưởng giữa hai nhóm nghiên cứu)</i></p>
    <ul>
      <li><b>Study</b>: Tên nghiên cứu (mỗi dòng tương ứng với 1 nghiên cứu).</li>
      <li><b>ES</b>: Mức độ ảnh hưởng (Effect Size), có thể là:
        <ul>
          <li>Khác biệt trung bình (Mean Difference, MD)</li>
          <li>Khác biệt trung bình chuẩn hóa (Standardized Mean Difference, SMD)</li>
        </ul>
      </li>
      <li><b>ll</b>: Giới hạn dưới của khoảng tin cậy 95% (Lower Limit of 95% CI).</li>
      <li><b>ul</b>: Giới hạn trên của khoảng tin cậy 95% (Upper Limit of 95% CI).</li>
      <li><b>RegVar</b>: (Tuỳ chọn: điền giá trị bất kỳ nếu không có dữ liệu) Biến phân tích gộp hồi quy – ví dụ: tuổi trung bình của đối tượng nghiên cứu.</li>
    </ul>
    <i>📎 Lưu ý: Mỗi dòng đại diện cho một nghiên cứu độc lập.<br>
    Dữ liệu ES, ll, ul phải ở cùng một đơn vị (ví dụ: mg/dL, điểm trung bình,...).</i>"
  ),
  
  "Contrast-based - Biến phân loại" = HTML(
    "<b>📘 Hướng dẫn nhập liệu cho Contrast-based – Dữ liệu phân loại:</b><br>
    <p><i>(Contrast-based data: dữ liệu thể hiện mức độ ảnh hưởng giữa hai nhóm nghiên cứu)</i></p>
    <ul>
      <li><b>Study</b>: Tên nghiên cứu.</li>
      <li><b>ES</b>: log(OR), log(RR) hoặc log(HR).</li>
      <li><b>ll</b>: Giới hạn dưới của khoảng tin cậy 95%.</li>
      <li><b>ul</b>: Giới hạn trên của khoảng tin cậy 95%.</li>
      <li><b>RegVar</b>: (Tuỳ chọn: điền giá trị bất kỳ nếu không có dữ liệu) Biến phân tích gộp hồi quy – ví dụ: tuổi trung bình của đối tượng nghiên cứu.</li>
    </ul>
    <i>📎 Mỗi dòng là một nghiên cứu. Cần đảm bảo log(OR), log(RR) được tính đúng công thức thống kê.</i>"
  ),
  
  "Arm-based - Biến liên tục" = HTML(
    "<b>📘 Hướng dẫn nhập liệu cho Arm-based – Dữ liệu liên tục:</b><br>
    <p><i>(Arm-based data: dữ liệu số lượng đối tượng ở từng nhóm nghiên cứu)</i></p>
    <ul>
      <li><b>Study</b>: Tên nghiên cứu.</li>
      <li><b>Exp_N</b>: Cỡ mẫu nhóm can thiệp.</li>
      <li><b>Exp_Mean</b>: Trung bình nhóm can thiệp.</li>
      <li><b>Exp_SD</b>: Độ lệch chuẩn nhóm can thiệp.</li>
      <li><b>Ctrl_N</b>: Cỡ mẫu nhóm chứng.</li>
      <li><b>Ctrl_Mean</b>: Trung bình nhóm chứng.</li>
      <li><b>Ctrl_SD</b>: Độ lệch chuẩn nhóm chứng.</li>
      <li><b>RegVar</b>: (Tuỳ chọn: điền giá trị bất kỳ nếu không có dữ liệu) Biến phân tích gộp hồi quy, ví dụ: tuổi trung bình hoặc chỉ số khác.</li>
    </ul>
    <i>📎 Mỗi dòng là một nghiên cứu. Cần đảm bảo dữ liệu trung bình và SD ở cùng đơn vị đo.</i>"
  ),
  
  "Arm-based - Biến phân loại" = HTML(
    "<b>📘 Hướng dẫn nhập liệu cho Arm-based – Dữ liệu phân loại:</b><br>
    <p><i>(Arm-based data: dữ liệu số lượng đối tượng ở từng nhóm nghiên cứu)</i></p>
    <ul>
      <li><b>Study</b>: Tên nghiên cứu.</li>
      <li><b>Exp_Event</b>: Số biến cố ở nhóm can thiệp.</li>
      <li><b>Exp_N</b>: Cỡ mẫu nhóm can thiệp.</li>
      <li><b>Ctrl_Event</b>: Số biến cố ở nhóm chứng.</li>
      <li><b>Ctrl_N</b>: Cỡ mẫu nhóm chứng.</li>
      <li><b>RegVar</b>: (Tuỳ chọn: điền giá trị bất kỳ nếu không có dữ liệu) Biến phân tích gộp hồi quy – ví dụ: tuổi trung bình của đối tượng nghiên cứu.</li>
    </ul>
    <i>📎 Mỗi dòng tương ứng với một nghiên cứu. Tỷ lệ biến cố = Event/N. 
    Ứng dụng sẽ tự động tính log(OR), log(RR) từ dữ liệu này.</i>"
  )
)

nma_instructions <- list(
  "Contrast-based - Biến liên tục" = HTML(
    "<b>🌐 Hướng dẫn nhập liệu cho NMA – Contrast-based, dữ liệu liên tục:</b><br>
    <p><i>(Contrast-based data: dữ liệu thể hiện mức độ ảnh hưởng giữa hai nhóm nghiên cứu)</i></p>
    <ul>
      <li><b>Study</b>: Tên nghiên cứu.</li>
      <li><b>Treat1</b>: Nhóm điều trị 1.</li>
      <li><b>Treat2</b>: Nhóm điều trị 2 (khác Treat1).</li>
      <li><b>ES</b>: Khác biệt trung bình (Mean Difference) hoặc SMD.</li>
      <li><b>ll</b>: Giới hạn dưới của khoảng tin cậy 95%.</li>
      <li><b>ul</b>: Giới hạn trên của khoảng tin cậy 95%.</li>
    </ul>
    <i>📎 Mỗi dòng đại diện cho một phép so sánh giữa hai nhóm điều trị.<br>
    Với mỗi nghiên cứu có n nhóm, số lượng so sánh cần thiết là n×(n-1)/2:</i>
    <ul>
      <li>Nghiên cứu có 2 nhóm (A, B): cần 1 so sánh (A-B)</li>
      <li>Nghiên cứu có 3 nhóm (A, B, C): cần 3 so sánh (A-B, A-C, B-C)</li>
      <li>Nghiên cứu có 4 nhóm (A, B, C, D): cần 6 so sánh (A-B, A-C, A-D, B-C, B-D, C-D)</li>
    </ul>
    <b>⚠️ Quan trọng:</b> Dữ liệu phải nhất quán về mặt toán học: (A–B) + (B–C) = (A–C)."
  ),
  
  "Contrast-based - Biến phân loại" = HTML(
    "<b>🌐 Hướng dẫn nhập liệu cho NMA – Contrast-based, dữ liệu phân loại:</b><br>
    <p><i>(Contrast-based data: dữ liệu thể hiện mức độ ảnh hưởng giữa hai nhóm nghiên cứu)</i></p>
    <ul>
      <li><b>Study</b>: Tên nghiên cứu.</li>
      <li><b>Treat1</b>: Nhóm điều trị 1.</li>
      <li><b>Treat2</b>: Nhóm điều trị 2.</li>
      <li><b>ES</b>: log(OR), log(RR) hoặc log(HR).</li>
      <li><b>ll</b>: Giới hạn dưới của khoảng tin cậy 95%.</li>
      <li><b>ul</b>: Giới hạn trên của khoảng tin cậy 95%.</li>
    </ul>
    <i>📎 Mỗi dòng là một so sánh giữa hai nhóm điều trị.<br>
    Với mỗi nghiên cứu có n nhóm, số lượng so sánh cần thiết là n×(n-1)/2:</i>
    <ul>
      <li>Nghiên cứu có 2 nhóm (A, B): cần 1 so sánh (A-B)</li>
      <li>Nghiên cứu có 3 nhóm (A, B, C): cần 3 so sánh (A-B, A-C, B-C)</li>
      <li>Nghiên cứu có 4 nhóm (A, B, C, D): cần 6 so sánh (A-B, A-C, A-D, B-C, B-D, C-D)</li>
    </ul>
    <b>⚠️ Quan trọng:</b> Trên thang logarit, phải đảm bảo (A–B) + (B–C) = (A–C)."
  ),
  
  "Arm-based - Biến liên tục" = HTML(
    "<b>🌐 Hướng dẫn nhập liệu cho NMA – Arm-based, dữ liệu liên tục:</b><br>
    <p><i>(Arm-based data: dữ liệu số lượng đối tượng ở từng nhóm nghiên cứu)</i></p>
    <ul>
      <li><b>Study</b>: Tên nghiên cứu.</li>
      <li><b>Treatment</b>: Tên nhóm điều trị (ví dụ: Placebo, DrugA, DrugB).</li>
      <li><b>N</b>: Cỡ mẫu của nhóm.</li>
      <li><b>Mean</b>: Giá trị trung bình của chỉ số đo.</li>
      <li><b>SD</b>: Độ lệch chuẩn.</li>
    </ul>
    <i>📎 Mỗi dòng là một nhóm trong một nghiên cứu.</i>
    <ul>
      <li>Mỗi nghiên cứu cần có ít nhất 2 nhóm điều trị.</li>
      <li>Các nghiên cứu có thể có số lượng nhóm khác nhau (2, 3, 4... nhóm).</li>
      <li>Mạng lưới được xây dựng dựa trên tên nhóm điều trị giống nhau giữa các nghiên cứu.</li>
    </ul>
    <b>⚠️ Quan trọng:</b> Tên nhóm điều trị phải trùng khớp chính tả trong toàn bộ bảng dữ liệu."
  ),
  
  "Arm-based - Biến phân loại" = HTML(
    "<b>🌐 Hướng dẫn nhập liệu cho NMA – Arm-based, dữ liệu phân loại:</b><br>
    <p><i>(Arm-based data: dữ liệu số lượng đối tượng ở từng nhóm nghiên cứu)</i></p>
    <ul>
      <li><b>Study</b>: Tên nghiên cứu.</li>
      <li><b>Treatment</b>: Nhóm điều trị.</li>
      <li><b>Event</b>: Số biến cố xảy ra.</li>
      <li><b>N</b>: Cỡ mẫu nhóm.</li>
    </ul>
    <i>📎 Mỗi dòng là một nhóm trong một nghiên cứu.</i>
    <ul>
      <li>Mỗi nghiên cứu cần có ít nhất 2 nhóm điều trị.</li>
      <li>Các nghiên cứu có thể có số lượng nhóm khác nhau (2, 3, 4... nhóm).</li>
      <li>Mạng lưới được xây dựng dựa trên tên nhóm điều trị giống nhau giữa các nghiên cứu.</li>
    </ul>
    <b>⚠️ Quan trọng:</b> Cần đảm bảo tỷ lệ Event/N hợp lý (0 ≤ Event ≤ N)."
  )
)

# Biện giải cho các kết quả phân tích gộp
meta_results_interpretation <- HTML("
<div style='margin-top: 20px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #28a745;'>
  <h4 style='color: #28a745;'>📊 Hướng dẫn biện giải kết quả phân tích gộp:</h4>
  
  <p><b>1. Mức độ ảnh hưởng gộp (Pooled effect)</b><br>
  - <b>Giá trị mức độ ảnh hưởng</b>: Đại diện cho sức mạnh và hướng của mối liên hệ/tác động.<br>
  - <b>Khoảng tin cậy 95% (95% CI)</b>: Khoảng mà chúng ta tin rằng giá trị thực nằm trong đó với độ tin cậy 95%.<br>
  - <b>Giá trị p</b>: Nếu p < 0.05, kết quả có ý nghĩa thống kê (có bằng chứng để bác bỏ giả thuyết vô hiệu).</p>
  
  <p><b>2. Tính bất đồng nhất (Heterogeneity)</b><br>
  - <b>I²</b>: Phần trăm biến thiên giữa các nghiên cứu do bất đồng nhất thực sự, không phải do sai số ngẫu nhiên.<br>
  &nbsp;&nbsp;• I² < 25%: Bất đồng nhất thấp<br>
  &nbsp;&nbsp;• I² = 25-50%: Bất đồng nhất trung bình<br>
  &nbsp;&nbsp;• I² = 50-75%: Bất đồng nhất đáng kể<br>
  &nbsp;&nbsp;• I² > 75%: Bất đồng nhất cao<br>
  - <b>Kiểm định Q (Q-test)</b>: Nếu p < 0.1, có bằng chứng về bất đồng nhất đáng kể.</p>
  
  <p><b>3. Biện giải mức độ ảnh hưởng trong phân tích gộp</b><br>
  <i>Cho biến liên tục (SMD - Standardized Mean Difference):</i><br>
  &nbsp;&nbsp;• SMD = 0.2-0.5: Mức độ ảnh hưởng nhỏ<br>
  &nbsp;&nbsp;• SMD = 0.5-0.8: Mức độ ảnh hưởng trung bình<br>
  &nbsp;&nbsp;• SMD > 0.8: Mức độ ảnh hưởng lớn<br>
  &nbsp;&nbsp;• SMD > 0: Nghiêng về nhóm can thiệp<br>
  &nbsp;&nbsp;• SMD < 0: Nghiêng về nhóm chứng<br>
  <i>Cho biến phân loại (OR - Odds Ratio):</i><br>
  &nbsp;&nbsp;• OR > 1: Can thiệp làm tăng khả năng xảy ra biến cố<br>
  &nbsp;&nbsp;• OR < 1: Can thiệp làm giảm khả năng xảy ra biến cố<br>
  &nbsp;&nbsp;• OR = 1: Không có sự khác biệt giữa hai nhóm</p>
  
  <p><b>4. Lựa chọn mô hình</b><br>
  - <b>Mô hình tác động cố định (fixed-effect)</b>: Sử dụng khi I² thấp, các nghiên cứu đồng nhất.<br>
  - <b>Mô hình tác động ngẫu nhiên (random-effects)</b>: Phù hợp hơn khi có tính bất đồng nhất, cho phép hiệu ứng thực sự khác nhau giữa các nghiên cứu.</p>
</div>
")

# Biện giải cho biểu đồ rừng
forest_plot_interpretation <- HTML("
<div style='margin-top: 20px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #007bff;'>
  <h4 style='color: #007bff;'>📊 Hướng dẫn biện giải biểu đồ rừng (forest plot):</h4>
  
  <p><b>1. Các thành phần chính của biểu đồ rừng:</b><br>
  - <b>Nghiên cứu</b>: Tên các nghiên cứu được liệt kê theo cột dọc bên trái.<br>
  - <b>Hình vuông/hình tròn</b>: Đại diện cho mức độ ảnh hưởng ước tính của từng nghiên cứu.<br>
  - <b>Kích thước hình vuông/hình tròn</b>: Thể hiện trọng số của nghiên cứu trong phân tích gộp (nghiên cứu lớn có trọng số cao hơn).<br>
  - <b>Đường ngang</b>: Thể hiện khoảng tin cậy 95% của mức độ ảnh hưởng từng nghiên cứu.<br>
  - <b>Đường đứt đoạn thẳng đứng</b>: Đường không hiệu ứng (thường là 0 cho SMD/MD, 1 cho RR/OR).<br>
  - <b>Hình thoi (♦)</b>: Mức độ ảnh hưởng gộp với khoảng tin cậy 95%.</p>
  
  <p><b>2. Cách đọc kết quả:</b><br>
  - Nếu khoảng tin cậy của nghiên cứu <b>không cắt qua đường không hiệu ứng</b>: Kết quả có ý nghĩa thống kê.<br>
  - Nếu khoảng tin cậy <b>cắt qua đường không hiệu ứng</b>: Kết quả không có ý nghĩa thống kê.<br>
  - <b>Hướng của mức độ ảnh hưởng</b>: Điểm ước lượng nằm bên phải (dương) hoặc bên trái (âm) của đường không hiệu ứng thể hiện hướng tác động.</p>
  
  <p><b>3. Biện giải sự bất đồng nhất:</b><br>
  - <b>Các mức độ ảnh hưởng khác nhau nhiều</b>: Kích thước và/hoặc hướng của các mức độ ảnh hưởng từng nghiên cứu rất khác nhau.<br>
  - <b>Khoảng tin cậy không chồng lấp</b>: Các khoảng tin cậy của các nghiên cứu không có phần giao nhau, gợi ý bất đồng nhất cao.<br>
  - <b>I² cao</b>: Biểu thị phần trăm biến thiên giữa các nghiên cứu không phải do sai số ngẫu nhiên.</p>
  
  <p><b>4. Trực quan hóa trọng số:</b><br>
  - <b>Các nghiên cứu có trọng số cao</b>: Đóng góp nhiều hơn vào mức độ ảnh hưởng gộp, thể hiện bằng kích thước lớn hơn của hình vuông/hình tròn.<br>
  - <b>Độ chính xác của ước lượng</b>: Khoảng tin cậy hẹp cho thấy độ chính xác cao hơn.</p>
</div>
")

# Biện giải cho publication bias
publication_bias_interpretation <- HTML("
<div style='margin-top: 20px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #17a2b8;'>
  <h4 style='color: #17a2b8;'>📊 Hướng dẫn biện giải sai lệch xuất bản:</h4>
  
  <p><b>1. Biểu đồ phễu (Funnel plot):</b><br>
  - <b>Đối xứng</b>: Ít khả năng có sai lệch xuất bản<br>
  - <b>Bất đối xứng</b>: Có thể có sai lệch xuất bản<br>
  &nbsp;&nbsp;• Thiếu các nghiên cứu ở góc dưới trái: Các nghiên cứu có kết quả âm tính và cỡ mẫu nhỏ có thể không được xuất bản<br>
  &nbsp;&nbsp;• Thiếu các nghiên cứu ở góc dưới phải: Các nghiên cứu có kết quả dương tính và cỡ mẫu nhỏ có thể không được xuất bản</p>
  
  <p><b>2. Kiểm định Egger:</b><br>
  - <b>p < 0.05</b>: Có bằng chứng thống kê về sai lệch xuất bản<br>
  - <b>p ≥ 0.05</b>: Không có bằng chứng thống kê về sai lệch xuất bản</p>
  
  <p><b>3. Phương pháp Trim-and-fill:</b><br>
  - Phương pháp này ước tính số nghiên cứu có thể bị thiếu do sai lệch xuất bản<br>
  - <b>Các điểm rỗng</b> trên biểu đồ: Các nghiên cứu được ước tính là bị thiếu<br>
  - Nếu mức độ ảnh hưởng gộp thay đổi đáng kể sau khi thêm các nghiên cứu này, kết quả có thể chịu ảnh hưởng bởi sai lệch xuất bản</p>
</div>
")

# Biện giải cho kết quả meta-regression
metareg_interpretation <- HTML("
<div style='margin-top: 20px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #28a745;'>
  <h4 style='color: #28a745;'>📊 Hướng dẫn biện giải kết quả phân tích gộp hồi quy:</h4>
  
  <p><b>1. Hệ số hồi quy (slope):</b><br>
  - <b>Dương (+)</b>: Biến dự báo có mối liên hệ thuận với mức độ ảnh hưởng của can thiệp.<br>
  - <b>Âm (-)</b>: Biến dự báo có mối liên hệ nghịch với mức độ ảnh hưởng của can thiệp.</p>
  
  <p><b>2. Giá trị p:</b><br>
  - <b>p < 0.05</b>: Biến dự báo có liên quan đáng kể đến mức độ ảnh hưởng của can thiệp.<br>
  - <b>p ≥ 0.05</b>: Không có bằng chứng thống kê về mối liên hệ giữa biến dự báo và mức độ ảnh hưởng của can thiệp.</p>
  
  <p><b>3. R² (tỷ lệ phương sai được giải thích):</b><br>
  - Giá trị cao (gần 1): Biến dự báo giải thích được phần lớn sự khác biệt giữa các nghiên cứu.<br>
  - Giá trị thấp (gần 0): Biến dự báo g10iải thích được ít sự khác biệt giữa các nghiên cứu.</p>
  
  <p><b>4. I² tồn dư (Residual heterogeneity):</b><br>
  - Giảm nhiều so với I² ban đầu: Biến dự báo có thể giải thích được phần lớn tính bất đồng nhất.<br>
  - Giảm ít hoặc không giảm: Biến dự báo không giải thích được nhiều tính bất đồng nhất giữa các nghiên cứu.</p>
  
  <p><i>Lưu ý: Phân tích gộp hồi quy chỉ thiết lập mối liên quan, không chứng minh quan hệ nhân quả. Cần thận trọng khi biện giải khi số lượng nghiên cứu nhỏ (< 10 nghiên cứu).</i></p>
</div>
")

# ----- HƯỚNG DẪN BIỆN GIẢI CHO NMA -----

# Hướng dẫn biện giải sơ đồ mạng lưới
network_plot_interpretation <- HTML("
<div style='margin-top: 20px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #007bff;'>
  <h4 style='color: #007bff;'>📊 Hướng dẫn biện giải sơ đồ mạng lưới:</h4>
  
  <p><b>1. Các thành phần chính:</b><br>
  - <b>Các điểm (nodes)</b>: Đại diện cho các phương pháp điều trị.<br>
  - <b>Các đường nối (edges)</b>: Thể hiện có bằng chứng trực tiếp từ nghiên cứu so sánh hai điều trị.<br>
  - <b>Độ dày của đường nối</b>: Thể hiện số lượng nghiên cứu hoặc số lượng đối tượng trong các nghiên cứu cho cặp điều trị.<br>
  - <b>Kích thước của điểm</b>: Thường đại diện cho số lượng đối tượng được điều trị bằng phương pháp đó.</p>

  <p><b>2. Cấu trúc mạng lưới:</b><br>
  - <b>Mạng lưới đầy đủ</b>: Tất cả các điều trị đều được kết nối với nhau (trực tiếp hoặc gián tiếp).<br>
  - <b>Mạng lưới không đầy đủ</b>: Có một số điều trị không được kết nối với phần còn lại của mạng lưới.<br>
  - <b>Mạng lưới hình sao</b>: Một điều trị (thường là giả dược) được so sánh với tất cả các điều trị khác, nhưng các điều trị khác không được so sánh trực tiếp với nhau.<br>
  - <b>Mạng lưới khép kín</b>: Có các vòng khép kín (loops) cho phép kiểm tra tính nhất quán.</p>

  <p><b>3. Độ mạnh của bằng chứng:</b><br>
  - <b>Đường nối dày</b>: Nhiều bằng chứng trực tiếp, ước lượng có độ tin cậy cao.<br>
  - <b>Đường nối mỏng</b>: Ít bằng chứng trực tiếp, ước lượng có thể kém tin cậy hơn.<br>
  - <b>Không có đường nối</b>: Chỉ có bằng chứng gián tiếp, ước lượng có độ không chắc chắn cao hơn.</p>

  <p><b>4. Cách đánh giá mạng lưới:</b><br>
  - <b>Mạng lưới tốt</b>: Nhiều so sánh trực tiếp, cấu trúc đa dạng với nhiều vòng khép kín.<br>
  - <b>Mạng lưới hạn chế</b>: Chủ yếu là cấu trúc hình sao, ít so sánh trực tiếp giữa các điều trị chủ động.<br>
  - <b>Mạng lưới có vấn đề</b>: Có các phần riêng biệt không kết nối, thiếu điều trị quan trọng.</p>
</div>
")

# Hướng dẫn biện giải kết quả chính NMA
nma_results_interpretation <- HTML("
<div style='margin-top: 20px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #28a745;'>
  <h4 style='color: #28a745;'>📊 Hướng dẫn biện giải kết quả phân tích tổng hợp mạng lưới:</h4>

  <p><b>1. Bảng League:</b><br>
  - Bảng này trình bày tất cả các so sánh cặp giữa các điều trị trong mạng lưới.<br>
  - <b>Phần trên đường chéo</b>: Thường hiển thị hiệu ứng tổng hợp (OR, SMD, etc.) với khoảng tin cậy.<br>
  - <b>Phần dưới đường chéo</b>: Thường hiển thị giá trị p hoặc thông tin bổ sung.<br>
  - <b>Kết quả có ý nghĩa thống kê</b>: Thường được in đậm hoặc có dấu hiệu khác.<br>
  - <b>Diễn giải OR</b>: OR > 1 có lợi cho điều trị được liệt kê theo hàng; OR < 1 có lợi cho điều trị được liệt kê theo cột.</p>

  <p><b>2. Các thống kê tổng hợp:</b><br>
  - <b>I²</b>: Đo lường tính bất đồng nhất trong mạng lưới.<br>
  - <b>Tau²</b>: Ước lượng phương sai giữa các nghiên cứu.<br>
  - <b>Q statistic</b>: Đánh giá tổng thể sự bất đồng nhất.</p>

  <p><b>3. Phân loại bằng chứng:</b><br>
  - <b>Bằng chứng trực tiếp</b>: Từ các nghiên cứu so sánh trực tiếp hai điều trị.<br>
  - <b>Bằng chứng gián tiếp</b>: Từ so sánh qua điều trị thứ ba (A vs C qua B).<br>
  - <b>Bằng chứng hỗn hợp</b>: Kết hợp bằng chứng trực tiếp và gián tiếp.</p>

  <p><b>4. Độ mạnh của hiệu ứng (SMD):</b><br>
  - <b>|SMD| < 0.2</b>: Hiệu ứng nhỏ không đáng kể.<br>
  - <b>|SMD| 0.2-0.5</b>: Hiệu ứng nhỏ.<br>
  - <b>|SMD| 0.5-0.8</b>: Hiệu ứng trung bình.<br>
  - <b>|SMD| > 0.8</b>: Hiệu ứng lớn.</p>

  <p><b>5. Diễn giải kết quả:</b><br>
  - <b>Khoảng tin cậy không chứa giá trị vô hiệu</b>: Kết quả có ý nghĩa thống kê.<br>
  - <b>Khoảng tin cậy rộng</b>: Độ không chắc chắn cao.<br>
  - <b>Khoảng tin cậy hẹp</b>: Ước lượng chính xác hơn.</p>
</div>
")

# Hướng dẫn biện giải tính nhất quán
nma_consistency_interpretation <- HTML("
<div style='margin-top: 20px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #dc3545;'>
  <h4 style='color: #dc3545;'>📊 Hướng dẫn biện giải tính nhất quán trong NMA:</h4>

  <p><b>1. Tính nhất quán là gì?</b><br>
  Tính nhất quán trong NMA là giả định rằng bằng chứng trực tiếp và gián tiếp cho cùng một so sánh là thống nhất với nhau. Ví dụ: hiệu ứng A vs C ước tính trực tiếp phải tương đồng với hiệu ứng A vs C ước tính gián tiếp qua B.</p>

  <p><b>2. Kiểm định tính nhất quán tổng thể (Global consistency):</b><br>
  - <b>Q test cho tính không nhất quán</b>: Kiểm định sự khác biệt giữa ước lượng trực tiếp và gián tiếp.<br>
  - <b>p < 0.05</b>: Có bằng chứng về sự không nhất quán trong mạng lưới.<br>
  - <b>p ≥ 0.05</b>: Không đủ bằng chứng để kết luận có sự không nhất quán.</p>

  <p><b>3. Kiểm định tính nhất quán cục bộ (Local consistency):</b><br>
  - Đánh giá tính nhất quán cho từng vòng khép kín (loop) trong mạng lưới.<br>
  - <b>Inconsistency Factor (IF)</b>: Chênh lệch tuyệt đối giữa bằng chứng trực tiếp và gián tiếp.<br>
  - <b>IF gần 0</b>: Tính nhất quán cao.<br>
  - <b>IF lớn với p < 0.05</b>: Có sự không nhất quán đáng kể ở vòng khép kín cụ thể đó.</p>

  <p><b>4. Diễn giải kết quả không nhất quán:</b><br>
  - <b>Nguyên nhân có thể</b>: Khác biệt về đặc điểm nghiên cứu, thiên lệch xuất bản, hiệu chỉnh đồ thị, thời điểm nghiên cứu khác nhau.<br>
  - <b>Hậu quả</b>: Giảm độ tin cậy của kết quả, đặc biệt là các so sánh dựa nhiều vào bằng chứng gián tiếp.</p>

  <p><b>5. Xử lý sự không nhất quán:</b><br>
  - Phân tích phân nhóm để xác định nguồn gốc không nhất quán.<br>
  - Loại bỏ các nghiên cứu có chất lượng thấp.<br>
  - Sử dụng mô hình không nhất quán (inconsistency model).<br>
  - Trình bày kết quả với mức độ tin cậy thích hợp, nêu rõ hạn chế.</p>
</div>
")

# Hướng dẫn biện giải xếp hạng điều trị
nma_ranking_interpretation <- HTML("
<div style='margin-top: 20px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #ffc107;'>
  <h4 style='color: #ffc107;'>📊 Hướng dẫn biện giải xếp hạng điều trị trong NMA:</h4>

  <p><b>1. Các thống kê xếp hạng chính:</b><br>
  - <b>P-score</b>: Xác suất trung bình mà một điều trị tốt hơn các điều trị khác, giá trị từ 0 đến 1.<br>
  - <b>SUCRA</b>: Diện tích dưới đường cong xếp hạng tích lũy, biểu thị bằng %, là P-score nhân với 100.<br>
  - <b>Xếp hạng trung bình</b>: Vị trí trung bình của điều trị trong các mô phỏng xếp hạng.</p>

  <p><b>2. Diễn giải P-score/SUCRA:</b><br>
  - <b>Gần 1 (100%)</b>: Điều trị có khả năng cao là tốt nhất.<br>
  - <b>Gần 0.5 (50%)</b>: Điều trị có hiệu quả trung bình.<br>
  - <b>Gần 0 (0%)</b>: Điều trị có khả năng cao là kém nhất.</p>

  <p><b>3. Thận trọng khi biện giải:</b><br>
  - <b>Xếp hạng chỉ là tương đối</b>: Không cho biết mức độ tuyệt đối của hiệu quả hoặc sự chênh lệch thực sự giữa các điều trị.<br>
  - <b>Có thể gây hiểu nhầm</b>: Điều trị xếp hạng cao hơn có thể không có ý nghĩa lâm sàng nếu hiệu ứng chênh lệch rất nhỏ.<br>
  - <b>Bị ảnh hưởng bởi</b>: Số lượng điều trị trong mạng lưới và số lượng nghiên cứu cho mỗi điều trị.</p>

  <p><b>4. Các trường hợp không thể xếp hạng:</b><br>
  - Mạng lưới không liên kết đầy đủ (có các 'đảo' riêng biệt).<br>
  - Số lượng nghiên cứu quá ít cho một số điều trị.<br>
  - Dữ liệu không nhất quán hoặc mâu thuẫn.<br>
  - Vấn đề về độ hội tụ trong thuật toán.<br>
  - Lỗi định dạng dữ liệu (trùng lặp tên điều trị, v.v.).</p>

  <p><b>5. Lựa chọn small.values:</b><br>
  - <b>Bad</b>: Giá trị hiệu ứng nhỏ hơn là kết quả xấu hơn (ví dụ: OR < 1 là tốt với kết cục tiêu cực).<br>
  - <b>Good</b>: Giá trị hiệu ứng nhỏ hơn là kết quả tốt hơn (ví dụ: OR < 1 là tốt với kết cục tích cực).</p>
</div>
")

# CÁC HÀM BIỆN GIẢI
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
  
  # Tạo nội dung HTML biện giải - phần còn lại giữ nguyên...
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



