#!/usr/bin/env bash

# ==============================================================================
# Antigravity Multi-Agent Team & SOP Scaffolding CLI Engine
# ==============================================================================
# Description: Bootstraps the 8-Gate Multi Sub-Agent SOP & Ponytail mindset
# into any software project across multiple technology stacks.
# ==============================================================================

set -euo pipefail

# Text Formatting & Colors
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
RESET='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR}/template"

# Default Variables
PROJECT_NAME=""
PROJECT_TYPE=""
PROJECT_DESCRIPTION=""
TARGET_DIR="${PWD}"
SELECTED_STACKS=""
DRY_RUN=false
AUTO_CONFIRM=false

show_banner() {
  echo -e "${CYAN}${BOLD}"
  echo "  █████╗ ███╗   ██╗████████╗██╗ ██████╗ ██████╗  █████╗ ██╗   ██╗██╗████████╗██╗   ██╗"
  echo " ██╔══██╗████╗  ██║╚══██╔══╝██║██╔════╝ ██╔══██╗██╔══██╗██║   ██║██║╚══██╔══╝╚██╗ ██╔╝"
  echo " ███████║██╔██╗ ██║   ██║   ██║██║  ███╗██████╔╝███████║██║   ██║██║   ██║    ╚████╔╝ "
  echo " ██╔══██║██║╚██╗██║   ██║   ██║██║   ██║██╔══██╗██╔══██║╚██╗ ██╔╝██║   ██║     ╚██╔╝  "
  echo " ██║  ██║██║ ╚████║   ██║   ██║╚██████╔╝██║  ██║██║  ██║ ╚████╔╝ ██║   ██║      ██║   "
  echo " ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝   ╚═╝      ╚═╝   "
  echo -e "${RESET}"
  echo -e "${PURPLE}${BOLD}   ⚡ 8-Gate Multi Sub-Agent SOP & Ponytail Mindset Scaffolding Engine ⚡${RESET}"
  echo -e "${DIM}   Cross-Platform: Flutter | React Native | iOS | Android | Web FE | Backend${RESET}\n"
}

usage() {
  cat << USAGE_EOF
Usage: ./setup.sh [OPTIONS]

Options:
  -n, --name <name>          Project name (e.g. "MyCoolApp")
  -t, --type <type>          Project type (e.g. "Mobile App", "Web Dashboard", "API Backend")
  -d, --dir <target_dir>     Target project directory (default: current directory)
  -s, --stacks <stacks>      Comma-separated stacks (flutter, react-native, ios, android, frontend, backend)
      --dry-run              Preview actions without writing or copying files
  -h, --help                 Show this help message

Examples:
  ./setup.sh                                              # Fully interactive mode
  ./setup.sh -n "AstroPay" -s "flutter,backend"           # Quick flag mode
  ./setup.sh -d "/path/to/project" -s "react-native"      # Specific directory
USAGE_EOF
  exit 0
}

# Parse Command Line Arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--name)
      PROJECT_NAME="$2"
      shift 2
      ;;
    -t|--type)
      PROJECT_TYPE="$2"
      shift 2
      ;;
    -d|--dir)
      TARGET_DIR="$2"
      shift 2
      ;;
    -s|--stacks)
      SELECTED_STACKS="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -y|--yes)
      AUTO_CONFIRM=true
      shift
      ;;
    -p|--desc)
      PROJECT_DESCRIPTION="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo -e "${RED}Error: Unknown option $1${RESET}" >&2
      usage
      ;;
  esac
done

show_banner

# Resolve absolute path for TARGET_DIR
mkdir -p "${TARGET_DIR}"
TARGET_DIR="$(cd "${TARGET_DIR}" && pwd)"

# Ensure stdin is attached to terminal tty for interactive prompts when piped (e.g. curl ... | bash)
if [ ! -t 0 ] && [ -e /dev/tty ]; then
  exec < /dev/tty
elif [ ! -t 0 ] && [ ! -e /dev/tty ]; then
  AUTO_CONFIRM=true
fi

# Interactive Inputs if not provided
if [[ -z "${PROJECT_NAME}" ]]; then
  DEFAULT_NAME="$(basename "${TARGET_DIR}")"
  echo -e "${BOLD}1. Project Identification:${RESET}"
  read -r -p "   Project Name [${DEFAULT_NAME}]: " INPUT_NAME || true
  PROJECT_NAME="${INPUT_NAME:-$DEFAULT_NAME}"
fi

if [[ -z "${PROJECT_TYPE}" ]]; then
  read -r -p "   Project Type (e.g. Mobile App, Web Fullstack, Backend Service) [Software Application]: " INPUT_TYPE || true
  PROJECT_TYPE="${INPUT_TYPE:-Software Application}"
