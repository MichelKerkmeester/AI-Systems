#!/bin/bash

# ───────────────────────────────────────────────────────────────
# BASH COMMAND SECURITY VALIDATION HOOK
# ───────────────────────────────────────────────────────────────
# PreToolUse hook that prevents wasted tokens by blocking reads of
# large, irrelevant files before they consume your context window

# Source output helpers (completely silent on success)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
source "$SCRIPT_DIR/../lib/output-helpers.sh" || exit 0

# Performance timing START
START_TIME=$(date +%s%N)

# Read JSON input from stdin
INPUT=$(cat)

# Extract the command from JSON - correct path (silent on error)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# If no command found, allow it
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Define whitelisted patterns (always allow these specific paths)
WHITELISTED_PATTERNS=(
  "\.claude/logs/"         # Allow reading skill logs
  "\.claude/hooks/logs/"   # Allow reading hook logs
  "\.claude/configs/"      # Allow reading configuration files
)

# Check if command matches any whitelisted patterns
for pattern in "${WHITELISTED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    exit 0  # Whitelisted, allow immediately
  fi
done

# Define forbidden patterns (security + performance)
FORBIDDEN_PATTERNS=(
  # Large directories (performance)
  "node_modules"
  "frontend/node_modules"
  "__pycache__"
  "build/"
  "dist/"
  "venv/"

  # Binary/data files (performance)
  "\.pyc$"
  "\.csv$"
  "\.log$"

  # Sensitive files (security)
  "\.env"
  "\.git/config"
  "\.git/objects"
  "\.ssh/"
  "\.aws/"
  "\.pem$"
  "\.key$"
  "id_rsa"
  "credentials\.json"
  "secrets\."
  "password"

  # Dangerous commands (security)
  "rm -rf /"
  "rm -rf \*"
  ":(){:\|:&};:"
  "chmod 777"
  "chmod -R 777"
  "sudo rm"
  "curl.*\|.*sh"
  "wget.*\|.*sh"
  "eval "
  "> /etc/"
  "dd if=/dev/zero"
  "mkfs\."
)

# ───────────────────────────────────────────────────────────────
# HEREDOC CONTENT EXCLUSION
# ───────────────────────────────────────────────────────────────
# Strip heredoc content from validation to prevent false positives.
# Heredocs are used for writing content (cat > file << 'EOF'), and their
# content should NOT be validated against file patterns.
#
# Examples that should NOT be blocked:
#   cat > report.txt << 'EOF'
#   This report discusses logging systems...  ← Contains ".log" but OK
#   EOF
#
# Only validate the command structure (before <<), not the content.
COMMAND_TO_CHECK="$COMMAND"
if echo "$COMMAND" | grep -q '<<'; then
  # Extract only the command portion before heredoc marker
  # Use head -1 to get first line only, then strip from << onwards
  # This removes both the heredoc marker AND all subsequent content lines
  COMMAND_TO_CHECK=$(echo "$COMMAND" | head -1 | sed 's/<<.*//')
fi

# Check if command contains any forbidden patterns
for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
  if echo "$COMMAND_TO_CHECK" | grep -qE "$pattern"; then
    # Determine the category and provide helpful message
    case "$pattern" in
      "node_modules"|"build/"|"dist/"|"venv/"|"__pycache__")
        print_error_box "COMMAND BLOCKED - Performance" \
          "Pattern: $pattern" \
          "Reason: Large directory wastes tokens and slows execution" \
          "" \
          "Alternative: Use targeted file reads:" \
          "  • Read specific files directly" \
          "  • Use grep/glob patterns to find files" \
          "  • Search with code-specific tools"
        ;;
      "\.env"|"\.ssh/"|"\.aws/"|"\.pem$"|"\.key$"|"id_rsa"|"credentials\.json"|"secrets\."|"password")
        print_error_box "COMMAND BLOCKED - Security" \
          "Pattern: $pattern" \
          "Reason: Sensitive files may contain credentials" \
          "" \
          "Security Risk: This could expose:" \
          "  • API keys and tokens" \
          "  • Passwords and secrets" \
          "  • Private SSH keys" \
          "" \
          "Do not access sensitive files in conversations."
        ;;
      *)
        print_error_box "COMMAND BLOCKED - Security" \
          "Pattern: $pattern" \
          "Reason: Dangerous command blocked by security policy" \
          "" \
          "This command could:" \
          "  • Delete important files" \
          "  • Modify system settings" \
          "  • Compromise system security" \
          "" \
          "Please use safer alternatives."
        ;;
    esac
    exit 2  # Exit code 2 = blocking error
  fi
done

# Performance timing END
END_TIME=$(date +%s%N)
DURATION=$(( (END_TIME - START_TIME) / 1000000 ))
HOOKS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] validate-bash.sh ${DURATION}ms" >> "$HOOKS_DIR/logs/performance.log"

# Command is clean, allow it
exit 0