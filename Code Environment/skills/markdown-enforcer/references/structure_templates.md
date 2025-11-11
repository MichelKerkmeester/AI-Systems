# Document Structure Templates - Valid Examples by Type

Reference templates showing correct structure for each document type. Use these as starting points when creating new documentation.

---

## SKILL.md Template

**Location**: `.claude/skills/*/SKILL.md`
**Enforcement**: Strict
**Frontmatter**: Required (name, description, allowed-tools)

```markdown
---
name: skill-name
description: Brief one-line description of what this skill does
allowed-tools: Read, Write, Edit, Bash, Grep
---

# Skill Name - Descriptive Subtitle

Brief introduction paragraph explaining the skill's purpose and value proposition.

---

## 1. 🎯 WHEN TO USE

**Primary use cases**:
- Scenario 1 description
- Scenario 2 description
- Scenario 3 description

**DO NOT use for**:
- Anti-pattern 1
- Anti-pattern 2

---

## 2. 🛠️ HOW IT WORKS

**Process Overview**:
1. Step 1 explanation
2. Step 2 explanation
3. Step 3 explanation

**Core Principles**:
- Principle 1
- Principle 2

---

## 3. 📋 INPUTS

### Required Inputs
- `param1`: Description of required parameter 1
- `param2`: Description of required parameter 2

### Optional Inputs
- `param3`: Description of optional parameter (default: value)
- `param4`: Description of optional parameter

---

## 4. 🚀 WORKFLOW

### Phase 1: Phase Name

**Step 1: Step Description**
```bash
# Code example
command --with-args
```

**Step 2: Step Description**
```bash
# Code example
another_command
```

### Phase 2: Phase Name

[Continue workflow steps...]

---

## 5. 📋 RULES

**ALWAYS**:
- Required behavior 1
- Required behavior 2
- Required behavior 3

**NEVER**:
- Forbidden action 1
- Forbidden action 2
- Forbidden action 3

**ESCALATE IF**:
- Condition requiring user intervention 1
- Condition requiring user intervention 2

---

## 6. 🎓 SUCCESS CRITERIA

**Task Completion**:
- ✅ Success criterion 1
- ✅ Success criterion 2

**Quality Standards**:
- ✅ Quality measure 1
- ✅ Quality measure 2

**User Experience**:
- ✅ UX criterion 1
- ✅ UX criterion 2

---

## 7. 🔗 INTEGRATION POINTS

**Pairs With**:
- `related-skill-1` - Integration description
- `related-skill-2` - Integration description

**Workflow Integration**:
```
1. prerequisite-skill  → Setup phase
2. this-skill          → Main execution
3. follow-up-skill     → Completion phase
```

---

## 8. 🎯 QUICK REFERENCE

### Command Examples

**Example 1**:
```bash
skill-invocation-example arg1 arg2
```

**Example 2**:
```bash
another-example --with-flags
```

### Validation Checklist

- [ ] Checklist item 1
- [ ] Checklist item 2
- [ ] Checklist item 3

### Common Issues

**Issue 1**: Description
- **Fix**: Solution

**Issue 2**: Description
- **Fix**: Solution
```

---

## Command Template

**Location**: `.claude/commands/**/*.md`
**Enforcement**: Strict
**Frontmatter**: Required (description, argument-hint, allowed-tools)

```markdown
---
description: Brief description of what this command does
argument-hint: [required_arg] <optional_arg>
allowed-tools: Read, Write, Bash
---

# Command Name

Brief introduction paragraph explaining the command's purpose.

---

## 1. 📋 INPUTS

### Required Inputs
- `arg1`: Description of required argument 1
- `arg2`: Description of required argument 2

### Optional Inputs
- `optional_arg`: Description of optional argument (default: value)

---

## 2. 🚀 WORKFLOW

**Step 1: Step Description**
```bash
# Implementation code
command_implementation
```

**Step 2: Step Description**
```bash
# More implementation
additional_steps
```

---

## 3. 📊 OUTPUTS

**Success Output**:
```
Output format when command succeeds
```

**Error Output**:
```
Output format when command fails
```

**Generated Files**:
- `path/to/generated/file.ext` - Description of generated file

---

## 4. ⚠️ CONSTRAINTS

**Requirements**:
- Constraint 1
- Constraint 2

**Limitations**:
- Limitation 1
- Limitation 2

**Edge Cases**:
- Edge case 1 handling
- Edge case 2 handling
```

---

## Knowledge File Template

**Location**: `.claude/knowledge/*.md`
**Enforcement**: Moderate
**Frontmatter**: NONE (must not have frontmatter)

```markdown
# Topic Name - Descriptive Subtitle

Brief introduction paragraph explaining the topic's importance and scope.

---

## 1. 📄 PRIMARY SECTION

Content explaining the primary concept...

### Subsection Name

Additional details in subsection...

---

## 2. 🔧 SECONDARY SECTION

Content explaining secondary concepts...

### Subsection Name

Additional details...

---

## 3. 📋 ADDITIONAL SECTION

Content for additional information...

**Key Points**:
- Point 1
- Point 2

---

## 4. 🔗 REFERENCES

- External link 1
- External link 2
- Related documentation
```

