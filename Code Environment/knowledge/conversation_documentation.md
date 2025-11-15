# Conversation Documentation - Mandatory Spec System

Defines the mandatory specification folder system for all conversations involving code or documentation file changes.

Every conversation that modifies files (code, documentation, configuration, etc.) requires documentation in `/specs/[###-short-name]/` before changes begin. This ensures context preservation, debugging capability, smooth handoffs, and searchable project history. Documentation level scales with complexity: minimal README for trivial changes to full SpecKit for complex features.

#### 📋 TABLE OF CONTENTS

1. [🎯 PURPOSE & BENEFITS](#1--purpose--benefits)
2. [📊 DECISION FRAMEWORK](#2--decision-framework)
3. [📁 LEVEL SPECIFICATIONS](#3--level-specifications)
4. [🛠️ IMPLEMENTATION GUIDE](#4-️-implementation-guide)
5. [📋 TEMPLATES & STRUCTURE](#5--templates--structure)
6. [🎭 REAL EXAMPLES](#6--real-examples)
7. [🚦 AUTOMATION & WORKFLOW](#7--automation--workflow)
8. [🏎️ QUICK REFERENCE](#8--quick-reference)
9. [🔍 TROUBLESHOOTING](#9--troubleshooting)

---

## 1. 🎯 PURPOSE & BENEFITS

### Why Mandatory?

Changes without context create technical debt. Conversations disappear, decisions are forgotten, and debugging becomes archaeology. Spec folders solve this by preserving the complete decision trail for **all file modifications** - whether code, documentation, configuration, or other project files.

### Scope: What Requires Documentation?

**Spec folders are required for ALL file modifications, including:**

✅ **Code files** - JavaScript, TypeScript, Python, CSS, HTML, etc.
✅ **Documentation files** - Markdown, text files, README updates, etc.
✅ **Configuration files** - JSON, YAML, TOML, environment configs, etc.
✅ **Knowledge base files** - `.claude/knowledge/*.md` updates
✅ **Template files** - `.specify/templates/*.md` modifications
✅ **Build/tooling files** - package.json, requirements.txt, etc.

**Exceptions (no spec needed):**
- Pure exploration/reading (no file modifications)
- Single typo fixes (<5 characters in one file)
- Whitespace-only changes
- Auto-generated file updates

**Rule of thumb:** If you're modifying ANY file content → Create a spec folder first.

### Key Benefits

- **Complete History** - Every change documented with rationale and context
- **Easy Debugging** - Understand original intent when bugs surface
- **Better Handoffs** - Context doesn't live in someone's head
- **Knowledge Preserved** - Searchable archive of all implementation decisions

---

## 2. 📊 DECISION FRAMEWORK

### Levels Overview

| Level | LOC | Core Files | Optional Files | Use When |
|-------|-----|------------|----------------|----------|
| **0** | <10 | README.md | - | Trivial fix (typo, comment) |
| **1** | <100 | spec.md | checklist.md | Simple, isolated change |
| **2** | <500 | spec.md + plan.md | tasks.md, checklist.md, retrospective.md | Moderate feature |
| **3** | ≥500 | Full SpecKit | spike-*.md, decision-record-*.md | Complex feature |

### Decision Factors

**Primary:** Lines of Code (LOC) - Count all files being modified, include new files, estimate conservatively

**Secondary:** Complexity, Risk, Dependencies, Testing needs

### Edge Cases

| Scenario | LOC | Level | Rationale |
|----------|-----|-------|-----------|
| Typo in one file | 1 | 0 | Truly trivial |
| Typo across 5 files | 5 | 1 | Multi-file |
| 95 LOC feature | 95 | 1 | Under threshold |
| 105 LOC feature | 105 | 2 | Just over, safer |
| Refactor (no new logic) | 200 | 2 | Complexity matters |
| Config cascade | 50 | 2 | Risk trumps LOC |

**When In Doubt:** Choose higher level. Better to over-document than under-document.

---

## 3. 📁 LEVEL SPECIFICATIONS

### Level 0: Trivial (<10 LOC)

**Criteria:** Single, isolated change with no complexity
**Files:** `README.md` (concise_readme_template.md)
**Content:** Brief description, files affected, reason
**Examples:** Typo fixes, comment updates, whitespace cleanup

---

### Level 1: Simple (<100 LOC)

**Criteria:** Localized to one component, clear requirements, low complexity
**Files:** `spec.md` (concise_spec_template.md)
**Content:** Problem statement, solution, files to change, testing notes
**Examples:** Bug fixes, small enhancements, simple features
**Escalate to Level 2 if:** Affects multiple systems, architectural decisions, complex testing

---

### Level 2: Moderate (100-499 LOC)

**Criteria:** Multiple files/components, moderate complexity, requires planning
**Files:** `spec.md` + `plan.md` (spec_template.md + plan_template.md)
**Content:**
- **spec.md:** Detailed requirements, technical approach, alternatives, success criteria
- **plan.md:** Implementation steps, file changes, testing strategy, rollout plan

**Examples:** New features, refactoring, library integration, authentication flows
**Escalate to Level 3 if:** Discover >500 LOC, complexity increases substantially, need multiple developers

---

### Level 3: Complex (≥500 LOC)

**Criteria:** High complexity, multiple systems, requires coordination
**Process:** Use `/speckit.specify` slash command
**Files:** Full SpecKit output (spec.md, plan.md, tasks.md, checklist.md, etc.)
**Examples:** Major features, system redesigns, architecture changes
**Note:** SpecKit handles Level 3 automatically—don't create files manually

---

## 4. 🛠️ IMPLEMENTATION GUIDE

### Quick Steps

1. **Determine Level:** Estimate LOC + assess complexity (see Section 2)
2. **Find Next Number:** `ls -d specs/[0-9]*/ | sed 's/.*\/\([0-9]*\)-.*/\1/' | sort -n | tail -1` (add 1)
3. **Create Folder:** `mkdir -p specs/###-short-name/`
4. **Copy Template(s):**
   - Level 0: `cp .specify/templates/concise_readme_template.md specs/###-short-name/README.md`
   - Level 1: `cp .specify/templates/concise_spec_template.md specs/###-short-name/spec.md`
   - Level 2: `cp .specify/templates/spec_template.md specs/###-short-name/spec.md && cp .specify/templates/plan_template.md specs/###-short-name/plan.md`
   - Level 3: Use `/speckit.specify` command (auto-generates)
5. **Fill Template:** Replace placeholders with actual content, remove sample sections
6. **Add Supporting Templates (if needed):**
   - For tasks: `cp .specify/templates/tasks_template.md specs/###-short-name/tasks.md`
   - For checklist: `cp .specify/templates/checklist_template.md specs/###-short-name/checklist.md`
   - For retrospective: `cp .specify/templates/retrospective_template.md specs/###-short-name/retrospective.md`
   - For ADR: `cp .specify/templates/decision_record_template.md specs/###-short-name/decision-record-[name].md`
   - For spike: `cp .specify/templates/spike_template.md specs/###-short-name/spike-[name].md`
7. **Present:** Show user level, folder, approach, and which templates were used
8. **Get Approval:** Wait for explicit "yes/go ahead/proceed"

### Naming Format

**Rules:** 2-4 words, lowercase, hyphen-separated, action-noun structure

**Good:**
- `fix-typo`, `add-validation`, `implement-auth`, `cdn-migration`

**Bad:**
- ❌ `fix-the-typo-in-header` (too long)
- ❌ `fixTypo` (not kebab-case)
- ❌ `fix_typo` (snake_case)
- ❌ `typo` (too vague)

### Number Padding

- Use 3 digits: `001`, `002`, `042`, `099`
- No padding past 999: `1000`, `1001`

---

## 5. 📋 TEMPLATES & STRUCTURE

### Template Location

**All templates are located in:** `.specify/templates/`

**AI Agent Instructions:**
- **ALWAYS** copy templates from `.specify/templates/` to the spec folder
- **NEVER** create documentation files from scratch
- **SELECT** the appropriate template based on documentation level and needs
- **ADAPT** template content to the specific feature (remove placeholders, fill in actual content)

### Core Templates by Level

| Level | Template File | Copy As | When to Use |
|-------|--------------|---------|-------------|
| 0 | `concise_readme_template.md` | `README.md` | Trivial changes (<10 LOC) |
| 1 | `concise_spec_template.md` | `spec.md` | Simple changes (<100 LOC) |
| 2 | `spec_template.md` + `plan_template.md` | `spec.md` + `plan.md` | Moderate complexity (100-499 LOC) |
| 3 | SpecKit auto-generates | Multiple files | Complex features (≥500 LOC) |

**Template Selection Process:**
1. Determine documentation level (0/1/2/3)
2. Copy appropriate core template(s) from `.specify/templates/` to spec folder
3. Rename copied file(s) according to table above
4. Fill in template sections with actual content
5. Add supporting templates if needed (see below)

### Supporting Templates

Additional templates available in `.specify/templates/` for specific needs:

| Template File | Copy As | Purpose | When to Use |
|--------------|---------|---------|-------------|
| `tasks_template.md` | `tasks.md` | Implementation task breakdown | Level 2/3 - after plan.md is complete, before coding |
| `checklist_template.md` | `checklist.md` | Validation & QA checklists | Any level - when systematic validation needed |
| `retrospective_template.md` | `retrospective.md` | Post-implementation review | After Level 2/3 feature completion |
| `decision_record_template.md` | `decision-record-[name].md` | Architecture Decision Records (ADR) | When making significant technical decisions |
| `spike_template.md` | `spike-[name].md` | Research & experimentation | Before implementation - time-boxed research |

**Supporting Template Usage:**
- Copy from `.specify/templates/` to spec folder when needed
- Use descriptive names for decision records and spikes (e.g., `decision-record-database-choice.md`, `spike-performance-testing.md`)
- Multiple decision records and spikes can exist in one spec folder
- Supporting templates are **optional** - only use when explicitly needed

### Folder Structures

```
Level 0: specs/###-name/
├── README.md                    (from concise_readme_template.md)

Level 1: specs/###-name/
├── spec.md                      (from concise_spec_template.md)
└── checklist.md                 (optional, from checklist_template.md)

Level 2: specs/###-name/
├── spec.md                      (from spec_template.md)
├── plan.md                      (from plan_template.md)
├── tasks.md                     (optional, from tasks_template.md)
├── checklist.md                 (optional, from checklist_template.md)
├── spike-[name].md              (optional, from spike_template.md)
├── decision-record-[name].md    (optional, from decision_record_template.md)
└── retrospective.md             (post-implementation, from retrospective_template.md)

Level 3: specs/###-name/
├── spec.md                      (SpecKit auto-generated)
├── plan.md                      (SpecKit auto-generated)
├── tasks.md                     (SpecKit auto-generated)
├── research.md                  (SpecKit auto-generated)
├── data-model.md                (SpecKit auto-generated)
├── quickstart.md                (SpecKit auto-generated)
├── contracts/                   (SpecKit auto-generated)
├── checklist.md                 (optional, from checklist_template.md)
├── spike-[name].md              (optional, from spike_template.md)
├── decision-record-[name].md    (optional, from decision_record_template.md)
└── retrospective.md             (post-implementation, from retrospective_template.md)
```

**Template Source Reference:**
- All templates copied from `.specify/templates/` directory
- Core templates (README, spec, plan) are **required** based on level
- Supporting templates (tasks, checklist, retrospective, decision-record, spike) are **optional**
- Level 3 uses SpecKit auto-generation for core files, but can still use supporting templates

### When to Use Supporting Templates

**tasks.md** (from `tasks_template.md`)
- **When**: After plan.md is complete, before implementation begins
- **Purpose**: Breaks plan into actionable tasks organized by user story
- **Copy**: `cp .specify/templates/tasks_template.md specs/###-name/tasks.md`

**checklist.md** (from `checklist_template.md`)
- **When**: When systematic validation needed (pre-implementation, QA, security review, deployment readiness)
- **Purpose**: Validation and quality assurance checklists
- **Copy**: `cp .specify/templates/checklist_template.md specs/###-name/checklist.md`

**retrospective.md** (from `retrospective_template.md`)
- **When**: AFTER feature is complete (Level 2/3)
- **Purpose**: Captures learnings, metrics achieved, what went well/poorly
- **Copy**: `cp .specify/templates/retrospective_template.md specs/###-name/retrospective.md`

**decision-record-[name].md** (from `decision_record_template.md`)
- **When**: Making significant architectural/technical decisions
- **Purpose**: Architecture Decision Records (ADRs) documenting major technical choices
- **Copy**: `cp .specify/templates/decision_record_template.md specs/###-name/decision-record-[descriptive-name].md`
- **Examples**: `decision-record-database-choice.md`, `decision-record-api-framework.md`

**spike-[name].md** (from `spike_template.md`)
- **When**: BEFORE implementation when research/experimentation needed
- **Purpose**: Time-boxed exploration and proof-of-concept work
- **Copy**: `cp .specify/templates/spike_template.md specs/###-name/spike-[descriptive-name].md`
- **Examples**: `spike-performance-testing.md`, `spike-library-evaluation.md`

### 5.5. Template Structure Requirements

Well-structured documentation is what allows future contributors (including AI agents) to reason about context within seconds. Every template shipped in `.specify/templates/` follows a predictable spine so reviewers can skim metadata, scan numbered sections, and jump directly to success criteria without reading the entire file. When you copy a template, you inherit this structure and are responsible for preserving it.

**Numbered Section Format**  
All core templates use H2 sections formatted as `## N. EMOJI TITLE` (for example `## 3. 🛠️ IMPLEMENTATION`). Keep section numbers sequential even if you remove optional subsections, and never drop the emoji. Use H3 headings for supporting details under the numbered sections; H3 headings stay in Title Case (no emoji).  

**Metadata Baseline**  
Every template begins with a metadata block that sets expectations on scale, ownership, and timing:
- **Level 0 README:** `## 1. METADATA` with Date, Type, Documentation Level, and Estimated LOC.
- **Level 1 spec.md:** `## 1. METADATA` plus Complexity, LOC Estimate, Success Criteria summary.
- **Level 2/3 spec.md:** `## 1. OBJECTIVE` followed by Metadata bullet list (Category, Tags, Priority, Feature Branch, Created, Status, Input).  
Plan templates list project scope, phases, and dependencies in the first section. Supporting templates inherit similar metadata (e.g., tasks.md starts with Owner + Target Date). Never delete these top sections; instead replace placeholders with actual values.

**Placeholder Conventions**  
Placeholders signal unfinished work:
- `[PLACEHOLDER]` for required values that must be overwritten.
- `[NEEDS CLARIFICATION: …]` when the requirement is unknown yet.
- HTML comments such as `<!-- SAMPLE CONTENT -->` mark instructional text that must be removed before final delivery.  
Do not ship documents that still contain square-bracket placeholders or instructional comments unless the user explicitly approves.

**Template Footer**  
All templates end with the accountability footer:
```html
<!--
  REPLACE SAMPLE CONTENT IN FINAL OUTPUT
  - This template contains placeholders and examples
  - Replace them with actual content
-->
```
Keep the footer intact. It reminds reviewers to validate that placeholders were replaced and gives future editors a clear signal if someone forgets.

**Cross-Document References**  
Spec folders operate as bundles. Whenever a template references another file (for example spec.md linking to plan.md or tasks.md), maintain those references and update section numbers when you add or remove supporting files. Decision records must include the descriptive suffix (e.g., `decision-record-database-choice.md`) so the context is obvious in listings. Spikes follow the same pattern: `spike-[short-topic].md`.

**Content Expectations by Template**
- **README.md (Level 0)** covers change summary, files touched, rationale, testing performed, and escalation guidance.
- **spec.md (Levels 1-3)** documents objectives, requirements, solution design, success criteria, and risks.
- **plan.md** breaks the solution into phases, task groups, testing strategy, and rollout plan.
- **tasks.md** organizes work into actionable tickets aligned with user stories.
- **checklist.md** enumerates validations grouped by category (Pre-Implementation, QA, Security, Performance, Documentation, Deployment).
- **retrospective.md** captures metrics vs. target, lessons learned, and follow-up actions.
- **decision-record-*.md** follows ADR format (Context → Decision → Consequences → Status).
- **spike-*.md** documents hypothesis, research steps, findings, and recommendations.  
Keeping each section intact ensures reviewers know exactly where to find information during audits.

### 5.6. Template Adherence Rules

These rules are the guardrails the enforcement hook will check. Treat them as non-negotiable unless the user explicitly waives them for an emergency fix.

1. **Always copy from `.specify/templates/`.** Never freehand documentation. Copy the correct template, then edit. This guarantees you start with the right metadata, numbered sections, and footer.
2. **Preserve numbering and emojis.** Do not renumber sections or rename headings unless you add additional sections at the bottom. Removing numbers or emojis breaks quick navigation and defeats the visual scanning pattern.
3. **Fill every placeholder before requesting approval.** Replace `[PLACEHOLDER]` snippets, `[NEEDS CLARIFICATION]` prompts, and sample bullets with factual content. If information is genuinely unknown, state that explicitly in prose (e.g., “Scope TBD – waiting for stakeholder input”).
4. **Remove instructional comments.** Delete HTML comment blocks that came from the template footer or inline guidance once you apply the instructions. The footer stays, but internal “REMOVE THIS” comments should not ship.
5. **Use descriptive filenames.** Supporting docs must keep their suffixes (`decision-record-[topic].md`, `spike-[topic].md`). Avoid generic names like `decision-record-final.md` that convey nothing.
6. **Keep sections relevant.** If a section does not apply (for example, no dependencies), state “N/A – no external dependencies” instead of deleting the section. Consistent sections make automated validation simpler.
7. **Link sibling documents.** When spec.md references plan.md or tasks.md, ensure the paths are correct and the referenced documents exist. Include relative links or at least call out the filenames in the References section.
8. **Document upgrades or downgrades.** If scope changes push you to a higher documentation level, copy the additional templates immediately and note the change inside spec.md (e.g., “Documentation escalated from Level 1 to Level 2 after discovering cross-team dependencies”).
9. **Keep history immutable.** Once a spec folder ships, edits should append new sections (Decision Log, Change Notes) rather than rewriting history. This keeps audit trails intact for future investigations.
10. **Validate before coding.** Run through the Pre-Implementation Checklist at the end of Section 8 to ensure the folder is complete. If any checkbox fails, stop and update the documentation before touching source files.

These adherence rules mirror what the upcoming enforcement hook validates (spec folder existence, template presence, placeholder cleanup). Following them manually keeps the automation happy and prevents hard-blocks from interrupting your workflow.

---

## 6. 🎭 REAL EXAMPLES

### Example 1: Typo Fix (Level 0)
**Request:** Fix "Eror submitting form" → "Error submitting form"
**Analysis:** 1 line, 1 file, zero complexity
**Folder:** `/specs/042-fix-form-typo/`
**Files:** README.md with change description

---

### Example 2: Add Validation (Level 1)
**Request:** Add email validation to contact form
**Analysis:** ~40 LOC, 2 files, clear requirements
**Folder:** `/specs/043-add-email-validation/`
**Files:** spec.md with problem/solution/testing

---

### Example 3: New Component (Level 2)
**Request:** Create reusable modal with animations
**Analysis:** ~250 LOC, 5 files, moderate complexity
**Folder:** `/specs/044-modal-component/`
**Files:** spec.md (requirements/API design) + plan.md (implementation steps)

---

## 7. 🔄 SPEC REUSE GUIDELINES

**PURPOSE**: Prevent duplicate spec folders by identifying when to update existing specs vs creating new ones.

### Core Principle

**Before creating a new spec folder, ALWAYS check if related work already exists.** Reusing existing specs preserves context, maintains continuity, and prevents documentation fragmentation.

---

### When to Update Existing Spec

Update an existing spec folder when:

✅ **Iterative Development** - Continuing work on the same feature across multiple sessions
- Example: Initial implementation → bug fixes → enhancements

✅ **Bug Fixes** - Fixing issues in existing implementation
- Example: "Fix alignment bug in markdown-optimizer" → Update existing markdown-optimizer spec

✅ **Scope Escalation** - Work grows beyond original estimate
- Example: Level 1 bug fix → Requires Level 2 refactor → Add plan.md to same folder

✅ **Feature Enhancement** - Adding to existing functionality
- Example: "Add dark mode support to modal component" → Update modal-component spec

✅ **Resuming Paused Work** - Continuing previously paused implementation
- Example: Spec status: paused → active → Add continuation notes

---

### When to Create New Spec

Create a new spec folder when:

❌ **Distinct Feature** - Completely separate functionality, even in same area
- Example: "markdown-optimizer" ≠ "markdown-validator" (both markdown, different purposes)

❌ **Different Approach** - Alternative implementation strategy
- Example: "hero-animation-css" vs "hero-animation-js" (same feature, different approach)

❌ **Separate User Story** - Different requirement or use case
- Example: "user-authentication" ≠ "user-profile" (both user-related, separate stories)

❌ **Complete Redesign** - Starting over with new architecture
- Example: "payment-flow-v2" (complete rewrite of payment-flow-v1)

❌ **Unrelated Work** - No connection to existing specs
- Example: "add-search-feature" ≠ "fix-form-validation" (different areas)

---

### Status Field Convention

**Every spec.md should include a `status` field in the frontmatter:**

```yaml
---
title: Feature Name
created: 2025-11-15
status: active  # ← Add this field
level: 2
---
```

#### Valid Status Values

| Status | Meaning | When to Use | Reuse Priority |
|--------|---------|-------------|----------------|
| `draft` | Planning phase | Initial spec creation, not started | 2 (can start) |
| `active` | Work in progress | Currently implementing | 1 (highest - continue here) |
| `paused` | Temporarily on hold | Blocked or deprioritized | 3 (can resume) |
| `complete` | Implementation finished | Feature deployed and stable | 4 (avoid reopening) |
| `archived` | Historical record | Deprecated or superseded | 5 (do not reuse) |

**Default**: If `status` field is missing, treat as `active`

#### Status Lifecycle

```
draft → active → complete
   ↓       ↓         ↓
paused  paused   archived
   ↓
active (resume)
```

---

### Decision Tree

Follow this decision tree when starting new work:

```
User requests modification
    ↓
Extract keywords from request
    ↓
Search existing specs (folder names, titles)
    ↓
    ├─→ No matches found
    │      ↓
    │   Create new spec folder
    │
    └─→ Related specs found
           ↓
        Check status field
           ↓
           ├─→ status: active or draft
           │      ↓
           │   Recommend: UPDATE existing spec
           │   Reason: Work in progress, maintain continuity
           │
           ├─→ status: paused
           │      ↓
           │   ASK user: Resume paused work or create new?
           │   Reason: Context exists, but was stopped intentionally
           │
           └─→ status: complete or archived
                  ↓
               ASK user: Reopen completed work or create new?
               Reason: Feature was finished, ensure not regression
```

---

### Examples

#### Example 1: Iterative Development (UPDATE existing)
**Scenario**: specs/049-markdown-optimizer-alignment exists (status: active)
**Request**: "Fix additional alignment issues in markdown-optimizer"
**Decision**: ✅ **Update specs/049-markdown-optimizer-alignment**
**Rationale**: Same feature, iterative work, maintains context continuity

---

#### Example 2: Related but Distinct (CREATE new)
**Scenario**: specs/049-markdown-optimizer-alignment exists (status: complete)
**Request**: "Create markdown validation tool"
**Decision**: ❌ **Create specs/054-markdown-validation-tool**
**Rationale**: Different purpose (optimize vs validate), separate feature

---

#### Example 3: Scope Escalation (UPDATE existing)
**Scenario**: specs/043-add-email-validation created as Level 1
**Midway**: Discover need for validation framework (now Level 2)
**Decision**: ✅ **Stay in specs/043-add-email-validation, add plan.md**
**Rationale**: Same feature, growing scope, maintain single source of truth

---

#### Example 4: Alternative Approach (CREATE new)
**Scenario**: specs/022-hero-general-rebuild (CSS approach, status: complete)
**Request**: "Rebuild hero with JavaScript animations instead"
**Decision**: ❌ **Create specs/055-hero-js-animations**
**Rationale**: Different implementation strategy, keep both for comparison

---

#### Example 5: Resume Paused Work (UPDATE existing)
**Scenario**: specs/030-magazine-page-turner (status: paused)
**Request**: "Continue work on magazine page turner"
**Decision**: ✅ **Update specs/030-magazine-page-turner**, change status to active
**Rationale**: Resuming previous work, context already exists

---

### AI Agent Workflow

**When receiving modification request, AI MUST:**

1. **Extract keywords** from user prompt
   - Example: "fix alignment in markdown optimizer" → ["fix", "alignment", "markdown", "optimizer"]

2. **Search for related specs**
   - Use: `find specs/ -type d -name "*markdown*" -o -name "*optimizer*"`
   - OR: Use helper script: `.claude/hooks/scripts/find-related-spec.sh "markdown optimizer"`

3. **Check hook output** for "RELATED SPECS FOUND" message
   - Hook automatically surfaces top 3 matches

4. **Review status** of matched specs
   - Prioritize: active > draft > paused > complete > archived

5. **Present options to user**
   - "Related spec found: specs/049-markdown-optimizer-alignment (status: active)"
   - "Options:"
   - "  A) Update existing spec 049 (recommended - work is related)"
   - "  B) Create new spec 053 (if this is distinct work)"

6. **Proceed based on user choice**
   - If update: Work within existing spec folder, update documentation
   - If new: Create new spec folder following normal process

---

### Migration Between Levels

**If scope grows during implementation:**

| From | To | Action |
|------|-----|--------|
| Level 0 | Level 1 | Add spec.md to same folder |
| Level 1 | Level 2 | Add plan.md to same folder |
| Level 2 | Level 3 | Use `/speckit.plan` in same folder |

**Document the migration**:
```markdown
## Change Log
- 2025-11-15: Created as Level 1 (simple bug fix)
- 2025-11-16: Escalated to Level 2 (discovered architectural changes needed)
```

---

### Troubleshooting

**Q: "I found 3 related specs - which one to update?"**
- Prioritize by status: active > draft > paused
- If multiple active: Choose most recent (highest number)
- If uncertain: Ask user with specific options

**Q: "Spec is complete, but I need to fix a bug"**
- If minor bug (<10 LOC): Update complete spec, note in changelog
- If major fix (>50 LOC): Consider if feature should reopen (status: complete → active)
- Ask user if uncertain

**Q: "Found related spec but it's for a different approach"**
- Create new spec if approaches are fundamentally different
- Reference original spec in new spec's "Related Documents" section

**Q: "No related specs found but I think one exists"**
- Manually search: `ls specs/ | grep -i "keyword"`
- Check folder names for synonyms (optimizer vs optimization, auth vs authentication)
- If truly new work: Create new spec

---

## 8. 🚦 AUTOMATION & WORKFLOW

### Agent Auto-Creation Workflow

**AI Agent MUST Follow This Process:**

1. **Determine documentation level** (0/1/2/3) based on LOC and complexity
2. **Find next spec number** using: `ls -d specs/[0-9]*/ | sed 's/.*\/\([0-9]*\)-.*/\1/' | sort -n | tail -1`
3. **Create spec folder** with correct naming: `specs/###-short-name/`
4. **Copy appropriate templates from `.specify/templates/`:**
   - Level 0: Copy `concise_readme_template.md` → `README.md`
   - Level 1: Copy `concise_spec_template.md` → `spec.md`
   - Level 2: Copy `spec_template.md` → `spec.md` AND `plan_template.md` → `plan.md`
   - Level 3: Use `/speckit.specify` command (auto-generates all files)
5. **Fill template content:**
   - Replace ALL `[PLACEHOLDER]` text with actual content
   - Remove sample/example sections marked with comments
   - Adapt structure to specific feature needs
   - Keep only relevant sections
6. **Add supporting templates if needed:**
   - Copy `tasks_template.md` if breaking down implementation
   - Copy `checklist_template.md` if validation needed
   - Copy `spike_template.md` if research required
   - Copy `decision_record_template.md` if architectural decision needed
7. **Present to user:**
   - Show documentation level chosen
   - Show spec folder path
   - Show which templates were used
   - Explain approach
8. **Wait for approval** - Get explicit "yes/go ahead/proceed" before making ANY file changes

**Critical Rules:**
- **NEVER** create documentation files from scratch
- **ALWAYS** copy from `.specify/templates/` directory
- **ALWAYS** rename copied files correctly (e.g., `concise_spec_template.md` → `spec.md`)
- **ALWAYS** fill in actual content (remove placeholders)
- **Applies to ALL file changes:** code, documentation, configuration, templates, knowledge base files, etc.

### Enforcement Checkpoints

1. **Collaboration First Rule** - Before ANY file changes (code, docs, config, etc.), create spec folder with templates
2. **Request Analysis** - Agent classifies Level 0/1/2/3 based on scope of changes
3. **Template Selection** - Agent copies correct templates from `.specify/templates/`
4. **Content Adaptation** - Agent fills templates with actual content
5. **Pre-Change Checklist** - Verify spec folder exists with filled templates (blocker for ALL file modifications)
6. **Final Review** - Confirm documentation complete and accurate

---

## 9. 🏎️ QUICK REFERENCE

### Decision Shortcuts

| Situation | Level | Core Templates | Copy Command | Optional Templates |
|-----------|-------|---------------|--------------|-------------------|
| Typo, <10 lines | 0 | `concise_readme_template.md` → `README.md` | `cp .specify/templates/concise_readme_template.md specs/###-name/README.md` | - |
| Bug fix, <100 lines | 1 | `concise_spec_template.md` → `spec.md` | `cp .specify/templates/concise_spec_template.md specs/###-name/spec.md` | checklist.md |
| Feature, <500 lines | 2 | `spec_template.md` → `spec.md`<br>`plan_template.md` → `plan.md` | `cp .specify/templates/spec_template.md specs/###-name/spec.md`<br>`cp .specify/templates/plan_template.md specs/###-name/plan.md` | tasks.md, checklist.md, spike-*.md, decision-record-*.md |
| Complex, 500+ lines | 3 | Use `/speckit.specify` | `/speckit.specify` command | checklist.md, spike-*.md, decision-record-*.md, retrospective.md |

### Supporting Template Usage

| Template File | Copy As | Create When | Example Scenario |
|--------------|---------|-------------|------------------|
| `tasks_template.md` | `tasks.md` | After plan.md, before coding | Breaking down implementation into actionable tasks |
| `checklist_template.md` | `checklist.md` | When validation needed | QA checklist, security review, deployment readiness |
| `retrospective_template.md` | `retrospective.md` | After feature complete | Post-mortem, learnings capture, metrics review |
| `spike_template.md` | `spike-[name].md` | Before uncertain work | Researching libraries, proof of concept, feasibility study |
| `decision_record_template.md` | `decision-record-[name].md` | Major technical decision | Choosing database, architecture pattern, framework |

### Template Copy Commands

**Core Templates:**
```bash
# Level 0
cp .specify/templates/concise_readme_template.md specs/###-name/README.md

# Level 1
cp .specify/templates/concise_spec_template.md specs/###-name/spec.md

# Level 2
cp .specify/templates/spec_template.md specs/###-name/spec.md
cp .specify/templates/plan_template.md specs/###-name/plan.md
```

**Supporting Templates:**
```bash
# Tasks
cp .specify/templates/tasks_template.md specs/###-name/tasks.md

# Checklist
cp .specify/templates/checklist_template.md specs/###-name/checklist.md

# Retrospective
cp .specify/templates/retrospective_template.md specs/###-name/retrospective.md

# Decision Record (use descriptive name)
cp .specify/templates/decision_record_template.md specs/###-name/decision-record-database-choice.md

# Spike (use descriptive name)
cp .specify/templates/spike_template.md specs/###-name/spike-performance-testing.md
```

### Pre-Implementation Checklist

- [ ] Determined level (0/1/2/3)
- [ ] Created `/specs/[###-short-name]/`
- [ ] Copied appropriate templates from `.specify/templates/`
- [ ] Renamed templates correctly (e.g., `concise_spec_template.md` → `spec.md`)
- [ ] Filled core template sections with actual content
- [ ] Removed placeholder text and sample sections
- [ ] Identified and copied needed supporting templates
- [ ] Presented approach to user (including which templates used)
- [ ] Got explicit approval

**If ANY unchecked → STOP**

---

## 10. 🔍 TROUBLESHOOTING

1. **"I forgot to create the spec folder"**

   Stop coding immediately. Create spec folder retroactively, document what was done and why, get user approval, then continue.

2. **"I'm not sure which level to choose"**

   When in doubt, choose the **higher level**. Ask user if confidence <80%. Consider complexity, not just LOC.

3. **"Can I change levels mid-work?"**

   Yes. Going up: add additional files (Level 0→1: add spec.md, 1→2: add plan.md). Going down: keep existing docs. Inform user why level changed.

4. **"What if it's just exploration?"**

   Pure exploration/reading = NO spec needed. **Once you write/edit ANY files = SPEC REQUIRED.**

5. **"Do I need specs for documentation changes?"**

   **YES - Documentation changes require specs just like code changes.**

   Guidelines:
   - **Code files** (*.js, *.ts, *.css, *.py, etc.) → **Spec required**
   - **Documentation files** (*.md, *.txt, docs/, etc.) → **Spec required** if modifying content
   - **Configuration files** (*.json, *.yaml, *.toml, etc.) → **Spec required**
   - **Knowledge base files** (.claude/knowledge/*.md) → **Spec required**
   - **Template files** (.specify/templates/*.md) → **Spec required**

   **Exceptions (no spec needed):**
   - Single typo fix in one file (<5 characters changed)
   - Whitespace-only changes
   - Auto-generated file updates (package-lock.json, etc.)

   **When in doubt:** Create a spec folder. Better to over-document than under-document.

6. **"When do I create a retrospective?"**

   Create `retrospective.md` AFTER feature completion (Level 2/3). Captures: what went well/poorly, lessons learned, metrics achieved vs targets, action items for future work.

7. **"When do I need an Architecture Decision Record (ADR)?"**

   Create `decision-record-*.md` when making significant technical decisions:
   - Choosing between databases, frameworks, or libraries
   - Selecting architectural patterns (microservices vs monolith, etc.)
   - Major refactoring approaches
   - Infrastructure/deployment strategy changes

   Store in `decision-records/` subfolder within spec folder.

8. **"When do I create a spike?"**

   Create `spike-*.md` BEFORE implementation when:
   - Technical feasibility unknown
   - Need to evaluate multiple libraries/approaches
   - Research required (performance testing, proof of concept)
   - Time-boxed exploration needed (typically 1-3 days)

   Spike results inform the spec and plan documents.

---

**Remember**: Every file change (code, documentation, configuration, etc.) deserves documentation. Future you will thank present you for creating that spec folder. When in doubt, document more rather than less—the cost of creating a spec is tiny compared to reconstructing lost context later.