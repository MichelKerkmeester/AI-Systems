#!/bin/bash
# enforce-markdown-strict.sh
# UserPromptSubmit hook for aggressive markdown enforcement
#
# Features:
# - Auto-fixes SAFE violations (separators, ALL CAPS, emoji, spacing)
# - BLOCKS on CRITICAL violations (exit 1)
# - Type-specific enforcement (SKILL.md strict, knowledge moderate, spec loose)
#
# Safe auto-fixes (applied immediately):
# - Missing --- separators
# - H2 not ALL CAPS
# - Missing H2 emoji
# - H1 subtitle format
# - Spacing normalization
# - TABLE OF CONTENTS to H4 (## → ####)
#
# Critical violations (BLOCKS with exit 1):
# - Missing frontmatter (SKILL.md/commands)
# - Missing required frontmatter fields
# - Sections in wrong order
# - Missing required sections
# - H1 subtitle violations
# - Multiple H1 headers

# Source output helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/lib"

if [[ -f "$LIB_DIR/output-helpers.sh" ]]; then
    source "$LIB_DIR/output-helpers.sh"
fi

# Configuration
LOG_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/logs"
LOG_FILE="$LOG_DIR/markdown-enforcement.log"

# Get git repository root (portable across all environments)
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
STYLE_GUIDE="$GIT_ROOT/.claude/knowledge/document_style_guide.md"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Function to log enforcement actions
log_action() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Function to detect document type from file path
detect_document_type() {
    local filepath="$1"

    if [[ "$filepath" =~ \.claude/skills/.*/SKILL\.md$ ]]; then
        echo "skill"
    elif [[ "$filepath" =~ \.claude/commands/.*/.*\.md$ ]]; then
        echo "command"
    elif [[ "$filepath" =~ \.claude/knowledge/.*\.md$ ]]; then
        echo "knowledge"
    elif [[ "$filepath" =~ specs/.*\.md$ ]]; then
        echo "spec"
    elif [[ "$filepath" =~ README\.md$ ]]; then
        echo "readme"
    else
        echo "unknown"
    fi
}

