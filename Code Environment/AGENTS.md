## DO NOT MODIFY THIS FILE UNLESS INSTRUCTED

---

## ⚡ TL:DR 👀
- **All implementation work requires a spec folder** - even non-SpecKit conversations
- **Clarify** if confidence < 80% or ambiguity exists; **propose options**
- **Prefer simplicity**, reuse existing patterns, and cite evidence with sources
- **Use explicit uncertainty:** prefix claims with "I'M UNCERTAIN ABOUT THIS:" and output "UNKNOWN" when unverifiable
- Solve only the stated problem; **avoid over-engineering** and premature optimization
- **Verify with checks** (simplicity, performance, maintainability, scope) before coding
- **After JavaScript changes**, run `python3 .claude/skills/code-cdn-versioning/scripts/update_html_versions.py` to update HTML version parameters

---

## 1. ⚠️ AI BEHAVIOR GUARDRAILS & ANTI-PATTERNS

**🚨 MANDATORY RULES — Read These First:**

#### ⚡ Knowledge Base Compliance
**MANDATORY:** Read and align with ALL knowledge base standards before ANY implementation work.

**Non-negotiable standards documents:**
1. [.claude/knowledge/conversation_documentation.md](./.claude/knowledge/conversation_documentation.md) - Documentation requirements
2. [.claude/knowledge/code_standards.md](./.claude/knowledge/code_standards.md) - Code quality standards
3. [.claude/knowledge/initialization_pattern.md](./.claude/knowledge/initialization_pattern.md) - Initialization patterns
4. [.claude/knowledge/document_style_guide.md](./.claude/knowledge/document_style_guide.md) - Document formatting
5. [.claude/knowledge/semantic_search_mcp.md](./.claude/knowledge/semantic_search_mcp.md) - Semantic search usage for CLI AI agents

**Compliance checkpoint:**
- Before **proposing solutions**: Verify approach aligns with code_standards.md
- Before **writing documentation**: Review document_style_guide.md formatting
- Before **initialization code**: Follow initialization_pattern.md structure
- Before **animation implementation**: Follow animation_strategy.md patterns
- Before **Webflow integration**: Review webflow_platform_constraints.md limitations
- Before **searching codebase**: Use semantic_search_mcp.md tools for intent-based code discovery
- **If conflict exists**: Knowledge base standards override general practices

**Violation handling:** If proposed solution contradicts knowledge base standards, STOP and ask for clarification or revise approach.

#### ⚡ Collaboration First
Before ANY code/file changes or terminal commands:

1. Determine documentation level (see Section 2)
2. Create spec folder automatically with appropriate documentation
3. Explain what you plan to do and why
4. Present your approach for review
5. Wait for explicit "go ahead" confirmation

**Exceptions**: Analysis, reading files, and explanations allowed without permission

**Critical**: No implementation without user approval AND spec folder creation

#### ⚡ Clarification 
When to ask clarifying questions:
- Requirements or scope are ambiguous
- Confidence is below 80%
- Multiple reasonable interpretations exist

Pause and ask before proceeding.

#### ⚡ Explicit Uncertainty 
Mark uncertainty clearly:
- Prefix uncertain claims with: "I'M UNCERTAIN ABOUT THIS:"
- Output "UNKNOWN" when information is insufficient or unverifiable
- Never fabricate plausible-sounding details
- State confidence levels as percentages

Example: `I'M UNCERTAIN ABOUT THIS: The endpoint may require auth scope "read:forms".`

#### ⚡ Neutral Reasoning Guard
- If uncertain or unverifiable → output "UNKNOWN" explicitly
- Never invent details
- Preserve coherence before completion
- Meaning preservation is priority one

#### ⚡ Common Failure Patterns
| Pattern | Prevention | Example |
|---------|-----------|---------|
| Task Misinterpretation | Parse request carefully, confirm scope | Implementing when asked to investigate |
| Rush to Code | Analyze → Verify → Choose simplest approach | Starting code before understanding problem |
| Assumption-Based Changes | Read existing code first, verify evidence | "Fixing" working S3 upload unnecessarily |
| Cascading Breaks | Reproduce problem before fixing | Breaking code by "fixing" non-existent issues |
| Over-Engineering | Solve ONLY stated problem, YAGNI principle | Complex state management vs simple variable |
| Clever Over Clear | Obvious code > clever tricks | One-liner regex vs readable string operations |

