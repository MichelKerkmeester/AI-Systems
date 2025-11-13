#!/bin/bash

# ───────────────────────────────────────────────────────────────
# SKILL AUTO-ACTIVATION HOOK
# ───────────────────────────────────────────────────────────────
# Pre-UserPromptSubmit hook that analyzes prompts and suggests
# relevant skills based on keywords, intent, and file context

# Source output helpers (completely silent on success)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
source "$SCRIPT_DIR/../lib/output-helpers.sh" || exit 0

# Performance timing START
START_TIME=$(date +%s%N)

# Check dependencies (silent on success)
check_dependency "jq" "brew install jq (macOS) or apt install jq (Linux)" || exit 0

# Read JSON input from stdin
INPUT=$(cat)

# Extract the prompt from JSON (silent on error)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

# If no prompt found, allow it
if [ -z "$PROMPT" ]; then
  exit 0
fi

# Load skill rules configuration
SKILL_RULES="$(cd "$SCRIPT_DIR/../.." && pwd)/configs/skill-rules.json"

if [ ! -f "$SKILL_RULES" ]; then
  # No rules file, silently allow
  exit 0
fi

# Validate JSON
validate_json "$SKILL_RULES" || exit 0

# Convert prompt to lowercase for case-insensitive matching
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Array to store matched skills
MATCHED_SKILLS=()

# ───────────────────────────────────────────────────────────────
# SECURITY: REGEX PATTERN VALIDATION
# ───────────────────────────────────────────────────────────────
# Validates regex patterns to prevent ReDoS (Regular Expression Denial of Service)
# attacks from compromised skill-rules.json configuration file
validate_regex_pattern() {
  local pattern="$1"

  # Check for dangerous ReDoS patterns:
  # 1. Nested quantifiers: (a+)+ or (a*)*
  # 2. Excessive wildcards: .*.*.* (3 or more in sequence)
  # 3. Overlapping alternation: (a|a)* or (ab|a)*
  # 4. Exponential backtracking patterns

  # Check for nested quantifiers
  if echo "$pattern" | grep -qE '\([^)]*[+*]\)[+*]'; then
    return 1  # Dangerous: nested quantifiers
  fi

  # Check for excessive consecutive wildcards
  if echo "$pattern" | grep -qE '(\.\*.*){3,}'; then
    return 1  # Dangerous: 3+ wildcards
  fi

  # Pattern is safe
  return 0
}

# ───────────────────────────────────────────────────────────────
# KEYWORD MATCHING
# ───────────────────────────────────────────────────────────────

check_keywords() {
  local skill_name="$1"
  local keywords=$(jq -r ".skills[\"$skill_name\"].promptTriggers.keywords[]" "$SKILL_RULES" 2>/dev/null)

  while IFS= read -r keyword; do
    if [ -n "$keyword" ]; then
      # Escape special regex chars and convert to lowercase
      keyword_lower=$(echo "$keyword" | tr '[:upper:]' '[:lower:]')

      # Validate pattern before use (security: prevent ReDoS)
      if ! validate_regex_pattern "\\b${keyword_lower}\\b"; then
        # Skip dangerous pattern, log warning
        continue
      fi

      if echo "$PROMPT_LOWER" | grep -qE "\\b${keyword_lower}\\b"; then
        return 0  # Match found
      fi
    fi
  done <<< "$keywords"

  return 1  # No match
}

# ───────────────────────────────────────────────────────────────
# INTENT PATTERN MATCHING
# ───────────────────────────────────────────────────────────────

check_intent_patterns() {
  local skill_name="$1"
  local patterns=$(jq -r ".skills[\"$skill_name\"].promptTriggers.intentPatterns[]" "$SKILL_RULES" 2>/dev/null)

  while IFS= read -r pattern; do
    if [ -n "$pattern" ]; then
      # Validate pattern before use (security: prevent ReDoS)
      if ! validate_regex_pattern "$pattern"; then
        # Skip dangerous pattern, log warning
        continue
      fi

      if echo "$PROMPT_LOWER" | grep -qiE "$pattern"; then
        return 0  # Match found
      fi
    fi
  done <<< "$patterns"

  return 1  # No match
}

# ───────────────────────────────────────────────────────────────
# FILE CONTEXT MATCHING
# ───────────────────────────────────────────────────────────────

check_file_context() {
  local skill_name="$1"
  
  # Extract file paths mentioned in prompt (common patterns)
  local file_paths=$(echo "$PROMPT" | grep -oE '(src|specs|knowledge)/[a-zA-Z0-9_/.-]+' || echo "")
  
  if [ -z "$file_paths" ]; then
    return 1  # No file paths in prompt
  fi
  
  local path_patterns=$(jq -r ".skills[\"$skill_name\"].fileTriggers.pathPatterns[]" "$SKILL_RULES" 2>/dev/null)
  
  while IFS= read -r pattern; do
    if [ -n "$pattern" ]; then
      # Convert glob pattern to regex (simple conversion)
      regex_pattern=$(echo "$pattern" | sed 's/\*\*/.\*/g' | sed 's/\*/[^\/]*/g')

      # Validate pattern before use (security: prevent ReDoS)
      if ! validate_regex_pattern "$regex_pattern"; then
        # Skip dangerous pattern, log warning
        continue
      fi

      while IFS= read -r file_path; do
        if echo "$file_path" | grep -qE "$regex_pattern"; then
          return 0  # Match found
        fi
      done <<< "$file_paths"
    fi
  done <<< "$path_patterns"
  
  return 1  # No match
}

# ───────────────────────────────────────────────────────────────
# SKILL EVALUATION
# ───────────────────────────────────────────────────────────────

