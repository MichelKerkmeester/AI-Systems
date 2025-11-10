---
description: Create new slash commands with standardized structure
argument-hint: [name] [purpose]
allowed-tools: Bash(mkdir:*), Bash(tee:*), Bash(test:*)
---

# Create Command

Generate properly structured slash command files for Claude Code with standardized formatting and conventions.

---

## 1. 📋 INPUTS

### Required Inputs

**Command Name**:
- **Format**: Lowercase, kebab-case, verb-first
- **Example**: `analyze-deps`, `check-security`, `generate-docs`

**Purpose**:
- **Format**: Clear description of what the command does
- **Example**: "Analyze dependencies for outdated packages"

### User Arguments

```text
$ARGUMENTS
```

---

## 2. 🚀 WORKFLOW

### Step 1: Validate Inputs

**Purpose**: Ensure command configuration is valid

**Actions**:
1. Check command name format (lowercase, kebab-case, verb-first)
2. Verify purpose is non-empty and descriptive
3. Validate name doesn't conflict with existing commands

**Validation**: `inputs_validated`

### Step 2: Generate Command Template

**Purpose**: Create properly structured command file

**Template Structure**:
```markdown
---
description: {{PURPOSE}}
argument-hint: [args...]
---

# /{{COMMAND_NAME}}

## Purpose
{{PURPOSE}}

## Contract
**Inputs:** `$ARGUMENTS` — command arguments
**Outputs:** `STATUS=<OK|FAIL> [key=value ...]`

## Instructions

1. **Validate inputs:**
   - Check that required arguments are provided
   - Validate argument format/values

2. **Execute the command:**

\`\`\`bash
# Add specific bash commands here
# Example: git worktree add path/to/worktree branch-name
\`\`\`

3. **Output status:**
   - Print `STATUS=OK` on success
   - Print `STATUS=FAIL ERROR="message"` on failure

## Constraints
- Idempotent and deterministic
- No network tools by default
- Minimal console output (STATUS line only)
```

**Validation**: `template_generated`

### Step 3: Create Command Directory

**Purpose**: Ensure `.claude/commands/` directory exists

**Actions**:
1. Check if `.claude/commands/` exists
2. Create directory if missing
3. Set appropriate permissions

**Validation**: `directory_ready`

### Step 4: Write Command File

**Purpose**: Save command to filesystem

**Actions**:
1. Write file atomically to `.claude/commands/{{COMMAND_NAME}}.md`
2. Ensure proper formatting and indentation
3. Set appropriate file permissions
4. Verify file was written successfully

**Validation**: `file_written`

### Step 5: Output Result

**Purpose**: Confirm creation with status message

**Output Format**:
```
STATUS=WROTE PATH=.claude/commands/{{COMMAND_NAME}}.md
```

**Validation**: `result_outputted`

---

## 3. 💡 EXAMPLES

### Example 1: Dependency Analysis Command

```bash
/create-command analyze-deps "Analyze dependencies for outdated packages"
```

**Output**:
```
STATUS=WROTE PATH=.claude/commands/analyze-deps.md
```

### Example 2: Security Check Command

```bash
/create-command check-security "Run security vulnerability scans on codebase"
```

**Output**:
```
STATUS=WROTE PATH=.claude/commands/check-security.md
```

### Example 3: Documentation Generator

```bash
/create-command generate-docs "Generate API documentation from source code"
```

**Output**:
```
STATUS=WROTE PATH=.claude/commands/generate-docs.md
```

---

## 4. 📖 RULES

### ALWAYS

- Validate command name format (lowercase, kebab-case, verb-first)
- Generate complete command template
- Create `.claude/commands/` directory if missing
- Write file atomically
- Output clear status message
- Include proper YAML frontmatter

### NEVER

- Overwrite existing command files without confirmation
- Use invalid naming conventions
- Create commands without purpose descriptions
- Skip validation steps
- Use network access by default

### ESCALATE IF

- Command name format is invalid
- Purpose description is unclear or too vague
- Directory creation fails
- File write operations fail
- Command conflicts with existing commands

---

## 5. 🎓 SUCCESS CRITERIA

**Command is successfully created when**:
- ✅ Command name follows naming conventions
- ✅ Purpose is clear and descriptive
- ✅ File created at correct location
- ✅ YAML frontmatter is properly formatted
- ✅ Template structure is complete
- ✅ Status output is provided
- ✅ File is ready to use immediately

**Quality Gates**:
- File is idempotent (won't overwrite existing)
- No network access required
- Minimal console output (STATUS line only)
- Command is deterministic and repeatable

---

## 6. 🔗 INTEGRATION POINTS

### Related Commands

- **`/commands`**: List all available commands
- **Usage**: Type `/{{command-name}}` to execute
- **Editing**: Manually edit `.claude/commands/{{command-name}}.md`

### Best Practices

- Use verb-first naming (e.g., `analyze`, `check`, `generate`)
- Keep commands focused on single responsibilities
- Document expected inputs and outputs clearly
- Make commands idempotent when possible
- Add to version control for team sharing
- Test commands after creation

---

## 7. ⚠️ COMMON MISTAKES

**Invalid naming conventions**:
- **Problem**: Using spaces, uppercase, or underscores in command name
- **Fix**: Use lowercase kebab-case with verb-first naming (e.g., `analyze-deps`)

**Vague purpose descriptions**:
- **Problem**: "Helper command" or "Utility function"
- **Fix**: Be specific about what the command does and when to use it

**Missing output status**:
- **Problem**: Command doesn't output STATUS line
- **Fix**: Always output `STATUS=OK` or `STATUS=FAIL` for tracking

**Non-idempotent commands**:
- **Problem**: Running command twice produces different results
- **Fix**: Design commands to be repeatable and deterministic