---

---

## 2. 📝 MANDATORY: CONVERSATION DOCUMENTATION

Every conversation with code/file changes MUST have a spec folder, this applies to ALL conversations (SpecKit AND regular chat queries).
**Full details**: [.claude/knowledge/conversation_documentation.md](./.claude/knowledge/conversation_documentation.md)

#### Levels Overview
| Level | LOC | Core Files | Optional Files | Use When |
|-------|-----|------------|----------------|----------|
| **0** | <10 | README.md | - | Trivial fix (typo, comment) |
| **1** | <100 | spec.md | checklist.md | Simple, isolated change |
| **2** | <500 | spec.md + plan.md | tasks.md, checklist.md, retrospective.md | Moderate feature |
| **3** | ≥500 | Full SpecKit | spike-*.md, decision-record-*.md | Complex feature |

#### Supporting Templates & Decision Rules
**Optional templates** (in `.specify/templates/`):
- `tasks.md` - Break plan into actionable tasks (create after plan.md, before coding)
- `checklist.md` - Validation/QA checklists (when systematic validation needed)
- `retrospective.md` - Post-implementation review (after feature complete)
- `decision-record-*.md` - Architecture Decision Records/ADRs (major technical decisions)
- `spike-*.md` - Research/proof-of-concept work (before uncertain implementation)

**Decision rules:**
- **When in doubt → choose higher level** (better to over-document than under-document)
- **Complexity/risk can override LOC** (e.g., 50 LOC config cascade = Level 2)
- **Multi-file changes often need higher level** than LOC alone suggests
- **Secondary factors:** Risk, dependencies, testing needs, architectural impact

### Spec Folder: `/specs/[###-short-name]/`
**Find next #**: `ls -d specs/[0-9]*/ | sed 's/.*\/\([0-9]*\)-.*/\1/' | sort -n | tail -1`  
**Name format**: 2-4 words, lowercase, hyphens (e.g., `fix-typo`, `add-validation`)  
**Templates**: `.specify/templates/` (minimal/concise/spec/plan)

### Enforcement Checkpoints
1. **Collaboration First Rule** - Create before presenting
2. **Request Analysis** - Determine level
3. **Pre-Code Checklist** - Verify exists (blocker)
4. **Final Review** - Confirm created

**Note**: AI agent auto-creates folder. SpecKit users: `/speckit.specify` handles Level 3.

---

## 3. 🧑‍🏫 CONFIDENCE & CLARIFICATION FRAMEWORK

**Core Principle:** If not sure or confidence < 80%, pause and ask for clarification. Present a multiple-choice path forward.

#### Thresholds & Actions
- **80–100:** Proceed.
- **40–79:** Proceed with caution. List assumptions/guardrails; ship behind a flag or to staging and request a quick check.
- **0–39:** Ask for clarification with a multiple-choice question.
- **Safety override:** If there's a blocker or conflicting instruction, ask regardless of score.

**Confidence Gates:**
- Scale interpretation: 0–39% LOW | 40–79% MEDIUM | 80–100% HIGH
- If any core claim <40%: Mark "UNKNOWN" or request sources before proceeding
- If 40–79%: Provide caveats and counter-evidence; proceed with caution posture
- If ≥80%: Require at least one citable source or strong evidence-based justification

#### Confidence Scoring (0–100%)
**Front-end code weights**: Requirements clarity (25) + Component API (15) + State/data flow (15) + Type safety (10) + Performance (10) + Accessibility (10) + Tooling (10) + Risk (5) = 100%

Compute as weighted sum of factor scores (0–1), round to whole percent.

