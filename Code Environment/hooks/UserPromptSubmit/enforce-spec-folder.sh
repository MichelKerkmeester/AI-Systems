#!/bin/bash

# ───────────────────────────────────────────────────────────────
# SPEC FOLDER ENFORCEMENT HOOK
# ───────────────────────────────────────────────────────────────
# UserPromptSubmit hook that blocks (or warns) when a conversation
# attempts to modify files without the required spec documentation.
#
# Features
#   • Detects implementation intent based on the prompt
#   • Supports configurable enforcement modes (warning, soft, hard)
#   • Validates spec folder existence and template structure
#   • Honors configurable exception patterns for trivial edits
#   • Logs every decision to spec-enforcement.log for auditing
#   • Records execution time in performance.log (<100ms target)
# ───────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
HOOKS_DIR="$(cd "$SCRIPT_DIR/.." 2>/dev/null && pwd)"
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || (cd "$SCRIPT_DIR/../.." && pwd))
CONFIG_FILE="$PROJECT_ROOT/.claude/configs/skill-rules.json"
LOG_DIR="$HOOKS_DIR/logs"
LOG_FILE="$LOG_DIR/spec-enforcement.log"
PERF_LOG="$LOG_DIR/performance.log"
SPECS_DIR="$PROJECT_ROOT/specs"
DOC_GUIDE="$PROJECT_ROOT/.claude/knowledge/conversation_documentation.md"

mkdir -p "$LOG_DIR"

source "$SCRIPT_DIR/../lib/output-helpers.sh" || exit 0

START_TIME=$(date +%s%N)

check_dependency "jq" "brew install jq (macOS) or apt install jq (Linux)" || exit 0

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)
if [ -z "$PROMPT" ]; then
  exit 0
fi
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')
PROMPT_SNIPPET="${PROMPT:0:200}"

log_event() {
  local status="$1"
  local detail="$2"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  {
    echo "$SEPARATOR"
    echo "[$timestamp] STATUS: $status"
    echo "Prompt: $PROMPT_SNIPPET"
    [ -n "$detail" ] && echo "Detail: $detail"
  } >> "$LOG_FILE"
}

MODIFICATION_KEYWORDS=(
  "add" "adjust" "apply" "build" "change" "create" "delete" "edit" "enhance" "fix"
  "implement" "improve" "modify" "optimize" "patch" "refactor" "remove" "replace"
  "revamp" "rewrite" "ship" "update" "write"
)

DETECTED_INTENT=""

detect_modification_intent() {
  for keyword in "${MODIFICATION_KEYWORDS[@]}"; do
    if [[ "$PROMPT_LOWER" == *"$keyword"* ]] || [[ "$PROMPT_LOWER" == *"$keyword "* ]]; then
      DETECTED_INTENT="$keyword"
      return 0
    fi
  done

  if echo "$PROMPT_LOWER" | grep -qE "let['’]?s (code|start|implement|build)"; then
    DETECTED_INTENT="collaborative-build"
    return 0
  fi

  return 1
}

ALLOWED_EXCEPTION_PATTERNS=()
ALLOWED_EXCEPTION_REASON=""
MAX_EXCEPTION_LOC=0
SINGLE_FILE_ONLY=false
ENFORCEMENT_MODE="hard-block"
VALIDATION_LEVEL="moderate"
CHECK_SPEC_FOLDER=true
CHECK_TEMPLATES=true
CHECK_PLACEHOLDERS=false

load_enforcement_config() {
  if [ ! -f "$CONFIG_FILE" ]; then
    return
  fi

  if ! validate_json "$CONFIG_FILE" >/dev/null 2>&1; then
    return
  fi

  local base_path='.skills["conversation-documentation"].enforcementConfig'

  ENFORCEMENT_MODE=$(jq -r "$base_path.mode // \"hard-block\"" "$CONFIG_FILE" 2>/dev/null)
  VALIDATION_LEVEL=$(jq -r "$base_path.validationLevel // \"moderate\"" "$CONFIG_FILE" 2>/dev/null)
  CHECK_SPEC_FOLDER=$(jq -r "$base_path.checkSpecFolder // true" "$CONFIG_FILE" 2>/dev/null)
  CHECK_TEMPLATES=$(jq -r "$base_path.checkTemplates // true" "$CONFIG_FILE" 2>/dev/null)
  CHECK_PLACEHOLDERS=$(jq -r "$base_path.checkPlaceholders // false" "$CONFIG_FILE" 2>/dev/null)
  MAX_EXCEPTION_LOC=$(jq -r "$base_path.allowedExceptions.maxLOC // 5" "$CONFIG_FILE" 2>/dev/null)
  SINGLE_FILE_ONLY=$(jq -r "$base_path.allowedExceptions.singleFileOnly // true" "$CONFIG_FILE" 2>/dev/null)

  # Bash 3.2 compatible: read patterns into array
  ALLOWED_EXCEPTION_PATTERNS=()
  while IFS= read -r pattern; do
    [ -n "$pattern" ] && ALLOWED_EXCEPTION_PATTERNS+=("$pattern")
  done < <(jq -r "$base_path.allowedExceptions.patterns[]?" "$CONFIG_FILE" 2>/dev/null)
}

