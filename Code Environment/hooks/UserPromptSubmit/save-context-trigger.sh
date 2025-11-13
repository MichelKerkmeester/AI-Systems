#!/bin/bash

# ───────────────────────────────────────────────────────────────
# AUTO SAVE-CONTEXT TRIGGER
# ───────────────────────────────────────────────────────────────
# UserPromptSubmit hook that automatically saves conversation
# context via TWO triggering methods:
#   1. Keyword detection (e.g., "save context", "save conversation")
#   2. Context window threshold (75% used, 25% remaining = 200 messages)
#
# Version: 1.2.0
# Last Updated: 2025-11-09
# ───────────────────────────────────────────────────────────────

# Source output helpers (completely silent on success)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
source "$SCRIPT_DIR/../lib/output-helpers.sh" || exit 0

# Performance timing START
START_TIME=$(date +%s%N)

# Check dependencies (silent on success)
check_dependency "jq" "brew install jq (macOS) or apt install jq (Linux)" || exit 0
check_dependency "node" "Install from https://nodejs.org/" || exit 0

# Read JSON input from stdin
INPUT=$(cat)

# Extract the prompt from JSON (silent on error)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

# Extract session metadata (silent on error)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null)

# ───────────────────────────────────────────────────────────────
# SECURITY: Sanitize SESSION_ID to prevent shell injection
# ───────────────────────────────────────────────────────────────
# SESSION_ID is used in find commands later. Sanitize to allow only
# alphanumeric characters, dash, and underscore (safe for shell)
if [ -n "$SESSION_ID" ]; then
  SESSION_ID=$(echo "$SESSION_ID" | tr -cd 'a-zA-Z0-9_-')
fi

# If no prompt found, allow it silently
if [ -z "$PROMPT" ]; then
  exit 0
fi

# Convert prompt to lowercase for case-insensitive matching
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# ───────────────────────────────────────────────────────────────
# KEYWORD DETECTION
# ───────────────────────────────────────────────────────────────

# Define keywords that trigger auto-save
TRIGGER_KEYWORDS=(
  "save context"
  "save conversation"
  "save session"
  "export conversation"
  "preserve context"
  "capture context"
  "export context"
  "save memory"
  "preserve memory"
  "document conversation"
  "document session"
  "save chat"
  "export session"
  "document this"
  "record this"
  "write this down"
  "store this"
  "backup conversation"
)

# Check if any keyword matches
TRIGGERED=false
MATCHED_KEYWORD=""
TRIGGER_REASON=""

for keyword in "${TRIGGER_KEYWORDS[@]}"; do
  if echo "$PROMPT_LOWER" | grep -qE "\\b${keyword}\\b"; then
    TRIGGERED=true
    MATCHED_KEYWORD="$keyword"
    TRIGGER_REASON="keyword"
    break
  fi
done

# ───────────────────────────────────────────────────────────────
# CONTEXT WINDOW DETECTION (75% used, 25% remaining)
# ───────────────────────────────────────────────────────────────
# NOTE: This is the PRIMARY auto-save mechanism for long
# conversations, triggered automatically at 200 messages.
# ───────────────────────────────────────────────────────────────

if [ "$TRIGGERED" = false ] && [ -n "$SESSION_ID" ]; then
  # Try to find transcript in standard location
  PROJECT_SLUG=$(echo "$CWD" | sed 's|^/||' | sed 's|/|-|g')
  TRANSCRIPT_DIR="$HOME/.claude/projects/$PROJECT_SLUG"
  TRANSCRIPT_PATH=$(find "$TRANSCRIPT_DIR" -name "${SESSION_ID}.jsonl" 2>/dev/null | head -1)

  if [ -f "$TRANSCRIPT_PATH" ]; then
    # Count messages in transcript (each line is a message)
    MESSAGE_COUNT=$(wc -l < "$TRANSCRIPT_PATH" 2>/dev/null | tr -d ' ')

    # Context window thresholds
    # Assuming 200k token context with ~500 tokens/message average
    # 75% used (25% remaining) = ~300 messages, but being conservative with 200 messages
    CONTEXT_THRESHOLD=200

    if [ "$MESSAGE_COUNT" -ge "$CONTEXT_THRESHOLD" ]; then
      TRIGGERED=true
      TRIGGER_REASON="context-window"
      MATCHED_KEYWORD="automatic (75% used, 25% remaining)"
    fi
  fi