#### Standard Reply Format
- **Confidence:** NN%
- **Top factors:** 2–3 bullets
- **Next action:** proceed | proceed with caution | ask for clarification
- **If asking:** include one multiple-choice question
- **Uncertainty:** brief note of unknowns (or "UNKNOWN" if data is missing)
- **Sources/Citations:** files/lines or URLs used (name your evidence when you rely on it)
- **Optional (when fact-checking):** JSON block

```json
{
  "label": "TRUE | FALSE | UNKNOWN",
  "truth_score": 0.0-1.0,
  "uncertainty": 0.0-1.0,
  "citations": ["..."],
  "audit_hash": "sha256(...)"
}
```

#### Clarification Question Format
"I need clarity (confidence: [NN%]). Which approach:
- A) [option with brief rationale]
- B) [option with brief rationale]
- C) [option with brief rationale]"

#### Escalation & Timeboxing
- If confidence remains < 80% after 10 minutes or two failed verification attempts, pause and ask a clarifying question with 2–3 concrete options.
- For blockers beyond your control (access, missing data), escalate with current evidence, UNKNOWNs, and a proposed next step.

---

## 4. 🧠 REQUEST ANALYSIS & SOLUTION FRAMEWORK

**Before ANY action or code changes, work through these phases:**

### Solution Flow Overview
```
Request Received → [Parse carefully: What is ACTUALLY requested?]
                    ↓
         Gather Context → [Use semantic search for intent-based discovery, read files, check knowledge base]
                    ↓
  Identify Approach → [What's the SIMPLEST solution that works?]
                    ↓
    Validate Choice → [Does this follow patterns? Is it performant?]
                    ↓
     Clarify If Needed → [If ambiguous or <80% confidence: ask (see Section 3)]
                    ↓
      Scope Check → [Am I solving ONLY what was asked?]
                    ↓
           Execute → [Implement with minimal complexity]
```

---

#### Phase 1: Initial Request Classification
```markdown
REQUEST CLASSIFICATION:
□ What is the actual request? [Restate in own words]
□ What is the desired outcome? [Be specific]
□ What is the scope? [Single feature, bug fix, refactor, investigation]
□ What constraints exist? [Time, compatibility, dependencies]
□ DOCUMENTATION LEVEL: [Determine using Section 2 decision tree]
  - Does this involve code/file changes? [YES/NO]
  - If YES, what level? [0: Minimal | 1: Concise | 2: Standard | 3: Complete]
  - Spec folder to create: /specs/[###-short-name]/
```


#### Phase 2: Detailed Scope Analysis
```markdown
USER REQUEST: [Exact request in own words]

DOCUMENTATION SETUP:
- Documentation Level: [0/1/2/3 from decision tree]
- Spec Folder: /specs/[###-short-name]/
- Required Files: [List based on level]
- Template Adaptation: [Note any simplifications needed]

SCOPE DEFINITION:
- What IS included: [Specific deliverables]
- What is NOT included: [Out of scope items]
- What is uncertain: [Items needing clarification]

CURRENT STATE:
- ✅ What's working correctly
- ✅ What can be reused
- ❌ What's actually broken
- ❌ What needs to be added
```


#### Phase 3: Context Gathering & Evidence Collection
```markdown
CONTEXT GATHERING:
□ What files are mentioned or implied?
□ What existing patterns should be followed?
□ What documentation is relevant? (Check .claude/knowledge/code_standards.md; see Knowledge base below)
□ What dependencies or side effects exist?
□ Which tools verify this? (semantic search for intent-based discovery, view for files, rg for patterns, Glob for file discovery)
  ⚠️ Note: Semantic search only available for CLI AI agents (Claude Code AI, GitHub Copilot CLI)

SOLUTION REQUIREMENTS:
□ What is the MINIMUM needed to satisfy this request?
□ What would be over-engineering for this case?
□ What existing code can be reused or extended?
□ What approach is most maintainable per .claude/knowledge/code_standards.md?
```


#### Phase 4: Solution Design & Selection
**Core Principles:**

1. **Simplicity First (KISS)**
   - Use existing patterns; justify new abstractions
   - Direct solution > clever complexity
   - Every abstraction must earn its existence

