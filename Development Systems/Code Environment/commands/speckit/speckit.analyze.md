---
description: Perform a non-destructive cross-artifact consistency and quality analysis across spec.md, plan.md, and tasks.md after task generation.
---

# Cross-Artifact Analysis

Perform read-only consistency and quality analysis across spec, plan, and tasks with constitution alignment checking and structured reporting.

---

## 1. 📋 INPUTS

### User Arguments

```text
$ARGUMENTS
```

**MUST consider user input before proceeding** (if not empty).

### Context

**Goal**: Identify inconsistencies, duplications, ambiguities before implementation

**Timing**: Run ONLY after \`/speckit.tasks\` produces complete tasks.md

**Mode**: STRICTLY READ-ONLY (no file modifications)

---

## 2. 🚀 WORKFLOW

### Step 1: Initialize Analysis Context

**Purpose**: Verify all required artifacts exist

**Actions**:
1. Run \`.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks\`
2. Parse JSON for FEATURE_DIR and AVAILABLE_DOCS
3. Derive absolute paths:
   - SPEC = FEATURE_DIR/spec.md
   - PLAN = FEATURE_DIR/plan.md
   - TASKS = FEATURE_DIR/tasks.md
4. Abort if any required file missing

**Note**: For single quotes: \`'I'\\''m Groot'\` or \`"I'm Groot"\`

**Validation**: \`context_initialized\`

### Step 2: Load Artifacts

**Purpose**: Load minimal necessary context (Progressive Disclosure)

**From spec.md**:
- Overview/Context
- Functional Requirements
- Non-Functional Requirements
- User Stories
- Edge Cases (if present)

**From plan.md**:
- Architecture/stack choices
- Data Model references
- Phases
- Technical constraints

**From tasks.md**:
- Task IDs
- Descriptions
- Phase grouping
- Parallel markers [P]
- Referenced file paths

**From constitution**:
- Load \`.specify/memory/constitution.md\` for principle validation

**Validation**: \`artifacts_loaded\`

### Step 3: Build Semantic Models

**Purpose**: Create internal representations for analysis

**Models**:

**Requirements inventory**:
- Each functional + non-functional requirement
- Stable key (slug from imperative phrase)
- Example: "User can upload file" → \`user-can-upload-file\`

**User story/action inventory**:
- Discrete user actions
- Acceptance criteria

**Task coverage mapping**:
- Map each task to requirements/stories
- Infer by keyword/explicit references

**Constitution rule set**:
- Extract principle names
- Extract MUST/SHOULD normative statements

**Validation**: \`models_built\`

### Step 4: Detection Passes

**Purpose**: Identify issues (limit to 50 findings, aggregate overflow)

**A. Duplication Detection**:
- Near-duplicate requirements
- Mark lower-quality phrasing

**B. Ambiguity Detection**:
- Vague adjectives (fast, scalable, secure, intuitive, robust) lacking metrics
- Unresolved placeholders (TODO, TKTK, ???, \`<placeholder>\`)

**C. Underspecification**:
- Requirements with verbs but missing object/outcome
- User stories missing acceptance criteria
- Tasks referencing undefined files/components

**D. Constitution Alignment**:
- Requirements/plan conflicting with MUST principles
- Missing mandated sections/quality gates

**E. Coverage Gaps**:
- Requirements with zero tasks
- Tasks with no mapped requirement/story
- Non-functional requirements not reflected in tasks

**F. Inconsistency**:
- Terminology drift (same concept, different names)
- Data entities in plan but absent in spec
- Task ordering contradictions
- Conflicting requirements (e.g., Next.js vs Vue)

**Validation**: \`issues_detected\`

### Step 5: Severity Assignment

**Purpose**: Prioritize findings using heuristic

**Severity Levels**:

- **CRITICAL**: Violates constitution MUST, missing core artifact, requirement with zero coverage blocking baseline
- **HIGH**: Duplicate/conflicting requirement, ambiguous security/performance, untestable acceptance
- **MEDIUM**: Terminology drift, missing non-functional task coverage, underspecified edge case
- **LOW**: Style/wording improvements, minor redundancy

**Validation**: \`severity_assigned\`

### Step 6: Produce Analysis Report

**Purpose**: Generate structured Markdown report (no file writes)

**Report Structure**:

\`\`\`markdown
## Specification Analysis Report

| ID | Category | Severity | Location(s) | Summary | Recommendation |
|----|----------|----------|-------------|---------|----------------|
| A1 | Duplication | HIGH | spec.md:L120-134 | Two similar requirements ... | Merge phrasing; keep clearer version |

**Coverage Summary Table:**

| Requirement Key | Has Task? | Task IDs | Notes |
|-----------------|-----------|----------|-------|

**Constitution Alignment Issues:** (if any)

**Unmapped Tasks:** (if any)

**Metrics:**

- Total Requirements
- Total Tasks
- Coverage % (requirements with ≥1 task)
- Ambiguity Count
- Duplication Count
- Critical Issues Count
\`\`\`

**Validation**: \`report_generated\`

### Step 7: Provide Next Actions

**Purpose**: Guide user on next steps

**Recommendations**:
- If CRITICAL issues: Resolve before \`/speckit.implement\`
- If only LOW/MEDIUM: May proceed with improvement suggestions
- Provide explicit commands: 
  - "Run /speckit.specify with refinement"
  - "Run /speckit.plan to adjust architecture"
  - "Manually edit tasks.md to add coverage for 'performance-metrics'"

**Validation**: \`next_actions_provided\`

### Step 8: Offer Remediation

**Purpose**: Optionally suggest fixes

**Ask**: "Would you like me to suggest concrete remediation edits for the top N issues?"

**Do NOT apply automatically** - user must explicitly approve

**Validation**: \`remediation_offered\`

---

## 3. 💡 EXAMPLES

### Example 1: Basic Analysis

\`\`\`bash
/speckit.analyze
\`\`\`

**Result**: Generates read-only analysis report with findings

### Example 2: With Context

\`\`\`bash
/speckit.analyze "Focus on constitution alignment and coverage gaps"
\`\`\`

**Result**: Prioritizes constitution and coverage in analysis

---

## 4. 📖 RULES

### ALWAYS

- Verify all required artifacts exist
- Load artifacts with progressive disclosure
- Build semantic models for analysis
- Perform all detection passes
- Assign severity to all findings
- Limit findings to 50 (aggregate overflow)
- Generate structured report
- Provide next actions
- Offer remediation suggestions
- **NEVER modify files** (read-only)

### NEVER

- Modify any files (strictly read-only)
- Hallucinate missing sections
- Dilute or ignore constitution principles
- Apply remediation automatically
- Exceed 50 findings without aggregation
- Skip severity assignment

### ESCALATE IF

- Required artifacts missing (instruct user on prerequisite command)
- CRITICAL constitution violations found
- Coverage gaps for baseline functionality
- Conflicting requirements detected

---

## 5. 🎓 SUCCESS CRITERIA

**Analysis is successful when**:
- ✅ Prerequisites check passes
- ✅ All artifacts loaded
- ✅ Semantic models built
- ✅ All detection passes complete
- ✅ Severity assigned to findings
- ✅ Structured report generated
- ✅ Coverage metrics calculated
- ✅ Next actions provided
- ✅ Remediation offered
- ✅ No files modified

**Quality Gates**:
- Findings limited to 50 (or aggregated)
- Constitution violations marked CRITICAL
- Zero-coverage requirements identified
- Deterministic results (rerunning produces consistent output)

---

## 6. 🔗 INTEGRATION POINTS

### Related Commands

- \`/speckit.specify\`: Creates spec.md (prerequisite)
- \`/speckit.plan\`: Creates plan.md (prerequisite)
- \`/speckit.tasks\`: Creates tasks.md (prerequisite)
- \`/speckit.implement\`: Next step after analysis

### Constitution Authority

- \`.specify/memory/constitution.md\` is **non-negotiable**
- Constitution conflicts are automatically CRITICAL
- Require adjustment of spec/plan/tasks, not constitution
- Constitution changes require separate explicit update

---

## 7. ⚠️ OPERATING PRINCIPLES

### Context Efficiency

- **Minimal high-signal tokens**: Focus on actionable findings
- **Progressive disclosure**: Load incrementally, don't dump all content
- **Token-efficient output**: Limit findings table to 50 rows
- **Deterministic results**: Consistent IDs and counts across reruns

### Analysis Guidelines

- **NEVER modify files** (read-only analysis)
- **NEVER hallucinate missing sections** (report accurately)
- **Prioritize constitution violations** (always CRITICAL)
- **Use examples over rules** (cite specific instances)
- **Report zero issues gracefully** (emit success report with stats)

---

## 8. ⚠️ COMMON MISTAKES

**Modifying files during analysis**:
- **Problem**: Accidentally editing artifacts
- **Fix**: Strictly read-only, only output reports

**Ignoring constitution violations**:
- **Problem**: Marking constitution conflicts as non-critical
- **Fix**: Always mark as CRITICAL, require spec/plan/task adjustments

**Reporting too many findings**:
- **Problem**: Overwhelming user with 100+ findings
- **Fix**: Limit to 50, aggregate remainder in summary

**Missing coverage gaps**:
- **Problem**: Not identifying requirements without tasks
- **Fix**: Build coverage mapping, report zero-coverage requirements
