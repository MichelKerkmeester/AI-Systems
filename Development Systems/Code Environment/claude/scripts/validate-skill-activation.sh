#!/bin/bash

# ───────────────────────────────────────────────────────────────
# SKILL AUTO-ACTIVATION HOOK
# ───────────────────────────────────────────────────────────────
# Pre-UserPromptSubmit hook that analyzes prompts and suggests
# relevant skills based on keywords, intent, and file context


# Read JSON input from stdin
INPUT=$(cat)

# Extract the prompt from JSON
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

# If no prompt found, allow it
if [ -z "$PROMPT" ]; then
  exit 0
fi

# Load skill rules configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_RULES="$SCRIPT_DIR/skill-rules.json"

if [ ! -f "$SKILL_RULES" ]; then
  # No rules file, silently allow
  exit 0
fi

# Convert prompt to lowercase for case-insensitive matching
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Array to store matched skills
MATCHED_SKILLS=()

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

# Get all skill names
SKILL_NAMES=$(jq -r '.skills | keys[]' "$SKILL_RULES" 2>/dev/null)

while IFS= read -r skill_name; do
  if [ -z "$skill_name" ]; then
    continue
  fi
  
  # Check if skill is always active
  always_active=$(jq -r ".skills[\"$skill_name\"].alwaysActive // false" "$SKILL_RULES" 2>/dev/null)
  
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
  # No skills matched, allow request as-is
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

# Format output by priority
if [ ${#CRITICAL_SKILLS[@]} -gt 0 ]; then
  ACTIVATION_MSG="${ACTIVATION_MSG}

⚠️ CRITICAL SKILLS (Must Apply):
"
  for item in "${CRITICAL_SKILLS[@]}"; do
    skill_name=$(echo "$item" | cut -d'|' -f1)
    desc=$(echo "$item" | cut -d'|' -f2)
    ACTIVATION_MSG="${ACTIVATION_MSG}   • $skill_name - $desc
"
  done
fi

if [ ${#HIGH_SKILLS[@]} -gt 0 ]; then
  ACTIVATION_MSG="${ACTIVATION_MSG}

🚨 HIGH PRIORITY SKILLS (Strongly Recommended):
"
  for item in "${HIGH_SKILLS[@]}"; do
    skill_name=$(echo "$item" | cut -d'|' -f1)
    desc=$(echo "$item" | cut -d'|' -f2)
    ACTIVATION_MSG="${ACTIVATION_MSG}   • $skill_name - $desc
"
  done
fi

if [ ${#MEDIUM_SKILLS[@]} -gt 0 ]; then
  ACTIVATION_MSG="${ACTIVATION_MSG}

🤔 RELEVANT SKILLS (Consider):
"
  for item in "${MEDIUM_SKILLS[@]}"; do
    skill_name=$(echo "$item" | cut -d'|' -f1)
    desc=$(echo "$item" | cut -d'|' -f2)
    ACTIVATION_MSG="${ACTIVATION_MSG}   • $skill_name - $desc
"
  done
fi

# Output the activation message to stderr (visible to user but doesn't modify prompt)
echo "───────────────────────────────────────────────────────────────" >&2
echo "SKILL ACTIVATION CHECK" >&2
echo "$ACTIVATION_MSG" >&2
echo "───────────────────────────────────────────────────────────────" >&2

# Allow the request to proceed (exit 0)
exit 0
