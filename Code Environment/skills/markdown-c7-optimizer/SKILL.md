---
name: markdown-c7-optimizer
description: Complete document quality pipeline with structure enforcement, content optimization (c7score), and style guide compliance. Unified skill replacing markdown-enforcer and llm-docs-optimizer.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
version: 2.0.0
---

# Markdown Optimizer - Complete Document Quality Pipeline

Enforce markdown structure, optimize content for AI assistants, and validate quality compliance through a unified 3-phase pipeline: Enforcement → Optimization → Validation.

**Core principle**: Structure first, then content, then quality = documentation that is valid, AI-friendly, and maintainable.

---

## 1. 🎯 WHEN TO USE

### Navigation Guide

**This file (SKILL.md)**: Essential overview and rules for using markdown-c7-optimizer

**Reference Files** (detailed documentation):
- [core_standards.md](./references/core_standards.md) - Filename conventions, document types, structural violations
- [workflows.md](./references/workflows.md) - Four execution modes, hook integration, enforcement patterns
- [optimization.md](./references/optimization.md) - C7score metrics and 16 transformation patterns
- [validation.md](./references/validation.md) - Quality scoring, gates, and improvement recommendations
- [quick_reference.md](./references/quick_reference.md) - One-page cheat sheet

**Assets** (templates and output resources):
- [frontmatter_templates.md](./assets/frontmatter_templates.md) - YAML frontmatter templates
- [structure_templates.md](./assets/structure_templates.md) - Document structure examples
- [llmstxt_templates.md](./assets/llmstxt_templates.md) - Example llms.txt files

### Automatic Enforcement

Enforcement runs automatically via hooks:

**PostToolUse Hook** - After Write/Edit/NotebookEdit operations:
- Auto-corrects filename violations (ALL CAPS → lowercase, hyphens → underscores)
- Logs corrections, never blocks execution
- Preserves exceptions (README.md, SKILL.md)

**UserPromptSubmit Hook** - Before AI processes prompts:
- Auto-fixes safe violations (separators, H2 case, emoji)
- Blocks execution on critical violations (missing frontmatter, wrong section order)
- Provides specific fix suggestions with line numbers

See [workflows.md](./references/workflows.md) for complete hook integration details.

### Manual Optimization

Run manual optimization when:

**Content Quality Improvement**:
- README needs optimization for AI assistants (target: c7score 85+)
- Creating critical documentation (specs, knowledge, skills)
- Generating llms.txt for LLM navigation
- Quality assurance before sharing

**Quality Validation**:
- Pre-release quality checks
- Compliance audits across structure, content, and style
- Documentation review (target: 85+ overall score)

See [workflows.md](./references/workflows.md) for workflow examples.

### When NOT to Use

**Do not use for**:
- Non-markdown files (only `.md` supported)
- Simple typo fixes (use Edit tool directly)
- Internal notes or drafts
- Auto-generated API docs
- Spec files during active development (loose enforcement by design)

---

## 2. 🛠️ HOW IT WORKS

### Three-Phase Pipeline

```
INPUT: Markdown File
       ↓
PHASE 1: ENFORCEMENT (Structure Validation)
       ├─ Filename conventions
       ├─ Document structure (frontmatter, headings, sections)
       ├─ Safe violations → Auto-fix
       └─ Critical violations → Block with fix suggestions
       ↓
PHASE 2: OPTIMIZATION (Content Enhancement)
       ├─ Document type detection
       ├─ c7score analysis (current state)
       ├─ Apply transformation patterns (16 patterns)
       └─ Optional: Generate llms.txt
       ↓
PHASE 3: VALIDATION (Quality Scoring)
       ├─ Structure: 0-100 (validity and format)
       ├─ C7Score: 0-100 (AI-friendliness)
       ├─ Style: 0-100 (style guide compliance)
       └─ Overall: Weighted average
       ↓
OUTPUT: Quality Report + Approved Document
```

### Execution Modes

**Mode 1: Full Pipeline** - All three phases (recommended for critical docs)
```bash
markdown-c7-optimizer --full-pipeline document.md
# Target: 85+ overall score
```

