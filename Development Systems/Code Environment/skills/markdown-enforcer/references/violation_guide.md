# Common Document Style Violations - Reference Guide

Quick reference for the most frequent document style violations, their causes, and fixes. Use this guide to quickly diagnose and resolve validation issues.

---

## SKILL.md Violations

### Violation 1: Missing YAML Frontmatter

**Detection**:
```
Error: Missing YAML frontmatter
Line: 1
```

**Cause**: SKILL.md file doesn't start with `---` or has malformed frontmatter.

**Fix**:
```markdown
❌ WRONG:
# My Skill - Description

Content...

✅ CORRECT:
---
name: my-skill
description: Brief description of what the skill does
allowed-tools: Read, Write, Bash
---

# My Skill - Description

Content...
```

---

### Violation 2: Missing Frontmatter Fields

**Detection**:
```
Error: Missing 'name' field in YAML frontmatter
Error: Missing 'description' field in YAML frontmatter
Error: Missing 'allowed-tools' field in YAML frontmatter
```

**Cause**: Required frontmatter fields not present.

**Fix**:
```yaml
❌ WRONG:
---
name: my-skill
---

✅ CORRECT:
---
name: my-skill
description: Clear description of skill purpose
allowed-tools: Read, Write, Edit, Bash, Grep
---
```

---

### Violation 3: H1 Missing Subtitle

**Detection**:
```
Error: H1 missing subtitle (expected: 'Skill Name - Descriptive Subtitle')
Line: 8
```

**Cause**: H1 header doesn't have " - Subtitle" format.

**Fix**:
```markdown
❌ WRONG:
# My Skill

✅ CORRECT:
# My Skill - Comprehensive Description
```

---

### Violation 4: H2 Sections Not ALL CAPS

**Detection**:
```
Error: H2 sections not in ALL CAPS format
Line: 12, 18, 24
```

**Cause**: H2 section titles use lowercase or Title Case.

**Fix**:
```markdown
❌ WRONG:
## 1. 🎯 When to Use
## 2. 🛠️ How it Works
## 3. 📋 Implementation Details

✅ CORRECT:
## 1. 🎯 WHEN TO USE
## 2. 🛠️ HOW IT WORKS
## 3. 📋 IMPLEMENTATION DETAILS
```

---

### Violation 4b: TABLE OF CONTENTS Wrong Heading Level

**Detection**:
```
Error: TABLE OF CONTENTS should use H4 (####), not H2 (##)
Line: 5
```

**Cause**: TABLE OF CONTENTS using wrong heading level.

**Fix**:
```markdown
❌ WRONG:
## 📋 TABLE OF CONTENTS

✅ CORRECT:
#### 📋 TABLE OF CONTENTS
```

**Applies to**: All README.md, SKILL.md, knowledge files, and documentation with table of contents

---

### Violation 5: Incorrect Section Order

**Detection**:
```
Error: Sections not in required order
Expected: WHEN TO USE → HOW IT WORKS → WORKFLOW → RULES
Found: HOW IT WORKS → WHEN TO USE → RULES → WORKFLOW
```

**Cause**: SKILL.md sections not in standard order.

**Fix**: Reorder sections to match:
```
1. WHEN TO USE
2. HOW IT WORKS
3. INPUTS (optional)
4. WORKFLOW
5. RULES
6. SUCCESS CRITERIA
7. INTEGRATION POINTS
8. QUICK REFERENCE
```

---

### Violation 6: Missing Required Sections

**Detection**:
```
Error: Missing required section: INTEGRATION POINTS
Error: Missing required section: QUICK REFERENCE
```

**Cause**: Required sections not present in SKILL.md.

**Fix**: Add missing sections:
```markdown
---

## 7. 🔗 INTEGRATION POINTS

**Pairs With**:
- `other-skill` - Description of integration

---

## 8. 🎯 QUICK REFERENCE

### Command Examples
[Examples here]

### Checklist
- [ ] Item 1
- [ ] Item 2
```

