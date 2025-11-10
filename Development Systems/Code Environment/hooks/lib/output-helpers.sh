#!/bin/bash

# ───────────────────────────────────────────────────────────────
# HOOK OUTPUT HELPERS
# ───────────────────────────────────────────────────────────────
# Shared formatting functions for consistent hook output
#
# Version: 1.0.0
# Created: 2025-11-08
# ───────────────────────────────────────────────────────────────

# ───────────────────────────────────────────────────────────────
# CONFIGURATION
# ───────────────────────────────────────────────────────────────

# Separator (consistent 48-char width)
SEPARATOR="────────────────────────────────────────────────"

# ANSI Color Codes
COLOR_RESET='\033[0m'
COLOR_INFO='\033[0;34m'      # Blue
COLOR_SUCCESS='\033[0;32m'   # Green
COLOR_WARN='\033[0;33m'      # Yellow
COLOR_ERROR='\033[0;31m'     # Red
COLOR_BOLD='\033[1m'
COLOR_DIM='\033[2m'

# Emoji Standards - Severity Levels
EMOJI_INFO="ℹ️ "
EMOJI_SUCCESS="✅"
EMOJI_WARN="⚠️ "
EMOJI_ERROR="❌"

# Emoji Standards - Process States
EMOJI_TRIGGER="🚀"
EMOJI_PROCESS="⏳"
EMOJI_SAVE="💾"

# Emoji Standards - Priority Levels
EMOJI_CRITICAL="🔴"
EMOJI_HIGH="🟡"
EMOJI_MEDIUM="🔵"

# Detect color support (completely silent)
USE_COLORS=true
if ! [ -t 2 ] 2>/dev/null || [ "$TERM" = "dumb" ] 2>/dev/null || [ -z "$TERM" ] 2>/dev/null; then
  USE_COLORS=false
fi 2>/dev/null

# ───────────────────────────────────────────────────────────────
# CORE FUNCTIONS
# ───────────────────────────────────────────────────────────────

# Print separator line
print_separator() {
  echo "$SEPARATOR" >&2
}

# Print empty line (for spacing)
print_line() {
  echo "" >&2
}

# Print message with level indicator
# Usage: print_message <level> <title> [message]
# Levels: INFO, SUCCESS, WARN, ERROR, TRIGGER, PROCESS, SAVE
print_message() {
  local level="$1"
  local title="$2"
  local message="${3:-}"

  local color=""
  local emoji=""

  case "$level" in
    INFO)
      color="$COLOR_INFO"
      emoji="$EMOJI_INFO"
      ;;
    SUCCESS)
      color="$COLOR_SUCCESS"
      emoji="$EMOJI_SUCCESS"
      ;;
    WARN)
      color="$COLOR_WARN"
      emoji="$EMOJI_WARN"
      ;;
    ERROR)
      color="$COLOR_ERROR"
      emoji="$EMOJI_ERROR"
      ;;
    TRIGGER)
      color="$COLOR_SUCCESS"
      emoji="$EMOJI_TRIGGER"
      ;;
    PROCESS)
      color="$COLOR_INFO"
      emoji="$EMOJI_PROCESS"
      ;;
    SAVE)
      color="$COLOR_INFO"
      emoji="$EMOJI_SAVE"
      ;;
  esac

  if [ "$USE_COLORS" = true ]; then
    echo -e "${color}${emoji} ${title}${COLOR_RESET}" >&2
  else
    echo "${emoji} ${title}" >&2
  fi

  if [ -n "$message" ]; then
    echo "   $message" >&2
  fi
}

# Print boxed section with header
# Usage: print_section <title>
print_section() {
  local title="$1"

  print_line
  print_separator

  if [ "$USE_COLORS" = true ]; then
    echo -e "${COLOR_BOLD}${title}${COLOR_RESET}" >&2
  else
    echo "$title" >&2
  fi

  print_separator
}

# Print skill priority header
# Usage: print_skill_priority <priority> <title>
# Priority: critical, high, medium
print_skill_priority() {
  local priority="$1"
  local title="$2"

  local emoji=""
  case "$priority" in
    critical)
      emoji="$EMOJI_CRITICAL"
      ;;
    high)
      emoji="$EMOJI_HIGH"
      ;;
    medium)
      emoji="$EMOJI_MEDIUM"
      ;;
  esac

  print_line
  if [ "$USE_COLORS" = true ]; then
    echo -e "${emoji} ${COLOR_BOLD}${title}${COLOR_RESET}" >&2
  else
    echo "${emoji} ${title}" >&2
  fi
}

# Print indented detail line
# Usage: print_detail <text>
print_detail() {
  echo "   $1" >&2
}

# Print bullet point
# Usage: print_bullet <text>
print_bullet() {
  echo "   • $1" >&2
}

# Print sub-bullet (nested)
# Usage: print_sub_bullet <text>
print_sub_bullet() {
  echo "     $1" >&2
}

# Check if command exists
# Usage: check_dependency <command_name> <install_hint>
# Returns: 0 if exists, 1 if missing (prints error)
check_dependency() {
  local cmd="$1"
  local hint="${2:-}"

  # Completely silent check - no stderr leakage
  if ! command -v "$cmd" >/dev/null 2>&1; then
    print_line
    print_separator
    print_message "ERROR" "Dependency Missing: $cmd"

    if [ -n "$hint" ]; then
      print_detail "Install: $hint"
    fi

    print_detail "Hook functionality limited until resolved."
    print_separator
    return 1
  fi

  # Silent success - no output at all
  return 0
}

# Validate JSON file
# Usage: validate_json <file_path>
# Returns: 0 if valid, 1 if invalid (prints error)
validate_json() {
  local file_path="$1"

  if [ ! -f "$file_path" ]; then
    print_message "ERROR" "File not found: $file_path"
    return 1
  fi

  # Completely silent validation - no stderr leakage
  if ! jq empty "$file_path" >/dev/null 2>&1; then
    print_line
    print_separator
    print_message "ERROR" "Invalid JSON Configuration"
    print_detail "File: $file_path"
    print_detail "Validate with: jq . $file_path"
    print_separator
    return 1
  fi

  # Silent success
  return 0
}

# ───────────────────────────────────────────────────────────────
# CONVENIENCE FUNCTIONS
# ───────────────────────────────────────────────────────────────

# Print a complete info box
# Usage: print_info_box <title> <lines...>
print_info_box() {
  local title="$1"
  shift

  print_line
  print_separator
  print_message "INFO" "$title"
  print_separator

  for line in "$@"; do
    print_detail "$line"
  done
}

# Print a complete success box
# Usage: print_success_box <title> <lines...>
print_success_box() {
  local title="$1"
  shift

  print_line
  print_separator
  print_message "SUCCESS" "$title"

  for line in "$@"; do
    print_detail "$line"
  done

  print_separator
}

# Print a complete warning box
# Usage: print_warn_box <title> <lines...>
print_warn_box() {
  local title="$1"
  shift

  print_line
  print_separator
  print_message "WARN" "$title"

  for line in "$@"; do
    print_detail "$line"
  done

  print_separator
}

# Print a complete error box
# Usage: print_error_box <title> <lines...>
print_error_box() {
  local title="$1"
  shift

  print_line
  print_separator
  print_message "ERROR" "$title"

  for line in "$@"; do
    print_detail "$line"
  done

  print_separator
}

# ───────────────────────────────────────────────────────────────
# END OF LIBRARY
# ───────────────────────────────────────────────────────────────
