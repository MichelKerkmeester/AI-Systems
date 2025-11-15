# Core Standards - Structure and Validation Rules

Filename conventions, document type detection, and structural violation patterns.

---

## 1. 📄 FILENAME CONVENTIONS

**Rule**: lowercase snake_case for all `.md` files

**Transformations**:
1. ALL CAPS → lowercase: `README.MD` → `readme.md`
2. Hyphens → underscores: `my-document.md` → `my_document.md`
3. Mixed case → snake_case: `MyDocument.md` → `my_document.md`
4. Spaces → underscores: `my document.md` → `my_document.md`
5. Multiple underscores → single: `my__doc.md` → `my_doc.md`

**Exceptions** (never modify):
- `README.md` (standard convention)
- `SKILL.md` (in `.claude/skills/` only)

**Detection**: PostToolUse hook auto-fixes filename violations after Write/Edit operations

---

## 2. 🔍 DOCUMENT TYPE DETECTION

**Priority order** (highest to lowest):

| Priority | Pattern | Type | Example |
|----------|---------|------|---------|
| 1 | Exact filename | README → readme | `/any/path/README.md` |
| 1 | Exact filename | SKILL → skill | `.claude/skills/*/SKILL.md` |
| 1 | Exact filename | llms.txt → llmstxt | `/any/path/llms.txt` |
| 2 | Directory path | `.claude/commands/**/*.md` → command | `.claude/commands/deploy.md` |
| 2 | Directory path | `.claude/knowledge/*.md` → knowledge | `.claude/knowledge/api.md` |
| 2 | Directory path | `specs/**/*.md` → spec | `specs/042/spec.md` |
| 3 | Parent directory | `*/specs/*` → spec | `project/specs/plan.md` |
| 4 | Default | `*.md` → generic | Any other `.md` file |

**Enforcement levels by type**:

| Type | Enforcement | Frontmatter | H1 Subtitle | TOC Allowed | Emojis Allowed | Blocks |
|------|-------------|-------------|-------------|-------------|----------------|--------|
| README | Flexible | None | Optional | ✅ Yes | ✅ Yes | No |
| SKILL | Strict | Required | Required | ❌ No | ✅ Required (H2) | Yes |
| llms.txt | Strict | Forbidden | N/A | ❌ No | ❌ No | Yes |
| Knowledge | Moderate | Forbidden | Required | ✅ Yes | ✅ Yes | Yes |
| Command | Strict | Required | Forbidden | ✅ Yes | ✅ Yes | Yes |
| Spec | Loose | Optional | Optional | ✅ Yes | ✅ Yes | No |
| Generic | Flexible | Optional | Optional | ✅ Yes | ✅ Yes | No |

**Manual override**:
```bash
markdown-c7-optimizer --type=skill document.md
```

---

## 3. ⚠️ STRUCTURAL VIOLATIONS

### Safe Auto-Fixes (Non-Blocking)

**Applied automatically, logged, execution continues**:

1. **Filename violations** - Convert to snake_case
2. **H2 case** - Convert to title case: `## when to use` → `## WHEN TO USE`
3. **Missing separators** - Add `---` between sections
4. **Emoji standardization** - Normalize emoji in H2 headings

### Critical Violations (Blocking)

**Execution stops, manual fix required**:

**SKILL type**:
- Missing YAML frontmatter
- Missing required fields: `name`, `description`
- H1 missing subtitle
- Missing required sections: WHEN TO USE, HOW IT WORKS, RULES
- Wrong section order

**Knowledge type**:
- Has YAML frontmatter (should not have)
- H1 missing subtitle
- H2 sections not numbered
- Multiple H1 headers

**Command type**:
- Missing YAML frontmatter
- Missing required fields: `description`
- H1 has subtitle (should not have)
- Missing required sections: INPUTS, WORKFLOW, OUTPUTS

**Fix template** (frontmatter):
```yaml
---
name: skill-name
description: Brief description
allowed-tools: Read, Write, Edit
---
```

**Fix template** (section order for SKILL):
```markdown
## 1. 🎯 WHEN TO USE
## 2. 🛠️ HOW IT WORKS
## 3. 📖 RULES
```

---

## 4. 📋 COMMON VIOLATIONS QUICK REFERENCE

| Violation | Detection | Fix | Auto |
|-----------|-----------|-----|------|
| ALL CAPS filename | `[A-Z]+\.md` | Lowercase | ✅ |
| Hyphenated filename | `-` in filename | Replace with `_` | ✅ |
| Missing frontmatter (SKILL) | No `---` at line 1 | Add YAML block | ❌ Manual |
| H1 no subtitle (SKILL/Knowledge) | Single `#` line | Add ` - Subtitle` | ❌ Manual |
| Multiple H1 | Count `^#\s` > 1 | Remove extras | ❌ Manual |
| H2 lowercase | `## [a-z]` | Title case | ✅ |
| Missing separator | No `---` between sections | Insert `---` | ✅ |
| Wrong section order | Sections out of sequence | Reorder | ❌ Manual |
| Skipped heading level | H2 → H4 | Add H3 | ❌ Manual |
| Frontmatter in Knowledge | Knowledge file has `---` | Remove YAML | ❌ Manual |
| No subtitle in Command | Command H1 has ` -` | Remove subtitle | ❌ Manual |
| Missing RULES section | SKILL without `## RULES` | Add section | ❌ Manual |
| Unclosed code fence | ` ``` ` count odd | Close fence | ✅ |
| Invalid frontmatter YAML | Parse error | Fix syntax | ❌ Manual |

**Validation command**:
```bash
# Check for violations
markdown-c7-optimizer --validate-only file.md
```

---

## 5. 📚 DOCUMENT TYPE REQUIREMENTS

**SKILL.md**:
```yaml
Required frontmatter: name, description, allowed-tools
Required sections: WHEN TO USE, HOW IT WORKS, RULES
H1 format: "# Name - Subtitle"
Quality target: 90+ overall
```

**Knowledge**:
```yaml
Frontmatter: None (forbidden)
H1 format: "# Topic - Subtitle"
H2 format: "## 1. 🎯 SECTION"
Quality target: 85+ overall
```

**Command**:
```yaml
Required frontmatter: description, argument-hint
Required sections: INPUTS, WORKFLOW, OUTPUTS
H1 format: "# Command Name" (no subtitle)
Quality target: 75+ overall
```

**README**:
```yaml
Frontmatter: None
H1 format: Flexible
Sections: Flexible
Quality target: 85+ c7score
TOC: Allowed (optional)
Emojis: Allowed
```

**llms.txt**:
```yaml
Frontmatter: None (forbidden)
H1 format: Plain text only (no markdown headers)
Sections: Free-form plain text
Quality target: High clarity, no formatting
TOC: Not allowed (plain text file)
Emojis: Not allowed (plain text only)
Format: Plain text navigation file for LLMs
```

---

## References

- Workflow details: [workflows.md](./workflows.md)
- Optimization patterns: [optimization.md](./optimization.md)
- Quality scoring: [validation.md](./validation.md)