fi

if [[ -z "${PROJECT_DESCRIPTION}" ]]; then
  read -r -p "   Short Description [High-performance application powered by Antigravity Agent Team]: " INPUT_DESC || true
  PROJECT_DESCRIPTION="${INPUT_DESC:-High-performance application powered by Antigravity Agent Team}"
fi

AVAILABLE_STACKS=("flutter" "react-native" "ios" "android" "frontend" "backend")
AVAILABLE_STACK_LABELS=(
  "Flutter (Dart, Riverpod, AutoRoute, Freezed, Clean Arch)"
  "React Native (Bare CLI, TypeScript, Zustand, Reanimated - No Expo)"
  "iOS Native (Swift, SwiftUI, UIKit, SwiftData, Instruments)"
  "Android Native (Kotlin, Jetpack Compose, Coroutines, Room)"
  "Web Frontend (React / Next.js / Vue, TypeScript, TailwindCSS)"
  "Backend & Cloud API (Node.js / Go / Python, PostgreSQL, Docker)"
)

if [[ -z "${SELECTED_STACKS}" ]]; then
  echo -e "\n${BOLD}2. Technology Stack Selection (Enter comma-separated numbers, e.g., 1 or 1,6):${RESET}"
  for i in "${!AVAILABLE_STACK_LABELS[@]}"; do
    echo -e "   ${CYAN}[$((i+1))]${RESET} ${AVAILABLE_STACK_LABELS[$i]}"
  done
  echo ""
  read -r -p "   Select Stack(s) [1]: " STACK_CHOICE || true
  STACK_CHOICE="${STACK_CHOICE:-1}"

  IFS=',' read -ra CHOICES <<< "${STACK_CHOICE}"
  PARSED_STACKS=()
  for c in "${CHOICES[@]}"; do
    c_clean="$(echo "$c" | tr -d ' ')"
    if [[ "$c_clean" =~ ^[1-6]$ ]]; then
      PARSED_STACKS+=("${AVAILABLE_STACKS[$((c_clean-1))]}")
    fi
  done
  SELECTED_STACKS="$(IFS=,; echo "${PARSED_STACKS[*]}")"
fi

if [[ -z "${SELECTED_STACKS}" ]]; then
  SELECTED_STACKS="flutter"
fi

echo -e "\n${BOLD}Target Directory:${RESET}  ${TARGET_DIR}"
echo -e "${BOLD}Project Name:${RESET}      ${PROJECT_NAME}"
echo -e "${BOLD}Project Type:${RESET}      ${PROJECT_TYPE}"
echo -e "${BOLD}Selected Stacks:${RESET}   ${SELECTED_STACKS}"
echo -e "${BOLD}Dry Run Mode:${RESET}      ${DRY_RUN}\n"

if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}[DRY RUN MODE ENABLED] No files will be modified.${RESET}"
fi

# Confirmation
if [ "$AUTO_CONFIRM" = false ]; then
  read -r -p "Proceed with scaffolding? [Y/n]: " CONFIRM || true
  CONFIRM="${CONFIRM:-Y}"
  if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "${RED}Aborted by user.${RESET}"
    exit 0
  fi
fi

# Step 1: Create Directories
echo -e "\n${BLUE}==> [1/4] Preparing directories in target workspace...${RESET}"
TARGET_AGENTS="${TARGET_DIR}/.agents"
TARGET_SKILLS="${TARGET_AGENTS}/skills"
TARGET_RULES="${TARGET_AGENTS}/rules"

if [ "$DRY_RUN" = false ]; then
  mkdir -p "${TARGET_SKILLS}" "${TARGET_RULES}"
fi

# Step 2: Copy Core Agnostic Skills & Rules
echo -e "${BLUE}==> [2/4] Injecting 8-Gate Agnostic Core Sub-Agents & Ponytail Rules...${RESET}"
if [ "$DRY_RUN" = false ]; then
  # Copy rules
  cp -R "${TEMPLATE_DIR}/.agents/rules/"* "${TARGET_RULES}/"
  
  # Copy MCP config if not present
  if [[ ! -f "${TARGET_AGENTS}/mcp_config.json" ]]; then
    cp "${TEMPLATE_DIR}/.agents/mcp_config.json" "${TARGET_AGENTS}/"
  fi

  # Copy Core Skills
  cp -R "${TEMPLATE_DIR}/.agents/skills/_core/"* "${TARGET_SKILLS}/"
fi
echo -e "    ${GREEN}✔${RESET} Core skills installed: PO, Tech Lead, BA, UI/UX, PM, QA/QC, Reviewer, Ponytail suite."

# Step 3: Copy Selected Stacks
echo -e "${BLUE}==> [3/4] Installing specialized Dev Sub-Agents for: ${SELECTED_STACKS}...${RESET}"
STACK_RULES_AGGREGATE=""
ACTIVE_DEV_AGENTS=""

