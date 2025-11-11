# Document Style Guide

Defines the canonical documentation format for all documents.

Follow these conventions to ensure documentation remains accessible, maintainable, and professional. All documents must start with a brief description and use numbered H2 sections with emoji and ALL CAPS titles.

#### 📋 TABLE OF CONTENTS

1. [📄 DOCUMENT STRUCTURE](#1--document-structure)
2. [📝 HEADERS & HIERARCHY](#2--headers--hierarchy)
3. [🎨 VISUAL ELEMENTS](#3--visual-elements)
4. [💻 CODE FORMATTING](#4--code-formatting)
5. [📊 TABLES & LISTS](#5--tables--lists)
6. [✍️ WRITING STYLE](#6-️-writing-style)
7. [📐 TEMPLATES](#7--templates)
8. [📚 DOCUMENT TYPE SPECIFICATIONS](#8--document-type-specifications)

---

## 1. 📄 DOCUMENT STRUCTURE

### Standard Layout

```markdown
# Title - Descriptive Subtitle

Brief introduction paragraph explaining the document's purpose and value.

#### 📋 TABLE OF CONTENTS

1. [SECTION ONE](#1--section-one)
2. [SECTION TWO](#2--section-two)

---

## 1. 🧭 FIRST SECTION

Content here...

---

## 2. 🛠️ SECOND SECTION

Content here...
```

### Section Separators
- Use three dashes (`---`) on its own line between major sections
- Creates visual breathing room without cluttering
- Place before and after section breaks

### File Naming Convention
**Markdown files MUST follow these naming rules:**
- **Use lowercase snake_case**: `document_name.md`, `api_reference.md`, `user_guide.md`
- **Never use ALL CAPS**: ❌ `SUMMARY.md`, ❌ `CHANGELOG.md`, ❌ `LICENSE.md`
- **Exceptions**:
  - ✅ `README.md` (documentation root files)
  - ✅ `SKILL.md` (Claude Code skill definition files in `.claude/skills/*/`)
- **Use descriptive names**: `animation_libraries.md` instead of `anim.md`
- **Separate words with underscores**: `document_style_guide.md` not `documentstyleguide.md`

**Examples:**
```
✅ CORRECT:
- README.md (exception allowed)
- .claude/skills/my-skill/SKILL.md (exception allowed)
- document_style_guide.md
- knowledge_base.md
- save_context_skill.md
- api_reference.md

❌ WRONG:
- SUMMARY.md (use summary.md)
- CHANGELOG.md (use changelog.md)
- DocumentStyleGuide.md (use document_style_guide.md)
- document-style-guide.md (use underscores, not hyphens)
- documentStyleGuide.md (use snake_case, not camelCase)
```

---

## 2. 📝 HEADERS & HIERARCHY

| Level | Format | Example | Usage |
|-------|--------|---------|-------|
| H1 | Title - Subtitle | `# Animation Libraries - Decision Framework` | Document title only |
| H2 | Number + Emoji + ALL CAPS TITLE | `## 1. 📄 DESCRIPTION` | Major sections |
| H3 | Title Case | `### Primary Order` | Subsections |
| H4 | Table of Contents only | `#### 📋 TABLE OF CONTENTS` | TABLE OF CONTENTS header |
| H5-H6 | Avoid | - | Reserve for exceptional cases |

**Header Numbering Rules:**
- All H2 sections MUST have numbers (1, 2, 3, etc.)
- Use sub-numbers (1.1, 1.2) ONLY for multi-phase processes
- Keep section titles in ALL CAPS for H2 headers
- Always include relevant emoji after the number (one space between emoji and title)
- Subsections (H3) use Title Case without numbers

---

## 3. 🎨 VISUAL ELEMENTS

### Emoji Usage
Standard emoji assignments for consistency:

| Emoji | Purpose | Common Usage |
|-------|---------|--------------|
| 🎯 | Objective/Goal | Section headers |
| 📋 | Table of Contents | TOC header |
| 🧭 | Navigation/Priority | Framework sections |
| 🛠️ | Tools/Implementation | Technical sections |
| ✅ | Best Practices/Done | Validation sections |
| ❌ | Anti-patterns/Wrong | Bad examples |
| 🔒 | Security/Quality | Gate sections |
| 📊 | Data/Performance | Metrics sections |
| 🚀 | Quick Start/Migration | Getting started |
| 💬 | Comments/Discussion | Commentary sections |
| 🧾 | Templates/Reference | Documentation sections |
| 🧩 | Components/Parts | Architecture sections |
| ⚙️ | Configuration/Settings | Setup sections |
| 🔍 | Search/Analysis | Investigation sections |

### Visual Markers
```markdown
✅ Good practice
❌ Bad practice
□ Checkbox item
```

---

## 4. 💻 CODE FORMATTING

### Code Blocks
```javascript
// Always specify language for syntax highlighting
function example_function() {
  // Use consistent indentation (2 spaces)
  return true;
}
```

### Good vs Bad Examples
```javascript
// ✅ CORRECT
const user_name = 'John';

// ❌ WRONG
const userName = 'John';
```

### Inline Code
- Use backticks for `inline_code`
- Include file paths: `src/component/file.js`
- Mark commands: `npm run build`

### Section Headers in Code
```javascript
// ───────────────────────────────────────────────────────────────
// COMPONENT: NAME
// ───────────────────────────────────────────────────────────────
```

---

## 5. 📊 TABLES & LISTS

### Tables
```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data 1 | Data 2 | Data 3 |
```
- Always include header row
- Use alignment pipes consistently
- Keep columns readable width

### Lists
- **Bullet points**: For unordered information
- **Numbered lists**: For sequential steps
- **Nested lists**: Indent with 2 spaces
  - Like this nested item
  - And this one

### Quick Decision Trees
```
Need Animation?
├─> Can Webflow handle it? -> Use Webflow
├─> Simple animation? -> Use Motion.dev
└─> Complex (3D/morphing)? -> Use GSAP
```

---

## 6. ✍️ WRITING STYLE

### Core Principles
- **Concise**: Get to the point quickly
- **Technical**: Use precise terminology
- **Actionable**: Focus on what to do
- **Present tense**: Write in active voice
- **Imperative mood**: Use commands for instructions

### Sentence Structure
```markdown
✅ "Use REM units for all measurements."
❌ "You should be using REM units when you're measuring things."

✅ "Define the mandatory code conventions."
❌ "This document will help define what the mandatory conventions are."
```

### Technical Writing Rules
1. Start with the outcome or objective
2. Provide context only when necessary
3. Use examples to clarify complex concepts
4. Include rationale for important decisions
5. Link to related documentation

---

## 7. 📐 TEMPLATES

### Knowledge Article Template
```markdown
# [Topic] - [Descriptive Subtitle]

[Brief introduction explaining purpose and value]

---

## 1. 📄 FIRST SECTION

[Content for first section]

---

## 2. 🧭 SECOND SECTION

[Content for second section]

---

[Continue sections...]
```

### Section Patterns
- **Description**: Define purpose and goals
- **Core Concepts**: Explain fundamental ideas
- **Implementation**: Show how to apply
- **Examples**: Provide concrete usage
- **Best Practices**: List do's and don'ts
- **Troubleshooting**: Common issues and solutions
- **Reference**: Quick lookup information

---

## 8. 📚 DOCUMENT TYPE SPECIFICATIONS

Different document types serve different purposes and require different structural requirements. This section defines type-specific rules that extend the universal standards above.

### Document Type Detection

Determine document type by file path:

| Type | Path Pattern | Enforcement Level |
|------|--------------|-------------------|
| **SKILL.md** | `.claude/skills/*/SKILL.md` | Strict |
| **Command** | `.claude/commands/**/*.md` | Strict |
| **Knowledge** | `.claude/knowledge/*.md` | Moderate |
| **Spec** | `specs/**/*.md` | Loose |
| **README** | `*/README.md` | Universal rules only |

### SKILL.md Requirements (Strict)

Skills require exact structure for AI parsing and consistent behavior.

**Required Elements**:
```markdown
---
name: skill-name
description: Brief description
allowed-tools: Tool1, Tool2, Tool3
---

# Skill Name - Descriptive Subtitle

Brief introduction paragraph...

---

## 1. 🎯 WHEN TO USE

[Content describing triggering conditions and symptoms]

---

## 2. 🛠️ HOW IT WORKS

[Content explaining core principles and process overview]

---

## 3. 📋 INPUTS

[Content specifying required and optional inputs - ONLY if applicable]

---

## 4. 🚀 WORKFLOW

[Content showing step-by-step implementation with examples]

---

## 5. 📋 RULES

**ALWAYS**:
- [Required behaviors]

**NEVER**:
- [Forbidden behaviors]

**ESCALATE IF**:
- [Conditions requiring user intervention]

---

## 6. 🎓 SUCCESS CRITERIA

[Content defining what constitutes successful application]

---

## 7. 🔗 INTEGRATION POINTS

**Pairs With**:
- `other-skill` - [How they work together]

---

## 8. 🎯 QUICK REFERENCE

[Content providing command examples and shortcuts]
```

**Strict Rules**:
- ✅ YAML frontmatter MUST include: `name`, `description`, `allowed-tools`
- ✅ H1 MUST have subtitle format: "Skill Name - Descriptive Subtitle"
- ✅ Sections MUST appear in exact order (1-8 as shown above)
- ✅ Section 3 (INPUTS) is optional - only include if skill has configurable inputs
- ✅ All H2 sections MUST use format: `## N. 🎯 ALL CAPS TITLE`
- ✅ RULES section MUST have ALWAYS/NEVER/ESCALATE IF structure
- ✅ Integration points MUST document pairs-with relationships
- ❌ NEVER skip required sections (except INPUTS)
- ❌ NEVER change section order

**Example Reference**: See `.claude/skills/git-commit/SKILL.md` or `.claude/skills/save-context/SKILL.md`

### Command Requirements (Strict)

Commands are programmatic interfaces requiring clear contracts.

**Required Elements**:
```markdown
---
description: What command does
argument-hint: [arg1] [arg2]
allowed-tools: Tool1, Tool2
---

# Command Name

Brief introduction paragraph...

---

## 1. 📋 INPUTS

### Required Inputs
- `input_name`: Description

### Optional Inputs
- `input_name`: Description (default: value)

---

## 2. 🚀 WORKFLOW

1. Validation step
2. Processing step
3. Output step

---

## 3. 📊 OUTPUTS

Returns/creates/modifies description...

---

## 4. ⚠️ CONSTRAINTS

- Constraint 1
- Constraint 2
```

**Strict Rules**:
- ✅ YAML frontmatter MUST include: `description`, `argument-hint`, `allowed-tools`
- ✅ H1 MUST NOT have subtitle (just command name)
- ✅ Sections MUST appear in exact order (1-4 as shown above)
- ✅ All H2 sections MUST use format: `## N. 📋 ALL CAPS TITLE`
- ✅ INPUTS section MUST separate Required vs Optional
- ✅ WORKFLOW section MUST use numbered steps
- ✅ OUTPUTS section MUST specify what command produces
- ❌ NEVER omit any of the four sections
- ❌ NEVER add subtitle to H1

**Example Reference**: See `.claude/commands/create/` directory

### Knowledge Requirements (Moderate)

Knowledge files are technical documentation requiring consistency but allowing flexibility.

**Required Elements**:
```markdown
# Topic - Descriptive Subtitle

Brief introduction paragraph explaining purpose and value.

---

## 1. 🧭 FIRST SECTION

Content with subsections as needed...

### Subsection Title

Content...

---

## 2. 🛠️ SECOND SECTION

Content continues...

---

[Continue numbered sections...]
```

**Moderate Rules**:
- ✅ NO YAML frontmatter (knowledge files are pure content)
- ✅ H1 MUST have subtitle format: "Topic - Descriptive Subtitle"
- ✅ MUST start with brief introduction paragraph
- ✅ All H2 sections MUST be numbered (1, 2, 3...)
- ✅ All H2 sections MUST use emoji + ALL CAPS format
- ✅ H3 subsections use Title Case (no numbers, no emoji)
- ✅ `---` separators between major sections
- ⚠️ Section order flexible (except description usually first)
- ⚠️ Number and types of sections flexible based on content
- ⚠️ H3 subsection structure flexible

**Example Reference**: See `.claude/knowledge/code_standards.md` or `.claude/knowledge/debugging.md`

### Spec Requirements (Loose)

Spec files need flexibility for rapid iteration and evolving designs.

**Suggested Elements**:
```markdown
# Feature Name - Spec

**Date**: YYYY-MM-DD
**Version**: X.X
**Priority**: HIGH/MEDIUM/LOW

Brief introduction...

---

## 🎯 Overview

[Content]

---

[Continue with flexible sections...]
```

**Loose Rules**:
- ✅ NO YAML frontmatter
- ⚠️ H1 subtitle optional (can be "Feature Name" or "Feature Name - Spec")
- ⚠️ H2 sections MAY be numbered (but not required)
- ⚠️ H2 sections MAY use emoji + ALL CAPS (but not required)
- ⚠️ Section order flexible based on spec type (spec.md, plan.md, tasks.md)
- ⚠️ Metadata at top recommended for plans (Date, Version, Priority)
- ✅ `---` separators recommended between major sections
- ⚠️ Allow informal structure for rapid iteration

**Rationale**: Specs evolve quickly during planning. Strict formatting would slow down iteration. Focus on content over structure.

**Example Reference**: See `specs/018-adaptive-page-loader/plan.md`

### Universal vs Type-Specific Rules

| Rule | Universal | SKILL.md | Command | Knowledge | Spec |
|------|-----------|----------|---------|-----------|------|
| **Filename** | snake_case | ✅ | ✅ | ✅ | ✅ |
| **YAML Frontmatter** | - | Required | Required | Forbidden | Forbidden |
| **H1 Subtitle** | - | Required | Forbidden | Required | Optional |
| **Numbered H2** | - | Required | Required | Required | Optional |
| **H2 ALL CAPS** | - | Required | Required | Required | Optional |
| **H2 Emoji** | - | Required | Required | Required | Optional |
| **Section Order** | - | Strict | Strict | Flexible | Flexible |
| **Separators** | Recommended | Required | Required | Required | Recommended |
| **Code Blocks** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Writing Style** | ✅ | ✅ | ✅ | ✅ | Flexible |

### When to Use Each Type

**Choose SKILL.md when**:
- Defining reusable AI behaviors
- Creating specialized workflows
- Integrating with Claude Code tools
- Need consistent structure for parsing

**Choose Command when**:
- Creating slash commands (`/command`)
- Defining programmatic interfaces
- Need clear input/output contracts
- Automating specific tasks

**Choose Knowledge when**:
- Documenting standards and conventions
- Creating reference materials
- Explaining concepts and patterns
- Building technical documentation

**Choose Spec when**:
- Planning feature implementations
- Defining requirements
- Tracking tasks and progress
- Rapid iteration documentation

---

**Remember**: Apply these standards to maintain professional, consistent documentation across the project. Use stricter enforcement for SKILL.md and commands where structure enables functionality, and more flexible guidance for knowledge and specs where content clarity matters most.