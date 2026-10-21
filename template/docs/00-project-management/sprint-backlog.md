# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 1
- **Tên Sprint**: Project Foundation & Core Scaffolding
- **Mã Epic / Feature**: `EPIC-CORE-01` / `FEAT-S01-INIT`
- **Phiên bản mục tiêu**: `v1.0.0`
- **Thời gian Sprint**: $(date +"%d/%m/%Y") – 14 ngày tới
- **Trạng thái Sprint**: ⚡ **IN_PROGRESS**
- **Tổng Story Points cam kết**: **12 SP** (Tiến độ: **0 / 12 SP — 0%**)

---

## 🎯 Mục Tiêu Sprint 1: Thiết Lập Nền Tảng Dự Án & Bộ Khung Chuẩn

1. **Gate 0 & Gate 1 (2 SP)**: Tech Lead & BA phân tích kiến trúc, lập PRD chuẩn BDD.
2. **Gate 2 & Gate 3 (2 SP)**: UI/UX Designer lên layout 4pt, QA lập Master Test Plan.
3. **Gate 4 (2 SP)**: Dev triển khai core clean architecture và zero-bloat conventions.
4. **Gate 5, 6, 6.5 & 7 (2 SP)**: Review Ponytail, QA test 100% pass, Security check và Release.
5. **Xử lý Khiếm Khuyết Thị Giác Gate 6 (4 SP)**: Tech Lead & Dev xử lý triệt để 3 Visual Bugs (S1 & S2).

---

## 📋 Bảng Kanban Sprint 1

### 1. 📝 BACKLOG / QUEUED — [8 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S01-02-DESIGN` | `docs/03-prd-features/` | **G2** | UI/UX Designer: Lập Layout Blueprint & Flow | `ui-ux-designer` | 1 | ⏳ **TODO** |
| `TSK-S01-03-TEST` | `docs/gates/` | **G3** | QA Tester: Thiết kế Master Test Plan | `qa-tester` | 1 | ⏳ **TODO** |
| `TSK-S01-04-CORE-DEV` | `lib/` hoặc `src/` | **G4** | Dev Team: Triển khai mã nguồn lõi | `dev` | 2 | ⏳ **TODO** |
| `TSK-BUG-VIS-01` | `meal_card.dart` | **G6-BUG** | [BUG S1] RenderFlex overflow 32px khi text scale 1.5x | `tech-lead` | 2 | ⏳ **TODO** |
| `TSK-BUG-VIS-02` | `scanner_screen.dart` | **G6-BUG** | [BUG S2] Header cấn tai thỏ/Dynamic Island trên iOS | `tech-lead` | 1 | ⏳ **TODO** |
| `TSK-BUG-VIS-03` | `coach_chat_bubble.dart` | **G6-BUG** | [BUG S2] Contrast ratio vi phạm WCAG AA (2.8:1) | `tech-lead` | 1 | ⏳ **TODO** |

### 2. ⚡ IN PROGRESS — [2 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S01-00-SPIKE` | `docs/superpowers/specs/` | **G0** | Tech Lead: Architectural Spike & ADR | `tech-lead` | 1 | ⚡ **IN_PROGRESS** |
| `TSK-S01-01-PRD` | `docs/03-prd-features/` | **G1** | BA & PO: Soạn PRD & BDD Given-When-Then | `business-analyst` | 1 | ⚡ **IN_PROGRESS** |

### 3. 🏁 DONE — [0 SP]

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)
*(Các sprint đã đóng sẽ được tự động lưu vào `docs/00-project-management/sprints/`)*
