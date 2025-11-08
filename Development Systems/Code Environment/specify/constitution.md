# Project Constitution - anobel.com

**Version**: 1.0.0  
**Ratification Date**: 2025-11-06  
**Last Amended**: 2025-11-06  
**Authority**: This document defines non-negotiable principles for all implementation work.  
**Primary Source**: `/Users/michelkerkmeester/MEGA/Websites/anobel.com/AGENTS.md`

---

## Introduction

This constitution extracts parseable principles from AGENTS.md for automated validation by SpecKit commands. For complete context, implementation guidance, and decision frameworks, refer to AGENTS.md.

---

## Core Principles

### Principle 1: Mandatory Documentation
**Name**: `mandatory-documentation`

**Rule**: Every conversation involving code or file changes MUST have a specification folder created BEFORE implementation begins.

**Specifics**:
- MUST create `/specs/[###-short-name]/` folder
- MUST determine documentation level (0/1/2/3) using LOC + complexity
- MUST use appropriate templates from `.specify/templates/`
- MUST NOT implement without spec folder existence

**Rationale**: Code without context creates technical debt. Documentation ensures decision preservation, debugging capability, and knowledge transfer.

**Source**: AGENTS.md Section 2

---

### Principle 2: Collaboration First
**Name**: `collaboration-first`

**Rule**: MUST explain planned approach and receive explicit user approval before ANY code changes or terminal commands.

**Specifics**:
- MUST determine documentation level first
- MUST create spec folder with documentation
- MUST explain what will be done and why
- MUST present approach for review
- MUST wait for explicit "go ahead" confirmation
- Exceptions: Analysis, reading files, explanations (no approval needed)

**Rationale**: Prevents task misinterpretation, rushed implementation, and cascading breaks. Ensures alignment before investment.

**Source**: AGENTS.md Section 1 - Collaboration First

---

### Principle 3: Explicit Uncertainty
**Name**: `explicit-uncertainty`

**Rule**: MUST mark uncertainty clearly; MUST output "UNKNOWN" when information is insufficient or unverifiable; MUST NOT fabricate details.

**Specifics**:
- MUST prefix uncertain claims with "I'M UNCERTAIN ABOUT THIS:"
- MUST output "UNKNOWN" for unverifiable information
- MUST state confidence levels as percentages
- MUST NOT invent plausible-sounding details
- MUST cite sources or mark "[CITATION: NONE]"

**Rationale**: Truth and safety over engagement. Prevents assumption-based changes and cascading failures.

**Source**: AGENTS.md Section 1 - Explicit Uncertainty

---

### Principle 4: Simplicity First (KISS)
**Name**: `simplicity-first`

**Rule**: MUST choose the simplest solution that works; MUST reuse existing patterns; MUST justify new abstractions.

**Specifics**:
- MUST use existing patterns over inventing new ones
- MUST prefer direct solutions over clever complexity
- MUST solve ONLY stated problem (no gold-plating)
- MUST verify: Is this the simplest solution?
- MUST avoid premature optimization
- Obviously correct code > clever tricks

**Rationale**: Code is read more than written. Maintainability and clarity trump brevity and cleverness.

**Source**: AGENTS.md Section 4 - Solution Design, Phase 5 Simplicity Check

---

### Principle 5: Evidence-Based Decision Making
**Name**: `evidence-based`

**Rule**: MUST cite sources for claims; MUST read existing code before changes; MUST verify evidence before proceeding.

**Specifics**:
- MUST cite sources as [SOURCE: file.md:lines]
- MUST read relevant files BEFORE making assumptions
- MUST verify current implementation with evidence
- MUST identify root cause, not symptoms
- MUST document counter-evidence/caveats
- For high-stakes: Require ≥1 primary source or escalate

**Rationale**: Prevents assumption-based changes that break working code. Ensures decisions based on facts, not guesses.

**Source**: AGENTS.md Section 4 - Phase 3 Context Gathering, Phase 4 Evidence-Based

---

### Principle 6: Confidence Threshold Gate
**Name**: `confidence-threshold`

**Rule**: If confidence < 80% OR requirements ambiguous OR multiple interpretations exist, MUST pause and ask clarifying question with options.

