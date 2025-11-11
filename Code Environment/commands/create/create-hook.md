---
description: Create and configure Claude Code hooks with reference documentation
argument-hint: [hook-type] [matcher] [command]
---

# Create Hook

Create and configure Claude Code hooks with production-ready templates, reference documentation, and interactive guidance.

---

## 1. 📋 INPUTS

### Required Inputs

**None** - Command supports interactive, guided, and direct modes

### Optional Inputs

**Hook Type**:
- **Options**: PreToolUse, PostToolUse, UserPromptSubmit, Notification, Stop, SubagentStop, PreCompact, SessionStart, SessionEnd
- **Example**: `PreToolUse`, `PostToolUse`

**Matcher Pattern**:
- **Format**: Tool name or pattern
- **Example**: `Bash`, `Edit|Write`, `*`

**Command**:
- **Format**: Shell command or path to external script
- **Example**: `jq -r '.tool_input.command'`

### User Arguments

```text
$ARGUMENTS
```

---

## 2. 🚀 WORKFLOW

### Step 1: Detect Common Use Cases

**Purpose**: Identify production-ready templates for common tools

**Actions**:
1. Scan user request for keywords: `eslint`, `prettier`, `format`, `lint`, `typescript`, `test`, `commit`
2. If detected, ask: "I can set up a production-ready [TOOL] hook. Would you like to use the template or create a custom hook?"
3. If template chosen: Generate external script file + settings.json entry
4. If custom or no match: Fall back to interactive/guided workflow

**Validation**: `use_case_detected`

### Step 2: Determine Configuration Mode

**Purpose**: Select appropriate workflow based on user input

**Mode Selection**:
```
IF no arguments provided:
  → Interactive menu of hook types with examples
ELSE IF HOOK_TYPE provided:
  → Guide user through creating that specific hook
ELSE IF all arguments provided:
  → Create hook directly
```

**Validation**: `mode_determined`

### Step 3: Validate Inputs

**Purpose**: Ensure hook configuration is valid

**Actions**:
1. Verify HOOK_TYPE is one of the valid hook events
2. Check MATCHER is a valid tool name or pattern
3. Validate COMMAND is a valid shell command or script path
4. For external scripts: Ensure `.claude/hooks/` directory exists

**Validation**: `inputs_validated`

### Step 4: Generate Hook Configuration

**Purpose**: Create properly structured hook with best practices

**Template Mode** (Common Tools):
- Create external script file in `.claude/hooks/`
- Generate settings.json configuration
- Make script executable (`chmod +x`)
- Use production-ready patterns

**Custom Mode**:
- Guide through hook event selection
- Define matcher pattern
- Write shell command processing JSON input
- Choose storage location

**Validation**: `configuration_generated`

### Step 5: Write Hook Files

**Purpose**: Save hook configuration and scripts to filesystem

**Actions**:
1. Create `.claude/hooks/` directory if needed
2. Write external script files (if applicable)
3. Set proper file permissions
4. Generate or update settings.json entry
5. Verify files were written successfully

**Validation**: `files_written`

### Step 6: Output Result

**Purpose**: Confirm creation and provide next steps

**Template Mode Output**:
```
STATUS=OK HOOK_FILE=.claude/hooks/[script-name].sh SETTINGS=.claude/settings.json
```

**Interactive Mode Output**:
```
STATUS=OK HOOK_FILE=~/.claude/settings.json
```

**Next Steps**:
- Reload hooks with `/hooks` command
- Test the hook
- Verify configuration

**Validation**: `result_outputted`

---

## 3. 🔧 PRODUCTION-READY TEMPLATES

### ESLint Auto-Fix

**Script**: `.claude/hooks/run-eslint.sh`

