#!/usr/bin/env bash
# ==============================================================================
# Antigravity End-to-End Gate Pipeline Orchestrator (Relay Race Multi-Agent)
# Tự động hóa luồng chuyển tiếp (Hand-off) giữa 8+ Quality Gates
# Lưu trữ Artifacts trên đĩa & nạp Context tuần tự cho từng Sub-Agent
# ==============================================================================

set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_FILE="${WORKSPACE_DIR}/.agents/pipeline_state.json"
GATES_DOC_DIR="${WORKSPACE_DIR}/docs/gates"

# Trích xuất tên project từ AGENTS.md hoặc thư mục
PROJECT_NAME="$(basename "$WORKSPACE_DIR")"
if [[ -f "$WORKSPACE_DIR/AGENTS.md" ]]; then
  PARSED_NAME="$(grep -E "^- \*\*Name\*\*:" "$WORKSPACE_DIR/AGENTS.md" | head -n1 | cut -d":" -f2 | tr -d " *" || true)"
  if [[ -n "$PARSED_NAME" ]]; then
    PROJECT_NAME="$PARSED_NAME"
  fi
fi

# Tạo thư mục docs/gates nếu chưa có
mkdir -p "$GATES_DOC_DIR"

# Danh sách 9 Gates chuẩn mực theo AGENTS.md
GATES_COUNT=9
GATES_KEYS=("0" "1" "2" "3" "4" "5" "6" "6.5" "7")
GATES_NAMES=(
  "Gate 0: Tech Lead (Brainstorming, Tech Spike & ADR)"
  "Gate 1: Business Analyst & PO (PRD & BDD Given-When-Then)"
  "Gate 2: UI/UX Designer (Design System Spec & Grid)"
  "Gate 3: QA/QC Tester (Master Test Plan & Gherkin .feature)"
  "Gate 4: Dev Specialist (Clean Architecture & Ponytail)"
  "Gate 5: Code Reviewer (Ponytail AST & Bloat Cutting)"
  "Gate 6: QA/QC Verification (Automated 100% Pass)"
  "Gate 6.5: Security Auditor (Zero-Trust & Cloudflare 6-Phase)"
  "Gate 7: Supreme Release Gate (PO & Tech Lead Clearance)"
)
GATES_ROLES=("tech-lead" "ba" "design" "qa" "dev" "reviewer" "qa" "security" "po")
GATES_TIERS=(
  "Tier S (Claude Opus 4.6 Thinking / Sonnet Thinking)"
  "Tier 2 (Gemini 3.1 Pro / Sonnet)"
  "Tier 2 (Gemini 3.1 Pro / Sonnet)"
  "Tier S / Tier 1"
  "Tier 1/2 (Claude Sonnet 4.6 / Gemini 3.1 Pro)"
  "Tier 2 (Gemini 3.1 Pro / Sonnet)"
  "Tier S (Claude Opus 4.6 Thinking)"
  "Tier S (Claude Opus 4.6 Thinking)"
  "Tier S (Supreme Release Board)"
)
GATES_ARTIFACTS=(
  "gate0-tech-spike-adr.md"
  "gate1-prd.md"
  "gate2-ui-ux-spec.md"
  "gate3-test-plan.feature"
  "src/"
  "gate5-ponytail-review.md"
  "gate6-qa-signoff.md"
  "gate6.5-security-signoff.md"
  "release-tag.txt"
)

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

get_skill_file_for_role() {
  local role="$1"
  case "$role" in
    tech-lead) echo ".agents/skills/tech-lead/SKILL.md" ;;
    po) echo ".agents/skills/product-owner/SKILL.md" ;;
    ba) echo ".agents/skills/business-analyst/SKILL.md" ;;
    design) echo ".agents/skills/ui-ux-designer/SKILL.md" ;;
    dev) detect_dev_skill ;;
    qa) echo ".agents/skills/qa-tester/SKILL.md" ;;
    reviewer) echo ".agents/skills/code-reviewer/SKILL.md" ;;
    security) echo ".agents/skills/security-auditor/SKILL.md" ;;
    *) echo "AGENTS.md" ;;
  esac
}

