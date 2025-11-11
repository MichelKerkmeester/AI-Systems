# YAML Frontmatter Templates - Document Type Reference

Templates for adding missing YAML frontmatter to documents. Use these templates when the document-style-fixer needs to add frontmatter to non-compliant files.

---

## SKILL.md Frontmatter Template

**Required Fields**: `name`, `description`, `allowed-tools`

**Template**:
```yaml
---
name: skill-name
description: Brief one-line description of what this skill does and when to use it
allowed-tools: Read, Write, Edit, Bash, Grep
---
```

**Field Guidelines**:

**`name`**:
- Format: `lowercase-with-hyphens`
- Should match directory name
- Example: `document-style-validator`, `git-commit`, `save-context`

**`description`**:
- One to two sentences maximum
- Explains what the skill does
- Mentions key triggering conditions or use cases
- Example: "Validates markdown document structure against style guide requirements for SKILL.md, commands, knowledge files, and specs"

**`allowed-tools`**:
- Comma-separated list of Claude Code tools the skill can use
- Common tools: Read, Write, Edit, Bash, Grep, Glob, WebFetch, AskUserQuestion
- Order by frequency of use (most common first)
- Example: `Read, Write, Bash` or `Read, Grep, Bash, WebFetch`

**Complete Example**:
```yaml
---
name: code-systematic-debugging
description: Four-phase debugging framework for browser console errors, CSS layout issues, JavaScript animations, and Webflow-specific bugs
allowed-tools: Read, Bash, Grep
---
```

---

## Command Frontmatter Template

**Required Fields**: `description`, `argument-hint`, `allowed-tools`

**Template**:
```yaml
---
description: Brief description of what this command does
argument-hint: [required_arg] [optional_arg]
allowed-tools: Read, Write, Bash
---
```

**Field Guidelines**:

**`description`**:
- One sentence explaining command purpose
- Focus on what it creates or generates
- Example: "Create new slash commands with standardized structure"

**`argument-hint`**:
- Shows command syntax with placeholders
- Square brackets for required args: `[required_arg]`
- Angle brackets for optional args: `<optional_arg>` OR square brackets with default notation
- Example: `[name] [purpose]` or `[name] <type>`

**`allowed-tools`**:
- Same as SKILL.md
- Common for commands: Read, Write, Bash, Grep
- Include tools needed to fulfill command's purpose

**Complete Example**:
```yaml
---
description: Generate properly structured command files with correct YAML frontmatter
argument-hint: [name] [purpose]
allowed-tools: Read, Write, Bash
---
```

---

## Knowledge File Frontmatter

**Rule**: Knowledge files should **NOT** have YAML frontmatter.

**If present**: The fixer should **remove** frontmatter from knowledge files.

**Rationale**: Knowledge files are pure content documents. Frontmatter is for programmatic interfaces (skills, commands) that need metadata for execution.

**Fix Action**:
```yaml
# BEFORE (incorrect)
---
name: document-style-guide
description: Style guide for documentation
---

# Document Style Guide - Official Standards

Content...

# AFTER (correct)
# Document Style Guide - Official Standards

Content...
```

---

## Spec File Frontmatter

**Rule**: Spec files should **NOT** have YAML frontmatter.

**Alternative Metadata Format**:
Specs use inline metadata at the top (not YAML frontmatter):

```markdown
# Feature Name - Spec

**Date**: 2025-11-10
**Version**: 1.0
**Priority**: HIGH

Brief introduction...
```

**Rationale**: Specs evolve rapidly during planning. YAML frontmatter adds formality that slows iteration. Inline metadata is more flexible.

**If YAML frontmatter present**: Suggest removal (loose enforcement, not required).

---

## README.md Frontmatter

**Rule**: README files follow universal rules only. No specific frontmatter requirements.

**Common Practice**: README files typically don't use YAML frontmatter unless they're skill/command documentation.

**Exception**: If README.md is in `.claude/skills/*/` directory and documents the skill, it might use skill-style frontmatter. However, the main SKILL.md should exist separately.

---

## Frontmatter Validation Rules

### Required Field Checks

**For SKILL.md**:
```bash
# Must have all three fields
grep -q "^name:" file.md
grep -q "^description:" file.md
grep -q "^allowed-tools:" file.md
```

**For Commands**:
```bash
# Must have all three fields
grep -q "^description:" file.md
grep -q "^argument-hint:" file.md
grep -q "^allowed-tools:" file.md
```

### Format Validation

**Opening delimiter**:
```bash
# First line must be ---
head -1 file.md | grep -q "^---$"
```

**Closing delimiter**:
```bash
# Must have matching --- to close frontmatter
# Should be within first 20 lines
head -20 file.md | grep -c "^---$" | grep -q "^2$"
```

**Field format**:
```bash
# Each field should be key: value
grep "^name:" file.md | grep -q "^name: [a-z-]\\+$"
grep "^description:" file.md | grep -q "^description: .\\+$"
grep "^allowed-tools:" file.md | grep -q "^allowed-tools: .\\+$"
```

