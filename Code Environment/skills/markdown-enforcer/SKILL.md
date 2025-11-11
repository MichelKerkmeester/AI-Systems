---
name: markdown-enforcer
description: Unified markdown enforcement for filenames, structure, and content with automated safe fixes and critical violation blocking
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Markdown Enforcer - Unified Filename & Structure Enforcement

Comprehensive markdown enforcement system that automatically corrects filename violations, validates document structure, and applies safe formatting fixes while blocking execution on critical structural violations. Integrates filename conventions, document structure rules, and automated correction workflows into a single enforcement framework.

---

## 1. 🎯 WHEN TO USE

**Automatic Enforcement** (via hooks):
- Runs automatically on Write/Edit operations for filenames
- Runs automatically on prompt submit for structure validation
- Auto-fixes safe violations without manual intervention
- Blocks execution when critical structural violations detected

**Manual Invocation**:
- Deep validation of document structure after creation
- Batch validation of multiple files or directories
- Generate detailed compliance reports with line numbers
- Apply structural fixes with approval gates
- Audit entire `.claude/` directory for compliance

**Before Git Operations**:
- Validate documents before staging changes
- Ensure compliance before pull requests
- Final cleanup pass before commits

**During Documentation Work**:
- Creating new SKILL.md or command files
- Updating knowledge documentation
- Restructuring document sections
- Migrating documents to new standards

**DO NOT use for**:
- Non-markdown files (only `.md` files enforced)
- Files outside the project directory
- Spec files (loose enforcement, rarely blocked)

---

## 2. 🛠️ HOW IT WORKS

**Three-Layer Enforcement Architecture**:

### Layer 1: Filename Enforcement (PostToolUse Hook - Auto-fix)
**Hook**: `.claude/hooks/PostToolUse/enforce-markdown-post.sh`
- Monitors Write/Edit/NotebookEdit operations
- Detects filename violations (ALL CAPS, hyphens, camelCase)
- Auto-corrects to lowercase snake_case immediately
- Logs corrections to `markdown-enforcement.log`
- **Never blocks** - always exits 0

**Transformations**:
- `ANALYSIS.md` → `analysis.md`
- `My-Document.md` → `my_document.md`
- `myDocument.md` → `my_document.md`
- `README.md` → `README.md` (exception)
- `SKILL.md` → `SKILL.md` (exception in `.claude/skills/`)

### Layer 2: Structure Validation (UserPromptSubmit Hook - Blocking)
**Hook**: `.claude/hooks/UserPromptSubmit/enforce-markdown-strict.sh`
- Scans modified .md files on prompt submit
- Auto-detects document type (SKILL.md, command, knowledge, spec)
- **Auto-fixes SAFE violations** immediately without approval
- **Blocks on CRITICAL violations** (exits 1 to prevent execution)

**Safe Auto-Fixes** (non-blocking):
- Add missing `---` separators between sections
- Convert H2 titles to ALL CAPS
- Add standard emoji to H2 sections
- Fix H1 subtitle format
- Normalize spacing around headers
- Convert TABLE OF CONTENTS to H4 (`#### 📋 TABLE OF CONTENTS`)