init_state() {
  local feature="$1"
  local feature_dir="${GATES_DOC_DIR}/${feature}"
  mkdir -p "$feature_dir"

  cat << EOF > "$STATE_FILE"
{
  "feature": "$feature",
  "feature_dir": "$feature_dir",
  "current_gate_index": 0,
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "updated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "gates": {
    "0": {"status": "IN_PROGRESS", "artifact": "$feature_dir/gate0-tech-spike-adr.md"},
    "1": {"status": "PENDING", "artifact": "$feature_dir/gate1-prd.md"},
    "2": {"status": "PENDING", "artifact": "$feature_dir/gate2-ui-ux-spec.md"},
    "3": {"status": "PENDING", "artifact": "$feature_dir/gate3-test-plan.feature"},
    "4": {"status": "PENDING", "artifact": "src/"},
    "5": {"status": "PENDING", "artifact": "$feature_dir/gate5-ponytail-review.md"},
    "6": {"status": "PENDING", "artifact": "$feature_dir/gate6-qa-signoff.md"},
    "6.5": {"status": "PENDING", "artifact": "$feature_dir/gate6.5-security-signoff.md"},
    "7": {"status": "PENDING", "artifact": "$feature_dir/release-tag.txt"}
  }
}
EOF
}

get_current_feature() {
  if [[ -f "$STATE_FILE" ]]; then
    grep -o '"feature": "[^"]*' "$STATE_FILE" | cut -d'"' -f4
  else
    echo ""
  fi
}

get_current_gate_idx() {
  if [[ -f "$STATE_FILE" ]]; then
    grep -o '"current_gate_index": [0-9]*' "$STATE_FILE" | awk '{print $2}'
  else
    echo "0"
  fi
}

show_status() {
  if [[ ! -f "$STATE_FILE" ]]; then
    printf "\033[1;33m⚠️ Chưa có Pipeline nào đang chạy. Khởi tạo bằng: ./scripts/gate_pipeline.sh start <feature_name>\033[0m\n"
    return 0
  fi

  local feature
  feature=$(get_current_feature)
  local cur_idx
  cur_idx=$(get_current_gate_idx)

  printf "\n\033[1;36m========================================================================================\033[0m\n"
  printf " 🚀 \033[1m%s FEATURE DELIVERY PIPELINE\033[0m — Feature: [\033[1;33m%s\033[0m]\n" "$PROJECT_NAME" "$feature"
  printf "\033[1;36m========================================================================================\033[0m\n"
  printf " %-10s | %-42s | %-20s | %-12s\n" "GATE" "TÊN CHỐT CHẶN & VAI TRÒ" "MODEL TIER" "TRẠNG THÁI"
  printf "\033[1;36m----------------------------------------------------------------------------------------\033[0m\n"

  for i in "${!GATES_KEYS[@]}"; do
    local key="${GATES_KEYS[$i]}"
    local name="${GATES_NAMES[$i]}"
    local tier="${GATES_TIERS[$i]}"
    local status_str
    
    if (( i < cur_idx )); then
      status_str="\033[1;32m[ PASSED ]\033[0m"
    elif (( i == cur_idx )); then
      status_str="\033[1;33m[ ACTIVE ]\033[0m"
    else
      status_str="\033[1;30m[ PENDING]\033[0m"
    fi

    printf " %-10s | %-42s | %-20s | %b\n" "Gate $key" "$name" "$tier" "$status_str"
  done
  printf "\033[1;36m========================================================================================\033[0m\n\n"
}

