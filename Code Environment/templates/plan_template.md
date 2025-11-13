# Implementation Plan: [FEATURE] - Technical Approach & Architecture

Implementation plan defining technical approach, project structure, and execution strategy for [FEATURE].

---

## 1. OBJECTIVE

### Metadata
- **Category**: Plan
- **Tags**: [FEATURE], [AREA]
- **Priority**: [P0 | P1 | P2 | P3]
- **Branch**: `[###-feature-name]`
- **Date**: [DATE]
- **Spec**: [Link to spec.md]

### Input
Feature specification from `/specs/[###-feature-name]/spec.md`

### Summary
[Extract from feature spec: primary requirement + technical approach from research]

### Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

- **Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]
- **Primary Dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]
- **Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]
- **Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]
- **Target Platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]
- **Project Type**: [single/web/mobile - determines source structure]
- **Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]
- **Constraints**: [domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]
- **Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

---

## 2. QUALITY GATES

**GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.**

### Definition of Ready (DoR)
- [ ] Problem statement clear; scope documented
- [ ] Stakeholders identified; decisions path agreed
- [ ] Constraints known; risks captured
- [ ] Success criteria measurable

### Definition of Done (DoD)
- [ ] All acceptance criteria met; tests passing
- [ ] Docs updated (spec/plan/tasks/README)
- [ ] Performance/error budgets respected
- [ ] Rollback verified or not needed

### Rollback Guardrails
- **Stop Signals**: [Signals to stop/rollback]
- **Recovery Procedure**: [Recovery procedure reference]

### Constitution Check (Complexity Tracking)

**Fill ONLY if Constitution Check has violations that must be justified**:

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |

---

## 3. PROJECT STRUCTURE

### Documentation (This Feature)

```
specs/[###-feature]/
  spec.md              # Feature specification (see spec-template.md)
  plan.md              # This file (/speckit.plan command output)
  research.md          # Phase 0 output (/speckit.plan command)
  data-model.md        # Phase 1 output (/speckit.plan command)
  quickstart.md        # Phase 1 output (/speckit.plan command)
  contracts/           # Phase 1 output (/speckit.plan command)
  tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (Repository Root)

<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
  models/
  services/
  cli/
  lib/

tests/
  contract/
  integration/
  unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
  src/
    models/
    services/
    api/
  tests/

frontend/
  src/
    components/
    pages/
    services/
  tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
  [same as backend above]

ios/ or android/
  [platform-specific structure: feature modules, UI flows, platform tests]
```

### Structure Decision

[Document the selected structure and reference the real directories captured above]

---

## 4. IMPLEMENTATION PHASES

### Phase 0: Research & Discovery

- **Goal**: [NEEDS CLARIFICATION: Define research objectives]
- **Deliverables**:
  - Research findings documented in research.md
  - Technical feasibility assessment
  - Architecture decision records
- **Owner**: [Team/Individual]
- **Duration**: [Time estimate]
- **Parallel Tasks**: [None | List tasks marked with [P]]

### Phase 1: Design & Setup

- **Goal**: [NEEDS CLARIFICATION: Define design objectives]
- **Deliverables**:
  - Data models defined (data-model.md)
  - API contracts defined (contracts/)
  - Quick start guide (quickstart.md)
  - Development environment setup
- **Owner**: [Team/Individual]
- **Duration**: [Time estimate]
- **Parallel Tasks**: [None | List tasks marked with [P]]

### Phase 2: Core Implementation

- **Goal**: [NEEDS CLARIFICATION: Define core functionality]
- **Deliverables**:
  - [Key feature 1] implemented
  - [Key feature 2] implemented
  - Unit tests coverage ≥ [X]%
- **Owner**: [Team/Individual]
- **Duration**: [Time estimate]
- **Parallel Tasks**: [List tasks marked with [P]]

### Phase 3: Integration & Testing

- **Goal**: [NEEDS CLARIFICATION: Define integration objectives]
- **Deliverables**:
  - Integration tests passing
  - E2E tests passing
  - Performance benchmarks met
- **Owner**: [Team/Individual]
- **Duration**: [Time estimate]
- **Parallel Tasks**: [None | List tasks marked with [P]]

### Phase 4: Deployment & Monitoring

- **Goal**: [NEEDS CLARIFICATION: Define deployment strategy]
- **Deliverables**:
  - Production deployment completed
  - Monitoring/alerting configured
  - Documentation finalized
- **Owner**: [Team/Individual]
- **Duration**: [Time estimate]
- **Parallel Tasks**: [None | List tasks marked with [P]]

**Parallelization Note**: Use [P] tag to denote tasks that can run in parallel

---

## 5. TESTING STRATEGY

### Test Pyramid

```
        /\
       /E2E\      <- Few, high-value end-to-end tests
      /------\
     /  INTEG \   <- More integration tests
    /----------\
   /   UNIT     \  <- Many unit tests (foundation)
  /--------------\
```

### Unit Tests

