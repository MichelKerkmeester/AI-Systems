#!/bin/bash

# ───────────────────────────────────────────────────────────────
# AUTO SAVE-CONTEXT ON KEYWORD TRIGGER
# ───────────────────────────────────────────────────────────────
# UserPromptSubmit hook that automatically saves conversation
# context when user types trigger keywords
#
# Version: 1.0.0
# Last Updated: 2025-11-08
# ───────────────────────────────────────────────────────────────

# Read JSON input from stdin
INPUT=$(cat)

# Extract the prompt from JSON
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

# Extract session metadata
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# If no prompt found, allow it
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
  "ultrathink"
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

for keyword in "${TRIGGER_KEYWORDS[@]}"; do
  if echo "$PROMPT_LOWER" | grep -qE "\\b${keyword}\\b"; then
    TRIGGERED=true
    MATCHED_KEYWORD="$keyword"
    break
  fi
done

# If not triggered, allow prompt to proceed
if [ "$TRIGGERED" = false ]; then
  exit 0
fi

# ───────────────────────────────────────────────────────────────
# FIND TRANSCRIPT AND VALIDATE ENVIRONMENT
# ───────────────────────────────────────────────────────────────

# Construct transcript path from session ID
if [ -z "$SESSION_ID" ]; then
  echo "⚠️  No session ID available - cannot locate transcript" >&2
  exit 0
fi

# Try to find transcript in standard location
PROJECT_SLUG=$(echo "$CWD" | sed 's|^/||' | sed 's|/|-|g')
TRANSCRIPT_DIR="$HOME/.claude/projects/$PROJECT_SLUG"

# Find most recent transcript (in case of reconnection)
TRANSCRIPT_PATH=$(find "$TRANSCRIPT_DIR" -name "${SESSION_ID}.jsonl" 2>/dev/null | head -1)

if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
  echo "⚠️  Transcript not found for session: $SESSION_ID" >&2
  echo "    Expected location: $TRANSCRIPT_DIR/" >&2
  exit 0
fi

# Check if project has specs/ folder
if [ ! -d "$CWD/specs" ]; then
  echo "⚠️  No specs/ folder found in project" >&2
  echo "    Create one first: mkdir -p specs/###-topic-name" >&2
  exit 0
fi

# ───────────────────────────────────────────────────────────────
# FIND TARGET SPEC FOLDER
# ───────────────────────────────────────────────────────────────

# Find most recent spec folder
SPEC_FOLDER=$(find "$CWD/specs" -maxdepth 1 -type d -name "[0-9][0-9][0-9]-*" 2>/dev/null | sort -r | head -1)

if [ -z "$SPEC_FOLDER" ]; then
  echo "⚠️  No spec folder (###-name) found in $CWD/specs/" >&2
  echo "    Create a spec folder first: mkdir -p specs/###-topic-name" >&2
  exit 0
fi

SPEC_FOLDER_NAME=$(basename "$SPEC_FOLDER")

# Create context directory
CONTEXT_DIR="$SPEC_FOLDER/context"
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
  echo "❌ Transformer script not found: $TRANSFORMER" >&2
  exit 0
fi

# Notify user that auto-save is triggered
echo "" >&2
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
echo "🚀 AUTO-SAVE TRIGGERED" >&2
echo "   Keyword detected: '$MATCHED_KEYWORD'" >&2
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
echo "" >&2

# Transform transcript
echo "🔄 Transforming transcript data..." >&2
node "$TRANSFORMER" "$TRANSCRIPT_PATH" "$TEMP_JSON" 2>&1

if [ ! -f "$TEMP_JSON" ]; then
  echo "❌ Transformation failed" >&2
  exit 0
fi

# Change to project directory
cd "$CWD" || {
  echo "❌ Failed to change to project directory" >&2
  rm -f "$TEMP_JSON"
  exit 0
}

# Check if save-context skill exists
SAVE_CONTEXT_SCRIPT="$CWD/.claude/skills/save-context/scripts/generate-context.js"

if [ ! -f "$SAVE_CONTEXT_SCRIPT" ]; then
  echo "❌ save-context skill not found" >&2
  rm -f "$TEMP_JSON"
  exit 0
fi

# Execute save-context script
echo "💾 Saving context to: $SPEC_FOLDER_NAME/context/" >&2
echo "" >&2

# Run with automatic overwrite
echo "O" | node "$SAVE_CONTEXT_SCRIPT" "$TEMP_JSON" 2>&1

EXIT_CODE=$?

# Clean up
rm -f "$TEMP_JSON"

# Report result
if [ $EXIT_CODE -eq 0 ]; then
  echo "" >&2
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
  echo "✅ Context saved successfully!" >&2
  echo "   Location: $SPEC_FOLDER_NAME/context/" >&2
  echo "   Trigger: Keyword ('$MATCHED_KEYWORD')" >&2
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
else
  echo "⚠️  Save completed with warnings (exit code: $EXIT_CODE)" >&2
fi

# Allow prompt to proceed to Claude
exit 0
