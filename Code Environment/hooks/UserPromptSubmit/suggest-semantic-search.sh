#!/bin/bash

# ───────────────────────────────────────────────────────────────
# SEMANTIC SEARCH SUGGESTION HOOK
# ───────────────────────────────────────────────────────────────
# Pre-UserPromptSubmit hook that reminds AI to use semantic search
# MCP tools when analyzing or exploring code

# Source output helpers (completely silent on success)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
source "$SCRIPT_DIR/../lib/output-helpers.sh" || exit 0

# Read JSON input from stdin
INPUT=$(cat)

# Extract the prompt from JSON (silent on error)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

# If no prompt found, allow it
if [ -z "$PROMPT" ]; then
  exit 0
fi

# Convert prompt to lowercase for case-insensitive matching
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# ───────────────────────────────────────────────────────────────
# TRIGGER PATTERNS
# ───────────────────────────────────────────────────────────────

# Keywords that suggest semantic search would be useful
CODE_EXPLORATION_KEYWORDS=(
  "find.*code"
  "find.*implementation"
  "find.*function"
  "find.*component"
  "where.*implement"
  "where.*handle"
  "where.*defined"
  "where is"
  "locate.*code"
  "locate.*function"
  "search.*codebase"
  "explore.*code"
  "how.*implement"
  "show.*implementation"
  "what.*handles"
  "which.*file"
  "which.*component"
  "look for"
  "understand.*code"
  "analyze.*code"
  "explain.*implementation"
)

# Check if prompt matches any exploration pattern
SHOULD_SUGGEST=false

for pattern in "${CODE_EXPLORATION_KEYWORDS[@]}"; do
  if echo "$PROMPT_LOWER" | grep -qE "$pattern"; then
    SHOULD_SUGGEST=true
    break
  fi
done

# ───────────────────────────────────────────────────────────────
# OUTPUT SUGGESTION
# ───────────────────────────────────────────────────────────────

if [ "$SHOULD_SUGGEST" = true ]; then
  echo ""
  echo "💡 SEMANTIC SEARCH REMINDER:"
  echo ""
  echo "This request involves code exploration/analysis. Consider using semantic search"
  echo "MCP tools for intent-based code discovery:"
  echo ""
  echo "  • semantic_search - Find code by what it does, not what it's called"
  echo "  • Helpful for: locating implementations, understanding features, finding patterns"
  echo ""
  echo "📖 See: .claude/knowledge/semantic_search_mcp.md for usage guidelines"
  echo ""
  echo "⚠️  Note: Only available for CLI AI agents (not IDE integrations)"
  echo ""
fi

# Always allow the prompt to proceed
exit 0
