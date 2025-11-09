---
name: markdown-naming-enforcer
description: This skill automatically enforces markdown filename conventions from document_style_guide.md. It detects and auto-corrects naming violations (ALL CAPS, hyphens, camelCase) to lowercase snake_case format. This skill should be used when creating or editing markdown files to ensure compliance with project naming standards.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Markdown Naming Enforcer

Automatically enforces markdown filename conventions across the project by detecting and correcting naming violations. All `.md` files are renamed to lowercase snake_case format as defined in `knowledge/document_style_guide.md`.

---

## 1. 🎯 WHEN TO USE

**This skill should be used when**:
- Creating new markdown documentation
- Editing existing markdown files
- Working in specs/, knowledge/, or any project directory
- Ensuring consistency across all project markdown files

**This skill should NOT be used for**:
- Non-markdown files (only `.md` files enforced)
- Files outside the project directory

---

## 2. 🛠️ HOW IT WORKS

This skill operates via a PostToolUse hook (`.claude/hooks/PostToolUse/enforce-markdown-naming.sh`) that:

1. Monitors Write, Edit, NotebookEdit tool operations
2. Detects markdown files with naming violations
3. Automatically renames files to lowercase snake_case
4. Injects correction notice into AI context
5. Logs corrections to `.claude/hooks/logs/naming-corrections.log`

**Note**: When a file is auto-corrected, a notification will appear explaining the change and referencing the style guide.

---

## 3. 📋 NAMING RULES

Based on `knowledge/document_style_guide.md` (lines 36-59):

**Required Format**: `lowercase_snake_case.md`

**Exceptions**:
- `README.md` (documentation root files)
- `SKILL.md` (Claude Code skill definition files in `.claude/skills/*/`)

**Transformation Examples**:

| Input | Output | Violation Type |
|-------|--------|----------------|
| `ANALYSIS.md` | `analysis.md` | ALL CAPS |
| `EXECUTIVE_SUMMARY.md` | `executive_summary.md` | ALL CAPS with underscore |
| `my-document.md` | `my_document.md` | Hyphens |
| `MyDocument.md` | `my_document.md` | PascalCase |
| `myDocument.md` | `my_document.md` | camelCase |
| `My-API_Guide.md` | `my_api_guide.md` | Mixed violations |
| `README.md` | `README.md` | Preserved (exception) |
| `SKILL.md` | `SKILL.md` | Preserved (exception in .claude/skills/) |

---

## 4. 💡 EXAMPLE CORRECTIONS

**Scenario 1: ALL CAPS File**
```
Created: specs/020-feature/ANALYSIS.md
Auto-corrected to: specs/020-feature/analysis.md
AI receives: Notification with style guide reference
```

**Scenario 2: README Exception**
```
Created: specs/020-feature/README.md
Result: No correction (valid filename)
```

**Scenario 3: SKILL.md Exception**
```
Created: .claude/skills/my-skill/SKILL.md
Result: No correction (valid filename in skills directory)
```

---

## 5. 📖 RULES

### ALWAYS

- Monitor all Write, Edit, NotebookEdit operations on `.md` files
- Preserve `README.md` and `SKILL.md` (in `.claude/skills/*/`) as ALL CAPS exceptions
- Convert to lowercase snake_case format
- Inject AI notification when corrections occur
- Log all corrections with timestamps
- Operate silently (non-blocking)

### NEVER

- Rename non-markdown files
- Block AI operations on rename failure
- Modify `README.md` or `SKILL.md` filenames
- Change file content (only filename)
- Interrupt AI workflow

### ESCALATE IF

- Hook script becomes non-executable
- Rename operations consistently fail
- Style guide rules change
- Hook conflicts with other PostToolUse hooks

---

## 6. 🎓 SUCCESS CRITERIA

**Enforcement is successful when**:
- ✅ All markdown files follow lowercase snake_case
- ✅ Violations detected and corrected automatically
- ✅ AI receives clear correction notifications
- ✅ `README.md` and `SKILL.md` exceptions honored consistently
- ✅ No workflow interruptions occur

---

## 7. 🔗 INTEGRATION POINTS

**Triggers**: Write, Edit, NotebookEdit tools on `.md` files

**Pairs With**:
- `document_style_guide.md` - Source of naming rules
- `save-context` skill - Documentation workflows
- `git-commit` skill - Clean commit history

**Outputs**:
- Renamed markdown files
- Correction notices to AI context
- Audit log: `.claude/hooks/logs/naming-corrections.log`

---

## 8. 🎯 QUICK REFERENCE

**Valid**: `user_guide.md`, `README.md`, `SKILL.md` (in `.claude/skills/*/`)

**Invalid**: `USER_GUIDE.md`, `user-guide.md`, `userGuide.md`, `UserGuide.md`

**Hook Location**: `.claude/hooks/PostToolUse/enforce-markdown-naming.sh`

**Style Guide**: `knowledge/document_style_guide.md` (lines 36-59)

**Core Rule**: Only `README.md` and `SKILL.md` (in skills directories) may use ALL CAPS; all other `.md` files must use lowercase snake_case.
