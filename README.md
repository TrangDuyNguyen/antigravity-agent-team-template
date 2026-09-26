# ⚡ Antigravity Multi-Agent Team & SOP Template

> **A production-grade, multi sub-agent software delivery workflow and Ponytail mindset engine for Google Antigravity IDE, Cursor, Gemini, and Claude Code.**

[![GitHub Template](https://img.shields.io/badge/GitHub-Template_Repo-blue.svg?style=for-the-badge&logo=github)](https://github.com/TrangDuyNguyen/antigravity-agent-team-template/generate)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![SOP: 8--Gate Clean Architecture](https://img.shields.io/badge/SOP-8--Gate_Clean_Architecture-68217A.svg?style=for-the-badge)](docs)
[![Mindset: Strict Ponytail](https://img.shields.io/badge/Mindset-Strict_Ponytail-00E676.svg?style=for-the-badge)](.agents/rules/ponytail.md)

---

## 🌟 Highlights

- **🎭 8 Distinct Sub-Agent Personas**: PO, Tech Lead, BA, UI/UX Designer, PM, QA/QC Tester, Dev Team, and Code Reviewer operating under the **Four-Eyes Principle (Checks & Balances)**.
- **🛡️ Zero Tolerance for Compromises (No "Du di")**: Hard quality gates requiring automated test verification, 0 memory leak, and zero-bloat code reviews.
- **✂️ Ruthless Ponytail Mindset**: YAGNI first, standard library and native features before third-party packages, shortest working diff, deletion over addition.
- **🧩 6 Modular Stacks**:
  - 🔵 **Flutter** (Dart, Riverpod, AutoRoute, Freezed, FlChart)
  - ⚛️ **React Native** (Bare CLI, TypeScript strict, Zustand, Reanimated — *No Expo*)
  - 🍏 **iOS Native** (Swift, SwiftUI, UIKit, SwiftData, Instruments)
  - 🤖 **Android Native** (Kotlin, Jetpack Compose, Coroutines, Room)
  - 🌐 **Web Frontend** (React, Next.js, Vue, TypeScript, TailwindCSS)
  - ⚡ **Backend & Cloud API** (Node.js, Go, Python, PostgreSQL, Docker)
- **🚀 One-Liner Scaffolding**: Setup any existing or new project in seconds.

---

## 🏗️ The 8-Gate End-to-End SOP Architecture

```
                                  [Gate 0: Sub-Agent Tech Lead]
                                  (Tech Spikes / Brainstorming / ADR)
                                                 │
                                                 ▼
[Sub-Agent PO] ──────────► [Gate 1: Sub-Agent BA] ──────────► [Sub-Agent PO & Tech Lead Duyệt]
(Roadmap & Epics)          (PRD & User Stories BDD)           (Gate 1 Sign-Off & Feasibility)
                                                                     │
                                                                     ▼
[Gate 3: QA Tester] ◄──── [PM Sub-Agent] ◄─────────── [Gate 2: UI/UX Designer]
(Test TCs & Gherkin)      (Sprint & WBS Matrix)       (UI Flow & Screen Layout)
       │                                                             │
       │                                                             ▼
       │                                                     [BA, PO & Tech Lead Duyệt]
       │                                                     (Gate 2 Sign-Off & Review)
       ▼
[Gate 4: Dev Team] ──────► [Gate 5: Reviewer] ───────► [Gate 6: QA Verify] ────► [Gate 7: PO & PM Release]
(Domain Dev Specialists)   (Ponytail Diff Review)      (Automated 100% Pass)      (Production Release)
```

### 🤖 AI Model Tiering Matrix

| Tier | Task Complexity | Recommended Model Tier | Sub-Agents & Scope |
| :--- | :--- | :--- | :--- |
| **Tier S (Frontier Reasoning)** | Strategic, Architecture & Quality Gatekeeping | **Claude Opus 4.6 (Thinking)** / **Claude Sonnet 4.6 (Thinking)** | **PO**: Roadmap, MoSCoW, Gate 1 & 7 Sign-offs.<br>**Tech Lead**: Gate 0 Brainstorming, Tech Spikes, ADR, Feasibility.<br>**QC/QA Lead**: Gate 3/6 Test Architecture & Zero-tolerance Verification.<br>**BA Lead**: Complex Architectural PRDs & Data Governance. |
| **Tier 1** | High-Complexity Engineering (`>= 5-8 SP`) | **Claude Sonnet 4.6 (Thinking)** / **Gemini 3.1 Pro** | **Dev Team**: Domain Dev, Native Bridges, Concurrency, Memory Profiling.<br>**QC/QA**: Automated boundary & stress testing. |
| **Tier 2** | Structured Spec & Design (`3 SP`) | **Gemini 3.1 Pro** / **Claude Sonnet 4.6 (Thinking)** | **UI/UX**: Mermaid flows, 4pt/8pt blueprints, 5 UI states.<br>**Reviewer**: Ponytail AST & diff review.<br>**Dev Core**: 3 SP clean screens/components. |
| **Tier 3** | Rapid Execution & Logistics (`1-2 SP`) | **Gemini 3.8 Flash** / **Gemini 3.7 Flash** | **PM**: Sprint backlog, WBS task breakdown, Risk log.<br>**Dev**: Small widgets, styling, const fixes. |

---

## 🚀 Quickstart & Usage

### Method 1: Use as GitHub Template (New Projects)
1. Click the green [**Use this template**](https://github.com/TrangDuyNguyen/antigravity-agent-team-template/generate) button on GitHub.
2. Clone your new repository.
3. Run `./setup.sh` to customize your project name and technology stack!

### Method 2: Remote One-Liner (Existing Projects)
Run this command inside any project directory:
```bash
curl -fsSL https://raw.githubusercontent.com/TrangDuyNguyen/antigravity-agent-team-template/main/install.sh | bash
```

### Method 3: Local Clone & Setup
```bash
git clone https://github.com/TrangDuyNguyen/antigravity-agent-team-template.git
cd antigravity-agent-team-template

# Interactive mode for current project
./setup.sh --dir /path/to/your/project

# Or with specific flags
./setup.sh --name "MyFinanceApp" --stacks "flutter,backend" --dir /path/to/your/project
```

---

## 📁 Repository Structure

```
antigravity-agent-team-template/
├── setup.sh                           # Interactive / automated scaffolding engine
├── install.sh                         # Remote one-liner installer
├── template/
│   ├── AGENTS.md.tpl                  # Modular AGENTS.md template with dynamic interpolation
│   └── .agents/
│       ├── mcp_config.json            # Base MCP server declarations
│       ├── rules/                     # Ponytail rules & code review policies
│       └── skills/
│           ├── _core/                 # 8 Sub-Agents & universal SOP skills
│           └── _stacks/               # Modular stacks (flutter, react-native, ios, android, frontend, backend)
```

---

## 📜 License

Distributed under the [MIT License](LICENSE).
