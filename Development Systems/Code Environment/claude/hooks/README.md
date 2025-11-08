# Claude Code Hooks

Automated workflows and quality checks for Claude Code interactions.

**Version**: 1.0.1
**Last Updated**: 2025-11-08

---

## Overview

This directory contains hooks that automatically trigger during Claude Code operations to:
- ✅ Auto-save conversation context
- ✅ Suggest relevant skills
- ✅ Block dangerous commands
- ✅ Provide quality check reminders

## Installed Hooks

### SessionEnd Hooks

#### `auto-save-context.sh`
**Trigger**: When session ends (clear, logout, exit)
**Action**: Automatically saves conversation context

**How it works**:
1. Detects session end events
2. Reads full conversation transcript (JSONL)
3. Transforms to save-context JSON format
4. Executes generate-context.js
5. Saves to most recent spec folder's context/ directory

**Output**: `specs/###-folder/context/{date}_{time}__{folder}.md`

**Behavior**:
- Silent operation (no user interaction)
- Only runs if specs/ folder exists
- Auto-detects most recent spec folder
- Overwrites existing context automatically

---

### UserPromptSubmit Hooks

#### `save-context-trigger.sh`
**Trigger**: User types save-context keywords
**Action**: Immediately saves conversation context

**Keywords**:
- "save context", "ultrathink"
- "save conversation", "export conversation"
- "document this", "record this"
- "preserve context", "capture context"
- [See full list in script]

**How it works**:
1. Detects trigger keywords in user prompt
2. Locates conversation transcript
3. Transforms and saves (same as SessionEnd hook)
4. Notifies user of save location

**Output**: Same as SessionEnd hook

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
- `.claude/logs/` (hook output logs)
- `.claude/configs/` (configuration files)

**Example Output**:
```
ERROR: Access to 'node_modules' is blocked by security policy
```

---

### PostToolUse Hooks

#### `validate-post-response.sh`
**Trigger**: After file edit operations (Edit, Write)
**Action**: Provides quality check reminders

**Checks**:
- **Animation**: CSS used for simple interactions? Motion.dev for complex?
- **Async Operations**: Error handling? Loading states? Timeouts?
- **Commit Operations**: Conventional Commits format? Atomic changes?
- **Form Handling**: Validation? Error states? Accessibility?
- **Initialization**: CDN-safe pattern? INIT_FLAG guard?
- **Spec Folder**: Created documentation? Got approval?

**Configuration**: `.claude/configs/skill-rules.json` (riskPatterns)

**Example Output**:
```
───────────────────────────────────────
QUALITY CHECK REMINDERS

✅ ASYNC CHECK:
- Error handling with try-catch?
- Loading states managed?
- Timeout handling present?

───────────────────────────────────────
💾 Logged to: .claude/hooks/logs/skill-recommendations.log
```

---

## Hook Structure

```
.claude/hooks/
├── README.md                              # This file
├── SessionEnd/
│   └── auto-save-context.sh               # Auto-save on session end
├── UserPromptSubmit/
│   ├── save-context-trigger.sh            # Keyword-triggered save
│   └── validate-skill-activation.sh       # Skill suggestions
├── PreToolUse/
│   └── validate-bash.sh                   # Security validation
├── PostToolUse/
│   └── validate-post-response.sh          # Quality checks
├── lib/
│   ├── output-helpers.sh                  # Shared formatting functions
│   └── transform-transcript.js            # JSONL → JSON transformer
└── logs/
    └── skill-recommendations.log          # Skill suggestion history
```

---

## Shared Libraries

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

## Logs Directory

### `logs/skill-recommendations.log`
**Purpose**: Historical record of skill suggestions and quality checks

**Contains**:
- Timestamp of each hook execution
- Detected trigger keywords and patterns
- Recommended skills for each prompt
- Priority levels (CRITICAL, HIGH, MEDIUM)
- Quality check reminders issued

**Usage**:
```bash
# View recent recommendations
tail -n 50 .claude/hooks/logs/skill-recommendations.log

# Search for specific skill mentions
grep "save-context" .claude/hooks/logs/skill-recommendations.log
```

