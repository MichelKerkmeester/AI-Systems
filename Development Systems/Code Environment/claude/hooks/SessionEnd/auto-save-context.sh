#!/bin/bash

# ───────────────────────────────────────────────────────────────
# AUTO SAVE-CONTEXT ON SESSION END
# ───────────────────────────────────────────────────────────────
# SessionEnd hook that automatically saves conversation context
# when a session terminates (clear, logout, exit)
#
# Version: 1.0.0
# Last Updated: 2025-11-08
# ───────────────────────────────────────────────────────────────

# Read JSON input from stdin
INPUT=$(cat)

# Extract hook data
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')
REASON=$(echo "$INPUT" | jq -r '.reason // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Debug logging (uncomment for troubleshooting)
# echo "DEBUG: SessionEnd triggered" >&2
# echo "  Session ID: $SESSION_ID" >&2
# echo "  Reason: $REASON" >&2
# echo "  Transcript: $TRANSCRIPT_PATH" >&2

# ───────────────────────────────────────────────────────────────
# VALIDATION CHECKS
# ───────────────────────────────────────────────────────────────

# Only save on specific exit reasons
case "$REASON" in
  "clear"|"logout"|"prompt_input_exit")
    # Proceed with save
    ;;
  *)
    # Unknown or unhandled reason, skip silently
    exit 0
    ;;
esac

# Expand tilde in transcript path
TRANSCRIPT_PATH="${TRANSCRIPT_PATH/#\~/$HOME}"

# Check if transcript exists and is readable
if [ ! -f "$TRANSCRIPT_PATH" ] || [ ! -r "$TRANSCRIPT_PATH" ]; then
  echo "⚠️  Transcript not found or not readable: $TRANSCRIPT_PATH" >&2
  exit 0
fi

# Check if we're in a valid project directory
if [ -z "$CWD" ] || [ ! -d "$CWD" ]; then
  echo "⚠️  Invalid working directory: $CWD" >&2
  exit 0
fi

# Check if project has specs/ folder
if [ ! -d "$CWD/specs" ]; then
  # No specs folder - skip save silently (user may not be using spec system)
  exit 0
fi

# ───────────────────────────────────────────────────────────────
# FIND TARGET SPEC FOLDER
# ───────────────────────────────────────────────────────────────

# Find most recent spec folder (format: ###-name)
SPEC_FOLDER=$(find "$CWD/specs" -maxdepth 1 -type d -name "[0-9][0-9][0-9]-*" 2>/dev/null | sort -r | head -1)

if [ -z "$SPEC_FOLDER" ]; then
  # No numbered spec folder found - skip save
  echo "⚠️  No spec folder (###-name) found in $CWD/specs/" >&2
  echo "    Create a spec folder first: mkdir -p specs/###-topic-name" >&2
  exit 0
fi

SPEC_FOLDER_NAME=$(basename "$SPEC_FOLDER")

# Create context directory if it doesn't exist
CONTEXT_DIR="$SPEC_FOLDER/context"
mkdir -p "$CONTEXT_DIR"

# ───────────────────────────────────────────────────────────────
# TRANSFORM TRANSCRIPT TO SAVE-CONTEXT FORMAT
# ───────────────────────────────────────────────────────────────

# Create temporary file for transformed data
TEMP_JSON="/tmp/save-context-data-${SESSION_ID}.json"

# Get path to transformer script
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRANSFORMER="$HOOK_DIR/../lib/transform-transcript.js"

if [ ! -f "$TRANSFORMER" ]; then
  echo "❌ Transformer script not found: $TRANSFORMER" >&2
  exit 1
fi

# Run transformation
echo "🔄 Transforming transcript data..." >&2

node "$TRANSFORMER" "$TRANSCRIPT_PATH" "$TEMP_JSON" 2>&1

# Check if transformation succeeded
if [ ! -f "$TEMP_JSON" ]; then
  echo "❌ Transcript transformation failed" >&2
  exit 1
fi

# ───────────────────────────────────────────────────────────────
# EXECUTE SAVE-CONTEXT SCRIPT
# ───────────────────────────────────────────────────────────────

# Change to project directory
cd "$CWD" || {
  echo "❌ Failed to change to project directory: $CWD" >&2
  rm -f "$TEMP_JSON"
  exit 1
}

# Check if save-context skill exists
SAVE_CONTEXT_SCRIPT="$CWD/.claude/skills/save-context/scripts/generate-context.js"

if [ ! -f "$SAVE_CONTEXT_SCRIPT" ]; then
  echo "❌ save-context skill not found at: $SAVE_CONTEXT_SCRIPT" >&2
  rm -f "$TEMP_JSON"
  exit 1
fi

# Execute save-context script
echo "💾 Auto-saving context to: $SPEC_FOLDER_NAME/context/" >&2
echo "" >&2

# Run with automatic overwrite (no interactive prompt)
echo "O" | node "$SAVE_CONTEXT_SCRIPT" "$TEMP_JSON" 2>&1

EXIT_CODE=$?

# Clean up temporary file
rm -f "$TEMP_JSON"

# Report result
if [ $EXIT_CODE -eq 0 ]; then
  echo "" >&2
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
  echo "✅ Context saved successfully!" >&2
  echo "   Location: $SPEC_FOLDER_NAME/context/" >&2
  echo "   Trigger: Session ended ($REASON)" >&2
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
else
  echo "" >&2
  echo "⚠️  save-context script exited with code $EXIT_CODE" >&2
fi

# Always exit with success to not block session end
exit 0