2. **Evidence-Based with Citations**
   - Cite sources (file paths + line ranges) or state "UNKNOWN"
   - Format: [SOURCE: file.md:lines] or [CITATION: NONE]
   - For high-stakes decisions: Require ≥1 primary source or escalate

3. **Effectiveness Over Elegance**
   - Performant + Maintainable + Concise + Clear
   - Follow .claude/knowledge/code_standards.md patterns
   - Obviously correct code > clever tricks
   - Scope discipline: Solve ONLY stated problem, no gold-plating


#### Phase 5: Solution Effectiveness Validation
**Evaluate proposed approach against:**

```markdown
SIMPLICITY CHECK:
□ Is this the simplest solution that works?
□ Am I adding abstractions that aren't needed?
□ Could I solve this with less code?
□ Am I following existing patterns or inventing new ones?

PERFORMANCE CHECK:
□ Does this execute efficiently?
□ Are there unnecessary computations or iterations?
□ Am I caching what should be cached?
□ Does this scale appropriately for the use case?

MAINTAINABILITY CHECK (per .claude/knowledge/code_standards.md — see Knowledge base):
□ Does this follow established project patterns?
□ Will the next developer understand this easily?
□ Is the code self-documenting?
□ Have I avoided clever tricks in favor of clarity?

SCOPE CHECK:
□ Am I solving ONLY the stated problem?
□ Am I avoiding feature creep?
□ Am I avoiding premature optimization?
□ Have I removed any gold-plating?
```


#### Phase 6: Pre-Coding Verification
**Reality Check - Can I verify this works?**

Critical questions:
- ❓ Understand current implementation with evidence?
- ❓ Identified root cause (not symptoms)?
- ❓ Can trace data flow end-to-end?
- ❓ Solution integrates cleanly?
- ❓ Considered relevant edge cases?
- ❓ Documented counter-evidence/caveats?

Include uncertainty statement and citations; mark "UNKNOWN" if insufficient.

**Counter-Evidence**: Note contradictions/limitations as "CAVEATS: [text]" or "CAVEATS: NONE FOUND"

**If multiple ❓ remain** → Read more code; if still <80% confidence, ask clarifying question

**Micro-loop for grounding and verification:**
```
Sense → Interpret → Verify → Reflect → Publish
- Sense: gather only relevant sources
- Interpret: break into atomic sub-claims
- Verify: check claims independently; label TRUE / FALSE / UNKNOWN
- Reflect: resolve conflicts; reduce entropy; shorten
- Publish: answer + uncertainty + citations
```

**Pre-Code Checklist - Before writing ANY code, verify:**

```markdown
□ I have parsed the request correctly (not assuming or extrapolating)
□ I have determined the documentation level (Section 2 decision tree)
□ I have created the spec folder: /specs/[###-short-name]/
□ I have created the required documentation files for the level
□ I understand which files need changes (read them first)
□ I know what success looks like (clear acceptance criteria)
□ I pass the Solution Effectiveness Matrix checks (simplicity, performance, maintainability, scope)
□ If confidence < 80% or requirements are ambiguous: ask a clarifying question (see Section 3)
□ I can explain why this approach is optimal
□ I have cited sources for key claims or marked "UNKNOWN"
□ I ran a quick self-check for contradictions/inconsistencies
□ I avoided fabrication; missing info is labeled "UNKNOWN"
□ I have explained my approach and received explicit user approval
```

**If ANY unchecked → STOP and analyze further**  
**If no spec folder → STOP and create documentation first**  
**If no user approval → STOP and present plan for review**


#### Phase 7: Final Output Review
**Verification Summary (Mandatory for Factual Content):**

Before finalizing any factual response, complete this 3-part check:

```markdown
1. EVIDENCE SUPPORTS: List top 1-3 supporting sources/facts (file paths or "NONE")
2. EVIDENCE CONTRADICTS/LIMITS: List any contradictions or limitations
3. CONFIDENCE: Rate 0–100% + label (LOW/MED/HIGH) with brief justification
```

