#!/bin/bash

# ───────────────────────────────────────────────────────────────
# POST-TOOL-USE QUALITY CHECK HOOK
# ───────────────────────────────────────────────────────────────
# Runs after tools are used and provides gentle self-check
# Reminders based on file edits and code patterns


# Read JSON input from stdin
INPUT=$(cat)

# Extract tool information from the input
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // .toolName // empty' 2>/dev/null)

# Only process file editing tools
case "$TOOL_NAME" in
  "Edit"|"Write"|"NotebookEdit"|"replace_string_in_file"|"create_file"|"edit_notebook_file")
    # Extract file path from tool input
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.filePath // .tool_input.file_path // .tool_input.path // .tool_input.notebook_path // empty' 2>/dev/null)

    if [ -z "$FILE_PATH" ]; then
      exit 0
    fi
    ;;
  *)
    # Not a file editing tool, exit silently
    exit 0
    ;;
esac

# Load risk patterns configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_RULES="$SCRIPT_DIR/skill-rules.json"

if [ ! -f "$SKILL_RULES" ]; then
  # No rules file, silently exit
  exit 0
fi

# Array to store triggered reminders
TRIGGERED_REMINDERS=()

# ───────────────────────────────────────────────────────────────
# CHECK FILE FOR RISK PATTERNS
# ───────────────────────────────────────────────────────────────

check_file_for_patterns() {
  local file_path="$1"
  
  # Skip if file doesn't exist or isn't readable
  if [ ! -f "$file_path" ] || [ ! -r "$file_path" ]; then
    return
  fi
  
  # Get file content
  local content=$(cat "$file_path" 2>/dev/null)
  
  if [ -z "$content" ]; then
    return
  fi
  
  # Check each risk pattern category
  local risk_categories=$(jq -r '.riskPatterns | keys[]' "$SKILL_RULES" 2>/dev/null)
  
  while IFS= read -r category; do
    if [ -z "$category" ]; then
      continue
    fi
    
    # Get patterns for this category
    local patterns=$(jq -r ".riskPatterns[\"$category\"].patterns[]" "$SKILL_RULES" 2>/dev/null)
    
    # Check if any pattern matches
    local matched=false
    while IFS= read -r pattern; do
      if [ -n "$pattern" ]; then
        if echo "$content" | grep -qE "$pattern"; then
          matched=true
          break
        fi
      fi
    done <<< "$patterns"
    
    # If matched, add reminder (avoid duplicates)
    if [ "$matched" = true ]; then
      local reminder=$(jq -r ".riskPatterns[\"$category\"].reminder" "$SKILL_RULES" 2>/dev/null)
      
      # Check if reminder already added
      local already_added=false
      for existing in "${TRIGGERED_REMINDERS[@]}"; do
        if [ "$existing" = "$reminder" ]; then
          already_added=true
          break
        fi
      done
      
      if [ "$already_added" = false ]; then
        TRIGGERED_REMINDERS+=("$reminder")
      fi
    fi
  done <<< "$risk_categories"
}

# Check the edited file
check_file_for_patterns "$FILE_PATH"

# ───────────────────────────────────────────────────────────────
# OUTPUT REMINDERS
# ───────────────────────────────────────────────────────────────

if [ ${#TRIGGERED_REMINDERS[@]} -gt 0 ]; then
  echo "" >&2
  echo "───────────────────────────────────────────────────────────────" >&2
  echo "QUALITY CHECK REMINDERS" >&2
  echo "" >&2
  
  for reminder in "${TRIGGERED_REMINDERS[@]}"; do
    echo "$reminder" >&2
    echo "" >&2
  done
  
  echo "───────────────────────────────────────────────────────────────" >&2
fi

# Always allow (non-blocking)
exit 0