fi

# If not triggered, allow prompt to proceed
if [ "$TRIGGERED" = false ]; then
  exit 0
fi

# Display trigger notification immediately (before validation that might fail)
if [ "$TRIGGER_REASON" = "keyword" ]; then
  echo "💾 Auto-saving context (keyword: '$MATCHED_KEYWORD' detected)..."
else
  echo "💾 Auto-saving context (75% capacity: $MESSAGE_COUNT messages ≈ 150k tokens)..."
fi

# ───────────────────────────────────────────────────────────────
# FIND TRANSCRIPT AND VALIDATE ENVIRONMENT
# ───────────────────────────────────────────────────────────────

# Construct transcript path from session ID
if [ -z "$SESSION_ID" ]; then
  echo "   ⚠️  Cannot save: Session ID not available"
  exit 0
fi

# Validate CWD path (security: prevent path traversal)
SAFE_CWD=$(realpath "$CWD" 2>/dev/null || echo "$CWD")
if [ ! -d "$SAFE_CWD" ]; then
  echo "   ⚠️  Cannot save: Invalid working directory"
  exit 0
fi

# Try to find transcript in standard location
# Convert path to Claude project slug format: add leading dash, replace / and . with -
# Security: Only allow alphanumeric, dash, underscore in slug
PROJECT_SLUG=$(echo "$SAFE_CWD" | sed 's|^/|-|' | sed 's|/|-|g' | sed 's|\.|-|g' | sed 's|[^a-zA-Z0-9_-]||g')
TRANSCRIPT_DIR="$HOME/.claude/projects/$PROJECT_SLUG"

# Find most recent transcript (in case of reconnection)
TRANSCRIPT_PATH=$(find "$TRANSCRIPT_DIR" -name "${SESSION_ID}.jsonl" 2>/dev/null | head -1)

if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
  echo "   ⚠️  Cannot save: Transcript file not found"
  exit 0
fi

# ───────────────────────────────────────────────────────────────
# FIND TARGET SPEC FOLDER OR USE MEMORY FALLBACK
# ───────────────────────────────────────────────────────────────

# Check if project has specs/ folder
if [ -d "$CWD/specs" ]; then
  # Find most recent spec folder
  SPEC_FOLDER=$(find "$CWD/specs" -maxdepth 1 -type d -name "[0-9][0-9][0-9]-*" 2>/dev/null | sort -r | head -1)

  if [ -n "$SPEC_FOLDER" ]; then
    SPEC_FOLDER_NAME=$(basename "$SPEC_FOLDER")
    # Create memory directory inside spec folder
    CONTEXT_DIR="$SPEC_FOLDER/memory"
  else
    # No spec folders found - use fallback "memory" folder
    SPEC_FOLDER="$CWD/memory"
    SPEC_FOLDER_NAME="memory"
    # memory fallback: save directly in memory/ without subfolder
    CONTEXT_DIR="$SPEC_FOLDER"
  fi
else
  # No specs directory - use fallback "memory" folder
  SPEC_FOLDER="$CWD/memory"
  SPEC_FOLDER_NAME="memory"
  # memory fallback: save directly in memory/ without subfolder
  CONTEXT_DIR="$SPEC_FOLDER"
fi

# Create directory
mkdir -p "$CONTEXT_DIR"

# ───────────────────────────────────────────────────────────────
# TRANSFORM AND SAVE
# ───────────────────────────────────────────────────────────────

