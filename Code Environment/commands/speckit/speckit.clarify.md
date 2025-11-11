---
description: Identify underspecified areas in the current feature spec by asking up to 5 highly targeted clarification questions and encoding answers back into the spec.
---

# Specification Clarification

Detect and reduce ambiguity in feature specifications through targeted questioning with incremental integration and intelligent recommendations.

---

## 1. 📋 INPUTS

### User Arguments

```text
$ARGUMENTS
```

**MUST consider user input before proceeding** (if not empty).

### Context

**Goal**: Reduce ambiguity in active feature specification before planning

**Timing**: Run BEFORE \`/speckit.plan\`. Skip only for exploratory spikes (with warning about rework risk).

**Question Limit**: Maximum 5 questions per session

---

## 2. 🚀 WORKFLOW

### Step 1: Prerequisites Check

**Purpose**: Verify spec file exists and get paths

**Actions**:
1. Run \`.specify/scripts/bash/check-prerequisites.sh --json --paths-only\`
2. Parse JSON fields: FEATURE_DIR, FEATURE_SPEC, (optionally IMPL_PLAN, TASKS)
3. If parsing fails: Abort, instruct to re-run \`/speckit.specify\`

**Note**: For single quotes in args, use: \`'I'\\''m Groot'\` or \`"I'm Groot"\`

**Validation**: \`prerequisites_checked\`

### Step 2: Ambiguity Coverage Scan

**Purpose**: Identify underspecified areas systematically

**Taxonomy Categories**:

**Functional Scope & Behavior**:
- Core user goals & success criteria
- Explicit out-of-scope declarations
- User roles/personas differentiation

**Domain & Data Model**:
- Entities, attributes, relationships
- Identity & uniqueness rules
- Lifecycle/state transitions
- Data volume/scale assumptions

**Interaction & UX Flow**:
- Critical user journeys/sequences
- Error/empty/loading states
- Accessibility or localization

**Non-Functional Quality Attributes**:
- Performance (latency, throughput targets)
- Scalability (horizontal/vertical, limits)
- Reliability & availability (uptime, recovery)
- Observability (logging, metrics, tracing)
- Security & privacy (authN/Z, data protection)
- Compliance/regulatory constraints

**Integration & External Dependencies**:
- External services/APIs and failure modes
- Data import/export formats
- Protocol/versioning assumptions

**Edge Cases & Failure Handling**:
- Negative scenarios
- Rate limiting/throttling
- Conflict resolution (concurrent edits)

**Constraints & Tradeoffs**:
- Technical constraints (language, storage, hosting)
- Explicit tradeoffs or rejected alternatives

**Terminology & Consistency**:
- Canonical glossary terms
- Avoided synonyms/deprecated terms

**Completion Signals**:
- Acceptance criteria testability
- Measurable Definition of Done indicators

**Misc/Placeholders**:
- TODO markers/unresolved decisions
- Ambiguous adjectives lacking quantification

**Status Marking**: Clear / Partial / Missing for each category

**Validation**: \`coverage_scanned\`

### Step 3: Generate Question Queue

**Purpose**: Prioritize up to 5 critical clarification questions

**Selection Criteria**:
- Answers materially impact architecture, data modeling, tasks, tests, UX, operations, or compliance
- Category coverage balance (highest impact first)
- Exclude already answered, trivial, or plan-level details
- Favor clarifications reducing downstream rework risk
- If >5 categories unresolved: Select top 5 by (Impact × Uncertainty)

**Question Format**:
- **Multiple-choice**: 2-5 mutually exclusive options, OR
- **Short-answer**: ≤5 words

**Maximum**: 10 total questions across entire session (typically stop at 5)

**Validation**: \`questions_prioritized\`

### Step 4: Sequential Questioning Loop

**Purpose**: Ask questions one at a time with intelligent recommendations

**For Multiple-Choice Questions**:

1. **Analyze options** and determine most suitable based on:
   - Best practices for project type
   - Common patterns in similar implementations
   - Risk reduction (security, performance, maintainability)
   - Alignment with project goals/constraints

2. **Present recommended option prominently**:
   \`\`\`
   **Recommended:** Option [X] - <reasoning in 1-2 sentences>
   \`\`\`

3. **Render all options as table**:
   \`\`\`
   | Option | Description |
   |--------|-------------|
   | A | <Option A description> |
   | B | <Option B description> |
   | C | <Option C description> |
   | Short | Provide different answer (≤5 words) |
   \`\`\`

4. **Add instruction**:
   "You can reply with option letter (e.g., 'A'), accept recommendation ('yes'/'recommended'), or provide your own short answer."

**For Short-Answer Questions**:

1. **Provide suggested answer**:
   \`\`\`
   **Suggested:** <proposed answer> - <brief reasoning>
   \`\`\`

2. **Add instruction**:
   "Format: Short answer (≤5 words). Accept suggestion ('yes'/'suggested') or provide your own answer."

**After User Answers**:
- If "yes"/"recommended"/"suggested": Use your recommendation/suggestion
- Otherwise: Validate answer maps to option or fits ≤5 word constraint
- If ambiguous: Ask quick disambiguation (doesn't count as new question)
- Record in working memory, move to next question

**Stop Asking When**:
- All critical ambiguities resolved
- User signals completion ("done", "good", "no more")
- Reached 5 asked questions

**Never reveal future queued questions in advance**

**If no valid questions**: Report "No critical ambiguities detected"

**Validation**: \`questioning_complete\`

### Step 5: Incremental Integration

**Purpose**: Update spec after EACH accepted answer

**Actions**:

1. **Maintain in-memory spec representation** (loaded once at start)

2. **For first answer in session**:
   - Ensure \`## Clarifications\` section exists (create after overview if missing)
   - Create \`### Session YYYY-MM-DD\` subheading for today

3. **Append bullet**: \`- Q: <question> → A: <final answer>\`

4. **Apply clarification to appropriate section(s)**:
   - Functional ambiguity → Update Functional Requirements
   - User interaction → Update User Stories or Actors
   - Data shape → Update Data Model (fields, types, relationships)
   - Non-functional → Add measurable criteria (convert vague to metric)
   - Edge case → Add bullet under Edge Cases/Error Handling
   - Terminology → Normalize term across spec

5. **If clarification invalidates earlier statement**: Replace (don't duplicate)

6. **Save spec file AFTER each integration** (atomic overwrite)

7. **Preserve formatting**: Keep heading hierarchy intact

**Validation**: \`answer_integrated\`

### Step 6: Validation

**Purpose**: Verify spec quality after each write

**Checks**:
- Clarifications session has exactly one bullet per accepted answer
- Total asked questions ≤ 5
- Updated sections have no lingering vague placeholders
- No contradictory statements remain
- Markdown structure valid
- Only allowed new headings: \`## Clarifications\`, \`### Session YYYY-MM-DD\`
- Terminology consistency maintained

**Validation**: \`spec_validated\`

### Step 7: Write Updated Spec

**Purpose**: Save final spec to filesystem

**Actions**:
- Write updated spec back to FEATURE_SPEC
- Verify write succeeded

**Validation**: \`spec_written\`

### Step 8: Report Completion

**Purpose**: Provide clarification session summary

**Report Includes**:
- Number of questions asked & answered
- Path to updated spec
- Sections touched (list names)
- Coverage summary table:
  - **Resolved**: Was Partial/Missing, now addressed
  - **Deferred**: Exceeds quota or better for planning
  - **Clear**: Already sufficient
  - **Outstanding**: Still Partial/Missing but low impact

**Recommendation**:
- If Outstanding/Deferred remain: Suggest \`/speckit.plan\` or re-run \`/speckit.clarify\`
- Suggested next command

**Validation**: \`completion_reported\`

---

## 3. 💡 EXAMPLES

### Example 1: Basic Clarification

\`\`\`bash
/speckit.clarify
\`\`\`

**Result**: Asks up to 5 targeted questions, updates spec incrementally

### Example 2: With Context

\`\`\`bash
/speckit.clarify "Focus on security and data model clarifications"
\`\`\`

**Result**: Prioritizes security and data model questions

---

## 4. 📖 RULES

### ALWAYS

- Run prerequisites check first
- Perform structured coverage scan
- Present ONE question at a time
- Provide intelligent recommendations for each question
- Accept "yes"/"recommended"/"suggested" as confirmation
- Integrate answers incrementally (after EACH answer)
- Save spec after each integration
- Validate after each write
- Stop at 5 questions maximum
- Respect user termination signals
- Report coverage summary at end

### NEVER

- Reveal future queued questions
- Exceed 5 total asked questions
- Ask low-impact or trivial questions
- Skip incremental integration
- Leave contradictory statements
- Create new spec (must exist first)
- Ask speculative tech stack questions (unless blocking)

### ESCALATE IF

- Spec file missing (instruct to run \`/speckit.specify\`)
- Prerequisites check fails
- Cannot determine question priority
- User answer is ambiguous
- High-impact ambiguities remain after quota

---

## 5. 🎓 SUCCESS CRITERIA

**Clarification is successful when**:
- ✅ Prerequisites check passes
- ✅ Coverage scan completes
- ✅ Questions prioritized by impact
- ✅ Recommendations provided for each question
- ✅ User answers validated
- ✅ Spec updated incrementally (after each answer)
- ✅ All integrations validated
- ✅ No contradictions remain
- ✅ Coverage summary generated
- ✅ Next steps suggested

**Quality Gates**:
- Maximum 5 questions asked
- Each answer materially reduces ambiguity
- Spec remains valid markdown
- Terminology consistent throughout

---

## 6. 🔗 INTEGRATION POINTS

### Related Commands

- \`/speckit.specify\`: Creates spec.md (prerequisite)
- \`/speckit.plan\`: Next step after clarification
- Can re-run \`/speckit.clarify\` if needed

### Clarifications Section

- Location: After overview section
- Format: \`### Session YYYY-MM-DD\`
- Bullets: \`- Q: <question> → A: <answer>\`

---

## 7. ⚠️ COMMON MISTAKES

**Asking too many questions**:
- **Problem**: Exceeding 5 question limit
- **Fix**: Prioritize by (Impact × Uncertainty), focus on critical ambiguities

**Not providing recommendations**:
- **Problem**: Just listing options without analysis
- **Fix**: Always analyze and recommend best option with reasoning

**Batching updates**:
- **Problem**: Waiting to update spec until all questions answered
- **Fix**: Integrate and save after EACH accepted answer

**Leaving contradictions**:
- **Problem**: Adding clarification without removing contradictory statements
- **Fix**: Replace invalidated statements, don't duplicate
