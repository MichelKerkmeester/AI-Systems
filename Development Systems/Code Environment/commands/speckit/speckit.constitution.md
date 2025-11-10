---
description: Create or update the project constitution from interactive or provided principle inputs, ensuring all dependent templates stay in sync
---

# Constitution Management

Create or update the project constitution with intelligent versioning, dependency tracking, and automatic template synchronization.

---

## 1. 📋 INPUTS

### User Arguments

```text
$ARGUMENTS
```

**MUST consider user input before proceeding** (if not empty).

### Constitution Elements

**Placeholders** (in square brackets):
- \`[PROJECT_NAME]\`, \`[PRINCIPLE_1_NAME]\`, etc.
- Collected from user input or inferred from context

**Versioning** (Semantic):
- MAJOR: Backward incompatible changes
- MINOR: New principles/sections added
- PATCH: Clarifications, typos, refinements

**Governance Dates**:
- RATIFICATION_DATE: Original adoption (ask if unknown)
- LAST_AMENDED_DATE: Today if changes made

---

## 2. 🚀 WORKFLOW

### Step 1: Load Existing Constitution

**Purpose**: Read current constitution template

**Actions**:
1. Load \`.specify/memory/constitution.md\`
2. Identify all placeholder tokens \`[ALL_CAPS_IDENTIFIER]\`
3. Note: User may require different number of principles than template

**Validation**: \`template_loaded\`

### Step 2: Collect Values for Placeholders

**Purpose**: Gather concrete values for all placeholders

**Sources**:
1. User input from conversation
2. Existing repo context (README, docs)
3. Prior constitution versions
4. Inferred from project structure

**Version Bump Logic**:
- MAJOR: Breaking governance changes
- MINOR: New principles added
- PATCH: Clarifications only

**Validation**: \`values_collected\`

### Step 3: Draft Updated Constitution

**Purpose**: Replace placeholders with concrete content

**Requirements**:
- Remove all bracketed tokens (except intentionally deferred)
- Preserve heading hierarchy
- Each principle: name, rules, rationale
- Governance section: amendment procedure, versioning, compliance

**Validation**: \`constitution_drafted\`

### Step 4: Consistency Propagation

**Purpose**: Update dependent templates and documents

**Check These Files**:
- \`.specify/templates/plan-template.md\`: Constitution Check alignment
- \`.specify/templates/spec-template.md\`: Scope/requirements alignment
- \`.specify/templates/tasks-template.md\`: Task categorization
- \`.specify/templates/commands/*.md\`: Remove outdated references
- Runtime docs: \`README.md\`, \`docs/quickstart.md\`

**Validation**: \`dependencies_synced\`

### Step 5: Generate Sync Impact Report

**Purpose**: Document changes in HTML comment at file top

**Report Contents**:
- Version change: old → new
- Modified principles (old title → new title)
- Added sections
- Removed sections
- Template update status (✅ updated / ⚠ pending)
- Follow-up TODOs

**Validation**: \`report_generated\`

### Step 6: Validation

**Purpose**: Ensure constitution quality

**Checks**:
- No unexplained bracket tokens
- Version line matches report
- Dates in ISO format (YYYY-MM-DD)
- Principles are declarative and testable
- Replace vague "should" with MUST/SHOULD rationale

**Validation**: \`constitution_validated\`

### Step 7: Write Constitution

**Purpose**: Save updated constitution to file

**Actions**:
- Overwrite \`.specify/memory/constitution.md\`
- Include Sync Impact Report as HTML comment
- Verify write succeeded

**Validation**: \`file_written\`

### Step 8: Output Summary

**Purpose**: Provide user with completion status

**Summary Includes**:
- New version and bump rationale
- Files flagged for manual follow-up
- Suggested commit message

**Example Commit Message**:
\`\`\`
docs: amend constitution to vX.Y.Z (principle additions + governance update)
\`\`\`

**Validation**: \`summary_outputted\`

---

## 3. 💡 EXAMPLES

### Example 1: Add New Principle

\`\`\`bash
/speckit.constitution "Add observability principle: All features must include logging and monitoring"
\`\`\`

**Result**: MINOR version bump, templates updated

### Example 2: Update Existing Principle

\`\`\`bash
/speckit.constitution "Clarify testing principle to require integration tests"
\`\`\`

**Result**: PATCH version bump, affected templates synced

### Example 3: Interactive Creation

\`\`\`bash
/speckit.constitution
\`\`\`

**Flow**: Prompts for project name, principles, governance

---

## 4. 📖 RULES

### ALWAYS

- Load existing constitution template first
- Respect user-specified principle count
- Apply semantic versioning correctly
- Propagate changes to dependent templates
- Generate Sync Impact Report
- Validate no unexplained placeholders remain
- Use ISO date format (YYYY-MM-DD)
- Make principles declarative and testable
- Include version bump rationale

### NEVER

- Create new template (always update existing)
- Leave bracketed tokens unexplained
- Skip dependency propagation
- Forget to update version number
- Use vague language in principles
- Omit Sync Impact Report
- Skip validation steps

### ESCALATE IF

- Version bump type is ambiguous
- Critical information missing (ratification date)
- Conflicting principles detected
- Dependent template conflicts arise
- Cannot determine appropriate version increment

---

## 5. 🎓 SUCCESS CRITERIA

**Constitution is successfully updated when**:
- ✅ All placeholders replaced with concrete values
- ✅ Version incremented appropriately
- ✅ Sync Impact Report generated
- ✅ Dependent templates updated
- ✅ Dates in correct format
- ✅ Principles are declarative and testable
- ✅ File written successfully
- ✅ User summary provided

**Quality Gates**:
- No unexplained bracket tokens
- Version matches bump rationale
- Templates stay synchronized
- Commit message suggested

---

## 6. 🔗 INTEGRATION POINTS

### Dependent Files

- \`.specify/templates/plan-template.md\`
- \`.specify/templates/spec-template.md\`
- \`.specify/templates/tasks-template.md\`
- \`.specify/templates/commands/*.md\`
- \`README.md\`, \`docs/quickstart.md\`

### Related Commands

- \`/speckit.specify\`: Uses constitution for requirements
- \`/speckit.plan\`: References constitution in checks
- \`/speckit.tasks\`: Applies principle-driven categorization

---

## 7. ⚠️ FORMATTING & STYLE

**Markdown Structure**:
- Use template headings exactly (don't demote/promote)
- Single blank line between sections
- No trailing whitespace
- Wrap long lines (~100 chars) for readability

**Language**:
- Declarative principles
- Replace "should" with MUST/SHOULD + rationale
- Testable, non-vague language

**Deferred Items**:
- Use \`TODO(<FIELD_NAME>): explanation\`
- Include in Sync Impact Report
