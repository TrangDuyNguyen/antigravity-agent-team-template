#!/usr/bin/env bash
# ==============================================================================
# Codebase File Length & Complexity Checker (Strict Ponytail Discipline)
# Enforces clean architecture by warning at 350 lines and capping files at 500 lines.
# ==============================================================================

set -euo pipefail

WARN_THRESHOLD=350
MAX_THRESHOLD=500
EXIT_ON_ERROR=0

while [[ $# -gt 0 ]]; do
  case $1 in
    --max)
      MAX_THRESHOLD="$2"
      shift 2
      ;;
    --warn)
      WARN_THRESHOLD="$2"
      shift 2
      ;;
    --strict)
      EXIT_ON_ERROR=1
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

echo "========================================================================"
echo "🚀 Codebase File Length & Complexity Checker"
echo "   Warning Threshold : > $WARN_THRESHOLD lines"
echo "   Hard Cap Threshold: > $MAX_THRESHOLD lines"
echo "========================================================================"

TOTAL_FILES=0
WARN_COUNT=0
ERROR_COUNT=0

TEMP_OUTPUT=$(mktemp)

# Tìm các thư mục source phổ biến
SEARCH_DIRS=()
for d in "lib" "src" "app"; do
  if [[ -d "$d" ]]; then
    SEARCH_DIRS+=("$d")
  fi
done

if [[ ${#SEARCH_DIRS[@]} -eq 0 ]]; then
  SEARCH_DIRS=(".")
fi

find "${SEARCH_DIRS[@]}" \
  -type f \
  \( -name "*.dart" -o -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.swift" -o -name "*.kt" -o -name "*.go" -o -name "*.py" \) \
  ! -path "*/node_modules/*" \
  ! -path "*/.git/*" \
  ! -path "*/build/*" \
  ! -path "*/dist/*" \
  ! -name "*.g.dart" \
  ! -name "*.freezed.dart" \
  ! -name "*.gr.dart" \
  ! -name "*.generated.*" 2>/dev/null | while read -r file; do
    lines=$(wc -l < "$file" | tr -d " ")
    echo "$lines $file" >> "$TEMP_OUTPUT"
done

if [[ ! -s "$TEMP_OUTPUT" ]]; then
  echo "Không tìm thấy file mã nguồn phù hợp để quét."
  rm -f "$TEMP_OUTPUT"
  exit 0
fi

echo ""
echo "📊 Top 10 Longest Source Files:"
echo "------------------------------------------------------------------------"
sort -nr "$TEMP_OUTPUT" | head -n 10 | while read -r lines file; do
  if [ "$lines" -gt "$MAX_THRESHOLD" ]; then
    printf "  🔴 %5d lines | %s (EXCEEDS HARD CAP)\n" "$lines" "$file"
  elif [ "$lines" -gt "$WARN_THRESHOLD" ]; then
    printf "  🟡 %5d lines | %s (WARNING)\n" "$lines" "$file"
  else
    printf "  🟢 %5d lines | %s\n" "$lines" "$file"
  fi
done

echo ""
echo "🔍 Checking Threshold Violations..."
echo "------------------------------------------------------------------------"
while read -r lines file; do
  TOTAL_FILES=$((TOTAL_FILES + 1))
  if [ "$lines" -gt "$MAX_THRESHOLD" ]; then
    ERROR_COUNT=$((ERROR_COUNT + 1))
    echo "❌ [HARD CAP] $file ($lines lines > $MAX_THRESHOLD max)"
  elif [ "$lines" -gt "$WARN_THRESHOLD" ]; then
    WARN_COUNT=$((WARN_COUNT + 1))
    echo "⚠️  [WARN]     $file ($lines lines > $WARN_THRESHOLD warn)"
  fi
done < <(sort -nr "$TEMP_OUTPUT")

rm -f "$TEMP_OUTPUT"

echo "------------------------------------------------------------------------"
echo "📈 Tổng kết:"
echo "   - Tổng số file quét: $TOTAL_FILES"
echo "   - File vượt mức cảnh báo ($WARN_THRESHOLD): $WARN_COUNT"
echo "   - File vượt mức chặn cứng ($MAX_THRESHOLD): $ERROR_COUNT"
echo "========================================================================"

if [ "$EXIT_ON_ERROR" -eq 1 ] && [ "$ERROR_COUNT" -gt 0 ]; then
  echo "🚫 Thất bại: Có $ERROR_COUNT file vượt quá giới hạn cứng ($MAX_THRESHOLD dòng)!"
  exit 1
fi

echo "✅ Kiểm tra độ dài file hoàn tất."
exit 0
