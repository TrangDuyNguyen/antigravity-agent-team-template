#!/usr/bin/env bash
# ==============================================================================
# Antigravity Multi-Agent CLI Session Launcher
# Tự động mở các phiên làm việc (Terminal Tabs/Windows) cho từng Sub-Agent
# Ánh xạ chuẩn Ma trận Model Tiering & Rules trong AGENTS.md
# ==============================================================================

set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_ROLE="${1:-help}"

# Trích xuất tên project từ AGENTS.md hoặc thư mục hiện tại
PROJECT_NAME="$(basename "$WORKSPACE_DIR")"
if [[ -f "$WORKSPACE_DIR/AGENTS.md" ]]; then
  PARSED_NAME="$(grep -E "^- \*\*Name\*\*:" "$WORKSPACE_DIR/AGENTS.md" | head -n1 | cut -d":" -f2 | tr -d " *" || true)"
  if [[ -n "$PARSED_NAME" ]]; then
    PROJECT_NAME="$PARSED_NAME"
  fi
fi

# Tự động phát hiện Dev Skill có trong .agents/skills/
detect_dev_skill() {
  local candidates=(
    "flutter-core-dev"
    "flutter-expert"
    "backend-core-dev"
    "frontend-core-dev"
    "react-native-core-dev"
    "ios-core-dev"
    "android-core-dev"
  )
  for c in "${candidates[@]}"; do
    if [[ -d "${WORKSPACE_DIR}/.agents/skills/${c}" ]]; then
      echo ".agents/skills/${c}/SKILL.md"
      return 0
    fi
  done
  local found
  found=$(find "${WORKSPACE_DIR}/.agents/skills" -maxdepth 2 -name "SKILL.md" 2>/dev/null | grep -E "dev|expert" | head -n 1 || true)
  if [[ -n "$found" ]]; then
    echo "${found#"${WORKSPACE_DIR}/"}"
  else
    echo ".agents/skills/code-reviewer/SKILL.md"
  fi
}

# Bảng cấu hình Metadata cho từng Sub-Agent
get_agent_info() {
  local role="$1"
  case "$role" in
    tech-lead)
      echo "Tech Lead & System Architect|Tier S (Claude Opus 4.6 Thinking / Sonnet Thinking)|Gate 0 (Tech Spike/ADR) & Gate 1/2 Feasibility Sign-Off|.agents/skills/tech-lead/SKILL.md|\033[1;35m"
      ;;
    po|product-owner)
      echo "Product Owner (The Strategic Tyrant)|Tier S (Claude Opus 4.6 Thinking)|Gate 1 (PRD Sign-off) & Gate 7 (Supreme Release)|.agents/skills/product-owner/SKILL.md|\033[1;31m"
      ;;
    ba|business-analyst)
      echo "Business Analyst (The Pedantic Logician)|Tier 2 (Gemini 3.1 Pro / Sonnet)|Gate 1 (PRD & BDD Given-When-Then)|.agents/skills/business-analyst/SKILL.md|\033[1;36m"
      ;;
    design|ui-ux-designer)
      echo "UI/UX Designer (Design System Purist)|Tier 2 (Gemini 3.1 Pro / Sonnet)|Gate 2 (4pt Grid, 5 UI States, Design Tokens)|.agents/skills/ui-ux-designer/SKILL.md|\033[1;34m"
      ;;
    dev|dev-core)
      local dev_skill
      dev_skill=$(detect_dev_skill)
      echo "Domain Dev Specialist (Clean Craftsman)|Tier 1/2 (Claude Sonnet 4.6 / Gemini 3.1 Pro)|Gate 4 (Clean Architecture & Ponytail)|${dev_skill}|\033[1;32m"
      ;;
    qa|qa-tester)
      echo "QA/QC Tester (The Paranoid Inquisitor)|Tier S (Claude Opus 4.6 Thinking)|Gate 3 (Test Design BDD) & Gate 6 (Zero-Tolerance Sign-off)|.agents/skills/qa-tester/SKILL.md|\033[1;33m"
      ;;
    reviewer|code-reviewer)
      echo "Code Reviewer (The Ruthless Bloat Assassin)|Tier 2 (Gemini 3.1 Pro / Sonnet)|Gate 5 (Ponytail Diff Review - One line per cut)|.agents/skills/code-reviewer/SKILL.md|\033[1;37m"
      ;;
    security|security-auditor)
      echo "Security Auditor (The Zero-Trust Sentinel)|Tier S (Claude Opus 4.6 Thinking)|Gate 6.5 (OWASP MASVS, Cloudflare 6-phase audit)|.agents/skills/security-auditor/SKILL.md|\033[1;31m"
      ;;
    pm|project-manager)
      echo "Project Manager (The Clockwork Disciplinarian)|Tier 3 (Gemini 3.8 Flash / 3.7 Flash)|Sprint Backlog, WBS Matrix & Risk Log|.agents/skills/project-manager/SKILL.md|\033[1;33m"
      ;;
    *)
      echo ""
      ;;
  esac
}