**Critical Violations** (BLOCKS execution):
- Missing YAML frontmatter (SKILL.md/commands)
- Missing required frontmatter fields (name, description, allowed-tools)
- Sections in wrong order
- Missing required sections (WHEN TO USE, HOW IT WORKS, RULES)
- H1 subtitle violations (present when shouldn't be, missing when should)
- Multiple H1 headers

### Layer 3: Manual Deep Validation & Fixing (Skill Invocation)
**Manual skill invocation** for:
- Detailed compliance reports with line numbers
- Structural fixes requiring approval (add sections, reorder, frontmatter)
- Batch validation of multiple files
- Re-validation after manual edits
- Generate comprehensive change summaries

---

## 3. ⚖️ ENFORCEMENT LEVELS

### Safe Violations (Auto-fix, Non-blocking)

**Filename Issues**:
- ALL CAPS → Convert to lowercase
- Hyphens → Replace with underscores
- camelCase/PascalCase → Convert to snake_case

**Formatting Issues**:
- Missing separators → Add `---` between sections
- H2 not ALL CAPS → Convert to uppercase
- Missing H2 emoji → Add standard emoji
- Incorrect spacing → Normalize around headers
- H1 subtitle format → Fix based on document type
- TABLE OF CONTENTS not H4 → Convert `## 📋 TABLE OF CONTENTS` to `#### 📋 TABLE OF CONTENTS`

**Behavior**: Applied immediately, logged to `markdown-enforcement.log`, never blocks

### Critical Violations (Block Execution)

**SKILL.md files**:
- ❌ Missing YAML frontmatter → EXIT 1
- ❌ Missing `name` field → EXIT 1
- ❌ Missing `description` field → EXIT 1
- ❌ Missing `allowed-tools` field → EXIT 1
- ❌ Sections in wrong order → EXIT 1
- ❌ Missing required sections (WHEN TO USE, HOW IT WORKS, RULES) → EXIT 1
- ❌ H1 missing subtitle → EXIT 1
- ❌ Multiple H1 headers → EXIT 1

**Command files**:
- ❌ Missing YAML frontmatter → EXIT 1
- ❌ Missing `description` field → EXIT 1
- ❌ Missing `argument-hint` field → EXIT 1
- ❌ H1 has subtitle (should not) → EXIT 1
- ❌ Sections in wrong order → EXIT 1
- ❌ Missing required sections (INPUTS, WORKFLOW, OUTPUTS) → EXIT 1

**Knowledge files**:
- ❌ Has YAML frontmatter (should not) → EXIT 1
- ❌ H1 missing subtitle → EXIT 1
- ❌ H2 sections not numbered → EXIT 1
- ❌ Multiple H1 headers → EXIT 1

**Spec files**:
- ⚠️ Suggestions only - NEVER blocks (loose enforcement)

**Behavior**: Exits 1, prevents AI execution, must be fixed before continuing

### Document Type Detection

**Auto-detection patterns**:
- `.claude/skills/*/SKILL.md` → skill (strict)
- `.claude/commands/**/*.md` → command (strict)
- `.claude/knowledge/*.md` → knowledge (moderate)
- `specs/**/*.md` → spec (loose)
- `README.md` → readme (flexible)

---

## 4. 📋 COMMON VIOLATIONS

### Filename Violations

| Violation | Fix | Example |
|-----------|-----|---------|
| ALL CAPS | Convert to lowercase | `ANALYSIS.md` → `analysis.md` |
| Hyphens | Replace with underscores | `my-document.md` → `my_document.md` |
| camelCase | Convert to snake_case | `myDocument.md` → `my_document.md` |
| PascalCase | Convert to snake_case | `MyDocument.md` → `my_document.md` |
| Mixed | Apply all transforms | `My-API_Guide.md` → `my_api_guide.md` |

**Exceptions**: `README.md`, `SKILL.md` (in `.claude/skills/`)

### Structure Violations

**Missing Frontmatter** (CRITICAL):
```yaml
# Before (BLOCKS)
# My Skill - Description

# After (FIXED)
---
name: my-skill
description: Brief description
allowed-tools: Read, Write, Bash
---

# My Skill - Description
```

**H2 Not ALL CAPS** (SAFE - auto-fixed):
```markdown
# Before
## 1. 🎯 when to use

# After
## 1. 🎯 WHEN TO USE
```

**Missing Separators** (SAFE - auto-fixed):
```markdown
# Before
## 1. 🎯 WHEN TO USE
Content here
## 2. 🛠️ HOW IT WORKS

# After
## 1. 🎯 WHEN TO USE
Content here

---

## 2. 🛠️ HOW IT WORKS
```

**TABLE OF CONTENTS Wrong Level** (SAFE - auto-fixed):
```markdown
# Before
## 📋 TABLE OF CONTENTS

# After
#### 📋 TABLE OF CONTENTS
```

**H1 Subtitle Missing** (CRITICAL for SKILL.md/knowledge):
```markdown
# Before (BLOCKS)
# My Skill

# After (MUST FIX)
# My Skill - Descriptive Subtitle
```

**Sections Out of Order** (CRITICAL for SKILL.md):
```markdown
# Before (BLOCKS)
## HOW IT WORKS
## WHEN TO USE
## RULES

# After (MUST FIX)
## WHEN TO USE
## HOW IT WORKS
## RULES
```

---

## 5. 📖 RULES

### ALWAYS

**Filename Enforcement**:
- Monitor all Write/Edit/NotebookEdit operations on `.md` files
- Preserve `README.md` and `SKILL.md` (in `.claude/skills/`) as exceptions
- Convert to lowercase snake_case format automatically
- Log all filename corrections with timestamps

**Structure Validation**:
- Detect document type automatically from file path
- Apply appropriate enforcement level (strict/moderate/loose)
- Auto-fix all safe violations immediately
- Block execution on critical violations (exit 1)
- Provide specific fix suggestions with line numbers

**Transparency**:
- Inject correction notices into AI context (stderr)
- Log all actions to `markdown-enforcement.log`
- Show before/after preview for structural changes
- Generate comprehensive change summaries

**Safety**:
- Work on git-tracked files (enable easy rollback)
- Never delete content without explicit approval
- Ask user approval before structural changes (manual skill invocation)
- Re-validate after fixes to confirm compliance

### NEVER

**DO NOT**:
- Rename non-markdown files
- Block AI operations on rename failure (filename layer always exits 0)
- Apply wrong document type rules
- Enforce strict rules on spec files (suggestions only)
- Apply structural fixes in batch mode without approval gates
- Modify file if validation shows no violations
- Proceed with structural fixes if file is not in git
- Skip validation because "it looks mostly ok"

### ESCALATE IF

**Immediate escalation required when**:
- Document type cannot be determined (ask user to specify)
- File path doesn't match standard location (confirm type)
- Document structure is severely malformed (suggest manual rewrite)
- Frontmatter is severely corrupted or unparseable
- Safe fixes cause content corruption (rollback and warn)
- User declines all structural fixes (document remains non-compliant)
- File is not git-tracked (unsafe to apply fixes)
- Hook script becomes non-executable
- Rename operations consistently fail
- Hook conflicts with other hooks

---

## 6. 🎓 SUCCESS CRITERIA

### Filename Enforcement Success
- ✅ All markdown files follow lowercase snake_case convention
- ✅ Violations detected and corrected automatically
- ✅ AI receives clear correction notifications
- ✅ `README.md` and `SKILL.md` exceptions honored consistently
- ✅ No workflow interruptions from filename corrections

### Structure Enforcement Success
- ✅ Safe violations auto-fixed without user intervention
- ✅ Critical violations block execution and provide clear error messages
- ✅ Violations include line numbers and context in reports
- ✅ Fix suggestions are specific and actionable
- ✅ Document passes validation after all fixes applied

### Validation Accuracy
- ✅ Correctly identifies document type from file path
- ✅ Applies appropriate enforcement level (strict/moderate/loose)
- ✅ Handles edge cases (non-standard locations, missing files)
- ✅ Detects missing sections, incorrect format, wrong order
- ✅ No false positives (incorrectly flagging compliant documents)

### User Experience
- ✅ User understands why something is a violation
- ✅ User knows how to fix critical issues
- ✅ User can find examples of correct structure
- ✅ Structural changes clearly explained before applying
- ✅ User has control over structural modifications

### Safety & Reliability
- ✅ No content deleted without approval
- ✅ File backed by git (rollback possible)
- ✅ Changes are reversible
- ✅ User can preview before applying structural fixes
- ✅ Logs provide complete audit trail

---

## 7. 🔗 INTEGRATION POINTS

### Hook Integration

**PostToolUse Hook** (`enforce-markdown-post.sh`):
- Triggers: Write, Edit, NotebookEdit on `.md` files
- Action: Auto-fix filename violations
- Timing: After tool execution, before response
- Blocking: No (always exits 0)

**UserPromptSubmit Hook** (`enforce-markdown-strict.sh`):
- Triggers: User submits prompt, checks modified .md files
- Action: Auto-fix safe violations, block on critical
- Timing: Before AI processes request
- Blocking: Yes (exits 1 on critical violations)

### Skill Pairings

**Complementary Skills**:
- `git-commit` - Validate/fix documents before committing
- `save-context` - Ensure saved documentation meets standards
- `create-skill` - Enforce standards when creating new skills
- `create-command` - Enforce standards when creating commands

### Workflow Integration

**Typical Workflow**:
```
1. User creates/edits markdown file
2. PostToolUse hook → Auto-fix filename (my-file.md → my_file.md)
3. User submits next prompt
4. UserPromptSubmit hook → Scan modified files
   a. Auto-fix safe violations (separators, ALL CAPS, emoji)
   b. BLOCK if critical violations found (missing frontmatter, wrong order)
5. If blocked: User fixes critical issues manually
6. If not blocked: AI continues execution
7. Manual skill invocation (optional): Deep validation with detailed reports
8. git-commit: Commit compliant documentation
```

**Batch Operations** (Manual Skill Invocation):
```bash
# Validate all skills
markdown-enforcer .claude/skills/ --mode=validate

# Fix all skills with approval gates
markdown-enforcer .claude/skills/ --mode=fix --level=with-approval

# Dry-run to preview changes
markdown-enforcer .claude/skills/ --mode=fix --level=dry-run
```

---

## 8. 🔧 TROUBLESHOOTING

### Hook Not Running

**Problem**: Filename corrections not applied automatically

**Diagnosis**:
```bash
# Check if hook is executable
ls -la .claude/hooks/PostToolUse/enforce-markdown-post.sh
# Should show: -rwxr-xr-x

# Check if hook exists
test -f .claude/hooks/PostToolUse/enforce-markdown-post.sh && echo "Exists" || echo "Missing"
```

**Fix**:
```bash
# Make hook executable
chmod +x .claude/hooks/PostToolUse/enforce-markdown-post.sh
chmod +x .claude/hooks/UserPromptSubmit/enforce-markdown-strict.sh
```

### Execution Blocked on Safe Violations

**Problem**: Prompt blocked even though violation seems minor

**Diagnosis**: Check if violation is actually critical
```bash
# View recent log entries
tail -20 .claude/hooks/logs/markdown-enforcement.log

# Check which violations are blocking
cat .claude/hooks/logs/markdown-enforcement.log | grep "CRITICAL"
```

**Fix**:
- Critical violations must be fixed manually before continuing
- Check that frontmatter exists and has required fields
- Verify H1 subtitle format matches document type
- Confirm sections are in correct order

### False Positives

**Problem**: Compliant document flagged as violation

**Diagnosis**: Verify document type detection
```bash
# Check file path pattern
echo "/Users/.../anobel.com/.claude/skills/my-skill/SKILL.md" | grep -E "\.claude/skills/.*/SKILL\.md"
```

**Fix**:
- Ensure file is in correct directory for its type
- Override document type in manual invocation if needed
- Report issue if detection logic is incorrect

### Structural Fixes Not Applied

**Problem**: Manual skill invocation doesn't apply fixes

**Diagnosis**:
- Check if file is git-tracked: `git status path/to/file.md`
- Verify no uncommitted changes preventing edits
- Check if user declined structural fixes

**Fix**:
```bash
# Ensure file is git-tracked
git add path/to/file.md

# Run skill with approval
markdown-enforcer path/to/file.md --mode=fix --level=with-approval

# Accept structural changes when prompted
```

### Log File Growing Large

**Problem**: `markdown-enforcement.log` consuming disk space

**Fix**:
```bash
# Archive old logs
mv .claude/hooks/logs/markdown-enforcement.log .claude/hooks/logs/markdown-enforcement-$(date +%Y%m%d).log

# Or truncate log
> .claude/hooks/logs/markdown-enforcement.log
```

---

## 9. 📚 REFERENCES

**Structure Templates**:
- `.claude/skills/markdown-enforcer/references/structure_templates.md`
  - Valid SKILL.md example
  - Valid command example
  - Valid knowledge file example

**Frontmatter Templates**:
- `.claude/skills/markdown-enforcer/references/frontmatter_templates.md`
  - SKILL.md frontmatter template
  - Command frontmatter template
  - Frontmatter field requirements

**Filename Conventions**:
- `.claude/skills/markdown-enforcer/references/filename_conventions.md`
  - Snake_case transformation rules
  - Exception patterns (README.md, SKILL.md)
  - Common filename violations

**Violation Guide**:
- `.claude/skills/markdown-enforcer/references/violation_guide.md`
  - 20+ common violations with before/after examples
  - Safe vs critical categorization
  - Fix strategies for each violation type

**Enforcement Workflows**:
- `.claude/skills/markdown-enforcer/references/enforcement_workflows.md`
  - Hook execution flow diagrams
  - Approval gate patterns for structural changes
  - Batch fixing workflows
  - Integration with git workflows

**Style Guide**:
- `.claude/knowledge/document_style_guide.md`
  - Section 8: DOCUMENT TYPE SPECIFICATIONS
  - Comprehensive style requirements
  - Enforcement level definitions

**Hook Scripts**:
- `.claude/hooks/PostToolUse/enforce-markdown-post.sh` (filename auto-fix)
- `.claude/hooks/UserPromptSubmit/enforce-markdown-strict.sh` (structure validation & blocking)

**Log Files**:
- `.claude/hooks/logs/markdown-enforcement.log` (all corrections and validations)