launch_gate_session() {
  local gate_idx="$1"
  local feature
  feature=$(get_current_feature)
  local feature_dir="${GATES_DOC_DIR}/${feature}"

  local gate_key="${GATES_KEYS[$gate_idx]}"
  local gate_name="${GATES_NAMES[$gate_idx]}"
  local gate_role="${GATES_ROLES[$gate_idx]}"
  local gate_tier="${GATES_TIERS[$gate_idx]}"
  local current_artifact="${feature_dir}/${GATES_ARTIFACTS[$gate_idx]}"
  local skill_file
  skill_file=$(get_skill_file_for_role "$gate_role")

  local prev_artifact=""
  local prev_gate_name=""
  if (( gate_idx > 0 )); then
    local prev_idx=$(( gate_idx - 1 ))
    prev_artifact="${feature_dir}/${GATES_ARTIFACTS[$prev_idx]}"
    prev_gate_name="${GATES_NAMES[$prev_idx]}"
  fi

  mkdir -p "${WORKSPACE_DIR}/.agents"
  local session_env="${WORKSPACE_DIR}/.agents/.pipeline_gate_${gate_key}.sh"
  cat << 'SESSION_EOF' > "$session_env"
export WORKSPACE_DIR="__WORKSPACE_DIR__"
export PROJECT_NAME="__PROJECT_NAME__"
export FEATURE="__FEATURE__"
export GATE_KEY="__GATE_KEY__"
export GATE_NAME="__GATE_NAME__"
export GATE_ROLE="__GATE_ROLE__"
export GATE_TIER="__GATE_TIER__"
export CURRENT_ARTIFACT="__CURRENT_ARTIFACT__"
export PREV_ARTIFACT="__PREV_ARTIFACT__"
export PREV_GATE_NAME="__PREV_GATE_NAME__"
export AGENT_SKILL="__SKILL_FILE__"

cd "$WORKSPACE_DIR"

clear
printf "[1;35m========================================================================================[0m
"
printf " 🚀 [1m%s QUALITY GATE PIPELINE[0m — [[1;33mGate %s[0m]
" "$PROJECT_NAME" "$GATE_KEY"
printf "[1;35m========================================================================================[0m
"
printf " 🎯 [1mNhiệm vụ:[0m        %s
" "$GATE_NAME"
printf " 🤖 [1mKhuyến nghị Model:[0m %s
" "$GATE_TIER"
printf " 📁 [1mTính năng:[0m       %s
" "$FEATURE"
printf " 📝 [1mSản phẩm đầu ra:[0m  %s
" "$CURRENT_ARTIFACT"

if [[ -n "$PREV_ARTIFACT" && -f "$PREV_ARTIFACT" ]]; then
  printf " 📥 [1;32mNhận bàn giao từ:[0m %s
" "$PREV_GATE_NAME"
  printf "    ↳ File đầu vào:   [1m%s[0m
" "$PREV_ARTIFACT"
fi

printf "[1;35m----------------------------------------------------------------------------------------[0m
"
printf " ⚡ [1;32mLệnh hỗ trợ trong phiên:[0m
"
printf "    • [1mask "<prompt>"[0m   : Gửi task tới agent (tự đính kèm Skill Directive & File bàn giao trước)
"
printf "    • [1mhand-off[0m         : Kiểm tra Artifacts đầu ra & TỰ ĐỘNG MỞ GATE TIẾP THEO!
"
printf "    • [1mprev-context[0m     : Xem toàn văn file bàn giao của Gate trước
"
printf "    • [1mpipeline-status[0m  : Xem dashboard tiến độ toàn bộ 8+ Gates
"
printf "[1;35m========================================================================================[0m

"

ask() {
  if [[ $# -eq 0 ]]; then
    printf "[1;31m❌ Vui lòng nhập nội dung: ask "<yêu cầu>"[0m
"
    return 1
  fi

  local extra_args=()
  if [[ -n "$PREV_ARTIFACT" && -f "$PREV_ARTIFACT" ]]; then
    extra_args+=("-a" "$PREV_ARTIFACT")
  fi

  printf "[1;34m[Gate %s] 🚀 Đang gửi yêu cầu kèm Context bàn giao tới Sub-Agent...[0m
" "$GATE_KEY"
  if command -v agy-ide &>/dev/null; then
    agy-ide chat -a "$WORKSPACE_DIR/$AGENT_SKILL" -a "$WORKSPACE_DIR/AGENTS.md" "${extra_args[@]}" "$*"
  elif command -v agy &>/dev/null; then
    agy chat -a "$WORKSPACE_DIR/$AGENT_SKILL" -a "$WORKSPACE_DIR/AGENTS.md" "${extra_args[@]}" "$*"
  else
    printf "[1;33m⚠️ agy CLI chưa khả dụng trong PATH. Hãy copy prompt vào Antigravity IDE.[0m
"
  fi
}

prev-context() {
  if [[ -n "$PREV_ARTIFACT" && -f "$PREV_ARTIFACT" ]]; then
    cat "$PREV_ARTIFACT"
  else
    printf "[1;33m⚠️ Đây là Gate khởi đầu hoặc chưa có Artifact từ Gate trước.[0m
"
  fi
}

hand-off() {
  "$WORKSPACE_DIR/scripts/gate_pipeline.sh" next
}

pipeline-status() {
  "$WORKSPACE_DIR/scripts/gate_pipeline.sh" status
}

export PS1="\[\033[1;35m\]$(echo "$PROJECT_NAME" | tr "[:upper:]" "[:lower:]")\[\033[0m\]:\[\033[1;33m\]gate$GATE_KEY-$GATE_ROLE\[\033[0m\]$ "
SESSION_EOF

  sed -i "" "s|__WORKSPACE_DIR__|$WORKSPACE_DIR|g" "$session_env"
  sed -i "" "s|__PROJECT_NAME__|$PROJECT_NAME|g" "$session_env"
  sed -i "" "s|__FEATURE__|$feature|g" "$session_env"
  sed -i "" "s|__GATE_KEY__|$gate_key|g" "$session_env"
  sed -i "" "s|__GATE_NAME__|$gate_name|g" "$session_env"
  sed -i "" "s|__GATE_ROLE__|$gate_role|g" "$session_env"
  sed -i "" "s|__GATE_TIER__|$gate_tier|g" "$session_env"
  sed -i "" "s|__CURRENT_ARTIFACT__|$current_artifact|g" "$session_env"
  sed -i "" "s|__PREV_ARTIFACT__|$prev_artifact|g" "$session_env"
  sed -i "" "s|__PREV_GATE_NAME__|$prev_gate_name|g" "$session_env"
  sed -i "" "s|__SKILL_FILE__|$skill_file|g" "$session_env"

  if [[ "$OSTYPE" == "darwin"* ]] && command -v osascript &>/dev/null; then
    osascript << EOA
tell application "Terminal"
    activate
    set newWin to do script "zsh --rcs <(cat ~/.zshrc "$session_env")"
    set custom title of newWin to "Gate $gate_key: $gate_name"
end tell
EOA
    printf "\n✅ \033[1;32mĐã kích hoạt Gate %s: %s\033[0m\n" "$gate_key" "$gate_name"
    printf "   ↳ Cửa sổ Terminal chuyên dụng đã mở. Gõ \033[1mhand-off\033[0m khi hoàn tất!\n\n"
  else
    printf "\n✅ \033[1;32mĐã kích hoạt Gate %s: %s\033[0m\n" "$gate_key" "$gate_name"
    printf "   Khởi động phiên bằng: zsh --rcs <(cat ~/.zshrc "%s")\n\n" "$session_env"
  fi
}

start_pipeline() {
  local feature="${1:-}"
  if [[ -z "$feature" ]]; then
    printf "\033[1;31m❌ Vui lòng nhập tên tính năng: ./scripts/gate_pipeline.sh start <feature_name>\033[0m\n"
    printf "   Ví dụ: ./scripts/gate_pipeline.sh start user-authentication\n"
    exit 1
  fi

  init_state "$feature"
  printf "🌟 \033[1;32mĐã khởi tạo Pipeline cho tính năng: %s\033[0m\n" "$feature"
  show_status
  launch_gate_session 0
}

next_gate() {
  if [[ ! -f "$STATE_FILE" ]]; then
    printf "\033[1;31m❌ Không tìm thấy Pipeline đang chạy!\033[0m\n"
    exit 1
  fi

  local cur_idx
  cur_idx=$(get_current_gate_idx)
  local feature
  feature=$(get_current_feature)
  local feature_dir="${GATES_DOC_DIR}/${feature}"
  local cur_artifact="${feature_dir}/${GATES_ARTIFACTS[$cur_idx]}"

  # Kiểm tra Artifacts đầu ra trước khi cho phép chuyển gate (ngoại trừ Gate 4 là code implementation)
  if [[ "$cur_artifact" != *"/"* && ! -f "$cur_artifact" ]] || [[ "$cur_artifact" == *"gate"* && ! -f "$cur_artifact" ]]; then
    printf "\n\033[1;31m⛔ CHỐT CHẶN BỊ CHẶN (ZERO-TOLERANCE):\033[0m\n"
    printf "Chưa tìm thấy Artifact bàn giao đầu ra tại: \033[1m%s\033[0m\n" "$cur_artifact"
    printf "Vui lòng xuất file tài liệu hoặc nghiệm thu trước khi chuyển tiếp sang Gate kế tiếp!\n\n"
    return 1
  fi

  local next_idx=$(( cur_idx + 1 ))
  if (( next_idx >= GATES_COUNT )); then
    printf "\n🎉 \033[1;32mCHÚC MỪNG! ĐÃ HOÀN TẤT TOÀN BỘ 8+ GATES CHO TÍNH NĂNG [%s]!\033[0m\n" "$feature"
    printf "Bản phát hành đã sẵn sàng đưa lên Production & CI/CD release.\n\n"
    sed -i "" "s|\"current_gate_index\": [0-9]*|\"current_gate_index\": $GATES_COUNT|g" "$STATE_FILE"
    show_status
    return 0
  fi

  sed -i "" "s|\"current_gate_index\": [0-9]*|\"current_gate_index\": $next_idx|g" "$STATE_FILE"
  sed -i "" "s|\"updated_at\": \"[^\"]*\"|\"updated_at\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"|g" "$STATE_FILE"

  printf "\n🔄 \033[1;36mĐang bàn giao Artifact từ Gate %s ➔ Gate %s...\033[0m\n" "${GATES_KEYS[$cur_idx]}" "${GATES_KEYS[$next_idx]}"
  show_status
  launch_gate_session "$next_idx"
}

CMD="${1:-help}"
case "$CMD" in
  start)
    shift
    start_pipeline "${1:-}"
    ;;
  next|hand-off)
    next_gate
    ;;
  status)
    show_status
    ;;
  current)
    cur_idx=$(get_current_gate_idx)
    launch_gate_session "$cur_idx"
    ;;
  reset)
    rm -f "$STATE_FILE" "${WORKSPACE_DIR}/.agents/.pipeline_gate_"*.sh
    printf "🧹 \033[1;32mĐã dọn dẹp sạch Pipeline State!\033[0m\n"
    ;;
  help|*)
    echo "================================================================================"
    echo "🚀 $PROJECT_NAME End-to-End Gate Pipeline Orchestrator"
    echo "================================================================================"
    echo "Cú pháp:"
    echo "  • ./scripts/gate_pipeline.sh start <feature_name> : Khởi động Pipeline từ Gate 0"
    echo "  • ./scripts/gate_pipeline.sh status               : Xem bảng tiến độ 8+ Gates"
    echo "  • ./scripts/gate_pipeline.sh next                 : Bàn giao context & mở Gate tiếp theo"
    echo "  • ./scripts/gate_pipeline.sh current              : Mở lại Terminal của Gate hiện tại"
    echo "  • ./scripts/gate_pipeline.sh reset                : Xóa trạng thái để bắt đầu mới"
    echo "================================================================================"
    ;;
esac
