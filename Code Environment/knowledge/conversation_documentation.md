# Conversation Documentation - Mandatory Spec System

Mandatory specification folder system for all conversations involving file changes. Every conversation that modifies files (code, documentation, configuration, etc.) requires documentation in `/specs/[###-short-name]/` before changes begin. This ensures context preservation, debugging capability, smooth handoffs, and searchable project history. Documentation level scales with complexity: minimal README for trivial changes to full SpecKit for complex features.

#### 📋 TABLE OF CONTENTS

1. [🎯 WHY DOCUMENTATION IS MANDATORY](#1--why-documentation-is-mandatory)
2. [📊 LEVEL DECISION FRAMEWORK](#2--level-decision-framework)
3. [📁 LEVEL SPECIFICATIONS](#3--level-specifications)
4. [🛠️ IMPLEMENTATION GUIDE](#4-️-implementation-guide)
5. [📋 TEMPLATES AND STRUCTURE](#5--templates-and-structure)
6. [🎭 REAL EXAMPLES BY LEVEL](#6--real-examples-by-level)
7. [🚦 AUTOMATION AND WORKFLOW](#7--automation-and-workflow)
8. [🏎️ QUICK REFERENCE](#8-️-quick-reference)
9. [🔍 TROUBLESHOOTING](#9--troubleshooting)

---

## 1. 🎯 WHY DOCUMENTATION IS MANDATORY

### The Problem Without Documentation

Changes without context create technical debt. Conversations disappear, decisions are forgotten, and debugging becomes archaeology. Six months later, when a bug surfaces, you're left asking:
- Why was this implemented this way?
- What alternatives were considered?
- What constraints influenced the design?

Without answers, you're debugging blind.

### What Requires Spec Folders

**Spec folders are REQUIRED for ALL file modifications:**

| File Type | Requires Spec | Examples |
|-----------|--------------|----------|
| Code files | ✅ Yes | JavaScript, TypeScript, Python, CSS, HTML |
| Documentation | ✅ Yes | Markdown, README updates, guides |
| Configuration | ✅ Yes | JSON, YAML, TOML, .env templates |
| Knowledge base | ✅ Yes | `.claude/knowledge/*.md` updates |
| Templates | ✅ Yes | `.specify/templates/*.md` modifications |
| Build/tooling | ✅ Yes | package.json, requirements.txt, Dockerfile |

**Exceptions (no spec needed):**
- ❌ Pure exploration/reading (no file modifications)
- ❌ Single typo fixes (<5 characters in one file)
- ❌ Whitespace-only changes
- ❌ Auto-generated file updates (package-lock.json)

**Rule of thumb:** If you're modifying ANY file content → Create spec folder first.

### Key Benefits

- **Complete history** - Every change documented with rationale and context
- **Easy debugging** - Understand original intent when bugs surface
- **Better handoffs** - Context doesn't live in someone's head
- **Knowledge preserved** - Searchable archive of all implementation decisions

---

## 2. 📊 LEVEL DECISION FRAMEWORK

### Level Decision Matrix

| Level | LOC Range | Core Files | Use When | Example Scenarios |
|-------|-----------|------------|----------|------------------|
| **0: Trivial** | <10 | `README.md` | Single isolated change, no complexity | Typo fix, comment update |
| **1: Simple** | <100 | `spec.md` | Localized change, clear requirements | Bug fix, small enhancement |
| **2: Moderate** | 100-499 | `spec.md` + `plan.md` | Multiple files, moderate complexity | New feature, refactoring |
| **3: Complex** | ≥500 | Full SpecKit | High complexity, multiple systems | Major features, system redesign |

### Decision Factors

**Primary factor: Lines of Code (LOC)**
- Count all files being modified
- Include new files
- Estimate conservatively (round up)

**Secondary factors that can override LOC:**
- **Complexity** - Simple refactor vs architectural change
- **Risk** - Config cascades, authentication changes
- **Dependencies** - Multiple systems affected
- **Testing needs** - Integration vs unit tests

### Edge Case Guidance

| Scenario | LOC | Suggested Level | Rationale |
|----------|-----|----------------|-----------|
| Typo in one file | 1 | Level 0 | Truly trivial |
| Typo across 5 files | 5 | Level 1 | Multi-file coordination |
| 95 LOC feature | 95 | Level 1 | Under threshold |
| 105 LOC feature | 105 | Level 2 | Just over, safer with plan |
| Refactor (no new logic) | 200 | Level 2 | Complexity matters more than LOC |
| Config cascade | 50 | Level 2 | Risk trumps LOC |
| Authentication change | 80 | Level 2 | Security implications require planning |

**When in doubt:** Choose higher level. Better to over-document than under-document.

---

## 3. 📁 LEVEL SPECIFICATIONS

### Level 0: Trivial Changes (<10 LOC)

**When to use:**
- Single, isolated change
- No complexity or risk
- One file affected (or multiple files with same trivial change)

**Required files:**
- `README.md` (from `concise_readme_template.md`)

**Content expectations:**
- Brief description of change
- Files affected
- Reason for change
- Testing performed (if any)

**Example scenarios:**
- Fix "Eror" → "Error" typo
- Update comment for clarity
- Whitespace cleanup in one function

**Template source:** `.specify/templates/concise_readme_template.md`

---

### Level 1: Simple Changes (<100 LOC)

**When to use:**
- Localized to one component or module
- Clear, well-defined requirements
- Low to moderate complexity
- Minimal dependencies

**Required files:**
- `spec.md` (from `concise_spec_template.md`)

**Optional files:**
- `checklist.md` (when systematic validation needed)

**Content expectations:**
- Problem statement or feature description
- Proposed solution
- Files to change
- Testing approach
- Success criteria

**Example scenarios:**
- Add email validation to contact form
- Fix bug in calculation logic
- Add loading spinner to form submission
- Update error message formatting

**Escalate to Level 2 if:**
- Affects multiple systems
- Requires architectural decisions
- Needs complex testing strategy
- Dependencies on other changes

**Template source:** `.specify/templates/concise_spec_template.md`

---

### Level 2: Moderate Features (100-499 LOC)

**When to use:**
- Multiple files or components affected
- Moderate complexity
- Requires planning and coordination
- Integration considerations

**Required files:**
- `spec.md` (from `spec_template.md`) - What we're building and why
- `plan.md` (from `plan_template.md`) - How we'll build it

**Optional files:**
- `tasks.md` - After plan.md, before coding (breaks plan into actionable tasks)
- `checklist.md` - When systematic validation needed (QA, security review)
- `spike-[name].md` - Before implementation if research needed
- `decision-record-[name].md` - For significant technical decisions
- `retrospective.md` - After completion (captures learnings)

**Content expectations:**

**spec.md:**
- Detailed requirements
- Technical approach
- Alternatives considered
- Success criteria
- Risks and mitigations

**plan.md:**
- Implementation steps (ordered)
- File changes breakdown
- Testing strategy
- Rollout plan
- Dependencies

**Example scenarios:**
- Create reusable modal component with animations
- Implement form validation framework
- Add authentication flow
- Migrate from library A to library B

**Escalate to Level 3 if:**
- Discover >500 LOC during implementation
- Complexity increases substantially
- Need multiple developers
- Requires extensive research or spikes

**Template sources:**
- `.specify/templates/spec_template.md`
- `.specify/templates/plan_template.md`

---

### Level 3: Complex Features (≥500 LOC)

**When to use:**
- High complexity
- Multiple systems or components
- Requires coordination
- Significant architectural impact

**Process:**
Use `/speckit.specify` slash command - it auto-generates all core files

**Auto-generated files:**
- `spec.md` - Feature specification
- `plan.md` - Implementation plan
- `tasks.md` - Task breakdown
- `research.md` - Research findings
- `data-model.md` - Data structures
- `quickstart.md` - Getting started guide
- `contracts/` - API contracts directory

**Optional files (copy manually):**
- `checklist.md` (from `checklist_template.md`)
- `spike-[name].md` (from `spike_template.md`)
- `decision-record-[name].md` (from `decision_record_template.md`)
- `retrospective.md` (from `retrospective_template.md`)

**Example scenarios:**
- Major feature implementation (user dashboard)
- System redesign (payment flow v2)
- Architecture changes (microservices migration)
- Multi-team projects

**Note:** SpecKit handles Level 3 automatically - don't create core files manually.

---

## 4. 🛠️ IMPLEMENTATION GUIDE

### Template Location

**All templates located in:** `.specify/templates/`

**AI Agent Rules:**
- **ALWAYS** copy templates from `.specify/templates/`
- **NEVER** create documentation files from scratch
- **SELECT** appropriate template based on documentation level
- **ADAPT** template content to specific feature (remove placeholders, fill actual content)

### Core Templates by Level

| Level | Template File | Copy As | Command |
|-------|--------------|---------|---------|
| 0 | `concise_readme_template.md` | `README.md` | `cp .specify/templates/concise_readme_template.md specs/###-name/README.md` |
| 1 | `concise_spec_template.md` | `spec.md` | `cp .specify/templates/concise_spec_template.md specs/###-name/spec.md` |
| 2 | `spec_template.md`<br>`plan_template.md` | `spec.md`<br>`plan.md` | `cp .specify/templates/spec_template.md specs/###-name/spec.md`<br>`cp .specify/templates/plan_template.md specs/###-name/plan.md` |
| 3 | SpecKit auto-generates | Multiple files | `/speckit.specify` command |

### Supporting Templates (Optional)

Additional templates for specific needs:

| Template File | Copy As | When to Use | Command |
|--------------|---------|-------------|---------|
| `tasks_template.md` | `tasks.md` | After plan.md, before coding - breaks plan into actionable tasks | `cp .specify/templates/tasks_template.md specs/###-name/tasks.md` |
| `checklist_template.md` | `checklist.md` | When systematic validation needed (QA, security, deployment) | `cp .specify/templates/checklist_template.md specs/###-name/checklist.md` |
| `retrospective_template.md` | `retrospective.md` | After Level 2/3 completion - captures learnings and metrics | `cp .specify/templates/retrospective_template.md specs/###-name/retrospective.md` |
| `decision_record_template.md` | `decision-record-[name].md` | Major technical decisions (database choice, architecture) | `cp .specify/templates/decision_record_template.md specs/###-name/decision-record-[topic].md` |
| `spike_template.md` | `spike-[name].md` | Before uncertain work - research, POC, feasibility | `cp .specify/templates/spike_template.md specs/###-name/spike-[topic].md` |

**Supporting template notes:**
- Use descriptive names for decision records and spikes
- Multiple decision records/spikes can exist per spec folder
- Only copy when explicitly needed (not mandatory)

### Folder Structure Examples

**Level 0:**
```
specs/042-fix-form-typo/
└── README.md                    (from concise_readme_template.md)
```

**Level 1:**
```
specs/043-add-email-validation/
├── spec.md                      (from concise_spec_template.md)
└── checklist.md                 (optional, from checklist_template.md)
```

**Level 2:**
```
specs/044-modal-component/
├── spec.md                      (from spec_template.md)
├── plan.md                      (from plan_template.md)
├── tasks.md                     (optional, from tasks_template.md)
├── checklist.md                 (optional, from checklist_template.md)
├── spike-animation-perf.md      (optional, from spike_template.md)
├── decision-record-library.md   (optional, from decision_record_template.md)
└── retrospective.md             (post-implementation, from retrospective_template.md)
```

**Level 3:**
```
specs/045-user-dashboard/
├── spec.md                      (SpecKit auto-generated)
├── plan.md                      (SpecKit auto-generated)
├── tasks.md                     (SpecKit auto-generated)
├── research.md                  (SpecKit auto-generated)
├── data-model.md                (SpecKit auto-generated)
├── quickstart.md                (SpecKit auto-generated)
├── contracts/                   (SpecKit auto-generated)
├── checklist.md                 (optional, manual copy)
└── retrospective.md             (optional, manual copy)
```

### Template Structure Requirements

**All templates follow consistent structure:**

1. **Numbered H2 sections** - Format: `## N. EMOJI TITLE`
   - Example: `## 3. 🛠️ IMPLEMENTATION`
   - Keep numbering sequential
   - Never remove emojis

2. **Metadata block** - First section sets expectations
   - Level 0: Date, Type, Level, LOC
   - Level 1: Metadata + Complexity + Success Criteria
   - Level 2/3: Category, Tags, Priority, Status

3. **Placeholder conventions**
   - `[PLACEHOLDER]` - Must be replaced
   - `[NEEDS CLARIFICATION: ...]` - Unknown requirement
   - `<!-- SAMPLE CONTENT -->` - Remove before delivery

4. **Template footer** - Accountability reminder
   ```html
   <!--
     REPLACE SAMPLE CONTENT IN FINAL OUTPUT
     - This template contains placeholders and examples
     - Replace them with actual content
   -->
   ```

### Template Adherence Rules

**Non-negotiable rules:**

1. **Always copy from `.specify/templates/`** - Never freehand documentation
2. **Preserve numbering and emojis** - Maintain visual scanning pattern
3. **Fill every placeholder** - Replace `[PLACEHOLDER]` with actual content
4. **Remove instructional comments** - Delete `<!-- SAMPLE -->` blocks
5. **Use descriptive filenames** - `decision-record-[topic].md`, not `decision-record-final.md`
6. **Keep sections relevant** - State "N/A" instead of deleting sections
7. **Link sibling documents** - Cross-reference spec.md ↔ plan.md ↔ tasks.md
8. **Document level changes** - Note upgrades/downgrades in changelog
9. **Keep history immutable** - Append to history, don't rewrite
10. **Validate before coding** - Complete pre-implementation checklist first

---

## 5. 📋 TEMPLATES AND STRUCTURE

### Folder Naming Convention

**Format:** `specs/###-short-name/`

**Rules:**
- 2-4 words
- Lowercase
- Hyphen-separated
- Action-noun structure

**Good examples:**
- `fix-typo`
- `add-validation`
- `implement-auth`
- `cdn-migration`
- `hero-animation-v2`

**Bad examples:**
- ❌ `fix-the-typo-in-header-component` (too long - max 4 words)
- ❌ `fixTypo` (not kebab-case)
- ❌ `fix_typo` (snake_case, should be kebab-case)
- ❌ `typo` (too vague, lacks context)
- ❌ `PROJ-123-fix` (no ticket numbers)

### Number Padding

- Use 3 digits: `001`, `002`, `042`, `099`
- No padding past 999: `1000`, `1001`, `1002`

### Finding Next Number

**Command:**
```bash
ls -d specs/[0-9]*/ | sed 's/.*\/\([0-9]*\)-.*/\1/' | sort -n | tail -1
```

**Then add 1 to get next number.**

### Step-by-Step Creation Process

1. **Determine documentation level** (0/1/2/3) using Section 2 decision matrix
2. **Find next spec number** using command above
3. **Create folder:** `mkdir -p specs/###-short-name/`
4. **Copy appropriate templates:**
   - Level 0: Copy `concise_readme_template.md` → `README.md`
   - Level 1: Copy `concise_spec_template.md` → `spec.md`
   - Level 2: Copy `spec_template.md` → `spec.md` AND `plan_template.md` → `plan.md`
   - Level 3: Run `/speckit.specify` command
5. **Fill template content:**
   - Replace ALL `[PLACEHOLDER]` text
   - Remove sample/example sections
   - Adapt to specific feature
6. **Add supporting templates if needed** (tasks, checklist, spike, decision-record)
7. **Present to user:**
   - Show level chosen
   - Show folder path
   - Show which templates used
   - Explain approach
8. **Wait for approval** - Get explicit "yes/go ahead/proceed"

---

## 6. 🎭 REAL EXAMPLES BY LEVEL

### Core Principle

**Before creating a new spec folder, ALWAYS check if related work already exists.** Reusing existing specs preserves context, maintains continuity, and prevents documentation fragmentation.

### When to UPDATE Existing Spec

Update an existing spec folder when:

✅ **Iterative development** - Continuing work on same feature across sessions
- Example: Initial implementation → bug fixes → enhancements

✅ **Bug fixes** - Fixing issues in existing implementation
- Example: "Fix alignment bug in markdown-c7-optimizer" → Update markdown-c7-optimizer spec

✅ **Scope escalation** - Work grows beyond original estimate
- Example: Level 1 bug fix → Requires Level 2 refactor → Add plan.md to same folder

✅ **Feature enhancement** - Adding to existing functionality
- Example: "Add dark mode to modal" → Update modal-component spec

✅ **Resuming paused work** - Continuing previously paused implementation
- Example: Spec status: paused → active (add continuation notes)

### When to CREATE New Spec

Create a new spec folder when:

❌ **Distinct feature** - Completely separate functionality
- Example: "markdown-c7-optimizer" ≠ "markdown-validator" (different purposes)

❌ **Different approach** - Alternative implementation strategy
- Example: "hero-animation-css" vs "hero-animation-js" (different approaches)

❌ **Separate user story** - Different requirement or use case
- Example: "user-authentication" ≠ "user-profile" (separate stories)

❌ **Complete redesign** - Starting over with new architecture
- Example: "payment-flow-v2" (complete rewrite of v1)

❌ **Unrelated work** - No connection to existing specs
- Example: "add-search-feature" ≠ "fix-form-validation" (different areas)

### Status Field Convention

**Every spec.md should include status field:**

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

**Status lifecycle:**
```
draft → active → complete → archived
   ↓       ↓
paused  paused
   ↓
active (resume)
```

### Decision Flowchart

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

### Level Migration During Implementation

**If scope grows:**

| From Level | To Level | Action | Document Change |
|-----------|----------|--------|----------------|
| 0 → 1 | Add `spec.md` to same folder | Add changelog entry |
| 1 → 2 | Add `plan.md` to same folder | Update level field, add changelog |
| 2 → 3 | Use `/speckit.plan` in same folder | Update level field, add changelog |

**Changelog example:**
```markdown
## Change Log
- 2025-11-15: Created as Level 1 (simple bug fix)
- 2025-11-16: Escalated to Level 2 (discovered architectural changes needed)
```

---

## 7. 🚦 AUTOMATION AND WORKFLOW

### Mandatory Process for AI Agents

**Before making ANY file changes (code, docs, config, templates), MUST:**

1. **Determine documentation level** (0/1/2/3) based on LOC and complexity
2. **Check for related specs** using keyword search
3. **Present reuse decision to user** if related specs found
4. **Find next spec number:** `ls -d specs/[0-9]*/ | sed 's/.*\/\([0-9]*\)-.*/\1/' | sort -n | tail -1`
5. **Create spec folder:** `mkdir -p specs/###-short-name/`
6. **Copy appropriate templates from `.specify/templates/`:**
   - Level 0: `concise_readme_template.md` → `README.md`
   - Level 1: `concise_spec_template.md` → `spec.md`
   - Level 2: `spec_template.md` → `spec.md` AND `plan_template.md` → `plan.md`
   - Level 3: Use `/speckit.specify` command
7. **Fill template content:**
   - Replace ALL `[PLACEHOLDER]` text
   - Remove sample/example sections
   - Adapt to specific feature
8. **Add supporting templates if needed:**
   - `tasks_template.md` → `tasks.md` (after plan, before coding)
   - `checklist_template.md` → `checklist.md` (validation needs)
   - `spike_template.md` → `spike-[name].md` (research required)
   - `decision_record_template.md` → `decision-record-[name].md` (major decisions)
9. **Present to user:**
   - Documentation level chosen
   - Spec folder path
   - Templates used
   - Implementation approach
10. **Wait for approval** - Get explicit "yes/go ahead/proceed" before ANY file changes

### Critical Agent Rules

- **NEVER** create documentation files from scratch
- **ALWAYS** copy from `.specify/templates/` directory
- **ALWAYS** rename copied files correctly
- **ALWAYS** fill in actual content (remove placeholders)
- **Applies to ALL file changes:** code, documentation, configuration, templates, knowledge base files

### Enforcement Checkpoints

1. **Request Analysis** - Classify Level 0/1/2/3 based on scope
2. **Template Selection** - Copy correct templates from `.specify/templates/`
3. **Content Adaptation** - Fill templates with actual content
4. **Pre-Change Validation** - Verify spec folder exists with filled templates (BLOCKER)
5. **User Approval** - Get explicit "yes" before modifications
6. **Final Review** - Confirm documentation complete

---

## 8. 🏎️ QUICK REFERENCE

### Level Decision Shortcuts

| Situation | Level | Core Templates | Supporting Templates |
|-----------|-------|----------------|---------------------|
| Typo, <10 lines | 0 | README.md | - |
| Bug fix, <100 lines | 1 | spec.md | checklist.md |
| Feature, <500 lines | 2 | spec.md + plan.md | tasks.md, checklist.md, spike-*.md |
| Complex, 500+ lines | 3 | SpecKit (auto) | checklist.md, retrospective.md |

### Template Copy Commands

**Core templates:**
```bash
## Level 0:
cp .specify/templates/concise_readme_template.md specs/###-name/README.md

## Level 1:
cp .specify/templates/concise_spec_template.md specs/###-name/spec.md

## Level 2:
cp .specify/templates/spec_template.md specs/###-name/spec.md
cp .specify/templates/plan_template.md specs/###-name/plan.md
```

**Supporting templates:**
```bash
## Tasks (after plan, before coding):
cp .specify/templates/tasks_template.md specs/###-name/tasks.md

## Checklist (validation needs):
cp .specify/templates/checklist_template.md specs/###-name/checklist.md

## Retrospective (post-completion):
cp .specify/templates/retrospective_template.md specs/###-name/retrospective.md

## Decision Record (use descriptive name):
cp .specify/templates/decision_record_template.md specs/###-name/decision-record-database.md

## Spike (use descriptive name):
cp .specify/templates/spike_template.md specs/###-name/spike-performance.md
```

### Pre-Implementation Checklist

Before making ANY file changes, verify:

- [ ] Determined level (0/1/2/3)
- [ ] Created `/specs/[###-short-name]/`
- [ ] Copied appropriate templates from `.specify/templates/`
- [ ] Renamed templates correctly
- [ ] Filled core template sections with actual content
- [ ] Removed placeholder text and sample sections
- [ ] Identified and copied needed supporting templates
- [ ] Presented approach to user (including templates used)
- [ ] Got explicit approval

**If ANY unchecked → STOP**

---

## 9. 🔍 TROUBLESHOOTING

### "I forgot to create the spec folder"

**Fix:** Stop coding immediately. Create spec folder retroactively, document what was done and why, get user approval, then continue.

### "I'm not sure which level to choose"

**Solution:** When in doubt, choose the **higher level**. Ask user if confidence <80%. Consider complexity and risk, not just LOC.

### "Can I change levels mid-work?"

**Yes:**
- Going up: Add additional files
  - 0→1: Add spec.md
  - 1→2: Add plan.md
  - 2→3: Use `/speckit.plan`
- Going down: Keep existing docs
- Always: Inform user why level changed, update changelog

### "What if it's just exploration?"

**Rule:** Pure exploration/reading = NO spec needed. Once you write/edit ANY files = SPEC REQUIRED.

### "Do I need specs for documentation changes?"

**YES - Documentation changes require specs just like code changes.**

**Requires spec:**
- ✅ Code files (*.js, *.ts, *.css, *.py)
- ✅ Documentation files (*.md, *.txt, docs/)
- ✅ Configuration files (*.json, *.yaml, *.toml)
- ✅ Knowledge base (.claude/knowledge/*.md)
- ✅ Templates (.specify/templates/*.md)
- ✅ Build files (package.json, requirements.txt)

**Exceptions (no spec needed):**
- ❌ Single typo fix (<5 characters in one file)
- ❌ Whitespace-only changes
- ❌ Auto-generated updates (package-lock.json)

**When in doubt:** Create a spec folder. Better to over-document.

### "When do I create a retrospective?"

**Answer:** Create `retrospective.md` AFTER feature completion (Level 2/3). Captures:
- What went well/poorly
- Lessons learned
- Metrics achieved vs targets
- Action items for future work

### "When do I need an Architecture Decision Record (ADR)?"

**Create `decision-record-*.md` when making:**
- Database, framework, or library choices
- Architectural pattern selections
- Major refactoring approaches
- Infrastructure/deployment strategy changes

### "When do I create a spike?"

**Create `spike-*.md` BEFORE implementation when:**
- Technical feasibility unknown
- Need to evaluate multiple approaches
- Research required (performance, POC)
- Time-boxed exploration needed (1-3 days)

**Spike results inform spec and plan documents.**

---

**Core principle:** Every file change (code, documentation, configuration, etc.) deserves documentation. Future you will thank present you for creating that spec folder. When in doubt, document more rather than less—the cost of creating a spec is tiny compared to reconstructing lost context later.