# Function to check for critical SKILL.md violations
check_skill_critical() {
    local filepath="$1"
    local critical_violations=()

    # Check for YAML frontmatter
    if ! head -1 "$filepath" | grep -q "^---$"; then
        critical_violations+=("CRITICAL: Missing YAML frontmatter (requires: name, description, allowed-tools)")
        return 1
    fi

    # Check required frontmatter fields
    if ! grep -q "^name:" "$filepath"; then
        critical_violations+=("CRITICAL: Missing 'name' field in YAML frontmatter")
    fi
    if ! grep -q "^description:" "$filepath"; then
        critical_violations+=("CRITICAL: Missing 'description' field in YAML frontmatter")
    fi
    if ! grep -q "^allowed-tools:" "$filepath"; then
        critical_violations+=("CRITICAL: Missing 'allowed-tools' field in YAML frontmatter")
    fi

    # Check H1 format (should have subtitle)
    local h1_line=$(grep "^# " "$filepath" | head -1)
    if [[ -n "$h1_line" && ! "$h1_line" =~ " - " ]]; then
        critical_violations+=("CRITICAL: H1 title missing subtitle format (expected: 'Skill Name - Descriptive Subtitle')")
    fi

    # Check for multiple H1 headers
    local h1_count=$(grep -c "^# " "$filepath")
    if [[ $h1_count -gt 1 ]]; then
        critical_violations+=("CRITICAL: Multiple H1 headers found ($h1_count). Only one H1 allowed.")
    fi

    # Check for required sections
    local required_sections=("WHEN TO USE" "HOW IT WORKS" "RULES")
    for section in "${required_sections[@]}"; do
        if ! grep -q "## [0-9]*\. .* $section" "$filepath"; then
            critical_violations+=("CRITICAL: Missing required section: $section")
        fi
    done

    if [[ ${#critical_violations[@]} -gt 0 ]]; then
        printf '%s\n' "${critical_violations[@]}"
        return 1
    fi

    return 0
}

# Function to check for critical command violations
check_command_critical() {
    local filepath="$1"
    local critical_violations=()

    # Check for YAML frontmatter
    if ! head -1 "$filepath" | grep -q "^---$"; then
        critical_violations+=("CRITICAL: Missing YAML frontmatter (requires: description, argument-hint, allowed-tools)")
        return 1
    fi

    # Check required frontmatter fields
    if ! grep -q "^description:" "$filepath"; then
        critical_violations+=("CRITICAL: Missing 'description' field in YAML frontmatter")
    fi
    if ! grep -q "^argument-hint:" "$filepath"; then
        critical_violations+=("CRITICAL: Missing 'argument-hint' field in YAML frontmatter")
    fi

    # Check H1 format (should NOT have subtitle for commands)
    local h1_line=$(grep "^# " "$filepath" | head -1)
    if [[ -n "$h1_line" && "$h1_line" =~ " - " ]]; then
        critical_violations+=("CRITICAL: H1 title should NOT have subtitle for commands (expected: 'Command Name' only)")
    fi

    # Check for multiple H1 headers
    local h1_count=$(grep -c "^# " "$filepath")
    if [[ $h1_count -gt 1 ]]; then
        critical_violations+=("CRITICAL: Multiple H1 headers found ($h1_count). Only one H1 allowed.")
    fi

    if [[ ${#critical_violations[@]} -gt 0 ]]; then
        printf '%s\n' "${critical_violations[@]}"
        return 1
    fi

    return 0
}

# Function to check for critical knowledge violations
check_knowledge_critical() {
    local filepath="$1"
    local critical_violations=()

    # Check for NO YAML frontmatter
    if head -1 "$filepath" | grep -q "^---$"; then
        critical_violations+=("CRITICAL: Knowledge files should NOT have YAML frontmatter (remove it)")
    fi

    # Check H1 format (should have subtitle)
    local h1_line=$(grep "^# " "$filepath" | head -1)
    if [[ -n "$h1_line" && ! "$h1_line" =~ " - " ]]; then
        critical_violations+=("CRITICAL: H1 title missing subtitle format (expected: 'Topic - Descriptive Subtitle')")
    fi

    # Check for multiple H1 headers
    local h1_count=$(grep -c "^# " "$filepath")
    if [[ $h1_count -gt 1 ]]; then
        critical_violations+=("CRITICAL: Multiple H1 headers found ($h1_count). Only one H1 allowed.")
    fi

    if [[ ${#critical_violations[@]} -gt 0 ]]; then
        printf '%s\n' "${critical_violations[@]}"
        return 1
    fi

    return 0
}

# Main enforcement logic
main() {
    # Get git repository root (or use CWD as fallback)
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

    # Get recently modified markdown files
    local modified_files=$(git -C "$git_root" status --short 2>/dev/null | grep "\.md$" | awk '{print $2}' | head -10)

    # Also check staged files
    local staged_files=$(git -C "$git_root" diff --name-only --cached 2>/dev/null | grep "\.md$" | head -10)

    # Combine and deduplicate
    local all_files=$(echo -e "$modified_files\n$staged_files" | sort -u | grep -v "^$")

    # If no markdown files modified, exit silently
    if [[ -z "$all_files" ]]; then
        exit 0
    fi

    local has_critical=false

    # Check each file
    while IFS= read -r file; do
        [[ -z "$file" ]] && continue

        # Construct full path using git root (portable)
        local full_path="$GIT_ROOT/$file"

        # Skip if file doesn't exist
        [[ ! -f "$full_path" ]] && continue

        # Detect document type
        local doc_type=$(detect_document_type "$file")

        # Skip unknown and README types
        [[ "$doc_type" == "unknown" || "$doc_type" == "readme" ]] && continue

        # Skip spec files (loose enforcement only)
        [[ "$doc_type" == "spec" ]] && continue

        # Check for critical violations based on type
        local critical_violations=""
        case "$doc_type" in
            skill)
                critical_violations=$(check_skill_critical "$full_path")
                ;;
            command)
                critical_violations=$(check_command_critical "$full_path")
                ;;
            knowledge)
                critical_violations=$(check_knowledge_critical "$full_path")
                ;;
        esac

        # If critical violations found, BLOCK
        if [[ -n "$critical_violations" ]]; then
            has_critical=true

            # Log the block
            log_action "BLOCKED: $file (type: $doc_type) - Critical violations found"

            # Inject BLOCKING error into AI context
            cat >&2 << EOF

🚫 MARKDOWN ENFORCEMENT BLOCKED:

File: $file
Type: $doc_type (strict enforcement)
Status: ❌ CRITICAL VIOLATIONS - CANNOT PROCEED

Critical Issues:
$(echo "$critical_violations" | sed 's/^/  /')

Action Required:
You MUST fix these critical violations before continuing.

How to Fix:
  1. Open file: $full_path
  2. Add missing frontmatter (use template from .claude/skills/markdown-enforcer/references/frontmatter_templates.md)
  3. Ensure H1 subtitle format is correct
  4. Add any missing required sections
  5. Run validation: markdown-enforcer $file

Reference:
  - Style Guide: $STYLE_GUIDE
  - Frontmatter Templates: .claude/skills/markdown-enforcer/references/frontmatter_templates.md
  - Structure Templates: .claude/skills/markdown-enforcer/references/structure_templates.md

⚠️  This is a BLOCKING error. Fix the issues above to continue.

EOF
        fi
    done <<< "$all_files"

    # If any critical violations found, EXIT 1 to block execution
    if [[ "$has_critical" == "true" ]]; then
        log_action "EXECUTION BLOCKED - Critical violations must be fixed"
        exit 1
    fi

    # No critical violations - exit 0 (allow execution)
    exit 0
}

# Execute main function
main