---

### Violation 7: Missing RULES Structure

**Detection**:
```
Error: RULES section missing ALWAYS/NEVER/ESCALATE IF structure
Line: 45
```

**Cause**: RULES section doesn't follow required format.

**Fix**:
```markdown
❌ WRONG:
## 5. 📋 RULES

- Rule 1
- Rule 2
- Rule 3

✅ CORRECT:
## 5. 📋 RULES

**ALWAYS**:
- Required behavior 1
- Required behavior 2

**NEVER**:
- Forbidden action 1
- Forbidden action 2

**ESCALATE IF**:
- Condition requiring user intervention 1
- Condition requiring user intervention 2
```

---

### Violation 8: Missing Section Separators

**Detection**:
```
Error: Insufficient section separators (found 2, expected 7+)
```

**Cause**: Missing `---` between major sections.

**Fix**:
```markdown
❌ WRONG:
## 1. 🎯 WHEN TO USE

Content...

## 2. 🛠️ HOW IT WORKS

✅ CORRECT:
## 1. 🎯 WHEN TO USE

Content...

---

## 2. 🛠️ HOW IT WORKS
```

---

## Command File Violations

### Violation 9: H1 Has Subtitle (Commands)

**Detection**:
```
Error: H1 should NOT have subtitle for commands
Line: 8
```

**Cause**: Command files use subtitle format when they shouldn't.

**Fix**:
```markdown
❌ WRONG:
# Create Command - Generator Tool

✅ CORRECT:
# Create Command
```

---

### Violation 10: Missing argument-hint in Frontmatter

**Detection**:
```
Error: Missing 'argument-hint' field in YAML frontmatter
```

**Cause**: Commands require argument-hint field.

**Fix**:
```yaml
❌ WRONG:
---
description: Creates something
allowed-tools: Read, Write
---

✅ CORRECT:
---
description: Creates something
argument-hint: [name] [type] [optional_param]
allowed-tools: Read, Write
---
```

---

### Violation 11: Wrong Command Section Order

**Detection**:
```
Error: Sections not in required order
Expected: INPUTS → WORKFLOW → OUTPUTS → CONSTRAINTS
```

**Cause**: Command sections not in standard order.

**Fix**: Reorder to:
```
1. INPUTS
2. WORKFLOW
3. OUTPUTS
4. CONSTRAINTS
```

---

### Violation 12: INPUTS Not Split Required/Optional

**Detection**:
```
Error: INPUTS section must separate Required vs Optional inputs
Line: 15
```

**Cause**: INPUTS section doesn't have subsections.

**Fix**:
```markdown
❌ WRONG:
## 1. 📋 INPUTS

- `param1`: Description
- `param2`: Description
- `param3`: Description (optional)

✅ CORRECT:
## 1. 📋 INPUTS

### Required Inputs
- `param1`: Description
- `param2`: Description

### Optional Inputs
- `param3`: Description (default: value)
```

---

## Knowledge File Violations

### Violation 13: Has YAML Frontmatter (Knowledge)

**Detection**:
```
Error: Knowledge files should NOT have YAML frontmatter
Line: 1
```

**Cause**: Knowledge file starts with `---` frontmatter block.

**Fix**:
```markdown
❌ WRONG:
---
name: my-knowledge
description: Something
---

# Topic - Subtitle

✅ CORRECT:
# Topic - Subtitle

Brief introduction...
```

---

### Violation 14: H1 Missing Subtitle (Knowledge)

**Detection**:
```
Error: H1 must have subtitle for knowledge files
Line: 1
```

**Cause**: Knowledge file H1 doesn't have subtitle.

**Fix**:
```markdown
❌ WRONG:
# Document Style Guide

✅ CORRECT:
# Document Style Guide - Official Standards
```

---

### Violation 15: H2 Not Numbered

**Detection**:
```
Error: Some H2 sections not numbered
Line: 12, 18
```

**Cause**: H2 headers missing number prefix.

