# Document Style Guide

Defines the canonical documentation format for all documents. 

Follow these conventions to ensure documentation remains accessible, maintainable, and professional. All documents must start with a brief description and use numbered H2 sections with emoji and ALL CAPS titles.

---

## 1. 📄 DOCUMENT STRUCTURE

### Standard Layout

```markdown
# Title - Descriptive Subtitle

Brief introduction paragraph explaining the document's purpose and value.

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
- **Exception**: ✅ `README.md` is the ONLY allowed ALL CAPS filename
- **Use descriptive names**: `animation_libraries.md` instead of `anim.md`
- **Separate words with underscores**: `document_style_guide.md` not `documentstyleguide.md`

**Examples:**
```
✅ CORRECT:
- README.md (exception allowed)
- document_style_guide.md
- knowledge_base.md
- save_context_skill.md
- api_reference.md

❌ WRONG:
- SUMMARY.md
- CHANGELOG.md
- DocumentStyleGuide.md
- document-style-guide.md
- documentStyleGuide.md
```

---

## 2. 📝 HEADERS & HIERARCHY

| Level | Format | Example | Usage |
|-------|--------|---------|-------|
| H1 | Title - Subtitle | `# Animation Libraries - Decision Framework` | Document title only |
| H2 | Number + Emoji + ALL CAPS TITLE | `## 1. 📄 DESCRIPTION` | Major sections |
| H3 | Title Case | `### Primary Order` | Subsections |
| H4-H6 | Avoid | - | Reserve for exceptional cases |

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

**Remember**: Apply these standards to maintain professional, consistent documentation across the project.