IFS=',' read -ra STACK_ARRAY <<< "${SELECTED_STACKS}"
for stack in "${STACK_ARRAY[@]}"; do
  stack_clean="$(echo "$stack" | tr -d ' ')"
  STACK_SRC="${TEMPLATE_DIR}/.agents/skills/_stacks/${stack_clean}"
  
  if [[ -d "${STACK_SRC}" ]]; then
    if [ "$DRY_RUN" = false ]; then
      # Copy all subdirectories (dev skills)
      for skill_dir in "${STACK_SRC}"/*; do
        if [[ -d "$skill_dir" ]]; then
          skill_dir_clean="${skill_dir%/}"
          cp -R "$skill_dir_clean" "${TARGET_SKILLS}/"
          skill_name="$(basename "$skill_dir_clean")"
          ACTIVE_DEV_AGENTS="${ACTIVE_DEV_AGENTS}   - \`${skill_name}\` (Stack: ${stack_clean})\n"
        fi
      done
    fi
    
    # Read stack rules if present
    if [[ -f "${STACK_SRC}/rules.md" ]]; then
      STACK_RULES_AGGREGATE="${STACK_RULES_AGGREGATE}$(cat "${STACK_SRC}/rules.md")\n\n---\n\n"
    fi
    echo -e "    ${GREEN}✔${RESET} Stack [${stack_clean}] successfully injected."
  else
    echo -e "    ${YELLOW}⚠ Warning: Stack '${stack_clean}' not found in template, skipping.${RESET}"
  fi
done

# Step 4: Render AGENTS.md
echo -e "${BLUE}==> [4/4] Synthesizing Project AGENTS.md...${RESET}"
if [ "$DRY_RUN" = false ]; then
  TPL_FILE="${TEMPLATE_DIR}/AGENTS.md.tpl"
  TARGET_AGENTS_MD="${TARGET_DIR}/AGENTS.md"

  # Replace tokens in template
  python3 -c '
import sys

tpl_path = sys.argv[1]
out_path = sys.argv[2]
p_name = sys.argv[3]
p_type = sys.argv[4]
p_desc = sys.argv[5]
stack_rules = sys.argv[6].replace("\\n", "\n")
dev_agents = sys.argv[7].replace("\\n", "\n")

with open(tpl_path, "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("{{PROJECT_NAME}}", p_name)
content = content.replace("{{PROJECT_TYPE}}", p_type)
content = content.replace("{{PROJECT_DESCRIPTION}}", p_desc)
content = content.replace("{{STACK_RULES_CONTENT}}", stack_rules)
content = content.replace("{{ACTIVE_DEV_AGENTS_LIST}}", dev_agents)

with open(out_path, "w", encoding="utf-8") as f:
    f.write(content)
' "${TPL_FILE}" "${TARGET_AGENTS_MD}" "${PROJECT_NAME}" "${PROJECT_TYPE}" "${PROJECT_DESCRIPTION}" "${STACK_RULES_AGGREGATE}" "${ACTIVE_DEV_AGENTS}"
fi
echo -e "    ${GREEN}✔${RESET} Generated ${TARGET_DIR}/AGENTS.md"

# Summary
TOTAL_SKILLS=$(find "${TARGET_SKILLS}" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ' || echo "0")
echo -e "\n${GREEN}${BOLD}========================================================================${RESET}"
echo -e "${GREEN}${BOLD}  🎉 SUCCESS: Antigravity Multi-Agent Team Successfully Initialized!${RESET}"
echo -e "${GREEN}${BOLD}========================================================================${RESET}"
echo -e "  • Project:             ${CYAN}${PROJECT_NAME}${RESET}"
echo -e "  • Target Directory:    ${CYAN}${TARGET_DIR}${RESET}"
echo -e "  • Total Active Skills: ${YELLOW}${TOTAL_SKILLS}${RESET} Sub-Agents & Workflows"
echo -e "  • SOP Architecture:    ${PURPLE}8-Gate Clean Lifecycle & Ponytail Mindset${RESET}"
echo -e "  • Configuration:       ${CYAN}${TARGET_DIR}/AGENTS.md${RESET}\n"
echo -e "${BOLD}Next Steps in Antigravity IDE:${RESET}"
echo -e "  1. Open ${CYAN}${TARGET_DIR}${RESET} in Antigravity IDE."
echo -e "  2. The IDE will automatically discover all Sub-Agents in ${CYAN}.agents/skills/${RESET}."
echo -e "  3. Start any new feature with ${YELLOW}/brainstorming${RESET} or ${YELLOW}/feature-lifecycle${RESET}!\n"