**Format**:
```
[2025-11-08 17:40:23] UserPromptSubmit Hook
Keywords detected: save, context
Recommended: save-context (HIGH), git-commit (MEDIUM)

[2025-11-08 17:42:15] PostToolUse Hook
File: src/javascript/form.js
Quality checks: ASYNC, FORM, INITIALIZATION
```

**Maintenance**:
- Log file grows over time with session history
- Can be safely deleted to reset (regenerates automatically)
- Not tracked in git (add to .gitignore if needed)

---

## Configuration

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
    "SessionEnd": [{
      "hooks": [{
        "type": "command",
        "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/SessionEnd/auto-save-context.sh",
        "timeout": 120000
      }]
    }],
    "UserPromptSubmit": [{
      "hooks": [{
        "type": "command",
        "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/UserPromptSubmit/save-context-trigger.sh"
      }]
    }]
  }
}
```

---

## Usage

### Auto-Save Context

**Method 1: On Session End**
```bash
# Just run /clear or logout - automatic save!
/clear
```

**Method 2: On Keyword**
```
User: save context
# or
User: ultrathink
```

**Output Location**:
```
specs/###-most-recent-folder/context/
├── 2025-11-08_13-45-30__folder-name.md
└── metadata.json
```

### Testing Hooks

**Test SessionEnd**:
```bash
# Create test transcript
echo '{"type":"user","message":{"content":"test"},"timestamp":"2025-11-08T12:00:00Z"}' > /tmp/test.jsonl

# Test transformer
node .claude/hooks/lib/transform-transcript.js /tmp/test.jsonl /tmp/test.json

# Verify output
cat /tmp/test.json
```

**Test Keyword Detection**:
```bash
# Simulate user prompt
echo '{"prompt": "save context"}' | bash .claude/hooks/UserPromptSubmit/save-context-trigger.sh
```

---

## Troubleshooting

### Hook Not Firing

**Check**:
1. Is hook executable? `chmod +x .claude/hooks/*/hookname.sh`
2. Is hook registered in settings.local.json?
3. Check stderr output for error messages

### Context Not Saving

**Common Issues**:

**No specs/ folder**:
```bash
# Create one
mkdir -p specs/###-topic-name
```

**No numbered spec folder**:
```bash
# Format must be: ###-name (3 digits)
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

## Development

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

## Hook Lifecycle

```
User Action
     │
     ▼
┌────────────────────────────────────┐
│  PreUserPromptSubmit Hooks         │
│  - validate-skill-activation.sh    │
│  - Can modify/block prompt         │
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
│  - validate-bash.sh                │
│  - Can modify/block tool execution │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  Tool Executes                     │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  PostToolUse Hooks                 │
│  - validate-post-response.sh       │
│  - Quality checks (non-blocking)   │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  Stop Hooks                        │
│  - After Claude response           │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  SessionEnd Hooks                  │
│  - auto-save-context.sh            │
│  - On /clear, logout, exit         │
└────────────────────────────────────┘
```

---

## Version History

### v1.0.1 (2025-11-08)
- ✅ Added output-helpers.sh shared library for standardized formatting
- ✅ Implemented file-based logging system (skill-recommendations.log)
- ✅ Silenced all hook output to prevent verbose console messages
- ✅ Removed test suite after successful validation
- ✅ Updated documentation to reflect current hook structure
- ✅ Added logs directory documentation

### v1.0.0 (2025-11-08)
- ✅ Created new hook directory structure
- ✅ Implemented SessionEnd auto-save hook
- ✅ Implemented UserPromptSubmit keyword trigger
- ✅ Created transcript transformer utility
- ✅ Moved existing hooks to correct locations
- ✅ Added security patterns to bash validator
- ✅ Updated skill-rules.json with new keywords
- ✅ Deprecated old auto-save-context.sh

---

## Related Documentation

- [save-context Skill](../.claude/skills/save-context/SKILL.md)
- [Skill Rules Configuration](../.claude/configs/skill-rules.json)
- [Claude Code Documentation](https://code.claude.com/docs/en/hooks.md)