```bash
#!/usr/bin/env bash
# Auto-fix JavaScript/TypeScript files with ESLint after edits
set -euo pipefail

# Extract file path from Claude's JSON payload
file_path="$(jq -r '.tool_input.file_path // ""')"

# Only process JS/TS files
[[ "$file_path" =~ \.(js|jsx|ts|tsx)$ ]] || exit 0

# Auto-detect package manager (prefer project's lock file)
if command -v pnpm >/dev/null 2>&1 && [ -f "pnpm-lock.yaml" ]; then
  PM="pnpm exec"
elif command -v yarn >/dev/null 2>&1 && [ -f "yarn.lock" ]; then
  PM="yarn"
else
  PM="npx"
fi

# Run ESLint with auto-fix from project root
cd "$CLAUDE_PROJECT_DIR" && $PM eslint --fix "$file_path"
```

**Settings Entry**:
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "comment": "Auto-fix with ESLint",
        "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/run-eslint.sh"
      }]
    }]
  }
}
```

### Prettier Format

**Script**: `.claude/hooks/run-prettier.sh`

```bash
#!/usr/bin/env bash
# Format files with Prettier after edits
set -euo pipefail

file_path="$(jq -r '.tool_input.file_path // ""')"

# Skip non-formattable files
[[ "$file_path" =~ \.(js|jsx|ts|tsx|json|css|scss|md|html|yml|yaml)$ ]] || exit 0

# Auto-detect package manager
if command -v pnpm >/dev/null 2>&1 && [ -f "pnpm-lock.yaml" ]; then
  PM="pnpm exec"
elif command -v yarn >/dev/null 2>&1 && [ -f "yarn.lock" ]; then
  PM="yarn"
else
  PM="npx"
fi

cd "$CLAUDE_PROJECT_DIR" && $PM prettier --write "$file_path"
```

### TypeScript Type Check

**Script**: `.claude/hooks/run-typescript.sh`

```bash
#!/usr/bin/env bash
# Run TypeScript type checker on TS/TSX file edits
set -euo pipefail

file_path="$(jq -r '.tool_input.file_path // ""')"

# Only process TypeScript files
[[ "$file_path" =~ \.(ts|tsx)$ ]] || exit 0

# Auto-detect package manager
if command -v pnpm >/dev/null 2>&1 && [ -f "pnpm-lock.yaml" ]; then
  PM="pnpm exec"
elif command -v yarn >/dev/null 2>&1 && [ -f "yarn.lock" ]; then
  PM="yarn"
else
  PM="npx"
fi

# Run tsc --noEmit to check types without emitting files
cd "$CLAUDE_PROJECT_DIR" && $PM tsc --noEmit --pretty
```

### Run Affected Tests

**Script**: `.claude/hooks/run-tests.sh`

```bash
#!/usr/bin/env bash
# Run tests for modified files
set -euo pipefail

file_path="$(jq -r '.tool_input.file_path // ""')"

# Only run tests for source files (not test files themselves)
[[ "$file_path" =~ \.(test|spec)\.(js|ts|jsx|tsx)$ ]] && exit 0
[[ "$file_path" =~ \.(js|jsx|ts|tsx)$ ]] || exit 0

# Auto-detect test runner and package manager
if [ -f "vitest.config.ts" ] || [ -f "vitest.config.js" ]; then
  TEST_CMD="vitest related --run"
elif [ -f "jest.config.js" ] || [ -f "jest.config.ts" ]; then
  TEST_CMD="jest --findRelatedTests"
else
  exit 0  # No test runner configured
fi

if command -v pnpm >/dev/null 2>&1 && [ -f "pnpm-lock.yaml" ]; then
  PM="pnpm exec"
elif command -v yarn >/dev/null 2>&1 && [ -f "yarn.lock" ]; then
  PM="yarn"
else
  PM="npx"
fi

cd "$CLAUDE_PROJECT_DIR" && $PM $TEST_CMD "$file_path"
```

### Commit Message Validation

**Script**: `.claude/hooks/validate-commit.sh`

```bash
#!/usr/bin/env bash
# Validate commit messages follow conventional commits format
set -euo pipefail

# Extract commit message from tool input
commit_msg="$(jq -r '.tool_input // ""')"

