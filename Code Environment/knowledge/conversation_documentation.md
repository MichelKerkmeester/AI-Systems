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
**Files:** `README.md` (concise-readme-template.md)
**Content:** Brief description, files affected, reason
**Examples:** Typo fixes, comment updates, whitespace cleanup

---

### Level 1: Simple (<100 LOC)

**Criteria:** Localized to one component, clear requirements, low complexity
**Files:** `spec.md` (concise-spec-template.md)
**Content:** Problem statement, solution, files to change, testing notes
**Examples:** Bug fixes, small enhancements, simple features
**Escalate to Level 2 if:** Affects multiple systems, architectural decisions, complex testing

---

### Level 2: Moderate (100-499 LOC)

**Criteria:** Multiple files/components, moderate complexity, requires planning
**Files:** `spec.md` + `plan.md` (spec-template.md + plan-template.md)
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
   - Level 0: `cp .specify/templates/concise-readme-template.md specs/###-short-name/README.md`
   - Level 1: `cp .specify/templates/concise-spec-template.md specs/###-short-name/spec.md`
   - Level 2: `cp .specify/templates/spec-template.md specs/###-short-name/spec.md && cp .specify/templates/plan-template.md specs/###-short-name/plan.md`
   - Level 3: Use `/speckit.specify` command (auto-generates)
5. **Fill Template:** Replace placeholders with actual content, remove sample sections
6. **Add Supporting Templates (if needed):**
   - For tasks: `cp .specify/templates/tasks-template.md specs/###-short-name/tasks.md`
   - For checklist: `cp .specify/templates/checklist-template.md specs/###-short-name/checklist.md`
   - For retrospective: `cp .specify/templates/retrospective-template.md specs/###-short-name/retrospective.md`
   - For ADR: `cp .specify/templates/decision-record-template.md specs/###-short-name/decision-record-[name].md`
   - For spike: `cp .specify/templates/spike-template.md specs/###-short-name/spike-[name].md`
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
| 0 | `concise-readme-template.md` | `README.md` | Trivial changes (<10 LOC) |
| 1 | `concise-spec-template.md` | `spec.md` | Simple changes (<100 LOC) |
| 2 | `spec-template.md` + `plan-template.md` | `spec.md` + `plan.md` | Moderate complexity (100-499 LOC) |
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
| `tasks-template.md` | `tasks.md` | Implementation task breakdown | Level 2/3 - after plan.md is complete, before coding |
| `checklist-template.md` | `checklist.md` | Validation & QA checklists | Any level - when systematic validation needed |
| `retrospective-template.md` | `retrospective.md` | Post-implementation review | After Level 2/3 feature completion |
| `decision-record-template.md` | `decision-record-[name].md` | Architecture Decision Records (ADR) | When making significant technical decisions |
| `spike-template.md` | `spike-[name].md` | Research & experimentation | Before implementation - time-boxed research |

**Supporting Template Usage:**
- Copy from `.specify/templates/` to spec folder when needed
- Use descriptive names for decision records and spikes (e.g., `decision-record-database-choice.md`, `spike-performance-testing.md`)
- Multiple decision records and spikes can exist in one spec folder
- Supporting templates are **optional** - only use when explicitly needed

### Folder Structures