**Key Differences from SKILL.md**:
- NO YAML frontmatter
- H1 MUST have subtitle
- All H2 sections numbered
- All H2 sections ALL CAPS with emoji
- H3 subsections use Title Case (no numbers, no emoji)

---

## Spec File Template

**Location**: `specs/**/*.md`
**Enforcement**: Loose (suggestions only)
**Frontmatter**: NONE (not recommended)

```markdown
# Feature Name - Specification

**Status**: Draft | In Progress | Complete
**Priority**: HIGH | MEDIUM | LOW
**Target**: Sprint X | Q2 2025

Brief introduction explaining the feature...

---

## Problem Statement

Description of the problem this feature solves...

---

## Proposed Solution

Detailed explanation of the solution...

### Approach

Technical approach details...

---

## Implementation Plan

1. Phase 1 description
2. Phase 2 description
3. Phase 3 description

---

## Technical Details

### Architecture

Architecture description...

### Dependencies

- Dependency 1
- Dependency 2

---

## Testing Strategy

Testing approach...

---

## Rollout Plan

Deployment strategy...
```

**Key Differences**:
- Very flexible structure (no strict requirements)
- No frontmatter (use inline metadata instead)
- Suggestions only (never blocking)

---

## README.md Template

**Location**: Any directory
**Enforcement**: Flexible (universal rules only)
**Frontmatter**: Not required

```markdown
# Project/Directory Name

Brief description of what this directory contains...

## Contents

- `subdirectory1/` - Description
- `subdirectory2/` - Description
- `important_file.ext` - Description

## Usage

How to use the contents of this directory...

## Related Documentation

- Link to related docs
- Link to more details
```

---

## Section Order Requirements

### SKILL.md (Strict Order)

**Required sections in order**:
1. WHEN TO USE
2. HOW IT WORKS
3. INPUTS (optional - only if skill takes parameters)
4. WORKFLOW
5. RULES
6. SUCCESS CRITERIA
7. INTEGRATION POINTS
8. QUICK REFERENCE

### Command (Strict Order)

**Required sections in order**:
1. INPUTS
2. WORKFLOW
3. OUTPUTS
4. CONSTRAINTS

### Knowledge (Numbered, Flexible Content)

**Requirements**:
- All H2 sections must be numbered
- All H2 sections must be ALL CAPS
- Section content is flexible (no required sections)

### Spec (Flexible)

**Requirements**:
- No strict section requirements
- Use sections that make sense for the spec

---

## H2 Emoji Standards

### SKILL.md Emoji Map

```
WHEN TO USE           → 🎯
HOW IT WORKS          → 🛠️
INPUTS                → 📋
WORKFLOW              → 🚀
RULES                 → 📋
SUCCESS CRITERIA      → 🎓
INTEGRATION POINTS    → 🔗
QUICK REFERENCE       → 🎯
TROUBLESHOOTING       → 🔧
```

### Command Emoji Map

```
INPUTS                → 📋
WORKFLOW              → 🚀
OUTPUTS               → 📊
CONSTRAINTS           → ⚠️
```

### Knowledge Emoji Map

```
Use relevant emoji for each section:
📄 Document/Content
🔧 Technical/Tools
📋 Lists/Requirements
🔗 Links/References
⚠️  Warnings/Cautions
💡 Tips/Best Practices
📊 Data/Statistics
🎯 Goals/Objectives
```

---

## Quick Validation Checklist

### SKILL.md Checklist

- [ ] Has YAML frontmatter with name, description, allowed-tools
- [ ] H1 has subtitle format
- [ ] All 8 required sections present in correct order
- [ ] All H2 sections numbered + emoji + ALL CAPS
- [ ] RULES section has ALWAYS/NEVER/ESCALATE IF structure
- [ ] Has `---` separators between all H2 sections

### Command Checklist

- [ ] Has YAML frontmatter with description, argument-hint, allowed-tools
- [ ] H1 does NOT have subtitle
- [ ] All 4 required sections present in correct order
- [ ] INPUTS split into Required/Optional subsections
- [ ] All H2 sections numbered + emoji + ALL CAPS
- [ ] Has `---` separators between all H2 sections

### Knowledge Checklist

- [ ] NO YAML frontmatter
- [ ] H1 has subtitle format
- [ ] All H2 sections numbered
- [ ] All H2 sections with emoji + ALL CAPS
- [ ] H3 subsections in Title Case (no numbers, no emoji)
- [ ] Has `---` separators between all H2 sections

### Spec Checklist

- [ ] NO YAML frontmatter (use inline metadata)
- [ ] Brief introduction paragraph
- [ ] Sections appropriate for spec content
- [ ] Flexible structure (no strict requirements)