# Check for conventional commit format: type(scope): message
if ! echo "$commit_msg" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?: .+'; then
  echo "ERROR: Commit message must follow conventional commits format"
  echo "Expected: type(scope): description"
  echo "Got: $commit_msg"
  exit 2  # Block the commit
fi
```

---

## 4. 📖 HOOK EVENTS REFERENCE

### PreToolUse
- **When**: Runs before tool calls
- **Can**: Block operations with exit code 2
- **Use case**: Validation, permission checks, blocking dangerous operations

### PostToolUse
- **When**: Runs after tool calls complete
- **Can**: Process results, trigger follow-up actions
- **Use case**: Formatting, linting, testing, notifications

### UserPromptSubmit
- **When**: Runs when user submits a prompt
- **Can**: Modify or validate user input
- **Use case**: Input validation, logging, prompt enhancement

### Notification
- **When**: Runs when Claude Code sends notifications
- **Can**: Send custom notifications
- **Use case**: Desktop notifications, logging, alerts

### Stop
- **When**: Runs when Claude Code finishes responding
- **Can**: Process session results
- **Use case**: Logging, analytics, cleanup

### SubagentStop
- **When**: Runs when subagent tasks complete
- **Can**: Process subagent results
- **Use case**: Aggregating results, notifications

### PreCompact
- **When**: Runs before compact operations
- **Can**: Prepare for context reduction
- **Use case**: Saving state, logging

### SessionStart
- **When**: Runs when session starts/resumes
- **Can**: Initialize session state
- **Use case**: Setup, loading preferences

### SessionEnd
- **When**: Runs when session ends
- **Can**: Cleanup and save state
- **Use case**: Cleanup, analytics, saving session data

---

## 5. 🎯 BEST PRACTICES

### Shell Safety Headers

**Always start with**:
```bash
#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

### Extract Data from JSON Payload

```bash
# File path (Edit/Write tools)
file_path="$(jq -r '.tool_input.file_path // ""')"

# Command (Bash tool)
command="$(jq -r '.tool_input.command // ""')"

# Tool name
tool_name="$(jq -r '.tool_name // ""')"

# Full tool input
tool_input="$(jq -r '.tool_input' | jq -c .)"
```

### Use Environment Variables

```bash
$CLAUDE_PROJECT_DIR   # Project root directory
$CLAUDE_USER_DIR      # User's ~/.claude directory
$CLAUDE_SESSION_ID    # Current session identifier
```

### Efficient File Extension Filtering

```bash
# Good: Use bash regex matching
[[ "$file_path" =~ \.(ts|tsx)$ ]] || exit 0

# Avoid: Spawning grep subprocess
echo "$file_path" | grep -q '\.ts$' || exit 0
```

### Package Manager Auto-Detection

```bash
# Check lock files to match project's package manager
if command -v pnpm >/dev/null 2>&1 && [ -f "pnpm-lock.yaml" ]; then
  PM="pnpm exec"
elif command -v yarn >/dev/null 2>&1 && [ -f "yarn.lock" ]; then
  PM="yarn"
else
  PM="npx"  # Fallback to npx
fi
```

### Exit Codes

```bash
exit 0  # Success: Allow operation to continue
exit 1  # Error: Log error but don't block
exit 2  # Block: Prevent operation in PreToolUse hooks
```

### Performance Considerations

- Avoid heavy operations in tight loops
- Use file extension checks to skip irrelevant files early
- Consider async/background execution for slow operations
- Cache results when possible

### External Scripts vs Inline Commands

**External scripts** (`.claude/hooks/*.sh`):
- Complex logic, multiple steps
- Reusable patterns
- Better debugging and testing

**Inline commands**:
- Simple one-liners
- Quick jq filters
- Logging

---

## 6. 💡 COMMON PATTERNS

