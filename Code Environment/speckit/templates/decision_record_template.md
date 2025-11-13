# Decision: [DECISION TITLE] - Architecture Decision Record

Architecture Decision Record (ADR) documenting a significant technical decision and its rationale.

---

## 1. METADATA

- **Decision ID**: ADR-[###]
- **Status**: [Proposed | Accepted | Deprecated | Superseded]
- **Date**: [YYYY-MM-DD]
- **Deciders**: [Names of decision makers]
- **Related Feature**: [Link to spec.md if applicable]
- **Supersedes**: [Link to ADR this replaces, or N/A]
- **Superseded By**: [Link to ADR that replaces this, or N/A]

---

## 2. CONTEXT

### Problem Statement
[What is the technical problem we are trying to solve? What forces are at play?]

### Current Situation
[Describe the current state - what exists today that we're changing or building upon]

### Constraints
- [Technical constraint 1]
- [Technical constraint 2]
- [Business constraint 1]
- [Time/resource constraint]

### Assumptions
- [Assumption 1 about environment/platform]
- [Assumption 2 about users/usage]
- [Assumption 3 about future needs]

---

## 3. DECISION

### Summary
[One-sentence description of the decision made]

### Detailed Description
[Comprehensive description of the decision, including:]
- What will be implemented
- How it will be implemented
- Why this approach was chosen
- What changes from the current state

### Technical Approach
```[language]
[Code example, architecture diagram, or technical specification]
```

---

## 4. ALTERNATIVES CONSIDERED

### Option 1: [CHOSEN] [Option Name]

**Description**: [How this option works]

**Pros**:
- [Pro 1]
- [Pro 2]
- [Pro 3]

**Cons**:
- [Con 1]
- [Con 2]

**Score**: [X/10]

**Why Chosen**: [Rationale for selecting this option]

---

### Option 2: [Option Name]

**Description**: [How this option works]

**Pros**:
- [Pro 1]
- [Pro 2]

**Cons**:
- [Con 1]
- [Con 2]
- [Con 3]

**Score**: [X/10]

**Why Rejected**: [Specific reasons this wasn't chosen]

---

### Option 3: [Option Name]

**Description**: [How this option works]

**Pros**:
- [Pro 1]
- [Pro 2]

**Cons**:
- [Con 1]
- [Con 2]

**Score**: [X/10]

**Why Rejected**: [Specific reasons this wasn't chosen]

---

### Comparison Matrix

| Criterion | Weight | Option 1 | Option 2 | Option 3 |
|-----------|--------|----------|----------|----------|
| Performance | High | Excellent | Moderate | Poor |
| Maintainability | High | Good | Good | Moderate |
| Cost | Medium | Low | Medium | High |
| Time to implement | Medium | Fast | Moderate | Slow |
| Scalability | High | Excellent | Moderate | Good |
| **Weighted Score** | - | **[X/10]** | [Y/10] | [Z/10] |

---

## 5. CONSEQUENCES

### Positive Consequences
- [Positive outcome 1]
- [Positive outcome 2]
- [Positive outcome 3]

### Negative Consequences
- [Negative outcome 1 + mitigation strategy]
- [Negative outcome 2 + mitigation strategy]
- [Negative outcome 3 + mitigation strategy]

### Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| [Risk 1] | High/Med/Low | High/Med/Low | [How to mitigate] |
| [Risk 2] | High/Med/Low | High/Med/Low | [How to mitigate] |

### Technical Debt Introduced
- [Technical debt item 1 + plan to address]
- [Technical debt item 2 + plan to address]

---

## 6. IMPACT ASSESSMENT

### Systems Affected
- [System/component 1] - [How it's affected]
- [System/component 2] - [How it's affected]
- [System/component 3] - [How it's affected]

### Teams Impacted
- [Team 1] - [What they need to do]
- [Team 2] - [What they need to do]

### Migration Path
[If this changes existing systems, describe the migration approach:]
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Rollback Strategy
[How to revert this decision if needed]

---

## 7. TIMELINE

- **Decision Made**: [Date]
- **Implementation Start**: [Date]
- **Target Completion**: [Date]
- **Review Date**: [Date - when we'll review if this decision still makes sense]

---

## 8. REFERENCES

### Related Documents
- **Feature Specification**: [Link to spec.md]
- **Implementation Plan**: [Link to plan.md]
- **Related ADRs**: [Links to related decisions]
- **Research/Spikes**: [Links to research that informed this decision]

### External References
- [Link to documentation]
- [Link to research paper]
- [Link to blog post/article]
- [Link to discussion/RFC]

### Discussion History
- [Link to Slack thread]
- [Link to meeting notes]
- [Link to RFC document]

---

## 9. APPROVAL & SIGN-OFF

### Approvers

| Name | Role | Approved | Date | Comments |
|------|------|----------|------|----------|
| [Name] | [Role] | Yes / No | [Date] | [Comments] |
| [Name] | [Role] | Yes / No | [Date] | [Comments] |
| [Name] | [Role] | Yes / No | [Date] | [Comments] |

### Status Changes

| Date | Previous Status | New Status | Reason |
|------|----------------|------------|--------|
| [Date] | - | Proposed | [Initial proposal] |
| [Date] | Proposed | Accepted | [Approval rationale] |

---

## 10. UPDATES & AMENDMENTS

### Amendment History

| Date | Change | Reason | Updated By |
|------|--------|--------|------------|
| [Date] | [What changed] | [Why] | [Name] |

### Review Notes
[Notes from periodic reviews of this decision]

---

**Review Schedule**: This decision should be reviewed on [DATE] to assess if it still meets our needs.


<!--
  REPLACE SAMPLE CONTENT IN FINAL OUTPUT
  - This template contains placeholders and examples
  - Replace them with actual content
--> 