```
Level 0: specs/###-name/
├── README.md                    (from concise-readme-template.md)

Level 1: specs/###-name/
├── spec.md                      (from concise-spec-template.md)
└── checklist.md                 (optional, from checklist-template.md)

Level 2: specs/###-name/
├── spec.md                      (from spec-template.md)
├── plan.md                      (from plan-template.md)
├── tasks.md                     (optional, from tasks-template.md)
├── checklist.md                 (optional, from checklist-template.md)
├── spike-[name].md              (optional, from spike-template.md)
├── decision-record-[name].md    (optional, from decision-record-template.md)
└── retrospective.md             (post-implementation, from retrospective-template.md)

Level 3: specs/###-name/
├── spec.md                      (SpecKit auto-generated)
├── plan.md                      (SpecKit auto-generated)
├── tasks.md                     (SpecKit auto-generated)
├── research.md                  (SpecKit auto-generated)
├── data-model.md                (SpecKit auto-generated)
├── quickstart.md                (SpecKit auto-generated)
├── contracts/                   (SpecKit auto-generated)
├── checklist.md                 (optional, from checklist-template.md)
├── spike-[name].md              (optional, from spike-template.md)
├── decision-record-[name].md    (optional, from decision-record-template.md)
└── retrospective.md             (post-implementation, from retrospective-template.md)
```

**Template Source Reference:**
- All templates copied from `.specify/templates/` directory
- Core templates (README, spec, plan) are **required** based on level
- Supporting templates (tasks, checklist, retrospective, decision-record, spike) are **optional**
- Level 3 uses SpecKit auto-generation for core files, but can still use supporting templates

### When to Use Supporting Templates

**tasks.md** (from `tasks-template.md`)
- **When**: After plan.md is complete, before implementation begins
- **Purpose**: Breaks plan into actionable tasks organized by user story
- **Copy**: `cp .specify/templates/tasks-template.md specs/###-name/tasks.md`

**checklist.md** (from `checklist-template.md`)
- **When**: When systematic validation needed (pre-implementation, QA, security review, deployment readiness)
- **Purpose**: Validation and quality assurance checklists
- **Copy**: `cp .specify/templates/checklist-template.md specs/###-name/checklist.md`

**retrospective.md** (from `retrospective-template.md`)
- **When**: AFTER feature is complete (Level 2/3)
- **Purpose**: Captures learnings, metrics achieved, what went well/poorly
- **Copy**: `cp .specify/templates/retrospective-template.md specs/###-name/retrospective.md`

**decision-record-[name].md** (from `decision-record-template.md`)
- **When**: Making significant architectural/technical decisions
- **Purpose**: Architecture Decision Records (ADRs) documenting major technical choices
- **Copy**: `cp .specify/templates/decision-record-template.md specs/###-name/decision-record-[descriptive-name].md`
- **Examples**: `decision-record-database-choice.md`, `decision-record-api-framework.md`

**spike-[name].md** (from `spike-template.md`)
- **When**: BEFORE implementation when research/experimentation needed
- **Purpose**: Time-boxed exploration and proof-of-concept work
- **Copy**: `cp .specify/templates/spike-template.md specs/###-name/spike-[descriptive-name].md`
- **Examples**: `spike-performance-testing.md`, `spike-library-evaluation.md`

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

## 7. 🚦 AUTOMATION & WORKFLOW

### Agent Auto-Creation Workflow

**AI Agent MUST Follow This Process:**

1. **Determine documentation level** (0/1/2/3) based on LOC and complexity
2. **Find next spec number** using: `ls -d specs/[0-9]*/ | sed 's/.*\/\([0-9]*\)-.*/\1/' | sort -n | tail -1`
3. **Create spec folder** with correct naming: `specs/###-short-name/`
4. **Copy appropriate templates from `.specify/templates/`:**
   - Level 0: Copy `concise-readme-template.md` → `README.md`
   - Level 1: Copy `concise-spec-template.md` → `spec.md`
   - Level 2: Copy `spec-template.md` → `spec.md` AND `plan-template.md` → `plan.md`
   - Level 3: Use `/speckit.specify` command (auto-generates all files)
5. **Fill template content:**
   - Replace ALL `[PLACEHOLDER]` text with actual content
   - Remove sample/example sections marked with comments
   - Adapt structure to specific feature needs
   - Keep only relevant sections
6. **Add supporting templates if needed:**
   - Copy `tasks-template.md` if breaking down implementation
   - Copy `checklist-template.md` if validation needed
   - Copy `spike-template.md` if research required
   - Copy `decision-record-template.md` if architectural decision needed