### Logging Bash Commands

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "comment": "Log all Bash commands with descriptions",
        "command": "set -euo pipefail; cmd=$(jq -r '.tool_input.command // \"\"'); desc=$(jq -r '.tool_input.description // \"No description\"'); echo \"[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $cmd - $desc\" >> \"$CLAUDE_USER_DIR/bash-command-log.txt\""
      }]
    }]
  }
}
```

### Block Sensitive File Edits

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "comment": "Prevent edits to sensitive files",
        "command": "set -euo pipefail; file_path=$(jq -r '.tool_input.file_path // \"\"'); if [[ \"$file_path\" =~ \\.(env|secrets|credentials) ]] || [[ \"$file_path\" == *\"package-lock.json\" ]] || [[ \"$file_path\" == *.git/* ]]; then echo \"ERROR: Cannot edit sensitive file: $file_path\" >&2; exit 2; fi"
      }]
    }]
  }
}
```

### Desktop Notifications

```json
{
  "hooks": {
    "Notification": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "comment": "Send desktop notifications",
        "command": "if command -v notify-send >/dev/null 2>&1; then notify-send 'Claude Code' 'Awaiting your input'; elif command -v osascript >/dev/null 2>&1; then osascript -e 'display notification \"Awaiting your input\" with title \"Claude Code\"'; fi"
      }]
    }]
  }
}
```

### Process Multiple Files

```bash
set -euo pipefail
jq -r '.tool_input.files[]?' | while IFS= read -r file; do
  [[ -f "$file" ]] && echo "Processing: $file"
  # Your processing logic here
done
```

### Conditional Execution Based on Directory

```bash
set -euo pipefail
file_path=$(jq -r '.tool_input.file_path // ""')
# Only process files in src/ directory
[[ "$file_path" =~ ^src/ ]] || exit 0
# Your command here
```

### Multi-Tool Chain with Error Handling

```bash
set -euo pipefail
file_path=$(jq -r '.tool_input.file_path // ""')
[[ "$file_path" =~ \.(ts|tsx)$ ]] || exit 0

cd "$CLAUDE_PROJECT_DIR"

# Run linter
if ! npx eslint --fix "$file_path" 2>/dev/null; then
  echo "Warning: ESLint failed" >&2
fi

# Run formatter (always runs even if linter fails)
npx prettier --write "$file_path" 2>/dev/null || true
```

### Cross-Platform Compatibility

```bash
set -euo pipefail

# Detect OS and use appropriate commands
case "$(uname -s)" in
  Darwin*)
    # macOS
    osascript -e 'display notification "Build complete"'
    ;;
  Linux*)
    # Linux
    notify-send "Build complete"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    # Windows
    powershell -Command "New-BurntToastNotification -Text 'Build complete'"
    ;;
esac
```

---

## 7. 📖 RULES

### ALWAYS

- Start bash scripts with `set -euo pipefail`
- Use `$CLAUDE_PROJECT_DIR` for project-relative paths
- Extract JSON data with `jq`
- Check file extensions before processing
- Auto-detect package managers
- Make external scripts executable (`chmod +x`)
- Test hooks standalone before deploying
- Document hook purpose in comments
- Use appropriate exit codes (0, 1, 2)

### NEVER

- Hardcode sensitive data in hook commands
- Skip validation steps
- Use hooks without testing
- Forget error handling
- Block operations unnecessarily
- Run heavy operations without optimization
- Skip safety headers in bash scripts
- Overwrite existing hooks without confirmation

### ESCALATE IF

- Hook execution fails repeatedly
- Performance issues occur
- Security concerns arise
- User needs custom hook behavior
- Package manager detection fails
- Required tools are missing

---

## 8. 🎓 SUCCESS CRITERIA

**Hook is successfully created when**:
- ✅ Hook type is valid and appropriate
- ✅ Matcher pattern is correct
- ✅ Command executes without errors
- ✅ External scripts are executable
- ✅ Settings.json is properly configured
- ✅ Hook follows best practices
- ✅ Performance is acceptable
- ✅ Documentation is clear

