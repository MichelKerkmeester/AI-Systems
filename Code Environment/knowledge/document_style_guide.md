# Document Style Guide - Markdown Formatting Standards

Canonical documentation format for all project documents. Follow these conventions to ensure documentation remains accessible, maintainable, and professional. All documents must start with a brief description and use numbered H2 sections with emoji and ALL CAPS titles.

#### 📋 TABLE OF CONTENTS

1. [📄 DOCUMENT STRUCTURE STANDARDS](#1--document-structure-standards)
2. [📝 FILE NAMING CONVENTIONS](#2--file-naming-conventions)
3. [🔤 HEADER HIERARCHY AND FORMATTING](#3--header-hierarchy-and-formatting)
4. [🎨 VISUAL ELEMENTS AND EMOJI USAGE](#4--visual-elements-and-emoji-usage)
5. [💻 CODE FORMATTING STANDARDS](#5--code-formatting-standards)
6. [📊 TABLES AND LISTS](#6--tables-and-lists)
7. [✍️ WRITING STYLE GUIDELINES](#7-️-writing-style-guidelines)
8. [📚 DOCUMENT TYPE SPECIFICATIONS](#8--document-type-specifications)

---

## 1. 📄 DOCUMENT STRUCTURE STANDARDS

### Standard Layout Template

Every document follows this consistent structure:

```markdown
## Title - Descriptive Subtitle

Brief introduction paragraph explaining the document's purpose and value.

---

## 1. 🧭 FIRST SECTION

Content here...

---

## 2. 🛠️ SECOND SECTION

Content here...
```

### Required Elements

| Element | Position | Purpose | Required |
|---------|----------|---------|----------|
| H1 with subtitle | Line 1 | Document title and context | ✅ Yes |
| Brief introduction | After H1 | Purpose and value proposition | ✅ Yes |
| Separator (`---`) | Before each H2 | Visual section breaks | ✅ Yes |
| Numbered H2 | Major sections | Structured content organization | ✅ Yes |
| H3 subsections | Within H2 blocks | Detailed breakdowns | ⚠️ Optional |

### Section Separator Usage

**When to use `---` separators:**
- Before each numbered H2 section
- Creates visual breathing room
- Aids in quick scanning

**Example:**
```markdown
Brief introduction here.

---

## 1. 📄 FIRST SECTION
```

---

## 2. 📝 FILE NAMING CONVENTIONS

### Markdown File Naming Rules

**Standard format: lowercase snake_case**

| Pattern | Example | Valid |
|---------|---------|-------|
| snake_case | `document_style_guide.md` | ✅ Correct |
| kebab-case | `document-style-guide.md` | ❌ Wrong |
| camelCase | `documentStyleGuide.md` | ❌ Wrong |
| PascalCase | `DocumentStyleGuide.md` | ❌ Wrong |
| ALL CAPS | `DOCUMENT.md` | ❌ Wrong (except exceptions) |

### Naming Exceptions

**Only two exceptions allowed:**

1. **README.md** - Documentation root files
   - Example: `/README.md`, `/docs/README.md`

2. **SKILL.md** - Claude Code skill definition files
   - Example: `.claude/skills/my-skill/SKILL.md`

### Good vs Bad Examples

```
✅ CORRECT:
- README.md (exception allowed)
- .claude/skills/my-skill/SKILL.md (exception allowed)
- document_style_guide.md
- knowledge_base.md
- save_context_skill.md
- api_reference.md
- animation_strategy.md

❌ WRONG:
- SUMMARY.md (use summary.md)
- CHANGELOG.md (use changelog.md)
- DocumentStyleGuide.md (use document_style_guide.md)
- document-style-guide.md (use underscores, not hyphens)
- documentStyleGuide.md (use snake_case, not camelCase)
- DOC.md (use descriptive name like documentation.md)
```

### Naming Best Practices

- Use **descriptive names**: `animation_libraries.md` > `anim.md`
- Separate **words with underscores**: `document_style_guide.md`
- Keep names **concise but clear**: 2-4 words ideal
- Avoid **abbreviations** unless universally understood (API, HTTP, etc.)

---

## 3. 🔤 HEADER HIERARCHY AND FORMATTING

### Header Level Usage

| Level | Format | Example | When to Use |
|-------|--------|---------|-------------|
| **H1** | `# Title - Subtitle` | `# Animation Strategy - Guidelines` | Document title only (one per file) |
| **H2** | `## N. 🎯 ALL CAPS` | `## 1. 📄 DESCRIPTION` | Major sections (always numbered) |
| **H3** | `### Title Case` | `### Primary Order` | Subsections within H2 |
| **H4** | `#### 📋 TABLE...` | `#### 📋 TABLE OF CONTENTS` | TABLE OF CONTENTS only |
| **H5-H6** | Avoid | - | Reserved for rare exceptions |

### H1 Title Format

**Structure:** `# Main Title - Descriptive Subtitle`

**Examples:**
```markdown
## Animation Strategy - Project Animation Guidelines
## Code Standards - Naming Conventions
## Document Style Guide - Format Specification
```

**Requirements:**
- One H1 per document
- Always include subtitle after hyphen
- Subtitle explains document purpose or scope

### H2 Section Format

**Structure:** `## Number. Emoji ALL CAPS TITLE`

**Examples:**
```markdown
## 1. 📄 DOCUMENT STRUCTURE
## 2. 🧭 DECISION FRAMEWORK
## 3. 🛠️ IMPLEMENTATION GUIDE
```

**Requirements:**
- Sequential numbering (1, 2, 3...)
- One emoji after number (one space before title)
- Title in ALL CAPS
- Never skip numbers

### H3 Subsection Format

**Structure:** `### Title Case (No Number, No Emoji)`

**Examples:**
```markdown
### Standard Layout
### Primary Decision Order
### Configuration Comments
```

**Requirements:**
- Title Case format
- No numbering
- No emoji
- Used for detailed breakdowns within H2 sections

### Header Numbering Guidelines

**Sequential numbering:**
```markdown
## 1. 🎯 FIRST SECTION
## 2. 🛠️ SECOND SECTION
## 3. 📋 THIRD SECTION
```

**Sub-numbering (only for multi-phase processes):**
```markdown
## 1. 🎯 PLANNING
### 1.1. Research Phase
### 1.2. Design Phase

## 2. 🛠️ IMPLEMENTATION
### 2.1. Setup Phase
### 2.2. Development Phase
```

**When to use sub-numbering:**
- Multi-phase processes with clear sequential dependencies
- Complex workflows requiring explicit ordering
- Generally avoid unless truly necessary

---

## 4. 🎨 VISUAL ELEMENTS AND EMOJI USAGE

### Standard Emoji Assignments

| Emoji | Purpose | Common Section Names |
|-------|---------|---------------------|
| 🎯 | Objective/Goal | OBJECTIVE, PURPOSE, WHEN TO USE |
| 📋 | Lists/Forms | TABLE OF CONTENTS, RULES, INPUTS |
| 🧭 | Navigation/Priority | DECISION FRAMEWORK, NAVIGATION |
| 🛠️ | Tools/Implementation | HOW IT WORKS, IMPLEMENTATION, WORKFLOW |
| ✅ | Best Practices/Success | SUCCESS CRITERIA, BEST PRACTICES |
| ❌ | Anti-patterns/Errors | ANTI-PATTERNS, COMMON MISTAKES |
| 🔒 | Security/Quality | VALIDATION, QUALITY GATES |
| 📊 | Data/Metrics | PERFORMANCE, METRICS, ANALYTICS |
| 🚀 | Quick Start | QUICK START, GETTING STARTED |
| 💬 | Comments/Discussion | COMMENTING RULES, GUIDELINES |
| 🧾 | Templates/Reference | TEMPLATES, REFERENCE |
| 🧩 | Components/Parts | COMPONENTS, ARCHITECTURE |
| ⚙️ | Configuration | CONFIGURATION, SETTINGS, SETUP |
| 🔍 | Search/Analysis | TROUBLESHOOTING, DEBUGGING |
| 🏎️ | Speed/Quick Ref | QUICK REFERENCE, SHORTCUTS |

### Visual Markers in Content

**Use these markers for inline emphasis:**

```markdown
✅ Good practice - Do this
❌ Bad practice - Avoid this
□ Unchecked checkbox item
✓ Checked checkbox item
⚠️ Warning or caution
```

**Example usage:**
```markdown
**Naming conventions:**
- ✅ Use snake_case: `user_name`
- ❌ Avoid camelCase: `userName`

**Pre-deployment checklist:**
- □ Tests passing
- □ Documentation updated
- ✓ Code reviewed
```

---

## 5. 💻 CODE FORMATTING STANDARDS

### Code Block Syntax

**Always specify language for syntax highlighting:**

```javascript
// JavaScript example
function example_function() {
  // Use consistent indentation (2 spaces)
  return true;
}
```

```python
## Python example
def example_function():
    # Use consistent indentation (4 spaces for Python)
    return True
```

```css
/* CSS example */
.component {
  /* Use consistent indentation (2 spaces) */
  margin: 0;
  padding: 1rem;
}
```

### Good vs Bad Code Examples

**Format comparison examples clearly:**

```javascript
// ✅ CORRECT
const user_name = 'John';
const is_active = true;

function get_user_data() {
  return { user_name, is_active };
}

// ❌ WRONG
const userName = 'John';           // camelCase
const isActive = true;

function getUserData() {           // camelCase
  return { userName, isActive };
}
```

### Inline Code Usage

**Use backticks for:**
- Variable names: `user_name`
- Function names: `get_data()`
- File paths: `src/components/file.js`
- Commands: `npm run build`
- HTTP methods: `GET`, `POST`
- Status codes: `404`, `200`

**Example:**
```markdown
Call the `initialize_component()` function from `src/init.js` using `npm run start`.
```

### File and Component Headers

**JavaScript/Python header format:**
```javascript
// ───────────────────────────────────────────────────────────────
// COMPONENT: NAME
// ───────────────────────────────────────────────────────────────
```

**CSS header format:**
```css
/* ───────────────────────────────────────────────────────────────
   COMPONENT - NAME
─────────────────────────────────────────────────────────────── */
```

---

## 6. 📊 TABLES AND LISTS

### Table Formatting

**Standard table structure:**

```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data 1   | Data 2   | Data 3   |
| Data 4   | Data 5   | Data 6   |
```

**Table best practices:**
- Always include header row
- Align pipes consistently
- Keep columns readable width (<30 characters ideal)
- Use tables for structured comparisons
- Use lists for sequential information

### List Types and Usage

**Bullet points** - Unordered information:
```markdown
- First point
- Second point
- Third point
```

**Numbered lists** - Sequential steps or priority:
```markdown
1. First step
2. Second step
3. Third step
```

**Nested lists** - Hierarchical information (indent with 2 spaces):
```markdown
- Main point
  - Nested detail
  - Another detail
- Second main point
  - Sub-detail
```

**Checkbox lists** - Action items:
```markdown
- [ ] Uncompleted task
- [x] Completed task
- [ ] Another task
```

### Decision Trees and Flowcharts

**Use ASCII tree format for decision flows:**

```
Need animation?
├─> Can CSS express it (transform/opacity/clip)?
│   └─> Use CSS
└─> Requires sequencing/stagger/scroll logic?
    └─> Use Motion.dev
```

**Format rules:**
- Use `├─>` for branches with siblings
- Use `└─>` for final branch
- Use `│` for vertical continuation
- Indent consistently (4 spaces per level)

---

## 7. ✍️ WRITING STYLE GUIDELINES

### Core Principles

| Principle | Description | Example |
|-----------|-------------|---------|
| **Concise** | Get to the point quickly | "Use REM units" not "You should consider using REM units for measurements" |
| **Technical** | Use precise terminology | "HTTP 404 error" not "page not found thing" |
| **Actionable** | Focus on what to do | "Set timeout to 3000ms" not "The timeout should probably be around 3 seconds" |
| **Present tense** | Write in active voice | "Function returns data" not "Function will return data" |
| **Imperative** | Use commands for instructions | "Install dependencies" not "You should install dependencies" |

### Sentence Structure Comparison

```markdown
✅ GOOD:
- "Use REM units for all measurements."
- "Define the mandatory code conventions."
- "Apply transformations before rendering."

❌ BAD:
- "You should be using REM units when you're measuring things."
- "This document will help define what the mandatory conventions are."
- "You'll want to make sure transformations are applied before the rendering happens."
```

### Technical Writing Rules

**Document structure:**
1. **Start with outcome** - What will be achieved
2. **Provide context** - Only when necessary for understanding
3. **Use examples** - Clarify complex concepts with code
4. **Include rationale** - Explain important decisions
5. **Link related docs** - Cross-reference for deeper dives

**Example:**
```markdown
## 1. 📄 CACHING STRATEGY

Cache API responses for 5 minutes to reduce server load.

### Implementation
[Code example showing caching]

### Rationale
Five-minute cache window balances freshness with performance. Shorter windows
increase server load without meaningful data improvements.

See [performance_optimization.md](./performance_optimization.md) for metrics.
```

---

## 8. 📚 DOCUMENT TYPE SPECIFICATIONS

### Document Type Detection

Determine document type by file path:

| Type | Path Pattern | Enforcement | Purpose |
|------|--------------|-------------|---------|
| **SKILL.md** | `.claude/skills/*/SKILL.md` | Strict | AI-parseable skill definitions |
| **Command** | `.claude/commands/**/*.md` | Strict | Programmatic slash commands |
| **Knowledge** | `.claude/knowledge/*.md` | Moderate | Technical reference documentation |
| **Spec** | `specs/**/*.md` | Loose | Feature planning and tracking |
| **README** | `*/README.md` | Universal | Project documentation roots |

### SKILL.md Requirements (Strict Enforcement)

**Required structure:**

```markdown
---
name: skill-name
description: Brief description
allowed-tools: Tool1, Tool2, Tool3
---

## Skill Name - Descriptive Subtitle

Brief introduction paragraph...

---

## 1. 🎯 WHEN TO USE

[Triggering conditions and symptoms]

---

## 2. 🛠️ HOW IT WORKS

[Core principles and process overview]

---

## 3. 📋 INPUTS

[Required and optional inputs - ONLY if applicable]

---

## 4. 🚀 WORKFLOW

[Step-by-step implementation with examples]

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

[What constitutes successful application]

---

## 7. 🔗 INTEGRATION POINTS

**Pairs With**:
- `other-skill` - [How they work together]

---

## 8. 🏎️ QUICK REFERENCE

[Command examples and shortcuts]
```

**Strict rules:**
- ✅ YAML frontmatter MUST include: `name`, `description`, `allowed-tools`
- ✅ H1 MUST have subtitle: "Skill Name - Descriptive Subtitle"
- ✅ Sections MUST appear in exact order (1-8)
- ✅ Section 3 (INPUTS) optional - only if skill has configurable inputs
- ✅ All H2 sections MUST use format: `## N. 🎯 ALL CAPS TITLE`
- ✅ RULES section MUST have ALWAYS/NEVER/ESCALATE IF structure
- ❌ NEVER skip required sections (except INPUTS)
- ❌ NEVER change section order

**Reference:** `.claude/skills/git-commit/SKILL.md`

### Command Requirements (Strict Enforcement)

**Required structure:**

```markdown
---
description: What command does
argument-hint: [arg1] [arg2]
allowed-tools: Tool1, Tool2
---

## Command Name

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

**Strict rules:**
- ✅ YAML frontmatter MUST include: `description`, `argument-hint`, `allowed-tools`
- ✅ H1 MUST NOT have subtitle (just command name)
- ✅ Sections MUST appear in exact order (1-4)
- ✅ INPUTS section MUST separate Required vs Optional
- ✅ WORKFLOW section MUST use numbered steps
- ❌ NEVER omit any of the four sections
- ❌ NEVER add subtitle to H1

**Reference:** `.claude/commands/create/` directory

### Knowledge Requirements (Moderate Enforcement)

**Required structure:**

```markdown
## Topic - Descriptive Subtitle

Brief introduction paragraph explaining purpose and value.

---

## 1. 🧭 FIRST SECTION

Content with subsections as needed...

### Subsection Title

Content...

---

## 2. 🛠️ SECOND SECTION

Content continues...
```

**Moderate rules:**
- ✅ NO YAML frontmatter (knowledge files are pure content)
- ✅ H1 MUST have subtitle: "Topic - Descriptive Subtitle"
- ✅ MUST start with brief introduction paragraph
- ✅ All H2 sections MUST be numbered (1, 2, 3...)
- ✅ All H2 sections MUST use emoji + ALL CAPS format
- ✅ H3 subsections use Title Case (no numbers, no emoji)
- ✅ Use `---` separators between major sections
- ⚠️ Section order flexible (except description usually first)
- ⚠️ Number and types of sections flexible

**Reference:** `.claude/knowledge/code_standards.md`

### Spec Requirements (Loose Enforcement)

**Suggested structure:**

```markdown
## Feature Name - Spec

**Date**: YYYY-MM-DD
**Level**: 1/2/3
**Status**: draft/active/complete

Brief introduction...

---

## 🎯 Overview

[Content]

---

[Continue with flexible sections...]
```

**Loose rules:**
- ✅ NO YAML frontmatter
- ⚠️ H1 subtitle optional
- ⚠️ H2 sections MAY be numbered (not required)
- ⚠️ H2 sections MAY use emoji + ALL CAPS (not required)
- ⚠️ Section order flexible
- ⚠️ Metadata at top recommended (Date, Level, Status)
- ⚠️ Allow informal structure for rapid iteration

**Rationale:** Specs evolve quickly. Strict formatting would slow iteration. Focus on content over structure.

**Reference:** `specs/*/spec.md` files

### Enforcement Level Comparison

| Rule | Universal | SKILL.md | Command | Knowledge | Spec |
|------|-----------|----------|---------|-----------|------|
| **Filename** | snake_case | ✅ Required | ✅ Required | ✅ Required | ✅ Required |
| **YAML Frontmatter** | - | ✅ Required | ✅ Required | ❌ Forbidden | ❌ Forbidden |
| **H1 Subtitle** | - | ✅ Required | ❌ Forbidden | ✅ Required | ⚠️ Optional |
| **Numbered H2** | - | ✅ Required | ✅ Required | ✅ Required | ⚠️ Optional |
| **H2 ALL CAPS** | - | ✅ Required | ✅ Required | ✅ Required | ⚠️ Optional |
| **H2 Emoji** | - | ✅ Required | ✅ Required | ✅ Required | ⚠️ Optional |
| **Section Order** | - | ✅ Strict | ✅ Strict | ⚠️ Flexible | ⚠️ Flexible |
| **Separators** | ⚠️ Recommended | ✅ Required | ✅ Required | ✅ Required | ⚠️ Recommended |
| **Code Blocks** | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| **Writing Style** | ✅ Yes | ✅ Strict | ✅ Strict | ✅ Moderate | ⚠️ Flexible |

---

**Core principle:** Apply these standards to maintain professional, consistent documentation. Use stricter enforcement for SKILL.md and commands where structure enables functionality, and more flexible guidance for knowledge and specs where content clarity matters most.
