# ⚡ Antigravity Multi-Agent Team & SOP Template

> **A production-grade, multi sub-agent software delivery workflow and Ponytail mindset engine for Google Antigravity IDE, Cursor, Gemini, and Claude Code.**

[![GitHub Template](https://img.shields.io/badge/GitHub-Template_Repo-blue.svg?style=for-the-badge&logo=github)](https://github.com/TrangDuyNguyen/antigravity-agent-team-template/generate)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![SOP: 8+ Quality Gates](https://img.shields.io/badge/SOP-8+_Quality_Gates-68217A.svg?style=for-the-badge)](docs)
[![Security: Cloudflare 6-Phase](https://img.shields.io/badge/Security-Cloudflare_6--Phase-F38020.svg?style=for-the-badge)](template/.agents/skills/_core/security-audit)
[![Mindset: Strict Ponytail](https://img.shields.io/badge/Mindset-Strict_Ponytail-00E676.svg?style=for-the-badge)](template/.agents/rules/ponytail.md)

---

## 🌟 Highlights

- **🎭 9 Distinct Sub-Agent Personas**: PO, Tech Lead, BA, UI/UX Designer, PM, QA/QC Tester, Dev Team, Code Reviewer, and **Security Auditor** operating under the **Four-Eyes Principle (Checks & Balances)**.
- **🛡️ Zero Tolerance for Compromises (No "Du di")**: Hard quality gates requiring automated test verification, 0 memory leak, zero Critical/High security flaws, and zero-bloat code reviews.
- **🔒 Zero-Trust AppSec & Cloudflare 6-Phase Audit**: Sub-Agent Security Auditor with VETO power, OWASP MASVS / Top 10 auditing, secret leak detection, cloud security rules, and prompt injection hardening.
- **🎛️ Real-Time Visual Neobrutalism Mission Control**: Ultra-fast, zero-dependency visual web dashboard (`make dashboard`) designed in signature [Neobrutalism UI style](https://namethatui.com/styles/neobrutalism). Live radar tracking of all 9 Sub-Agents, 8-Gate pipeline stepper, live Kanban board, and human-in-the-loop Gate approval deck.
- **⚡ CLI Multi-Agent Relay Pipeline**: Automated hand-off orchestrator (`gate_pipeline.sh` & `launch_agent_session.sh`) connecting quality gates, preserving artifacts on disk, and feeding context sequentially into each Sub-Agent session.
- **✂️ Ruthless Ponytail Mindset**: YAGNI first, standard library and native features before third-party packages, shortest working diff, deletion over addition.
- **🧩 6 Modular Stacks**:
  - 🔵 **Flutter** (Dart, Riverpod, AutoRoute, Freezed, FlChart)
  - ⚛️ **React Native** (Bare CLI, TypeScript strict, Zustand, Reanimated — *No Expo*)
  - 🍏 **iOS Native** (Swift, SwiftUI, UIKit, SwiftData, Instruments)
  - 🤖 **Android Native** (Kotlin, Jetpack Compose, Coroutines, Room)
  - 🌐 **Web Frontend** (React, Next.js, Vue, TypeScript, TailwindCSS)
  - ⚡ **Backend & Cloud API** (Node.js, Go, Python, PostgreSQL, Docker)
- **🚀 One-Liner Scaffolding**: Setup any existing or new project in seconds with automated scripts and Makefile integration.

---

## 🏗️ The 8+ Gates End-to-End SOP Architecture

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
[Gate 4: Dev Team] ──────► [Gate 5: Reviewer] ───────► [Gate 6: QA Verify]
(Domain Dev Specialists)   (Ponytail Diff Review)      (Automated 100% Pass)
                                                              │
                                                              ▼
                                                   [Gate 6.5: Security Auditor]
                                                   (Zero-Trust Audit & AppSec Sign-Off)
                                                              │
                                                              ▼
                                                   [Gate 7: PO & PM Release]
                                                   (Super-Repo Release Clearance)
```

### 🤖 AI Model Tiering Matrix

| Tier | Task Complexity | Recommended Model Tier | Sub-Agents & Scope |
| :--- | :--- | :--- | :--- |
| **Tier S (Frontier Reasoning)** | Strategic, Architecture, Security & Gatekeeping | **Claude Opus 4.6 (Thinking)** / **Claude Sonnet 4.6 (Thinking)** | **PO**: Roadmap, MoSCoW, Gate 1 & 7 Sign-offs.<br>**Tech Lead**: Gate 0 Brainstorming, Tech Spikes, ADR, Feasibility.<br>**Security Auditor**: Cloudflare 6-phase audit, trust boundary mapping, OWASP MASVS, security rules, secret leaks.<br>**QC/QA Lead**: Gate 3/6 Test Architecture & Zero-tolerance Verification.<br>**BA Lead**: Complex Architectural PRDs & Data Governance. |
| **Tier 1** | High-Complexity Engineering (`>= 5-8 SP`) | **Claude Sonnet 4.6 (Thinking)** / **Gemini 3.1 Pro** | **Dev Team**: Domain Dev, Native Bridges, Concurrency, Memory Profiling.<br>**QC/QA**: Automated boundary & stress testing. |
| **Tier 2** | Structured Spec & Design (`3 SP`) | **Gemini 3.1 Pro** / **Claude Sonnet 4.6 (Thinking)** | **UI/UX**: Mermaid flows, 4pt/8pt blueprints, 5 UI states.<br>**Reviewer**: Ponytail AST & diff review.<br>**Dev Core**: 3 SP clean screens/components. |
| **Tier 3** | Rapid Execution & Logistics (`1-2 SP`) | **Gemini 3.8 Flash** / **Gemini 3.7 Flash** | **PM**: Sprint backlog, WBS task breakdown, Risk log.<br>**Dev**: Small widgets, styling, const fixes. |

---

## 🎛️ Real-Time Visual Mission Control (Neobrutalism UI)

Launch the interactive visual command center anytime with a single command:

```bash
make dashboard
# or: bash scripts/dashboard.sh
```

- **Live Sub-Agent Radar**: Real-time status indicators (🟢 IDLE, 🟡 WORKING, 🔴 BLOCKED) for all 9 Sub-Agents with active task indicators.
- **8 Quality Gates Stepper**: Visual pipeline showing which gate is open, artifacts produced, and assigned agent.
- **Sprint Kanban Matrix**: Synchronized live from `docs/00-project-management/sprint-backlog.md` (TODO, IN PROGRESS, DONE).
- **Human Command Deck**: Click **`[ ⚡ APPROVE CURRENT GATE ]`** to sign off and advance the pipeline directly from your browser.
- **Zero-Dependency & Lightweight**: Built with Python 3 standard library and Vanilla ES6 + Neobrutalism CSS (no `npm install`, no `pip install`, starts in < 0.5s).
- **Zero-Trust Security**: Strictly binds to `127.0.0.1` (localhost only) with automatic regex secret/API token masking.

---

## ⚡ CLI Multi-Agent Relay Pipeline (Automated Hand-off)

The template includes an end-to-end multi-agent orchestrator that connects all 8+ Quality Gates in a relay race:

```bash
# 1. Start a new feature pipeline (automatically launches Gate 0: Tech Lead session)
make pipeline FEATURE="user-authentication"
# or: ./scripts/gate_pipeline.sh start user-authentication

# 2. View 9-Gate progress dashboard
make pipeline-status

# 3. Advance to the next Gate (Enforces required artifact zero-tolerance check)
make pipeline-next
# or type directly inside the active gate terminal:
hand-off

# 4. Reset pipeline state
make pipeline-reset
```

### Interactive Commands inside each Agent Terminal:
- `ask "<task>"`: Sends prompt to Sub-Agent CLI, automatically attaching Skill Directives, `AGENTS.md`, and previous gate hand-off context (`$PREV_ARTIFACT`).
- `prev-context`: Instantly prints the hand-off documentation from the previous Gate.
- `hand-off`: Verifies gate artifact and advances pipeline to the next gate session.
- `pipeline-status`: Displays current gate status table.

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
├── setup.sh                           # Interactive / automated scaffolding engine (5-step)
├── install.sh                         # Remote one-liner installer
├── template/
│   ├── AGENTS.md.tpl                  # Modular 9-Gate AGENTS.md template with dynamic interpolation
│   ├── Makefile.tpl                   # Makefile automation for pipeline & individual sub-agents
│   ├── scripts/                       # CLI Multi-Agent Orchestrator scripts
│   │   ├── gate_pipeline.sh           # Relay race quality gate hand-off orchestrator
│   │   ├── launch_agent_session.sh    # Multi-model sub-agent CLI session launcher
│   │   └── check_file_length.sh       # Ponytail file length & complexity checker
│   └── .agents/
│       ├── mcp_config.json            # Base MCP server declarations
│       ├── rules/                     # Ponytail rules & code review policies
│       └── skills/
│           ├── _core/                 # 9 Sub-Agents & universal SOP skills (including Security Auditor & Audit)
│           └── _stacks/               # Modular stacks (flutter, react-native, ios, android, frontend, backend)
```

---

## 📜 License

Distributed under the [MIT License](LICENSE).