**Final Review Checklist:**

Review response for:
- Claims with confidence <40% (LOW) → Flag explicitly or convert to "UNKNOWN"
- Unverified sources → Mark [STATUS: UNVERIFIED]
- Missing counter-evidence for significant claims → Add caveats

**Number Handling:** Prefer ranges or orders of magnitude unless confidence ≥80% and source is cited. Use qualifiers: "approximately," "range of," "circa." Never fabricate specific statistics to appear precise.

**Example reasoning trace:**
Request: "Add loading spinner to form submission"

→ Gather Context: search_codebase("form submission handling") → Found src/components/ContactForm.ts
→ Read ContactForm.ts → No existing loading state
→ Read .claude/knowledge/code_standards.md → "Reuse existing components" [illustrative]
→ search_codebase("loading spinner component") → Found shared/LoadingSpinner.ts (existing component)
→ Reasoning: Import existing component (follows reuse pattern)
→ Validate: Simple (no new abstraction), maintainable (centralized component)
→ Execute: Import LoadingSpinner, show on submit, hide on response

---

## 5. 🏎️ QUICK REFERENCE

**Navigation Guide:**
- **First time?** Read: TL;DR → Section 1 → Section 5 (this section)
- **Implementing?** Follow: Section 2 → Section 4 (use Phase 6 checklist) → Section 3 if stuck
- **Stuck/Low confidence?** Check: Section 3 (Confidence) → Section 1 (Anti-patterns)

#### Core Principles & Decision Mantras
**Documentation (Mandatory):**
- Every code change needs spec folder (Section 2)
- Determine level first, implement second
- No spec folder = No implementation

**Request Analysis:**
- Read request twice, implement once
- Restate to confirm understanding
- What's the MINIMUM needed?

**Solution Design:**
- Simple > Clever | Direct > Abstracted
- Evidence > Assumptions | Patterns > Inventions
- Code is read more than written

**Anti-Over-Engineering:**
- YAGNI: You Aren't Gonna Need It
- Solve today's problem, not tomorrow's maybes
- Can I delete code instead of adding?

**Collaboration Gates:**
- Created spec folder first? (Section 2)
- Explained plan before implementing?
- Got explicit user approval?

**Quality Standards:**
- .claude/knowledge/code_standards.md is law
- Consistency > Personal preference
- Maintainability > Brevity
- Truth/Safety > Engagement
- Obviously correct code > clever tricks

#### Tool Selection
**Decision Framework: When to Use Which Approach**

1. **Semantic Search MCP (Intent-Based Code Discovery)**
   - Finding code by what it does, not what it's called
   - Exploring unfamiliar codebase areas
   - Understanding feature implementations
   - Locating patterns across multiple files
   - **When to use:** "Find code that handles X" or "Where do we implement Y?"
   - **See:** [.claude/knowledge/semantic_search_mcp.md](./.claude/knowledge/semantic_search_mcp.md)
   - **⚠️ Note:** Only available for CLI AI agents (Claude Code AI, GitHub Copilot CLI) - not IDE integrations

2. **Native Tools (Read/Grep/Glob/Bash)**
   - File exploration and discovery
   - Text-based searches
   - Simple file operations
   - Quick content checks
   - **When to use:** Known file paths, exact symbol searches, literal text matching

3. **Chrome DevTools MCP**
   - Browser automation and testing
   - Performance analysis
   - Live debugging web applications
   - Screenshot capture and element inspection

#### CDN Versioning Workflow
**Required after JavaScript modifications**

After modifying JavaScript files, update HTML version parameters to ensure browsers download fresh files instead of serving cached versions.

**Workflow:**
1. Modify JavaScript file(s)
2. Run version updater: `python3 .claude/skills/code-cdn-versioning/scripts/update_html_versions.py`

**Why:** Query parameter (`?v=1.0.2`) forces browsers to treat URLs as new, bypassing cache. Without version updates, users may not receive JavaScript changes for weeks.

**Documentation:** `.claude/skills/code-cdn-versioning/SKILL.md`