**Specifics**:
- 80-100%: Proceed
- 40-79%: Proceed with caution (list assumptions, caveats)
- 0-39%: Ask clarifying question (multiple-choice format)
- MUST use standard reply format with confidence score
- MUST present 2-3 concrete options when asking

**Rationale**: Prevents task misinterpretation and wasted effort. Better to clarify once than iterate many times.

**Source**: AGENTS.md Section 3 - Confidence & Clarification Framework

---

### Principle 7: Scope Discipline (YAGNI)
**Name**: `scope-discipline`

**Rule**: MUST solve ONLY the stated problem; MUST NOT add features not requested; MUST avoid over-engineering.

**Specifics**:
- MUST check: Am I solving ONLY stated problem?
- MUST avoid feature creep
- MUST avoid premature optimization
- MUST remove gold-plating
- You Aren't Gonna Need It (YAGNI)
- Solve today's problem, not tomorrow's maybes

**Rationale**: Every abstraction must earn its existence. Complexity is a liability. Ship what's needed, nothing more.

**Source**: AGENTS.md Section 4 - Phase 5 Scope Check

---

### Principle 8: Pattern Consistency
**Name**: `pattern-consistency`

**Rule**: MUST follow established project patterns in `knowledge/code_standards.md`; consistency over personal preference.

**Specifics**:
- MUST read `knowledge/code_standards.md` before implementation
- MUST follow existing patterns (naming, structure, style)
- MUST justify deviations from standards
- Consistency > Personal preference
- Maintainability > Brevity

**Rationale**: Uniform codebase is easier to maintain, debug, and onboard new developers. Patterns reduce cognitive load.

**Source**: AGENTS.md Section 5 - Knowledge Base, Quality Standards

---

## Enforcement & Compliance

### Pre-Implementation Checklist
Before ANY code changes, verify:
- [ ] Documentation level determined (0/1/2/3)
- [ ] Spec folder created: `/specs/[###-short-name]/`
- [ ] Required documentation files created
- [ ] Approach explained to user
- [ ] Explicit user approval received
- [ ] Confidence ≥ 80% OR clarifying question asked
- [ ] Evidence gathered and cited
- [ ] Solution is simplest that works
- [ ] Following existing patterns
- [ ] Scope limited to stated problem only

### Violation Handling
- **CRITICAL**: Constitution violation blocks implementation
- **REQUIRED**: Adjust spec/plan/tasks to align with principle
- **PROHIBITED**: Diluting, reinterpreting, or ignoring principles
- **EXCEPTION**: Principle changes require separate constitution update

### Constitution Updates
- Version format: MAJOR.MINOR.PATCH (semver)
- MAJOR: Backward incompatible principle changes
- MINOR: New principles added
- PATCH: Clarifications, wording fixes
- Update via: `/speckit.constitution` command
- Amendments MUST update LAST_AMENDED date

---

## Governance

### Amendment Process
1. Propose change via `/speckit.constitution` command
2. Update CONSTITUTION_VERSION per semver rules
3. Validate dependent templates align
4. Update LAST_AMENDED date
5. Document change in Sync Impact Report

### Dependent Artifacts
When constitution changes, MUST validate:
- `.specify/templates/spec-template.md`
- `.specify/templates/plan-template.md`
- `.specify/templates/tasks-template.md`
- `/Users/michelkerkmeester/MEGA/Websites/anobel.com/AGENTS.md`
- `knowledge/*.md` documentation files

### Compliance Review
- Automated: `/speckit.analyze` validates spec/plan/tasks against principles
- Manual: User approval gates at collaboration checkpoints
- Continuous: Every implementation follows Pre-Implementation Checklist

---

## Reference

**Full Documentation**: `/Users/michelkerkmeester/MEGA/Websites/anobel.com/AGENTS.md`

AGENTS.md contains:
- Complete implementation framework
- Detailed decision trees
- Anti-pattern examples
- Troubleshooting guides
- Knowledge base references
- Tool selection frameworks

**Constitution Scope**: This document extracts only the **parseable principles** needed for automated validation. For complete context and workflows, always refer to AGENTS.md.