7. **Present to user:**
   - Show documentation level chosen
   - Show spec folder path
   - Show which templates were used
   - Explain approach
8. **Wait for approval** - Get explicit "yes/go ahead/proceed" before making ANY file changes

**Critical Rules:**
- **NEVER** create documentation files from scratch
- **ALWAYS** copy from `.specify/templates/` directory
- **ALWAYS** rename copied files correctly (e.g., `concise-spec-template.md` → `spec.md`)
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

## 8. 🏎️ QUICK REFERENCE

### Decision Shortcuts

| Situation | Level | Core Templates | Copy Command | Optional Templates |
|-----------|-------|---------------|--------------|-------------------|
| Typo, <10 lines | 0 | `concise-readme-template.md` → `README.md` | `cp .specify/templates/concise-readme-template.md specs/###-name/README.md` | - |
| Bug fix, <100 lines | 1 | `concise-spec-template.md` → `spec.md` | `cp .specify/templates/concise-spec-template.md specs/###-name/spec.md` | checklist.md |
| Feature, <500 lines | 2 | `spec-template.md` → `spec.md`<br>`plan-template.md` → `plan.md` | `cp .specify/templates/spec-template.md specs/###-name/spec.md`<br>`cp .specify/templates/plan-template.md specs/###-name/plan.md` | tasks.md, checklist.md, spike-*.md, decision-record-*.md |
| Complex, 500+ lines | 3 | Use `/speckit.specify` | `/speckit.specify` command | checklist.md, spike-*.md, decision-record-*.md, retrospective.md |

### Supporting Template Usage

| Template File | Copy As | Create When | Example Scenario |
|--------------|---------|-------------|------------------|
| `tasks-template.md` | `tasks.md` | After plan.md, before coding | Breaking down implementation into actionable tasks |
| `checklist-template.md` | `checklist.md` | When validation needed | QA checklist, security review, deployment readiness |
| `retrospective-template.md` | `retrospective.md` | After feature complete | Post-mortem, learnings capture, metrics review |
| `spike-template.md` | `spike-[name].md` | Before uncertain work | Researching libraries, proof of concept, feasibility study |
| `decision-record-template.md` | `decision-record-[name].md` | Major technical decision | Choosing database, architecture pattern, framework |

### Template Copy Commands

**Core Templates:**
```bash
# Level 0
cp .specify/templates/concise-readme-template.md specs/###-name/README.md

# Level 1
cp .specify/templates/concise-spec-template.md specs/###-name/spec.md

# Level 2
cp .specify/templates/spec-template.md specs/###-name/spec.md
cp .specify/templates/plan-template.md specs/###-name/plan.md
```

**Supporting Templates:**
```bash
# Tasks
cp .specify/templates/tasks-template.md specs/###-name/tasks.md

# Checklist
cp .specify/templates/checklist-template.md specs/###-name/checklist.md

# Retrospective
cp .specify/templates/retrospective-template.md specs/###-name/retrospective.md

# Decision Record (use descriptive name)
cp .specify/templates/decision-record-template.md specs/###-name/decision-record-database-choice.md

# Spike (use descriptive name)
cp .specify/templates/spike-template.md specs/###-name/spike-performance-testing.md
```

### Pre-Implementation Checklist

- [ ] Determined level (0/1/2/3)
- [ ] Created `/specs/[###-short-name]/`
- [ ] Copied appropriate templates from `.specify/templates/`
- [ ] Renamed templates correctly (e.g., `concise-spec-template.md` → `spec.md`)
- [ ] Filled core template sections with actual content
- [ ] Removed placeholder text and sample sections
- [ ] Identified and copied needed supporting templates
- [ ] Presented approach to user (including which templates used)
- [ ] Got explicit approval

**If ANY unchecked → STOP**

---

## 9. 🔍 TROUBLESHOOTING

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