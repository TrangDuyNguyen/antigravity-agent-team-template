# Sổ Nhật Ký Rủi Ro & Điểm Nghẽn (Risk & Blocker Log)

- **Quản lý bởi**: Sub-Agent Project Manager (PM) & Sub-Agent QA Tester (Gate 3/6)
- **Chu kỳ rà soát**: Cập nhật liên tục theo từng Quality Gate

| Mã Risk/Blocker | Mức Độ | Sub-Agent Báo Cáo | Mô Tả & Tác Động | Phương Án Giảm Thiểu | Trạng Thái |
|:---|:---:|:---|:---|:---|:---:|
| `RSK-INIT-01` | Medium | `tech-lead` | Xung đột phiên bản SDK môi trường local | Kiểm tra pre-flight script trước khi code | 🟢 MITIGATED |
| `BLK-VIS-01` | Critical | `qa-tester` | S1 RenderFlex overflowed by 32px khi text scale 1.5x | Chặn Gate 6; bàn giao Tech Lead chỉ đạo chuyển sang Wrap layout | 🔴 OPEN (BLOCKER) |
| `BLK-VIS-02` | Major | `qa-tester` | S2 Header Camera Scanner bị lẹm vào Dynamic Island | Chặn Gate 6; bàn giao Tech Lead chỉ đạo bọc SafeArea | 🔴 OPEN (BLOCKER) |
| `BLK-VIS-03` | Major | `qa-tester` | S2 Độ tương phản text màu 2.8:1 vi phạm WCAG AA | Bàn giao Tech Lead & UI/UX chuẩn hóa Design Tokens | 🟡 IN_REVIEW |
