# 🚨 Báo Cáo Khiếm Khuyết Thị Giác — Visual Defect Report
**Mã Báo Cáo**: `BUG-REPORT-2026-VISUAL-01`  
**Người lập**: Sub-Agent QA / QC Tester (*The Paranoid Inquisitor*) & Kỹ năng `visual-qa`  
**Ngày phát hiện**: 21/10/2026  
**Chất lượng nghiệm thu Gate 6**: ❌ **REJECTED (TỪ CHỐI DUYỆT RELEASE)**  
**Người nhận xử lý**: Sub-Agent Tech Lead (*The Pragmatic System Architect*)  

---

## 📋 Danh Sách Khiếm Khuyết Thị Giác Được Phát Hiện (Visual Bug Matrix)

| Mã Bug | Màn Hình / Thành Phần | Mức Độ | Trụ Cột Vi Phạm | Tác Động Người Dùng | Trạng Thái |
|:---|:---|:---:|:---|:---|:---:|
| `BUG-VIS-01` | `MealCard` (`meal_card.dart`) | **S1 (Critical)** | Trụ cột 1: Layout & Overflow | Vạch sọc vàng đen `RenderFlex overflowed by 32px` khi text scale 1.5x | 🔴 **OPEN** |
| `BUG-VIS-02` | Scanner Header (`scanner_screen.dart`) | **S2 (Major)** | Trụ cột 3: Safe Area & Ergonomics | Header và nút Close bị Dynamic Island / tai thỏ đục thủng | 🔴 **OPEN** |
| `BUG-VIS-03` | Coach Insights (`coach_chat_bubble.dart`) | **S2 (Major)** | Trụ cột 4: Accessibility & Contrast | Tỉ lệ tương phản màu chữ 2.8:1, vi phạm tiêu chuẩn WCAG AA (>= 4.5:1) | 🔴 **OPEN** |

---

## 🔬 Chi Tiết Kỹ Thuật Từng Bug

### 1. `BUG-VIS-01`: Lỗi Tràn Viền RenderFlex Khi Phóng To Cỡ Chữ (S1 - Critical)
* **Thành phần**: `lib/features/nutrition/presentation/widgets/meal_card.dart:L64`
* **Công cụ phát hiện**: Flutter Preview MCP (`flutter-preview:run_widget_test` & `get_frame: last`) với `textScaler: TextScaler.linear(1.5)`.
* **Biểu hiện**:
  - Hàng hiển thị Macro Nutrition Badges (Carbs, Protein, Fat, Calories) bị tràn cạnh phải màn hình `375pt`.
  - Xuất hiện vạch sọc vàng đen đặc trưng: `A RenderFlex overflowed by 32 pixels on the right`.
* **Nguyên nhân gốc rễ (Root Cause)**:
  - Sử dụng widget `Row` cố định thay vì cho phép tự động bẻ dòng khi các thẻ tag badges phình to do font chữ lớn.
* **Đề xuất khắc phục sơ bộ**:
  - Chuyển đổi từ `Row` sang `Wrap(spacing: 8, runSpacing: 6, children: ...)` hoặc bọc các item trong `Flexible`.

---

### 2. `BUG-VIS-02`: Lẹm Vùng An Toàn Dynamic Island / Hardware Cutout (S2 - Major)
* **Thành phần**: `lib/features/scanner/presentation/screens/scanner_screen.dart:L28`
* **Công cụ phát hiện**: Screen Snapshot trên iPhone 15 Pro & Google Pixel 8.
* **Biểu hiện**:
  - Nút Back / Close và thanh tiêu đề "Quét Dinh Dưỡng" nằm sát đỉnh màn hình, bị cụm camera đục lỗ đè lên một nửa nút bấm.
  - Người dùng chạm vào nút Back rất khó khăn (Touch Target bị che khuất).
* **Nguyên nhân gốc rễ (Root Cause)**:
  - Màn hình quét Camera sử dụng `Scaffold(extendBodyBehindAppBar: true)` nhưng phần Header không được bọc widget `SafeArea(top: true)`.
* **Đề xuất khắc phục sơ bộ**:
  - Bọc cụm Header trong `SafeArea` hoặc sử dụng `MediaQuery.paddingOf(context).top` làm khoảng đệm đỉnh.

---

### 3. `BUG-VIS-03`: Tương Phản Màu Chữ Dưới Chuẩn Khả Năng Tiếp Cận (S2 - Major)
* **Thành phần**: `lib/features/coach/presentation/widgets/coach_chat_bubble.dart:L92`
* **Công cụ phát hiện**: Ma trận phân tích điểm ảnh Vision AI & WCAG Contrast Checker.
* **Biểu hiện**:
  - Dòng ghi chú thời gian và phân tích calo phụ đang dùng màu xám xỉn `#6B7280` trên bề mặt kính nền tối `#0A192F`.
  - Độ tương phản đo được chỉ đạt **2.8:1**, dưới ngưỡng tối thiểu **4.5:1** theo quy chuẩn tiếp cận WCAG AA. Người dùng ở môi trường ánh sáng mạnh ngoài trời hoàn toàn không đọc được.
* **Nguyên nhân gốc rễ (Root Cause)**:
  - Không sử dụng token độ mờ `AppColors.textSecondary` chuẩn của Design System mà hardcode mã màu xám thông thường.
* **Đề xuất khắc phục sơ bộ**:
  - Thay thế bằng token `AppColors.textSecondary` (`#A0AEC0` hoặc `#CBD5E1`) đạt độ tương phản chuẩn **5.6:1**.

---

## 📦 Biên Bản Chuyển Giao (Hand-Off to Tech Lead)
- **Từ**: Sub-Agent QA / QC Tester (*The Paranoid Inquisitor*)
- **Tới**: Sub-Agent Tech Lead (*The Pragmatic System Architect*)
- **Yêu cầu**: 
  1. Thẩm định nguyên nhân và phê duyệt giải pháp kiến trúc (Architectural Fix).
  2. Phân công task khắc phục cho Dev Team tại Gate 4.
  3. Cấm Release Gate 6 & Gate 7 cho đến khi toàn bộ 3 bug trên đạt **100% Pass** trong bài kiểm tra Golden & Visual QA tiếp theo.