launch_terminal_session() {
  local role="$1"
  local raw_info
  raw_info=$(get_agent_info "$role")

  if [[ -z "$raw_info" ]]; then
    echo "❌ Role không hợp lệ: $role"
    exit 1
  fi

  IFS="|" read -r title tier gates skill_file color <<< "$raw_info"

  mkdir -p "${WORKSPACE_DIR}/.agents"
  local agent_env_file="${WORKSPACE_DIR}/.agents/.session_${role}.sh"
  cat << 'SESSION_EOF' > "$agent_env_file"
# Antigravity Sub-Agent Session Init
export WORKSPACE_DIR="__WORKSPACE_DIR__"
export PROJECT_NAME="__PROJECT_NAME__"
export AGENT_ROLE="__ROLE__"
export AGENT_TITLE="__TITLE__"
export AGENT_TIER="__TIER__"
export AGENT_GATES="__GATES__"
export AGENT_SKILL="__SKILL_FILE__"

cd "$WORKSPACE_DIR"

clear
printf "[1;36m================================================================================[0m
"
printf " ✨ [1m%s MULTI-AGENT WORKSPACE[0m — [[1;33m%s[0m]
" "$PROJECT_NAME" "$AGENT_TITLE"
printf "[1;36m================================================================================[0m
"
printf " 🤖 [1mAI Model Tier:[0m     %s
" "$AGENT_TIER"
printf " 🚪 [1mGate Phụ Trách:[0m    %s
" "$AGENT_GATES"
printf " 📜 [1mSkill Directive:[0m   %s
" "$AGENT_SKILL"
printf "[1;36m--------------------------------------------------------------------------------[0m
"
printf " 💡 [1;32mLệnh hỗ trợ trong phiên:[0m
"
printf "    • [1mask "<prompt>"[0m    : Gửi yêu cầu tới agent (tự nạp Skill Directive & AGENTS.md)
"
printf "    • [1mskill[0m              : Đọc toàn văn hướng dẫn & quy chuẩn của agent này
"
printf "    • [1mgates[0m              : Xem tiêu chuẩn và điều kiện cấm du di của các Gate
"
printf "    • [1mcheck-code[0m         : Chạy kiểm tra chuẩn Ponytail & độ dài file
"
printf "[1;36m================================================================================[0m

"

ask() {
  if [[ $# -eq 0 ]]; then
    printf "[1;31m❌ Vui lòng nhập câu hỏi hoặc nhiệm vụ: ask "<nhiệm vụ>"[0m
"
    return 1
  fi
  printf "[1;34m[%s Agent] 🚀 Đang gửi yêu cầu tới %s...[0m
" "$PROJECT_NAME" "$AGENT_TITLE"
  if command -v agy-ide &>/dev/null; then
    agy-ide chat -a "$WORKSPACE_DIR/$AGENT_SKILL" -a "$WORKSPACE_DIR/AGENTS.md" "$*"
  elif command -v agy &>/dev/null; then
    agy chat -a "$WORKSPACE_DIR/$AGENT_SKILL" -a "$WORKSPACE_DIR/AGENTS.md" "$*"
  else
    printf "[1;33m⚠️ Công cụ CLI agy/agy-ide chưa có trong PATH. Hãy copy prompt vào Antigravity IDE:[0m
"
    printf "Context: %s & AGENTS.md
Prompt: %s
" "$AGENT_SKILL" "$*"
  fi
}

skill() {
  if command -v bat &>/dev/null; then
    bat "$WORKSPACE_DIR/$AGENT_SKILL"
  else
    cat "$WORKSPACE_DIR/$AGENT_SKILL"
  fi
}

gates() {
  printf "[1;33m=== TRÍCH XUẤT TIÊU CHUẨN CỔNG TỪ AGENTS.md ===[0m
"
  grep -A 10 -E "Chốt Chặn [0-7]" "$WORKSPACE_DIR/AGENTS.md" | head -n 40 || cat "$WORKSPACE_DIR/AGENTS.md"
}

check-code() {
  if [[ -f "$WORKSPACE_DIR/scripts/check_file_length.sh" ]]; then
    bash "$WORKSPACE_DIR/scripts/check_file_length.sh"
  elif command -v make &>/dev/null && grep -q "check-files:" "$WORKSPACE_DIR/Makefile" 2>/dev/null; then
    make check-files
  else
    echo "Check script not found."
  fi
}

export PS1="\[\033[1;35m\]$(echo "$PROJECT_NAME" | tr "[:upper:]" "[:lower:]")\[\033[0m\]:\[\033[1;33m\]$AGENT_ROLE\[\033[0m\]$ "
SESSION_EOF

  sed -i "" "s|__WORKSPACE_DIR__|$WORKSPACE_DIR|g" "$agent_env_file"
  sed -i "" "s|__PROJECT_NAME__|$PROJECT_NAME|g" "$agent_env_file"
  sed -i "" "s|__ROLE__|$role|g" "$agent_env_file"
  sed -i "" "s|__TITLE__|$title|g" "$agent_env_file"
  sed -i "" "s|__TIER__|$tier|g" "$agent_env_file"
  sed -i "" "s|__GATES__|$gates|g" "$agent_env_file"
  sed -i "" "s|__SKILL_FILE__|$skill_file|g" "$agent_env_file"

  if [[ "$OSTYPE" == "darwin"* ]] && command -v osascript &>/dev/null; then
    osascript << EOA
tell application "Terminal"
    activate
    set newWin to do script "zsh --rcs <(cat ~/.zshrc "$agent_env_file")"
    set custom title of newWin to "$PROJECT_NAME: $title"
end tell
EOA
    printf "✅ Đã mở phiên Terminal cho: \033[1;32m%s\033[0m (%s)\n" "$title" "$tier"
  else
    printf "✅ Đã tạo cấu hình phiên tại: %s\n" "$agent_env_file"
    printf "Khởi động phiên bằng: zsh --rcs <(cat ~/.zshrc "%s")\n" "$agent_env_file"
  fi
}

case "$TARGET_ROLE" in
  all)
    echo "🌟 Đang mở đồng loạt các Sub-Agent Sessions cốt lõi của $PROJECT_NAME..."
    launch_terminal_session "tech-lead"
    sleep 0.4
    launch_terminal_session "design"
    sleep 0.4
    launch_terminal_session "dev"
    sleep 0.4
    launch_terminal_session "qa"
    sleep 0.4
    launch_terminal_session "security"
    echo "🎉 Đã mở đầy đủ các phiên Sub-Agent!"
    ;;
  tech-lead|po|ba|design|dev|qa|reviewer|security|pm)
    launch_terminal_session "$TARGET_ROLE"
    ;;
  help|*)
    echo "================================================================================"
    echo "🚀 $PROJECT_NAME Sub-Agent CLI Session Launcher"
    echo "================================================================================"
    echo "Cú pháp: ./scripts/launch_agent_session.sh <role>"
    echo ""
    echo "Các vai trò khả dụng:"
    echo "  • all          : Mở đồng loạt các Agent cốt lõi (Tech Lead, Design, Dev, QA, Security)"
    echo "  • tech-lead    : Gate 0 Spike/ADR & Feasibility Sign-off (Tier S Thinking)"
    echo "  • po           : Product Owner - Roadmap & Gate 1/7 Sign-off (Tier S Thinking)"
    echo "  • ba           : Business Analyst - PRD & BDD Stories (Tier 2 Pro)"
    echo "  • design       : UI/UX Designer - Design System Spec & Grid (Tier 2 Pro)"
    echo "  • dev          : Domain Dev Specialist - Clean Architecture & Ponytail (Tier 1/2)"
    echo "  • qa           : QA/QC - Kịch bản BDD & Nghiệm thu Zero-Tolerance (Tier S)"
    echo "  • reviewer     : Ponytail Reviewer - Triệt tiêu code thừa (Tier 2 Pro)"
    echo "  • security     : Security Auditor - Kiểm toán 6 pha Cloudflare (Tier S)"
    echo "  • pm           : Project Manager - WBS & Kanban Velocity (Tier 3 Flash)"
    echo "================================================================================"
    ;;
esac