**Mode 2: Enforcement Only** - Automatic via hooks (structure validation)
```bash
# Runs automatically via PostToolUse and UserPromptSubmit hooks
# Result: Structurally valid markdown
```

**Mode 3: Optimization Only** - Content improvement (c7score focus)
```bash
markdown-c7-optimizer --optimize document.md
# Target: 80+ c7score
```

**Mode 4: Validation Only** - Quality audit (no modifications)
```bash
markdown-c7-optimizer --validate document.md
# Output: Triple scoring report
```

See [workflows.md](./references/workflows.md) for complete mode details and selection guidance.

### Document Type Detection

System auto-detects document type to apply appropriate rules:

| Type | Enforcement | Frontmatter | H1 Subtitle | C7Score Target |
|------|-------------|-------------|-------------|----------------|
| README | Flexible | None | Optional | 85+ |
| SKILL | Strict | Required | Required | 85+ |
| Knowledge | Moderate | Forbidden | Required | 80+ |
| Command | Strict | Required | Forbidden | 75+ |
| Spec | Loose | Optional | Optional | N/A |
| Generic | Flexible | Optional | Optional | N/A |

**Detection priority**: Exact filename → Directory path → Parent directory → Default

See [core_standards.md](./references/core_standards.md) for complete type system.

### Phase Interactions

**Independent Use**: Each phase runs standalone without dependencies

**Sequential Chaining**: Phases build on each other (1 ensures validity, 2 optimizes content, 3 validates result)

**Error Handling**:
- Phase 1 critical violations → STOP (manual fix required)
- Phase 2 low c7score (<60) → WARNING (suggestions provided, continues)
- Phase 3 low overall (<80) → REPORT (improvement plan generated)

---

## 3. 📖 RULES

### ALWAYS Rules

**ALWAYS do these without asking:**

1. **ALWAYS validate filename conventions before processing**
   - Check snake_case format
   - Apply auto-fixes for violations
   - Preserve exceptions (README.md, SKILL.md)

2. **ALWAYS detect document type first**
   - Identify type (SKILL, Knowledge, README, Spec, etc.)
   - Apply appropriate enforcement strictness
   - Use type-specific validation rules

3. **ALWAYS verify frontmatter for types that require it**
   - Check YAML frontmatter presence (SKILL, Command types)
   - Validate required fields
   - Flag missing or malformed frontmatter

4. **ALWAYS preserve TOC sections based on document type**
   - SKILL.md: Remove TOC (not allowed)
   - llms.txt: Remove TOC (not allowed)
   - Knowledge/Command/Spec/README: Preserve TOC if present (never add if absent)
   - TOC format: H4 header `#### 📋 TABLE OF CONTENTS`

5. **ALWAYS ask about llms.txt generation during optimization**
   - Use AskUserQuestion tool when c7score optimization requested
   - Present choice: docs only, or docs + llms.txt
   - Never generate llms.txt without explicit consent

6. **ALWAYS apply safe auto-fixes for enforcement**
   - Convert H2 headings to proper case
   - Add missing section separators (---)
   - Fix filename violations
   - Log all auto-fixes applied

7. **ALWAYS validate before declaring completion**
   - Run structure validation
   - Calculate c7score estimate
   - Check style compliance
   - Provide scoring breakdown

8. **ALWAYS provide before/after metrics**
   - Document baseline scores
   - Show improvement deltas
   - Highlight transformation impact

### NEVER Rules

**NEVER do these:**

1. **NEVER modify spec files during active development**
   - Spec type uses loose enforcement (suggestions only, never blocks)
   - Respect iterative planning workflow
   - Only suggest improvements, don't enforce

2. **NEVER delete original content without user approval**
   - Optimizations modify copies or create new versions
   - Preserve original until validation complete
   - Backup important changes

3. **NEVER block execution for safe violations**
   - Auto-fix: filename issues, H2 case, missing separators
   - Only block: missing frontmatter, wrong section order, invalid structure
   - Safe fixes are logged but non-blocking