**Fix**:
```markdown
❌ WRONG:
## 📄 DOCUMENT STRUCTURE
## 📝 HEADERS

✅ CORRECT:
## 1. 📄 DOCUMENT STRUCTURE
## 2. 📝 HEADERS
```

---

### Violation 16: H3 Has Numbers or Emoji

**Detection**:
```
Warning: H3 subsections should use Title Case without numbers or emoji
Line: 25, 30
```

**Cause**: H3 headers formatted like H2.

**Fix**:
```markdown
❌ WRONG:
### 1.1 🎯 PRIMARY STRUCTURE
### 1.2 🛠️ SECONDARY STRUCTURE

✅ CORRECT:
### Primary Structure
### Secondary Structure
```

---

## Universal Violations

### Violation 17: Missing Brief Introduction

**Detection**:
```
Warning: Document should start with brief introduction paragraph
Line: 8
```

**Cause**: No paragraph between H1 and first H2.

**Fix**:
```markdown
❌ WRONG:
# Document Title - Subtitle

---

## 1. 🧭 FIRST SECTION

✅ CORRECT:
# Document Title - Subtitle

Brief introduction paragraph explaining the purpose and value of this document.

---

## 1. 🧭 FIRST SECTION
```

---

### Violation 18: Inconsistent Separator Usage

**Detection**:
```
Warning: Inconsistent section separator usage
Line: 15, 22, 35
```

**Cause**: Some sections have `---` separator, others don't.

**Fix**: Add `---` between ALL major (H2) sections consistently.

---

### Violation 19: Code Blocks Without Language

**Detection**:
```
Warning: Code block missing language specification
Line: 45
```

**Cause**: Code fence uses ` ``` ` without language identifier.

**Fix**:
```markdown
❌ WRONG:
```
const value = 'example';
```

✅ CORRECT:
```javascript
const value = 'example';
```
```

---

### Violation 20: Filename Not snake_case

**Detection**:
```
Error: Filename violates naming convention
Expected: document_name.md
Found: DocumentName.md
```

**Cause**: File uses camelCase, PascalCase, or hyphens.

**Fix**: Rename file to `document_name.md` (lowercase snake_case).

---

## Quick Fix Commands

### Auto-fix Safe Violations

Use the `document-style-fixer` skill to automatically fix:
- Missing `---` separators
- H2 titles not in ALL CAPS
- Adding standard emoji to H2 sections
- H1 subtitle format issues

### Manual Fix Required

These require manual intervention:
- Section reordering
- Adding missing frontmatter
- Restructuring INPUTS subsections
- Adding missing required sections

### Validation Workflow

```bash
# 1. Run validator
document-style-validator path/to/file.md

# 2. Review violations report

# 3. Apply safe auto-fixes
document-style-fixer path/to/file.md --safe-only

# 4. Manually fix structural issues

# 5. Validate again
document-style-validator path/to/file.md

# 6. Commit when clean
git add path/to/file.md
git commit -m "docs: fix style violations in file.md"
```

---

## Prevention Tips

### For SKILL.md Files
1. Copy valid_skill_example.md as template
2. Fill in sections in order
3. Use document-style-validator before committing
4. Keep RULES in ALWAYS/NEVER/ESCALATE IF format

### For Command Files
1. Copy valid_command_example.md as template
2. Always separate Required/Optional inputs
3. Never add subtitle to H1
4. Include all 4 sections (INPUTS, WORKFLOW, OUTPUTS, CONSTRAINTS)

### For Knowledge Files
1. Copy valid_knowledge_example.md as template
2. No YAML frontmatter
3. Always add subtitle to H1
4. Number all H2 sections
5. Keep H3 in Title Case (no numbers/emoji)

### General Best Practices
1. Run document-style-validator before committing any .md file
2. Use `---` separators between all major sections
3. Keep H2 titles in ALL CAPS
4. Specify language for all code blocks
5. Include brief introduction paragraph after H1