exception_matches_prompt() {
  ALLOWED_EXCEPTION_REASON=""
  if [ ${#ALLOWED_EXCEPTION_PATTERNS[@]} -eq 0 ]; then
    return 1
  fi

  for pattern in "${ALLOWED_EXCEPTION_PATTERNS[@]}"; do
    local clean_pattern=$(echo "$pattern" | tr '[:upper:]' '[:lower:]')
    if [ -n "$clean_pattern" ] && [[ "$PROMPT_LOWER" == *"$clean_pattern"* ]]; then
      ALLOWED_EXCEPTION_REASON="$pattern"
      return 0
    fi
  done

  return 1
}

file_has_structure() {
  local file_path="$1"
  local size=$(wc -c < "$file_path" 2>/dev/null | tr -d ' ')
  if [ -z "$size" ] || [ "$size" -lt 200 ]; then
    return 1
  fi

  if ! grep -qE '^## [0-9]+\. ' "$file_path" 2>/dev/null; then
    return 1
  fi

  if [ "$CHECK_PLACEHOLDERS" = true ] && grep -qE '\[PLACEHOLDER|\[NEEDS CLARIFICATION' "$file_path" 2>/dev/null; then
    return 1
  fi

  return 0
}

VALIDATION_ERRORS=()

validate_templates() {
  local folder="$1"
  VALIDATION_ERRORS=()

  if [ ! -d "$folder" ]; then
    VALIDATION_ERRORS+=("Spec folder not found at $folder")
    return 1
  fi

  local spec_file="$folder/spec.md"
  local readme_file="$folder/README.md"
  local plan_file="$folder/plan.md"

  local has_valid_spec=false
  local has_valid_readme=false

  if [ -f "$spec_file" ] && file_has_structure "$spec_file"; then
    has_valid_spec=true
  fi

  if [ -f "$readme_file" ] && file_has_structure "$readme_file"; then
    has_valid_readme=true
  fi

  if [ "$has_valid_spec" = false ] && [ "$has_valid_readme" = false ]; then
    VALIDATION_ERRORS+=("spec.md or README.md missing/too small (<200 bytes) or missing numbered sections")
  fi

  if [ "$VALIDATION_LEVEL" = "strict" ] && [ -f "$spec_file" ] && ! file_has_structure "$plan_file"; then
    VALIDATION_ERRORS+=("plan.md missing or incomplete for strict validation")
  fi

  if [ ${#VALIDATION_ERRORS[@]} -gt 0 ]; then
    return 1
  fi

  return 0
}

find_latest_spec_folder() {
  if [ ! -d "$SPECS_DIR" ]; then
    return
  fi

  local latest=$(find "$SPECS_DIR" -maxdepth 1 -mindepth 1 -type d -name "[0-9]*-*" 2>/dev/null | sort | tail -1)
  echo "$latest"
}

calculate_next_spec_number() {
  if [ ! -d "$SPECS_DIR" ]; then
    printf "%03d" 1
    return
  fi

  local max=0
  while IFS= read -r dir; do
    local base=$(basename "$dir")
    local num=${base%%-*}
    if [[ "$num" =~ ^[0-9]+$ ]]; then
      if ((10#$num > max)); then
        max=$((10#$num))
      fi
    fi
  done < <(find "$SPECS_DIR" -maxdepth 1 -mindepth 1 -type d -name "[0-9]*-*" 2>/dev/null)

  printf "%03d" $((max + 1))
}

NEXT_SPEC_NUMBER=$(calculate_next_spec_number)

estimate_documentation_level() {
  local text="$1"
  if echo "$text" | grep -qiE "typo|misspell|spelling|grammar|whitespace"; then
    echo 0
    return
  fi
  if echo "$text" | grep -qiE "rename|single file|small fix|docs only"; then
    echo 1
    return
  fi
  if echo "$text" | grep -qiE "architecture|system|platform|multiple services|rebuild"; then
    echo 3
    return
  fi
  if echo "$text" | grep -qiE "feature|component|integration|workflow|refactor"; then
    echo 2
    return
  fi
  echo 2
}

DOC_LEVEL=$(estimate_documentation_level "$PROMPT_LOWER")

get_level_label() {
  case "$DOC_LEVEL" in
    0) echo "0 (Minimal)" ;;
    1) echo "1 (Concise)" ;;
    2) echo "2 (Standard)" ;;
    3) echo "3 (Complete)" ;;
  esac
}

# ───────────────────────────────────────────────────────────────
# RELATED SPEC DISCOVERY FUNCTIONS
# ───────────────────────────────────────────────────────────────

extract_keywords() {
  local text="$1"
  # Remove common stop words and extract significant terms
  local keywords=$(echo "$text" | \
    tr '[:upper:]' '[:lower:]' | \
    sed -E 's/\b(the|is|a|an|and|or|but|in|on|at|to|for|of|with|from)\b//g' | \
    tr -s ' ' '\n' | \
    grep -E '^[a-z]{2,}$' | \
    sort -u | \
    head -10)
  echo "$keywords"
}

get_spec_status() {
  local spec_folder="$1"
  local spec_file="$spec_folder/spec.md"

  if [ ! -f "$spec_file" ]; then
    echo "active"  # Default if spec.md missing
    return
  fi

  # Extract from YAML frontmatter (between --- markers)
  local status=$(awk '/^---$/,/^---$/ {if (/^status:/) {print $2; exit}}' "$spec_file" 2>/dev/null)

  # Default to "active" if missing
  echo "${status:-active}"
}

status_priority() {
  local status="$1"
  case "$status" in
    active) echo "1" ;;
    draft) echo "2" ;;
    paused) echo "3" ;;
    complete) echo "4" ;;
    archived) echo "5" ;;
    *) echo "1" ;; # Treat unknown as active
  esac
}