- **Scope**: [NEEDS CLARIFICATION: What components/functions require unit tests]
- **Tools**: [e.g., pytest, jest, XCTest]
- **Coverage Target**: [e.g., ≥80% line coverage]
- **Execution**: [Local + CI on every commit]

### Integration Tests

- **Scope**: [NEEDS CLARIFICATION: What integrations require testing (API, database, external services)]
- **Tools**: [e.g., pytest + docker-compose, Postman, integration test framework]
- **Coverage Target**: [e.g., All API endpoints, all database operations]
- **Execution**: [CI on PR, nightly]

### End-to-End Tests

- **Scope**: [NEEDS CLARIFICATION: Critical user journeys to test]
- **Tools**: [e.g., Playwright, Cypress, Selenium]
- **Coverage Target**: [e.g., Top 5 user flows, happy paths]
- **Execution**: [CI on PR to main, pre-release]

### Test Data & Environments

- **Test Data**: [NEEDS CLARIFICATION: Strategy for test data (fixtures, factories, snapshots)]
- **Environments**: [Development | Staging | Production-like]
- **Database**: [NEEDS CLARIFICATION: Test database strategy (in-memory, containerized, shared)]

### CI Quality Gates

- [ ] All tests must pass
- [ ] Code coverage ≥ [X]%
- [ ] No critical security vulnerabilities
- [ ] Linting/formatting checks pass
- [ ] Performance benchmarks met
- [ ] No breaking changes (or documented + approved)

---

## 6. SUCCESS METRICS

### Functional Metrics

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| [NEEDS CLARIFICATION: Feature completion] | 100% | [Acceptance criteria checklist] |
| [NEEDS CLARIFICATION: Bug count] | P0/P1 = 0 | [Issue tracker] |

### Performance Metrics

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| [NEEDS CLARIFICATION: Response time] | < [X] ms p95 | [APM tool] |
| [NEEDS CLARIFICATION: Throughput] | > [Y] req/sec | [Load testing] |
| [NEEDS CLARIFICATION: Resource usage] | < [Z] MB memory | [Monitoring] |

### Quality Metrics

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Test coverage | ≥ [X]% | [Coverage tool] |
| Code review turnaround | < [Y] hours | [PR metrics] |
| Documentation completeness | 100% | [Checklist] |

---

## 7. RISKS & MITIGATIONS

### Risk Matrix

| Risk ID | Description | Impact | Likelihood | Mitigation Strategy | Owner |
|---------|-------------|--------|------------|---------------------|-------|
| R-001 | [NEEDS CLARIFICATION] | High/Med/Low | High/Med/Low | [Mitigation plan] | [Name] |
| R-002 | [NEEDS CLARIFICATION] | High/Med/Low | High/Med/Low | [Mitigation plan] | [Name] |

### Rollback Plan

- **Rollback Trigger**: [Conditions that require rollback - e.g., error rate > X%, critical bug detected]
- **Rollback Procedure**:
  1. [Step 1]
  2. [Step 2]
  3. [Step 3]
- **Data Migration Reversal**: [If applicable - how to reverse data migrations]
- **Verification**: [How to verify successful rollback]

---

## 8. DEPENDENCIES

### Internal Dependencies

| Dependency | Type | Owner | Status | Timeline | Impact if Blocked |
|------------|------|-------|--------|----------|-------------------|
| [System/API] | Internal | [Team] | [Green/Yellow/Red] | [Date] | [Impact description] |
| [Library/Tool] | Internal | [Team] | [Green/Yellow/Red] | [Date] | [Impact description] |

### External Dependencies

| Dependency | Type | Vendor | Status | Timeline | Impact if Blocked |
|------------|------|--------|--------|----------|-------------------|
| [Service/API] | External | [Company] | [Green/Yellow/Red] | [Date] | [Impact description] |
| [Library/Tool] | External | [Source] | [Green/Yellow/Red] | [Date] | [Impact description] |

---

## 9. COMMUNICATION & REVIEW

### Stakeholders

- **Product**: [Names]
- **Engineering**: [Names]
- **Design**: [Names]
- **QA**: [Names]
- **Operations**: [Names]

### Checkpoints

- **Standups**: [Cadence - e.g., Daily at 10am]
- **Sprint Planning**: [Cadence - e.g., Bi-weekly Monday]
- **Demo**: [Date/Cadence - e.g., Every sprint end]
- **Review Gates**: [Phase 0 review, Phase 1 review, Pre-launch review]

### Approvals

- **Technical Design**: [Name/Role]
- **Security Review**: [Name/Role]
- **Product Sign-off**: [Name/Role]
- **Launch Approval**: [Name/Role]

---

## 10. REFERENCES

### Related Documents

- **Feature Specification**: See `spec.md` for requirements and user stories
- **Task Breakdown**: See `tasks.md` for implementation task list
- **Checklist**: See `.specify/templates/checklist-template.md` for validation

### Additional References

- [Link additional docs]
- [Architecture diagrams]
- [API documentation]
- [Design mockups]


<!--
  REPLACE SAMPLE CONTENT IN FINAL OUTPUT
  - This template contains placeholders and examples
  - Replace them with actual content
--> 