# Create temporary file
TEMP_JSON="/tmp/save-context-keyword-${SESSION_ID}.json"

# Get path to transformer script
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRANSFORMER="$HOOK_DIR/../lib/transform-transcript.js"

if [ ! -f "$TRANSFORMER" ]; then
  echo "   ⚠️  Cannot save: Transform script not found"
  exit 0
fi

# Transform transcript (silently)
node "$TRANSFORMER" "$TRANSCRIPT_PATH" "$TEMP_JSON" >/dev/null 2>&1

if [ ! -f "$TEMP_JSON" ]; then
  echo "   ⚠️  Cannot save: Transform failed"
  exit 0
fi

# Change to project directory
cd "$CWD" || {
  rm -f "$TEMP_JSON"
  exit 0  # Silently exit
}

# Check if save-context skill exists
SAVE_CONTEXT_SCRIPT="$CWD/.claude/skills/save-context/scripts/generate-context.js"

if [ ! -f "$SAVE_CONTEXT_SCRIPT" ]; then
  echo "   ⚠️  Cannot save: save-context skill not found"
  rm -f "$TEMP_JSON"
  exit 0
fi

# Execute save-context script (silently)
# Run in auto-save mode (bypasses alignment prompts)
# Spec folders: saves to memory/ subfolder
# memory fallback: saves directly to memory/ folder
AUTO_SAVE_MODE=true node "$SAVE_CONTEXT_SCRIPT" "$TEMP_JSON" >/dev/null 2>&1
EXIT_CODE=$?

# Clean up
rm -f "$TEMP_JSON"

# ───────────────────────────────────────────────────────────────
# DISPLAY CONFIRMATION TO USER
# ───────────────────────────────────────────────────────────────

# Display completion status to user
if [ $EXIT_CODE -eq 0 ]; then
  # Show relative path from CWD for clarity
  REL_PATH=$(echo "$CONTEXT_DIR" | sed "s|^$CWD/||")
  echo "   ✅ Context saved to: $REL_PATH/"
else
  echo "   ⚠️  Save failed (exit code: $EXIT_CODE)"
fi

# ───────────────────────────────────────────────────────────────
# LOG DETAILED INFO TO FILE
# ───────────────────────────────────────────────────────────────

# Log result to file
LOG_DIR="$SCRIPT_DIR/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/auto-save-context.log"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

{
  echo ""
  echo "───────────────────────────────────────────────────────────────"
  echo "[$TIMESTAMP] AUTO-SAVE TRIGGERED"
  echo "───────────────────────────────────────────────────────────────"
  echo "Trigger: $TRIGGER_REASON"
  if [ "$TRIGGER_REASON" = "keyword" ]; then
    echo "Keyword: '$MATCHED_KEYWORD'"
  elif [ "$TRIGGER_REASON" = "context-window" ]; then
    echo "Reason: Context window 75% used, 25% remaining ($MESSAGE_COUNT messages)"
    echo "Threshold: $CONTEXT_THRESHOLD messages"
  fi
  echo "Session: $SESSION_ID"
  if [ "$SPEC_FOLDER_NAME" = "memory" ]; then
    echo "Target: memory/"
  else
    echo "Target: $SPEC_FOLDER_NAME/memory/"
  fi
  echo "Exit Code: $EXIT_CODE"
  if [ $EXIT_CODE -eq 0 ]; then
    echo "Status: ✅ Success"
  else
    echo "Status: ⚠️  Completed with warnings"
  fi
  echo "───────────────────────────────────────────────────────────────"
  echo ""
} >> "$LOG_FILE"

# Performance timing END
END_TIME=$(date +%s%N)
DURATION=$(( (END_TIME - START_TIME) / 1000000 ))
echo "[$(date '+%Y-%m-%d %H:%M:%S')] save-context-trigger.sh ${DURATION}ms" >> "$HOOKS_DIR/logs/performance.log"

# Allow prompt to proceed to Claude (silently)
exit 0