find_related_specs() {
  local prompt="$1"
  local keywords=$(extract_keywords "$prompt")

  if [ -z "$keywords" ] || [ ! -d "$SPECS_DIR" ]; then
    return
  fi

  # Use simple array (bash 3.2 compatible)
  declare -a matches

  # Helper to check if folder already in matches
  folder_in_matches() {
    local check="$1"
    for m in "${matches[@]}"; do
      [[ "$m" == "$check" ]] && return 0
    done
    return 1
  }

  # Search spec folder names for keyword matches
  while IFS= read -r keyword; do
    [ -z "$keyword" ] && continue

    while IFS= read -r folder; do
      [ -z "$folder" ] && continue
      name=$(basename "$folder")

      # Skip if folder name is just numbers
      [[ "$name" =~ ^[0-9]+$ ]] && continue

      # Skip if already matched
      folder_in_matches "$folder" && continue

      if echo "$name" | grep -qiE "$keyword"; then
        matches+=("$folder")
      fi
    done < <(find "$SPECS_DIR" -maxdepth 1 -mindepth 1 -type d -name "[0-9]*-*" 2>/dev/null)
  done <<< "$keywords"

  # If no matches, return empty
  if [ ${#matches[@]} -eq 0 ]; then
    return
  fi

  # Get status for each match and rank
  declare -a ranked
  for folder in "${matches[@]}"; do
    local status=$(get_spec_status "$folder")
    local priority=$(status_priority "$status")
    ranked+=("$priority:$folder:$status")
  done

  # Sort by priority (1=active is highest), get top 3
  printf '%s\n' "${ranked[@]}" | sort -t: -k1 -n | head -3
}

print_template_guidance() {
  case "$DOC_LEVEL" in
    0)
      print_detail "cp .specify/templates/concise_readme_template.md specs/${NEXT_SPEC_NUMBER}-short-name/README.md"
      ;;
    1)
      print_detail "cp .specify/templates/concise_spec_template.md specs/${NEXT_SPEC_NUMBER}-short-name/spec.md"
      ;;
    2)
      print_detail "cp .specify/templates/spec_template.md specs/${NEXT_SPEC_NUMBER}-short-name/spec.md"
      print_detail "cp .specify/templates/plan_template.md specs/${NEXT_SPEC_NUMBER}-short-name/plan.md"
      ;;
    3)
      print_detail "/speckit.specify (auto-generates Level 3 bundle)"
      ;;
  esac
}

show_block_message() {
  local reason="$1"
  local folder="$2"
  print_error_box "SPEC DOCUMENTATION REQUIRED" \
    "Detected modification intent: ${DETECTED_INTENT:-unknown}" \
    "Estimated documentation level: $(get_level_label)" \
    "Reason: $reason"

  print_section "NEXT ACTIONS"
  print_detail "1. Create folder: specs/${NEXT_SPEC_NUMBER}-short-name/"
  print_detail "2. Copy required templates:" 
  print_template_guidance
  print_detail "3. Fill every placeholder and metadata field"
  print_detail "4. Reference: $DOC_GUIDE"

  if [ -n "$folder" ]; then
    print_detail "Current folder detected: $folder"
  fi

  print_line
  print_detail "Need a refresher? Open .claude/knowledge/conversation_documentation.md"
}