4. **NEVER add emojis to llms.txt files**
   - llms.txt is plain text format (no emojis anywhere)
   - All other document types allow emojis
   - SKILL.md requires emojis in H2 headers
   - Knowledge/Command/Spec/README allow emojis

5. **NEVER generate llms.txt without asking**
   - Always use AskUserQuestion for llms.txt generation
   - User must explicitly consent
   - Respect user's navigation preferences

6. **NEVER apply strict enforcement to wrong document types**
   - README, Generic → Flexible enforcement
   - SKILL, Command → Strict enforcement
   - Knowledge → Moderate enforcement
   - Spec → Loose enforcement (suggestions only)

### ESCALATE IF

**Ask user when:**

1. **ESCALATE IF document type detection is ambiguous**
   - Multiple types could apply
   - File location doesn't match content
   - Use AskUserQuestion to clarify intended type

2. **ESCALATE IF critical violations in SKILL/Command files**
   - Missing required frontmatter fields
   - Wrong section order (can't auto-fix safely)
   - User must manually correct structure

3. **ESCALATE IF c7score optimization requires major restructuring**
   - Current score <40 (needs fundamental rewrite)
   - Optimization would change document purpose
   - Get approval for significant changes

4. **ESCALATE IF style guide is missing or incomplete**
   - `.claude/knowledge/document_style_guide.md` not found
   - Style dimension can't be scored
   - Ask if user wants to create style guide

5. **ESCALATE IF optimization conflicts with user intent**
   - Transformation would remove important content
   - User's writing style differs from recommendations
   - Get confirmation before major changes

---

## 4. 🎓 SUCCESS CRITERIA

### Quality Score Thresholds

**Excellent (90-100)**:
- Structure: 100/100 (perfect validity)
- C7Score: 85+/100 (highly AI-friendly)
- Style: 90+/100 (exemplary compliance)
- Overall: 90+/100
- Status: Ready for production, no improvements needed

**Good (80-89)**:
- Structure: 95+/100
- C7Score: 75+/100
- Style: 85+/100
- Overall: 85+/100
- Status: Ready for sharing, minor improvements optional

**Acceptable (70-79)**:
- Structure: 90+/100
- C7Score: 65+/100
- Style: 75+/100
- Overall: 75+/100
- Status: Functional, optimization recommended

**Needs Improvement (<70)**:
- Any dimension <70
- Overall <75
- Status: Significant improvements required

### Completion Checklist

**Phase 1 Complete:**
- ✅ No critical violations detected
- ✅ All safe violations auto-fixed
- ✅ Structure score: 100/100
- ✅ Document type correctly detected

**Phase 2 Complete:**
- ✅ c7score improvement shown (before → after)
- ✅ Transformation patterns applied (list provided)
- ✅ Content optimized for AI assistants
- ✅ llms.txt generated (if user requested)

**Phase 3 Complete:**
- ✅ Triple scoring completed (structure, c7score, style)
- ✅ Overall score calculated
- ✅ Quality gate evaluation shown
- ✅ Improvement recommendations provided (if needed)

### Document-Type Specific Gates

**SKILL.md**:
- Structure: 100/100 (strict, no exceptions)
- C7Score: 85+/100
- Overall: 90+/100
- Required: Frontmatter, WHEN TO USE, HOW IT WORKS, RULES sections

**README.md**:
- Structure: 95+/100 (flexible enforcement)
- C7Score: 85+/100
- Overall: 85+/100
- Focus: Quick Start, usage examples, question-answering format

**Knowledge**:
- Structure: 100/100 (no frontmatter allowed)
- C7Score: 80+/100
- Overall: 85+/100
- Required: Numbered H2 sections, concept → implementation → examples

See [validation.md](./references/validation.md) for complete scoring details.

---

## 5. 🔗 INTEGRATION POINTS

### Hook System Integration

**PostToolUse Hook** (`enforce-markdown-post.sh`):
- Triggers after Write/Edit/NotebookEdit operations
- Purpose: Filename enforcement (automatic corrections)
- Execution: <50ms per file (non-blocking)
- Logging: `.claude/hooks/logs/quality-checks.log`

**UserPromptSubmit Hook** (`enforce-markdown-strict.sh`):
- Triggers before AI processes user prompts
- Purpose: Structure validation and safe auto-fixes
- Execution: <200ms per file
- Blocking: Only on critical violations
- Logging: `.claude/hooks/logs/quality-checks.log`

See [workflows.md](./references/workflows.md) for hook integration details.

### Related Skills

**Interaction with other skills:**

**create-skill**: Markdown-optimizer validates SKILL.md files created by create-skill skill
- Ensures proper frontmatter, structure, and quality
- Validates compliance with Anthropic skill standards
- Target: 90+ overall score for new skills

**save-context**: Context files saved by save-context skill can be optimized
- Document type: memory (flexible enforcement)
- Optional optimization for clarity and future reference
- No blocking violations on memory files

### Tool Usage Guidelines

**Read tool**: Examine files before optimization, check existing structure

**Write tool**: Create optimized versions or llms.txt files

**Edit tool**: Apply specific transformations for safe auto-fixes

**Bash tool**: Execute c7score command-line tool for scoring

**Glob tool**: Find multiple markdown files for batch processing

**Grep tool**: Search for patterns or violations across files

**AskUserQuestion tool**: Required for llms.txt generation consent, document type clarification, major restructuring approval

### Knowledge Base Dependencies

**Required:**
- `.claude/knowledge/document_style_guide.md` - Style scoring dimension
  - If missing: Style dimension shows N/A, create from project standards
  - Used by: Style compliance validation

**Optional:**
- `.claude/knowledge/code_standards.md` - Code example validation
  - If missing: Skip code validation
  - Used by: Code example formatting checks

**Recommended:**
- `.claude/knowledge/conversation_documentation.md` - Spec folder system
  - Integration: Validates spec folder documentation
  - Used by: Spec type detection and enforcement level selection

### External Tools

**c7score** (Python package):
- Installation: `pip install c7score`
- Purpose: AI-friendliness scoring
- Fallback: `export MARKDOWN_SKIP_C7SCORE=true` to disable

---

## 6. 📚 REFERENCES

### Skill Resources

**Reference Documentation** (detailed guides):
- `references/core_standards.md` - Filename conventions, document types, structural violations
- `references/workflows.md` - Four execution modes, hook integration, enforcement patterns
- `references/optimization.md` - C7score metrics and 16 transformation patterns
- `references/validation.md` - Quality scoring, gates, and improvement recommendations
- `references/quick_reference.md` - One-page cheat sheet

**Assets** (templates and examples):
- `assets/frontmatter_templates.md` - YAML frontmatter by document type
- `assets/structure_templates.md` - Document structure examples
- `assets/llmstxt_templates.md` - Example llms.txt files

**Scripts** (automation):
- `scripts/` - Executable scripts for batch processing and automation

### External Documentation

- **llms.txt specification**: https://llmstxt.org/
- **c7score benchmarking**: https://context7.ai/ (AI documentation quality)
- **Anthropic skill standards**: `.claude/skills/create-skill/SKILL.md`
- **Document style guide**: `.claude/knowledge/document_style_guide.md`

### Related Standards

- **Structural rules**: [core_standards.md](./references/core_standards.md)
- **Execution workflows**: [workflows.md](./references/workflows.md)
- **Content optimization**: [optimization.md](./references/optimization.md)
- **Quality validation**: [validation.md](./references/validation.md)
- **Document templates**: [structure_templates.md](./assets/structure_templates.md)
- **Frontmatter formats**: [frontmatter_templates.md](./assets/frontmatter_templates.md)

### Quick Navigation

**Getting started**: Read this SKILL.md, then [quick_reference.md](./references/quick_reference.md)

**Execution modes and workflows**: [workflows.md](./references/workflows.md)

**Document types and rules**: [core_standards.md](./references/core_standards.md)

**Optimization patterns**: [optimization.md](./references/optimization.md)
