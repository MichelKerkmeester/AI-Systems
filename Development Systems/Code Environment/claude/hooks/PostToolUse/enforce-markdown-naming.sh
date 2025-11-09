#!/bin/bash
# enforce-markdown-naming.sh
# PostToolUse hook to automatically enforce markdown filename conventions
# Based on: knowledge/document_style_guide.md (lines 36-62)
#
# Detects and auto-corrects:
# - ALL CAPS filenames (except README.md and SKILL.md)
# - Hyphen-separated names
# - camelCase/PascalCase names
#
# Enforces: lowercase snake_case only (e.g., document_name.md)
# Exceptions: README.md, SKILL.md (in .claude/skills/*/ only)

# Source output helpers for consistent formatting
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/lib"

if [[ -f "$LIB_DIR/output-helpers.sh" ]]; then
    source "$LIB_DIR/output-helpers.sh"
fi

# Configuration
LOG_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/logs"
LOG_FILE="$LOG_DIR/naming-corrections.log"
STYLE_GUIDE="/Users/michelkerkmeester/MEGA/Websites/anobel.com/knowledge/document_style_guide.md"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Function to log corrections
log_correction() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Function to convert filename to lowercase snake_case
to_snake_case() {
    local filename="$1"
    local extension="${filename##*.}"
    local basename="${filename%.*}"

    # Convert to lowercase
    basename=$(echo "$basename" | tr '[:upper:]' '[:lower:]')

    # Replace hyphens with underscores
    basename=$(echo "$basename" | tr '-' '_')

    # Insert underscores before uppercase letters in camelCase
    # (already lowercased, so handle spacing)
    basename=$(echo "$basename" | sed 's/\([a-z]\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]')

    # Replace multiple underscores with single underscore
    basename=$(echo "$basename" | sed 's/__*/_/g')

    # Remove leading/trailing underscores
    basename=$(echo "$basename" | sed 's/^_//;s/_$//')

    echo "${basename}.${extension}"
}

# Function to check if filename violates naming rules
is_violation() {
    local filename="$1"
    local filepath="$2"

    # Exception: README.md is always allowed
    if [[ "$filename" == "README.md" ]]; then
        return 1  # Not a violation
    fi

    # Exception: SKILL.md is allowed in .claude/skills/*/ directories
    if [[ "$filename" == "SKILL.md" && "$filepath" =~ \.claude/skills/ ]]; then
        return 1  # Not a violation
    fi

    # Check if .md file
    if [[ "$filename" != *.md ]]; then
        return 1  # Not a markdown file
    fi

    local basename="${filename%.*}"

    # Check for uppercase letters
    if [[ "$basename" =~ [A-Z] ]]; then
        return 0  # Violation
    fi

    # Check for hyphens
    if [[ "$basename" =~ - ]]; then
        return 0  # Violation
    fi

    return 1  # Not a violation
}

# Main enforcement logic
main() {
    # Read tool input from stdin
    local input=$(cat)

    # Extract tool name
    local tool_name=$(echo "$input" | jq -r '.tool_name // .toolName // empty' 2>/dev/null)

    # Only process Write, Edit, NotebookEdit tools
    case "$tool_name" in
        "Write"|"Edit"|"NotebookEdit"|"create_file"|"edit_notebook_file"|"replace_string_in_file")
            ;;
        *)
            # Not a file editing tool, exit silently
            exit 0
            ;;
    esac

    # Extract file_path from tool input
    local file_path=$(echo "$input" | jq -r '.tool_input.filePath // .tool_input.file_path // .tool_input.path // .tool_input.notebook_path // empty' 2>/dev/null)

    # Skip if no file path found
    if [[ -z "$file_path" || "$file_path" == "null" ]]; then
        exit 0
    fi

    # Get just the filename
    local filename=$(basename "$file_path")
    local dirname=$(dirname "$file_path")

    # Check if violation exists
    if ! is_violation "$filename" "$file_path"; then
        exit 0
    fi

    # Generate corrected filename
    local corrected_filename=$(to_snake_case "$filename")

    # If already correct, skip
    if [[ "$filename" == "$corrected_filename" ]]; then
        exit 0
    fi

    local corrected_path="${dirname}/${corrected_filename}"

    # Perform the rename
    if [[ -f "$file_path" ]]; then
        mv "$file_path" "$corrected_path" 2>/dev/null

        if [[ $? -eq 0 ]]; then
            # Log the correction
            log_correction "RENAMED: $file_path → $corrected_path (naming convention violation)"

            # Inject correction notice into AI context (to stderr so it appears in system reminders)
            cat >&2 << EOF

⚠️  MARKDOWN NAMING AUTO-CORRECTED:
   Renamed: $file_path → $corrected_filename
   Reason: Violates document_style_guide.md naming conventions
   Rule: Only README.md and SKILL.md (in .claude/skills/) may use ALL CAPS
   Enforced: lowercase snake_case for all other markdown files
   Reference: $STYLE_GUIDE:37-42

   ✓ Future markdown files should follow: lowercase_snake_case.md
   ✗ Avoid: ALL_CAPS.md, My-File.md, MyFile.md, myFile.md
   ✓ Exceptions: README.md, .claude/skills/*/SKILL.md

EOF
        fi
    fi
}

# Execute main function
main

exit 0