handle_block() {
  local reason="$1"
  local folder="$2"
  log_event "BLOCKED" "$reason"
  show_block_message "$reason" "$folder"

  if [ "$ENFORCEMENT_MODE" = "warning-only" ]; then
    return 0
  fi

  exit 1
}

handle_warning() {
  local reason="$1"
  log_event "WARNING" "$reason"
  print_warn_box "Documentation Warning" "$reason" "Mode: warning-only (execution allowed)"
}

if ! detect_modification_intent; then
  echo "✓ [enforce-spec-folder] No modification detected, skipping validation" >&2
  END_TIME=$(date +%s%N)
  DURATION=$(((END_TIME - START_TIME)/1000000))
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] enforce-spec-folder.sh ${DURATION}ms" >> "$PERF_LOG"
  exit 0
fi

echo "⚡ [enforce-spec-folder] Modification intent detected, validating spec folder..." >&2

load_enforcement_config

if exception_matches_prompt; then
  log_event "ALLOWED" "Exception matched: $ALLOWED_EXCEPTION_REASON"
  END_TIME=$(date +%s%N)
  DURATION=$(((END_TIME - START_TIME)/1000000))
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] enforce-spec-folder.sh ${DURATION}ms" >> "$PERF_LOG"
  exit 0
fi

# ───────────────────────────────────────────────────────────────
# SEARCH FOR RELATED SPECS
# ───────────────────────────────────────────────────────────────

RELATED_SPECS=$(find_related_specs "$PROMPT")

if [ -n "$RELATED_SPECS" ]; then
  echo "📋 [enforce-spec-folder] Found related specs, suggesting reuse..." >&2
  print_section "RELATED SPECS FOUND"
  print_detail "Found existing specs that may be related to your request:"
  print_line

  while IFS=':' read -r priority path status; do
    [ -z "$path" ] && continue
    name=$(basename "$path")
    status_label=""

    case "$status" in
      active) status_label="✓ ACTIVE - recommended for updates" ;;
      draft) status_label="◐ DRAFT - can be started" ;;
      paused) status_label="⏸  PAUSED - can be resumed" ;;
      complete) status_label="✓ COMPLETE - reopening discouraged" ;;
      archived) status_label="📦 ARCHIVED - do not reuse" ;;
      *) status_label="status: $status" ;;
    esac

    print_detail "  • $name"
    print_detail "    Status: $status_label"
    print_detail "    Path: $path"
    print_line
  done <<< "$RELATED_SPECS"

  print_section "RECOMMENDATION"
  print_detail "Consider updating one of the related specs above instead of creating a new one."
  print_detail "Guidelines: .claude/knowledge/conversation_documentation.md Section 7"
  print_detail ""
  print_detail "AI should ask user:"
  print_detail "  A) Update existing spec (if work is related)"
  print_detail "  B) Create new spec (if work is distinct)"
  print_line
fi

# ───────────────────────────────────────────────────────────────

SPEC_FOLDER=""
SPEC_FOLDER_NAME=""
if [ "$CHECK_SPEC_FOLDER" != "false" ]; then
  SPEC_FOLDER=$(find_latest_spec_folder)
  if [ -z "$SPEC_FOLDER" ]; then
    if [ "$ENFORCEMENT_MODE" = "warning-only" ]; then
      handle_warning "No spec folders detected in specs/."
    else
      handle_block "No spec folder detected" ""
    fi
  else
    SPEC_FOLDER_NAME=$(basename "$SPEC_FOLDER")
  fi
fi

if [ -n "$SPEC_FOLDER" ] && [ "$CHECK_TEMPLATES" != "false" ]; then
  if ! validate_templates "$SPEC_FOLDER"; then
    local joined_errors="$(printf '%s; ' "${VALIDATION_ERRORS[@]}")"
    if [ "$ENFORCEMENT_MODE" = "warning-only" ]; then
      handle_warning "$joined_errors"
    else
      handle_block "$joined_errors" "$SPEC_FOLDER_NAME"
    fi
  fi
fi

log_event "ALLOWED" "Spec folder validated: ${SPEC_FOLDER_NAME:-n/a}"
echo "✅ [enforce-spec-folder] Spec folder validated: ${SPEC_FOLDER_NAME:-n/a}" >&2
END_TIME=$(date +%s%N)
DURATION=$(((END_TIME - START_TIME)/1000000))
echo "[$(date '+%Y-%m-%d %H:%M:%S')] enforce-spec-folder.sh ${DURATION}ms (${SPEC_FOLDER_NAME:-no-spec})" >> "$PERF_LOG"
exit 0