**Quality Gates**:
- Hooks are idempotent
- Error handling is comprehensive
- Security considerations are addressed
- Performance impact is minimal
- Cross-platform compatibility (when needed)

---

## 9. 🔗 INTEGRATION POINTS

### Related Commands

- **`/hooks`**: Reload and list hooks
- **Usage**: Hooks execute automatically on events
- **Settings**: `.claude/settings.json`, `.claude/settings.local.json`, `~/.claude/settings.json`

### Storage Locations

- **`.claude/settings.json`**: Project-specific, committed to git
- **`.claude/settings.local.json`**: Project-specific, not committed
- **`~/.claude/settings.json`**: User-wide, all projects

### Best Practices

- Use template mode for common tools
- Create external scripts for complex logic
- Test hooks independently with sample JSON
- Use appropriate hook events
- Consider performance impact
- Document hook behavior
- Version control hook scripts

---

## 10. 🐛 TROUBLESHOOTING

### Hook Not Executing

**Actions**:
1. Run `/hooks` to reload configuration
2. Check hook registration with `/hooks` command
3. Verify JSON syntax in settings files
4. Check file permissions (`chmod +x` for scripts)
5. Review Claude Code output for errors

### Hook Blocking Operations

**Actions**:
1. Check exit codes (exit 2 blocks in PreToolUse)
2. Review hook logic for blocking conditions
3. Test hook command standalone
4. Add error logging to identify issue
5. Temporarily disable hook to verify

### Performance Issues

**Actions**:
1. Add file extension checks early
2. Move slow operations to background
3. Cache expensive results
4. Reduce hook frequency
5. Profile hook execution time

### Testing Hooks

```bash
# Test with sample JSON
echo '{"tool_name":"Edit","tool_input":{"file_path":"test.ts"}}' | .claude/hooks/run-eslint.sh

# Run with debug mode
claude --debug

# Check exit code
.claude/hooks/run-eslint.sh; echo "Exit code: $?"
```

---

## 11. 💡 EXAMPLES

### Template Mode (Recommended)

```bash
# User: "Set up ESLint to run on file edits"
/create-hook
# Detects "ESLint", offers template
# → Creates .claude/hooks/run-eslint.sh
# → Adds PostToolUse hook to settings.json
# → Makes script executable
# → STATUS=OK HOOK_FILE=.claude/hooks/run-eslint.sh
```

### Interactive Mode

```bash
/create-hook
# Shows menu of:
#  1. Common tools (ESLint, Prettier, TypeScript, Tests)
#  2. Hook types (PreToolUse, PostToolUse, etc.)
#  3. Custom hook creation
```

### Guided Mode

```bash
/create-hook PostToolUse
# Guides through creating a PostToolUse hook
# Asks for: matcher, command/script, storage location
```

### Direct Mode

```bash
/create-hook PreToolUse "Bash" "set -euo pipefail; cmd=$(jq -r '.tool_input.command'); echo \"[$(date -Iseconds)] $cmd\" >> \"$CLAUDE_USER_DIR/bash.log\""
# Creates hook configuration directly with best practices
```

---

## 12. 🔒 SECURITY CONSIDERATIONS

- Hooks run automatically with your environment's credentials
- Always review hook implementation before registering
- Be cautious with hooks that execute external commands
- Avoid hardcoding sensitive data in hook commands
- Use exit code 2 to block operations in PreToolUse hooks
- Validate input data before processing
- Limit hook scope to necessary tools/events
- Test hooks in safe environments first

---

## 13. 📚 REFERENCE

**Documentation**: https://docs.claude.com/en/hooks

**Debug Command**: `claude --debug`

**Reload Hooks**: `/hooks`

**Environment Variables**:
- `$CLAUDE_PROJECT_DIR`
- `$CLAUDE_USER_DIR`
- `$CLAUDE_SESSION_ID`

**Exit Codes**:
- `0` - Success/continue
- `1` - Error/log
- `2` - Block operation
