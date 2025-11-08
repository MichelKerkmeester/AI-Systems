#!/bin/bash

# ───────────────────────────────────────────────────────────────
# BASH COMMAND SECURITY VALIDATION HOOK
# ───────────────────────────────────────────────────────────────
# PreToolUse hook that prevents wasted tokens by blocking reads of
# large, irrelevant files before they consume your context window


# Read JSON input from stdin
INPUT=$(cat)

# Extract the command from JSON - correct path
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# If no command found, allow it
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Define whitelisted patterns (always allow these)
WHITELISTED_PATTERNS=(
  "\.claude/logs/"
)

# Check if command matches any whitelisted patterns
for pattern in "${WHITELISTED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    exit 0  # Whitelisted, allow immediately
  fi
done

# Define forbidden patterns
FORBIDDEN_PATTERNS=(
  "node_modules"
  "frontend/node_modules"
  # "pipelines/data"
  "\.env"
  "build/"
  "dist/"
  # "data/"
  "__pycache__"
  "\.git/"
  "venv/"
  "\.pyc$"
  "\.csv$"
  "\.log$"
)

# Check if command contains any forbidden patterns
for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "ERROR: Access to '$pattern' is blocked by security policy" >&2
    exit 2  # Exit code 2 = blocking error
  fi
done

# Command is clean, allow it
exit 0