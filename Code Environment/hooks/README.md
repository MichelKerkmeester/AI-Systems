# Claude Code Hooks - Automated Workflows & Quality Checks

Automated workflows and quality checks for Claude Code interactions. Hooks trigger during operations to provide auto-save, skill suggestions, security validation, and quality reminders.

#### 📋 TABLE OF CONTENTS

1. [📖 OVERVIEW](#1--overview)
2. [🎯 INSTALLED HOOKS](#2--installed-hooks)
3. [⚠️ KNOWN ISSUES & WORKAROUNDS](#3-️-known-issues--workarounds)
4. [📁 HOOK STRUCTURE](#4--hook-structure)
5. [📚 SHARED LIBRARIES](#5--shared-libraries)
6. [📊 LOGS DIRECTORY](#6--logs-directory)
7. [⚙️ CONFIGURATION](#7-️-configuration)
8. [💻 USAGE](#8--usage)
9. [🔧 TROUBLESHOOTING](#9--troubleshooting)
10. [🛠️ DEVELOPMENT](#10-️-development)
11. [🔄 HOOK LIFECYCLE](#11--hook-lifecycle)
12. [📜 VERSION HISTORY](#12--version-history)
13. [🔗 RELATED DOCUMENTATION](#13--related-documentation)

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

## 2. 🎯 INSTALLED HOOKS

### UserPromptSubmit Hooks

#### `save-context-trigger.sh`
**Trigger**: User types save-context keywords OR when 25% context capacity remains (75% used)
**Action**: Immediately saves conversation context

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

---

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

**Example Output**:
```
───────────────────────────────────────
SKILL ACTIVATION CHECK

🚨 HIGH PRIORITY SKILLS:
   • save-context - Save conversation context
   • git-commit - Professional commit workflow

───────────────────────────────────────
```

---

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

---

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

---

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

## 3. 🔧 BUG FIXES & IMPROVEMENTS

### Recent Bug Fixes (2025-11-10)

**Bug #1: validate-bash.sh Whitelist Pattern**
- **Issue**: Hook logs couldn't be read - whitelist only included `.claude/logs/`
- **Fix**: Added `.claude/hooks/logs/` to whitelist patterns
- **Impact**: Hook execution logs now accessible via bash commands

**Bug #2: enforce-markdown-post.sh Case-Sensitivity**
- **Issue**: Failed to rename files on case-insensitive filesystems (macOS/Windows)
- **Root Cause**: `mv TEST_FILE.md test_file.md` fails silently on APFS/NTFS
- **Fix**: Implemented two-step rename using temporary file + case-aware verification
- **Impact**: ALL CAPS → lowercase renaming now works correctly on all platforms

**Bug #3: Missing Security Risk Patterns**
- **Issue**: Security risks like `eval()`, `innerHTML` not detected
- **Fix**: Added comprehensive `securityRisks` pattern category to skill-rules.json
- **Impact**: Quality validation now detects 8 security risk patterns

**Testing**:
- Comprehensive test suite created with 9 test scenarios
- All tests passing (9/9) after bug fixes
- Test scripts available in `specs/020-new-skills-hooks-commands/test-files/`

---

## 4. 📁 HOOK STRUCTURE

```
.claude/hooks/
├── README.md                              # This file
├── UserPromptSubmit/
│   ├── save-context-trigger.sh            # Auto-save (keywords + context threshold)
│   ├── validate-skill-activation.sh       # Skill suggestions
│   └── enforce-markdown-strict.sh         # Document structure validation (BLOCKING)
├── PreToolUse/
│   └── validate-bash.sh                   # Security validation (BLOCKING)
├── PostToolUse/
│   ├── enforce-markdown-post.sh           # Markdown filename auto-fix (non-blocking)
│   └── validate-post-response.sh          # Quality checks (non-blocking)
├── lib/
│   ├── output-helpers.sh                  # Shared formatting functions
│   └── transform-transcript.js            # JSONL → JSON transformer
└── logs/
    ├── auto-save-context.log              # Auto-save trigger logs
    ├── skill-recommendations.log          # Skill suggestion history
    ├── quality-checks.log                 # Quality validation reminders
    └── markdown-enforcement.log           # Filename auto-fix history
```

---

## 5. 📚 SHARED LIBRARIES

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

## 6. 📊 LOGS DIRECTORY

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

---

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

---

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

---

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

## 7. ⚙️ CONFIGURATION

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

---

## 8. 💻 USAGE

### Auto-Save Context

**Method 1: Automatic Context Window Monitoring (25% Remaining)**
```
# Completely automatic - no action required!
# Hook monitors conversation and auto-saves at 200 messages
# Triggers when 25% capacity remains (75% used)
# Prevents context loss in long conversations
```

**Method 2: Keyword Trigger**
```
User: save context
# or
User: save conversation
# or any other trigger keyword (see save-context-trigger.sh)
```

**Output Location**:

With spec folders:
```
specs/###-most-recent-folder/memory/
├── 09-11-25_07-52__folder-name.md
└── metadata.json
```

Without spec folders (fallback):
```
memory/
├── 09-11-25_07-52__session_summary.md
└── metadata.json
```

**Logs**:
```
.claude/hooks/logs/auto-save-context.log
# Shows trigger reason: keyword vs. context-window
```

### Testing Hooks

**Test Keyword Detection**:
```bash
# Simulate user prompt
echo '{"prompt": "save context"}' | bash .claude/hooks/UserPromptSubmit/save-context-trigger.sh
```

**Test Transcript Transformer**:
```bash
# Create test transcript
echo '{"type":"user","message":{"content":"test"},"timestamp":"2025-11-08T12:00:00Z"}' > /tmp/test.jsonl

# Test transformer
node .claude/hooks/lib/transform-transcript.js /tmp/test.jsonl /tmp/test.json

# Verify output
cat /tmp/test.json
```

---

## 9. 🔧 TROUBLESHOOTING

### Hook Not Firing

**Check**:
1. Is hook executable? `chmod +x .claude/hooks/*/hookname.sh`
2. Is hook registered in settings.local.json?
3. Check stderr output for error messages

### Context Not Saving

**Common Issues**:

**No specs/ folder**:
```bash
# Auto-handled: Creates memory/ folder as fallback
# No action needed - works automatically
```

**No numbered spec folder in specs/**:
```bash
# Auto-handled: Creates memory/ folder as fallback
# Or manually create spec folder:
mkdir -p specs/001-my-feature
```

**Transcript not found**:
```bash
# Check Claude Code transcript location
ls ~/.claude/projects/*/
```

### Permission Errors

```bash
# Make all hooks executable
chmod +x .claude/hooks/**/*.sh
chmod +x .claude/hooks/lib/*.js
```

---

## 10. 🛠️ DEVELOPMENT

### Adding New Hooks

1. **Create hook script** in appropriate directory:
   ```bash
   touch .claude/hooks/[HookType]/my-hook.sh
   chmod +x .claude/hooks/[HookType]/my-hook.sh
   ```

2. **Add hook logic**:
   ```bash
   #!/bin/bash
   INPUT=$(cat)
   # ... process input ...
   exit 0  # 0 = allow, non-zero = block
   ```

3. **Register in settings.local.json**

4. **Test**:
   ```bash
   echo '{"test": "data"}' | bash .claude/hooks/[HookType]/my-hook.sh
   ```

### Hook Exit Codes

- **0**: Success, allow operation
- **1**: Soft warning (log but allow)
- **2**: Hard error (block operation)
- **3**: Configuration error (skip hook)

---

## 11. 🔄 HOOK LIFECYCLE

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

## 12. 📜 VERSION HISTORY

**Current Version**: 1.3.0
**Last Updated**: 2025-11-10

### v1.3.0 (2025-11-10) - Bug Fixes & Testing
- ✅ **VERIFIED: PostToolUse hooks ARE working** (previous documentation was incorrect)
- ✅ **BUG FIX**: Added `.claude/hooks/logs/` to validate-bash.sh whitelist
- ✅ **BUG FIX**: Fixed case-sensitivity bug in enforce-markdown-post.sh (two-step rename)
- ✅ **BUG FIX**: Added security risk patterns (eval, innerHTML, etc.) to skill-rules.json
- ✅ Created comprehensive test suite (9 test scenarios, all passing)
- ✅ Added markdown-enforcement.log for filename corrections
- ✅ Added quality-checks.log for risk pattern detection
- ✅ Updated all documentation to reflect correct hook status
- ✅ Added enforce-markdown-strict.sh to hook structure

### v1.2.0 (2025-11-09)
- ✅ Auto-save now ONLY triggers via keywords or context window threshold
- ✅ Simplified triggering mechanism to two reliable methods
- ✅ Updated all documentation for clarity

### v1.1.0 (2025-11-09)
- ✅ **NEW: Automatic Context Window Detection**
- ✅ Added automatic save trigger when 25% capacity remains (75% used, 200 messages)
- ✅ Enhanced save-context-trigger.sh with dual-mode triggering (keyword + threshold)
- ✅ Added detailed trigger reason logging (keyword vs. context-window)
- ✅ Prevents context loss in long conversations without user intervention
- ✅ Fixed unhandled promise rejection in generate-context.js entry point
- ✅ Added TTY safety check to prevent readline spawn errors in non-interactive mode

### v1.0.1 (2025-11-08)
- ✅ Added output-helpers.sh shared library for standardized formatting
- ✅ Implemented file-based logging system (skill-recommendations.log)
- ✅ Silenced all hook output to prevent verbose console messages
- ✅ Removed test suite after successful validation
- ✅ Updated documentation to reflect current hook structure
- ✅ Added logs directory documentation

### v1.0.0 (2025-11-08)
- ✅ Created new hook directory structure
- ✅ Implemented UserPromptSubmit keyword trigger
- ✅ Created transcript transformer utility
- ✅ Moved existing hooks to correct locations
- ✅ Added security patterns to bash validator
- ✅ Updated skill-rules.json with new keywords
- ✅ Deprecated old auto-save-context.sh

---

## 13. 🔗 RELATED DOCUMENTATION

- [save-context Skill](../.claude/skills/save-context/SKILL.md)
- [Skill Rules Configuration](../.claude/configs/skill-rules.json)
- [Claude Code Documentation](https://code.claude.com/docs/en/hooks.md)