# Get all skill names (with error handling)
SKILL_NAMES=$(jq -r '.skills | keys[]' "$SKILL_RULES" 2>/dev/null)
if [ -z "$SKILL_NAMES" ]; then
  # Silent failure - log but don't display error to user
  {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Failed to parse skill names from $SKILL_RULES"
  } >> "$LOG_FILE" 2>/dev/null
  exit 0
fi

while IFS= read -r skill_name; do
  if [ -z "$skill_name" ]; then
    continue
  fi

  # Check if skill is always active (with error handling)
  always_active=$(jq -r ".skills[\"$skill_name\"].alwaysActive // false" "$SKILL_RULES" 2>/dev/null)
  if [ $? -ne 0 ]; then
    # jq failed - skip this skill and continue
    continue
  fi
  
  if [ "$always_active" = "true" ]; then
    MATCHED_SKILLS+=("$skill_name")
    continue
  fi
  
  # Check keyword matches
  if check_keywords "$skill_name"; then
    MATCHED_SKILLS+=("$skill_name")
    continue
  fi
  
  # Check intent pattern matches
  if check_intent_patterns "$skill_name"; then
    MATCHED_SKILLS+=("$skill_name")
    continue
  fi
  
  # Check file context matches
  if check_file_context "$skill_name"; then
    MATCHED_SKILLS+=("$skill_name")
    continue
  fi
done <<< "$SKILL_NAMES"

# ───────────────────────────────────────────────────────────────
# GENERATE SKILL ACTIVATION MESSAGE
# ───────────────────────────────────────────────────────────────

if [ ${#MATCHED_SKILLS[@]} -eq 0 ]; then
  # No skills matched, exit silently
  exit 0
fi

# Build activation message
ACTIVATION_MSG=""
CRITICAL_SKILLS=()
HIGH_SKILLS=()
MEDIUM_SKILLS=()

for skill in "${MATCHED_SKILLS[@]}"; do
  priority=$(jq -r ".skills[\"$skill\"].priority" "$SKILL_RULES" 2>/dev/null)
  description=$(jq -r ".skills[\"$skill\"].description" "$SKILL_RULES" 2>/dev/null)

  case "$priority" in
    critical)
      CRITICAL_SKILLS+=("$skill|$description")
      ;;
    high)
      HIGH_SKILLS+=("$skill|$description")
      ;;
    medium)
      MEDIUM_SKILLS+=("$skill|$description")
      ;;
  esac
done

# ───────────────────────────────────────────────────────────────
# DISPLAY CRITICAL SKILLS TO USER
# ───────────────────────────────────────────────────────────────

# Display CRITICAL priority skills to user (others logged only)
if [ ${#CRITICAL_SKILLS[@]} -gt 0 ]; then
  echo ""
  echo "🔴 CRITICAL SKILLS APPLY:"
  for item in "${CRITICAL_SKILLS[@]}"; do
    skill_name=$(echo "$item" | cut -d'|' -f1)
    desc=$(echo "$item" | cut -d'|' -f2)

    # Smart truncation at 100 chars with word boundary preservation
    if [ ${#desc} -gt 100 ]; then
      desc_short="${desc:0:97}"  # Leave room for "..."
      # Truncate at last space to avoid mid-word cut
      desc_short="${desc_short% *}..."
    else
      desc_short="$desc"
    fi

    echo "   • $skill_name - $desc_short"
  done
  echo ""
fi

# ───────────────────────────────────────────────────────────────
# LOG ALL MATCHED SKILLS TO FILE
# ───────────────────────────────────────────────────────────────

# Only log if there are skills to recommend
# Log to file instead of stderr to keep interface clean

# Prepare log directory
LOG_DIR="$SCRIPT_DIR/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/skill-recommendations.log"

# Prepare log entry with timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Write to log file
{
  echo ""
  echo "$SEPARATOR"
  echo "[$TIMESTAMP] SKILL RECOMMENDATIONS"
  echo "$SEPARATOR"
  echo "Prompt: ${PROMPT:0:100}..."
  echo "$SEPARATOR"

  # Format output by priority
  if [ ${#CRITICAL_SKILLS[@]} -gt 0 ]; then
    echo ""
    echo "🔴 CRITICAL (Must Apply)"
    for item in "${CRITICAL_SKILLS[@]}"; do
      skill_name=$(echo "$item" | cut -d'|' -f1)
      desc=$(echo "$item" | cut -d'|' -f2)
      echo "   • $skill_name"
      echo "     $desc"
    done
  fi

  if [ ${#HIGH_SKILLS[@]} -gt 0 ]; then
    echo ""
    echo "🟡 HIGH PRIORITY (Strongly Recommended)"
    for item in "${HIGH_SKILLS[@]}"; do
      skill_name=$(echo "$item" | cut -d'|' -f1)
      desc=$(echo "$item" | cut -d'|' -f2)
      echo "   • $skill_name"
      echo "     $desc"
    done
  fi

  if [ ${#MEDIUM_SKILLS[@]} -gt 0 ]; then
    echo ""
    echo "🔵 RELEVANT SKILLS (Consider)"
    for item in "${MEDIUM_SKILLS[@]}"; do
      skill_name=$(echo "$item" | cut -d'|' -f1)
      desc=$(echo "$item" | cut -d'|' -f2)
      echo "   • $skill_name"
      echo "     $desc"
    done
  fi

  echo ""
  echo "$SEPARATOR"
  echo ""
} >> "$LOG_FILE"

# Performance timing END
END_TIME=$(date +%s%N)
DURATION=$(( (END_TIME - START_TIME) / 1000000 ))
echo "[$(date '+%Y-%m-%d %H:%M:%S')] validate-skill-activation.sh ${DURATION}ms" >> "$HOOKS_DIR/logs/performance.log"

# Allow the request to proceed silently (exit 0)
exit 0
