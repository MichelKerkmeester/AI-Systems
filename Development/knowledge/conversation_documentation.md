# Conversation Documentation - Mandatory Spec System

Defines the mandatory specification folder system for all conversations involving code or file changes.

Every implementation conversation requires documentation in `/specs/[###-short-name]/` before code changes begin. This ensures context preservation, debugging capability, smooth handoffs, and searchable project history. Documentation level scales with complexity: minimal README for trivial changes to full SpecKit for complex features.

---

## 1. 🎯 PURPOSE & BENEFITS

### Why Mandatory?

Code without context creates technical debt. Conversations disappear, decisions are forgotten, and debugging becomes archaeology. Spec folders solve this by preserving the complete decision trail.

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

1. **Determine Level:** Estimate LOC + assess complexity
2. **Find Next Number:** `ls -d specs/[0-9]*/ | sed 's/.*\/\([0-9]*\)-.*/\1/' | sort -n | tail -1` (add 1)
3. **Create Folder:** `mkdir -p specs/###-short-name/`
4. **Copy Template:** From `.specify/templates/` to spec folder
5. **Fill Template:** Adapt sections to your needs
6. **Present:** Show user level, folder, approach
7. **Get Approval:** Wait for explicit "yes/go ahead/proceed"

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

### Core Templates by Level

All in `.specify/templates/`:

| Level | Template | Files Created | When to Use |
|-------|----------|---------------|-------------|
| 0 | concise-readme-template.md | README.md | Trivial changes (<10 LOC) |
| 1 | concise-spec-template.md | spec.md | Simple changes (<100 LOC) |
| 2 | spec-template.md + plan-template.md | spec.md + plan.md | Moderate complexity (100-499 LOC) |
| 3 | SpecKit auto-generates | Multiple files | Complex features (≥500 LOC) |

### Supporting Templates

Additional templates for specific needs:

| Template | Purpose | When to Use |
|----------|---------|-------------|
| tasks-template.md | Implementation task breakdown | Level 2/3 - after plan.md is complete |
| checklist-template.md | Validation & QA checklists | Any level - for systematic validation |
| retrospective-template.md | Post-implementation review | After Level 2/3 completion |
| decision-record-template.md | Architecture decisions (ADR) | When making significant technical decisions |
| spike-template.md | Research & experimentation | Before implementation - time-boxed research |

### Folder Structures

```
Level 0: specs/###-name/
├── README.md

Level 1: specs/###-name/
├── spec.md

Level 2: specs/###-name/
├── spec.md
├── plan.md
├── tasks.md (optional)
└── retrospective.md (post-implementation)

Level 3: specs/###-name/
├── spec.md
├── plan.md
├── tasks.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
├── checklist.md (optional)
├── decision-records/ (optional)
└── retrospective.md (post-implementation)
```

### When to Use Supporting Templates

**tasks.md** - Create after plan.md is complete, before implementation begins. Breaks plan into actionable tasks.

**checklist.md** - Create when you need systematic validation (pre-implementation, QA, security review, deployment readiness).

**retrospective.md** - Create AFTER feature is complete. Captures learnings, metrics achieved, what went well/poorly.

**decision-record-*.md** - Create when making significant architectural/technical decisions (store in `decision-records/` subfolder).

**spike-*.md** - Create BEFORE implementation when research/experimentation needed. Time-boxed exploration (store in spec folder).

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

### Agent Auto-Creation

**AI Agent Automatically:**
1. Determines documentation level
2. Finds next spec number
3. Creates spec folder with correct name
4. Copies appropriate templates
5. Fills initial content
6. Presents to user for approval

**Exception:** Level 3 uses `/speckit.specify` command

### Enforcement Checkpoints

1. **Collaboration First Rule** - Before ANY code changes, create spec folder
2. **Request Analysis** - Agent classifies Level 0/1/2/3
3. **Pre-Code Checklist** - Verify spec folder exists (blocker)
4. **Final Review** - Confirm documentation complete

---

## 8. ⚡ QUICK REFERENCE

### Decision Shortcuts

| Situation | Level | Core Files | Optional Files |
|-----------|-------|------------|----------------|
| Typo, <10 lines | 0 | README.md | - |
| Bug fix, <100 lines | 1 | spec.md | - |
| Feature, <500 lines | 2 | spec.md + plan.md | tasks.md, checklist.md |
| Complex, 500+ lines | 3 | Full SpecKit | spike-*.md, decision-record-*.md |

### Supporting Template Usage

| Template | Create When | Example Scenario |
|----------|-------------|------------------|
| tasks.md | After plan.md, before coding | Breaking down implementation into actionable tasks |
| checklist.md | When validation needed | QA checklist, security review, deployment readiness |
| retrospective.md | After feature complete | Post-mortem, learnings capture, metrics review |
| spike-*.md | Before uncertain work | Researching libraries, proof of concept, feasibility study |
| decision-record-*.md | Major technical decision | Choosing database, architecture pattern, framework |

### Pre-Implementation Checklist

- [ ] Determined level (0/1/2/3)
- [ ] Created `/specs/[###-short-name]/`
- [ ] Filled core template sections
- [ ] Identified needed supporting templates
- [ ] Presented approach to user
- [ ] Got explicit approval

**If ANY unchecked → STOP**

---

## 9. 🔍 TROUBLESHOOTING

### "I forgot to create the spec folder"

Stop coding immediately. Create spec folder retroactively, document what was done and why, get user approval, then continue.

---

### "I'm not sure which level to choose"

When in doubt, choose the **higher level**. Ask user if confidence <80%. Consider complexity, not just LOC.

---

### "Can I change levels mid-work?"

Yes. Going up: add additional files (Level 0→1: add spec.md, 1→2: add plan.md). Going down: keep existing docs. Inform user why level changed.

---

### "What if it's just exploration?"

Pure exploration/reading = NO spec needed. **Once you write/edit code = SPEC REQUIRED.**

---

### "Do I need specs for documentation changes?"

Code files (*.js, *.css, etc.) → Spec required
Doc files → Only if significant (multi-file restructure)
Single typo in README → No spec needed

---

### "When do I create a retrospective?"

Create `retrospective.md` AFTER feature completion (Level 2/3). Captures: what went well/poorly, lessons learned, metrics achieved vs targets, action items for future work.

---

### "When do I need an Architecture Decision Record (ADR)?"

Create `decision-record-*.md` when making significant technical decisions:
- Choosing between databases, frameworks, or libraries
- Selecting architectural patterns (microservices vs monolith, etc.)
- Major refactoring approaches
- Infrastructure/deployment strategy changes

Store in `decision-records/` subfolder within spec folder.

---

### "When do I create a spike?"

Create `spike-*.md` BEFORE implementation when:
- Technical feasibility unknown
- Need to evaluate multiple libraries/approaches
- Research required (performance testing, proof of concept)
- Time-boxed exploration needed (typically 1-3 days)

Spike results inform the spec and plan documents.

---

**Remember**: Every code change deserves documentation. Future you will thank present you for creating that spec folder. When in doubt, document more rather than less—the cost of creating a spec is tiny compared to reconstructing lost context later.