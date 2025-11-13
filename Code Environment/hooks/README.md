# Claude Code Hooks

Automated workflows and quality checks for Claude Code interactions. Hooks trigger during operations to provide auto-save, skill suggestions, security validation, and quality reminders.

#### 📋 TABLE OF CONTENTS

1. [📖 OVERVIEW](#1--overview)
2. [🔄 HOOK LIFECYCLE](#2--hook-lifecycle)
3. [🎯 INSTALLED HOOKS](#3--installed-hooks)
4. [📚 SHARED LIBRARIES](#4--shared-libraries)
5. [📊 LOGS DIRECTORY](#5--logs-directory)
6. [⚙️ CONFIGURATION](#6-️-configuration)

---

## 1. 📖 OVERVIEW

This directory contains hooks that automatically trigger during Claude Code operations.

### Hook Support Status

| Hook Type | Status | Description |
|-----------|--------|-------------|
| **UserPromptSubmit** | ✅ WORKING | Triggers before user prompts are processed |
| **PreToolUse** | ✅ WORKING | Triggers before Bash tool execution |
| **PostToolUse** | ✅ WORKING | Triggers after Write/Edit/NotebookEdit operations |

### Active Features
- ✅ Auto-save conversation context (keywords + context threshold)
- ✅ Suggest relevant skills based on prompt content
- ✅ Block dangerous Bash commands (security + performance)
- ✅ Auto-fix markdown filenames to lowercase snake_case
- ✅ Quality check reminders for edited code files
- ✅ Security risk pattern detection (eval, innerHTML, etc.)

---

## 2. 🔄 HOOK LIFECYCLE

```
User Action
     │
     ▼
┌────────────────────────────────────┐
│  UserPromptSubmit Hooks            │
│  - save-context-trigger.sh (0)     │
│  - validate-skill-activation.sh(0) │
│  - enforce-markdown-strict.sh (1)  │
│  Note: (1) = blocking, (0) = allow │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  Claude Processes Prompt           │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  PreToolUse Hooks                  │
│  - validate-bash.sh (2)            │
│  Note: (2) = blocks if dangerous   │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  Tool Executes                     │
│  (Write/Edit/Bash/etc.)            │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  PostToolUse Hooks                 │
│  - enforce-markdown-post.sh (0)    │
│  - validate-post-response.sh (0)   │
│  Note: (0) = non-blocking auto-fix │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  Result Returned to User           │
└────────────────────────────────────┘
```

---

## 3. 🎯 INSTALLED HOOKS

### UserPromptSubmit Hooks

#### `save-context-trigger.sh`
**Trigger**: User types save-context keywords OR when 25% context capacity remains (75% used)
**Action**: Immediately saves conversation context and displays confirmation

**Trigger Methods**:

**1. Keyword Triggers**:
- "save context", "save conversation"
- "export conversation", "document this"
- "record this", "preserve context"
- "capture context"
- [See full list in script]

**2. Automatic Context Window Detection**:
- Monitors transcript size on every user prompt
- Automatically triggers when conversation reaches 200 messages (≈75% used, 25% remaining)
- Prevents context loss by saving before hitting limits
- Completely automatic - no user intervention required

**How it works**:
1. On every user prompt, checks for trigger keywords
2. If no keyword, checks transcript message count
3. If ≥200 messages, automatically triggers save
4. Locates conversation transcript
5. Transforms transcript to save-context JSON format
6. Executes generate-context.js script
7. Saves to most recent spec folder's memory/ directory (or memory/ fallback if no specs exist)
8. Logs trigger reason (keyword vs. context-window)

**Output**:
- **With spec folders**: `specs/###-folder/memory/{date}_{time}__{folder}.md`
- **Without spec folders**: `memory/{date}_{time}__session_summary.md` (fallback, no subfolder)

**Context Window Calculation**:
- 200k token context window ≈ 400 messages (500 tokens/message avg)
- 75% used (25% remaining) = 300 messages
- Conservative setting: 200 messages to account for longer messages

**User Feedback**:
```
💾 Context auto-saved (keyword: 'save context')
💾 Context auto-saved (context capacity: 75% used, 205 messages)
⚠️  Context auto-save failed (exit code: 1)
```

#### `validate-skill-activation.sh`
**Trigger**: Before every user prompt
**Action**: Suggests relevant skills based on prompt content

**How it works**:
1. Analyzes user prompt for keywords and patterns
2. Matches against skill-rules.json definitions
3. Suggests applicable skills by priority:
   - ⚠️ CRITICAL: Must apply (alwaysActive=true)
   - 🚨 HIGH PRIORITY: Strongly recommended
   - 🤔 RELEVANT: Consider using

**Configuration**: `.claude/configs/skill-rules.json`

**Display Behavior**: CRITICAL priority skills display to user, HIGH/MEDIUM priority skills logged only

**Example Output** (when CRITICAL skills match):
```
🔴 CRITICAL SKILLS APPLY:
   • code-standards - Naming conventions, file headers, commenting rule
   • conversation-documentation - Mandatory spec folder system for all i
```

**Note**: HIGH and MEDIUM priority skills (like git-commit, save-context) are logged to `.claude/hooks/logs/skill-recommendations.log` but not displayed to reduce noise

#### `suggest-semantic-search.sh`
**Status**: ✅ REGISTERED AND ACTIVE (as of 2025-11-13)
**Trigger**: Before user prompts containing code exploration keywords
**Action**: Reminds AI to consider semantic search MCP tools

**Trigger Keywords**:
- "find code/implementation/function/component"
- "where is/implement/handle/defined"
- "locate code/function"
- "search codebase"
- "explore/analyze/understand code"
- "show implementation"
- "which file/component"

**How it works**:
1. Analyzes user prompt for code exploration patterns
2. If matched, displays semantic search reminder
3. References `.claude/knowledge/semantic_search_mcp.md`
4. Notes CLI AI agent requirement (not IDE integrations)

**Example Output**:
```
💡 SEMANTIC SEARCH REMINDER:

This request involves code exploration/analysis. Consider using semantic search
MCP tools for intent-based code discovery:

  • semantic_search - Find code by what it does, not what it's called
  • Helpful for: locating implementations, understanding features, finding patterns

📖 See: .claude/knowledge/semantic_search_mcp.md for usage guidelines

⚠️  Note: Only available for CLI AI agents (not IDE integrations)
```

#### Display vs Log Behavior Summary

**UserPromptSubmit Hooks Output Strategy:**

| Hook | Display to User | Log to File | Rationale |
|------|----------------|-------------|-----------|
| **validate-skill-activation** | ✅ CRITICAL priority only | All matched skills | Reduce noise while highlighting critical requirements |
| **save-context-trigger** | ✅ Confirmation message | Full execution details | User deserves feedback for background actions |
| **suggest-semantic-search** | ✅ Always (when triggered) | N/A | Educational reminder, brief and helpful |
| **enforce-markdown-strict** | ✅ Blocking errors only | All violations | Only displays when blocking execution |

**Rationale**: This strategy balances value vs noise. CRITICAL information displays to prevent violations, while HIGH/MEDIUM skills are logged for debugging without cluttering the interface.

### PreToolUse Hooks

#### `validate-bash.sh`
**Trigger**: Before executing Bash commands
**Action**: Blocks dangerous/wasteful commands

**Blocked Patterns**:

**Security**:
- Destructive commands (`rm -rf /`, `chmod 777`)
- Privilege escalation (`sudo`)
- Malware vectors (`curl ... | sh`)
- Sensitive files (`.ssh/`, `.env`, `.pem`)
- Credentials (`password`, `api_key`, `secret`)

**Performance**:
- Large directories (`node_modules`, `build/`)
- Binary files (`.pyc`, `.csv`)
- Git objects (`.git/objects`)

**Whitelisted**:
- `.claude/logs/` (skill logs)
- `.claude/hooks/logs/` (hook execution logs)
- `.claude/configs/` (configuration files)

**Example Output**:
```
ERROR: Access to 'node_modules' is blocked by security policy
```

### PostToolUse Hooks

> ✅ **STATUS**: PostToolUse hooks are **FULLY WORKING** (verified 2025-11-10).
> Tested and confirmed to execute after Write, Edit, and NotebookEdit operations.

#### `enforce-markdown-post.sh`
**Trigger**: After Write, Edit, NotebookEdit operations on .md files
**Action**: Auto-corrects markdown filenames to lowercase snake_case
**Exit**: Always 0 (non-blocking - fixes applied automatically)

**Enforcement Rules**:
- Converts ALL_CAPS.md → all_caps.md
- Converts My-File.md → my_file.md
- Converts myFile.md → my_file.md
- **Exceptions**: README.md, SKILL.md (in .claude/skills/ only)

**Technical Details**:
- Uses two-step rename process for case-insensitive filesystems (macOS/Windows)
- Verifies actual filename case using `ls` to handle APFS/NTFS
- Logs all corrections to `.claude/hooks/logs/markdown-enforcement.log`

**Example Output**:
```
✓ MARKDOWN FILENAME AUTO-CORRECTED:
   Renamed: TEST_FILE.md → test_file.md
   Reason: Violates document_style_guide.md naming conventions
   Rule: Only README.md and SKILL.md may use ALL CAPS
   Enforced: lowercase snake_case for all other markdown files
```

#### `validate-post-response.sh`
**Trigger**: After file edit operations (Edit, Write)
**Action**: Detects risk patterns and logs quality check reminders
**Exit**: Always 0 (non-blocking - informational only)

**Risk Pattern Categories**:
- **Animation**: CSS used? Motion.dev for complex? Performance optimized?
- **Async Operations**: Error handling? Loading states? Timeouts?
- **Security Risks**: eval() usage? innerHTML manipulation? XSS prevention?
- **Commit Operations**: Conventional Commits? Atomic changes?
- **Form Handling**: Validation? Error states? Accessibility?
- **Initialization**: CDN-safe pattern? INIT_FLAG guard?
- **Spec Folder**: Created documentation? Got approval?

**Configuration**: `.claude/configs/skill-rules.json` (riskPatterns)

**Example Output** (logged to `.claude/hooks/logs/quality-checks.log`):
```
───────────────────────────────────────
[2025-11-10 15:00:00] File: src/code.js
───────────────────────────────────────
⚠️  SECURITY CHECK:
- eval() usage detected - consider safer alternatives?
- innerHTML/outerHTML manipulation - sanitize user input?
- XSS prevention implemented?
- Input validation present?

✅ ASYNC CHECK:
- Error handling with try-catch?
- Loading states managed?
- Timeout handling present?
───────────────────────────────────────
```

---

## 4. 📚 SHARED LIBRARIES

### `lib/output-helpers.sh`
**Purpose**: Standardized visual output formatting for all hooks

**Provides**:
- Consistent color-coded messages (INFO, SUCCESS, WARN, ERROR)
- Visual separators and section headers
- Emoji indicators for severity and process states
- Terminal capability detection (colors disabled on non-TTY)
- Silent dependency checking and JSON validation

**Usage in Hooks**:
```bash
#!/bin/bash
source "$(dirname "$0")/../lib/output-helpers.sh"

print_section "MY HOOK NAME"
print_message "SUCCESS" "Operation completed"
print_bullet "First item"
print_bullet "Second item"
```

**Key Functions**:
- `print_message <level> <title> [message]` - Print status message
- `print_section <title>` - Print boxed section header
- `print_separator` - Print horizontal line
- `print_bullet <text>` - Print bullet point
- `check_dependency <cmd> [hint]` - Silently check if command exists
- `validate_json <path>` - Silently validate JSON file

### `lib/transform-transcript.js`
**Purpose**: Convert Claude Code transcript (JSONL) to save-context format (JSON)

**Usage**:
```bash
node lib/transform-transcript.js input.jsonl output.json
```

**Transforms**:
- Extracts user prompts and assistant responses
- Filters system messages and tool calls
- Structures conversation flow for documentation
- Prepares data for generate-context.js processing

---

## 5. 📊 LOGS DIRECTORY

### `logs/skill-recommendations.log`
**Purpose**: Historical record of skill suggestions
**Hook**: validate-skill-activation.sh (UserPromptSubmit)

**Contains**:
- Timestamp of each hook execution
- Detected trigger keywords and patterns
- Recommended skills for each prompt
- Priority levels (CRITICAL, HIGH, MEDIUM)

**Usage**:
```bash
tail -n 50 .claude/hooks/logs/skill-recommendations.log
grep "git-commit" .claude/hooks/logs/skill-recommendations.log
```

### `logs/quality-checks.log`
**Purpose**: Risk pattern detection and quality reminders
**Hook**: validate-post-response.sh (PostToolUse)

**Contains**:
- Files edited with risk patterns
- Risk categories detected (async, security, animation, etc.)
- Quality check reminders for each pattern

**Usage**:
```bash
tail -n 50 .claude/hooks/logs/quality-checks.log
grep "SECURITY CHECK" .claude/hooks/logs/quality-checks.log
```

### `logs/markdown-enforcement.log`
**Purpose**: Filename auto-fix history
**Hook**: enforce-markdown-post.sh (PostToolUse)

**Contains**:
- Original and corrected filenames
- Timestamp of each rename operation
- Reason for correction

**Usage**:
```bash
tail -n 50 .claude/hooks/logs/markdown-enforcement.log
```

### `logs/auto-save-context.log`
**Purpose**: Auto-save trigger history
**Hook**: save-context-trigger.sh (UserPromptSubmit)

**Contains**:
- Trigger method (keyword vs. context-window threshold)
- Session ID and target folder
- Success/failure status

**Usage**:
```bash
tail -n 50 .claude/hooks/logs/auto-save-context.log
```

**Maintenance**:
- All log files grow over time with session history
- Can be safely deleted to reset (regenerate automatically)
- Not tracked in git (.gitignore recommended)

---

## 6. ⚙️ CONFIGURATION

### Main Config File
`.claude/configs/skill-rules.json`

**Contains**:
- Skill definitions (type, priority, description)
- Trigger keywords and intent patterns
- File path patterns for auto-detection
- Risk patterns for quality checks

### Settings File
`.claude/settings.local.json`

**Hook Registration** (add to file):
```json
{
  "hooks": {
    "UserPromptSubmit": [{
      "hooks": [{
        "type": "command",
        "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/UserPromptSubmit/save-context-trigger.sh"
      }, {
        "type": "command",
        "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/UserPromptSubmit/validate-skill-activation.sh"
      }]
    }]
  }
}
```