---

## Auto-Generation Guidelines

### When to Add Frontmatter

**SKILL.md**:
- Always required
- If missing, auto-generate template
- Ask user to fill in specific values OR infer from context

**Commands**:
- Always required
- If missing, auto-generate template
- Can infer `description` from H1 title
- Can infer `argument-hint` from INPUTS section

**Knowledge/Specs**:
- Should NOT have frontmatter
- If present, suggest removal

### Inferring Field Values

**`name` (SKILL.md)**:
```bash
# Infer from directory name
name=$(basename "$(dirname "$file_path")")
# Converts: .claude/skills/my-skill/SKILL.md → my-skill
```

**`description` (SKILL.md, Commands)**:
```bash
# Infer from H1 subtitle
h1_subtitle=$(grep "^# " file.md | head -1 | sed 's/^# [^-]* - //')
# Converts: # My Skill - Brief Description → Brief Description

# Or infer from first paragraph
first_paragraph=$(awk '/^# /{getline; getline; print; exit}' file.md)
```

**`argument-hint` (Commands)**:
```bash
# Infer from INPUTS section
required_inputs=$(awk '/### Required Inputs/,/### Optional Inputs/' file.md | grep "^- " | sed 's/^- `\([^`]*\)`.*/[\1]/' | tr '\n' ' ')
# Converts:
# - `name`: Description
# - `type`: Description
# → [name] [type]
```

**`allowed-tools`**:
```bash
# Infer from tool usage in WORKFLOW section
tools=$(grep -E "^(Read|Write|Edit|Bash|Grep)" file.md | cut -d' ' -f1 | sort -u | tr '\n' ',' | sed 's/,$//')
# Finds tool calls in code examples and generates comma-separated list
```

---

## Interactive Frontmatter Addition

### Approval Flow

**Step 1: Present Template**
```
STRUCTURAL FIX: Add YAML Frontmatter

File: .claude/skills/new-skill/SKILL.md
Type: SKILL.md (frontmatter required)

Proposed frontmatter (inferred from document):
---
name: new-skill
description: Brief description inferred from H1 subtitle
allowed-tools: Read, Write, Bash
---

Options:
1. Accept as-is
2. Edit values before applying
3. Skip (leave non-compliant)

Choice:
```

**Step 2: If Edit Selected**
```
Edit frontmatter values:

name [new-skill]: _
description [Brief description...]: _
allowed-tools [Read, Write, Bash]: _

Press Enter to keep default, or type new value.
```

**Step 3: Apply**
```bash
# Insert at beginning of file
{
  echo "---"
  echo "name: $name"
  echo "description: $description"
  echo "allowed-tools: $allowed_tools"
  echo "---"
  echo ""
  cat original_file.md
} > updated_file.md
```

---

## Frontmatter Correction

### Fixing Incomplete Frontmatter

**Missing Fields**:
```yaml
# BEFORE (missing allowed-tools)
---
name: my-skill
description: My skill description
---

# FIX: Add missing field
---
name: my-skill
description: My skill description
allowed-tools: Read, Write, Bash
---
```

**Incorrect Format**:
```yaml
# BEFORE (wrong format)
---
Name: my-skill  # Should be lowercase
desc: Description  # Should be 'description'
tools: Read  # Should be 'allowed-tools'
---

# FIX: Correct field names
---
name: my-skill
description: Description
allowed-tools: Read
---
```

**Malformed Delimiters**:
```yaml
# BEFORE (missing closing delimiter)
---
name: my-skill
description: Description
allowed-tools: Read

# FIX: Add closing delimiter
---
name: my-skill
description: Description
allowed-tools: Read
---
```

---

## Quick Reference

### Frontmatter Decision Tree

```
Document type?
├─> SKILL.md       → MUST have frontmatter (name, description, allowed-tools)
├─> Command        → MUST have frontmatter (description, argument-hint, allowed-tools)
├─> Knowledge      → MUST NOT have frontmatter (remove if present)
├─> Spec           → SHOULD NOT have frontmatter (suggest removal)
└─> README         → No specific requirement (usually none)
```

### Field Requirements

| Document Type | name | description | argument-hint | allowed-tools |
|---------------|------|-------------|---------------|---------------|
| **SKILL.md** | ✅ Required | ✅ Required | ❌ N/A | ✅ Required |
| **Command** | ❌ N/A | ✅ Required | ✅ Required | ✅ Required |
| **Knowledge** | ❌ Forbidden | ❌ Forbidden | ❌ Forbidden | ❌ Forbidden |
| **Spec** | ❌ Not used | ❌ Not used | ❌ Not used | ❌ Not used |

### Common Mistakes

1. **Knowledge file with frontmatter** → Remove it
2. **SKILL.md missing `name` field** → Add with directory name
3. **Command missing `argument-hint`** → Infer from INPUTS or ask user
4. **Spec with YAML frontmatter** → Suggest inline metadata instead
5. **Wrong field names** → Correct to standard names (name, description, etc.)
