---
description: Generate post-implementation retrospective for completed features.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/speckit.retrospective` in the triggering message **is** optional context or focus areas. The command will generate a retrospective for the current feature directory.

Given the feature context, do this:

1. **Setup & Validation**:
   - Run `.specify/scripts/bash/check-prerequisites.sh --json` from repo root
   - Parse JSON for FEATURE_DIR and AVAILABLE_DOCS
   - **Verify feature is complete**:
     - spec.md must exist
     - plan.md must exist (or at minimum spec.md)
     - tasks.md should exist (optional but recommended)
   - If feature not complete: WARN user but proceed (retrospective can be done mid-implementation)

2. **Load Context**:
   - Read spec.md:
     - Feature name and purpose
     - User stories
     - Success Criteria section
     - Metadata (dates if available)
   - Read plan.md:
     - Success Metrics section (functional, performance, quality)
     - Timeline estimates
     - Technical Context
   - Read tasks.md (if exists):
     - Total task count
     - Completed vs. pending tasks
   - Check for existing retrospective.md to avoid overwriting

3. **Load Template**:
   - Load `.specify/templates/retrospective-template.md` as structure reference

4. **Interactive Retrospective Gathering**:

   a. **Timeline Information**:
      - Ask: "When did implementation start?" (Date: YYYY-MM-DD)
      - Ask: "When was implementation completed?" (Date: YYYY-MM-DD or "still in progress")
      - Calculate duration
      - Compare to plan.md estimate (if available)

   b. **What Went Well** (3-5 items):
      ```markdown
      Q: What went well during this implementation?

      Please provide 3-5 things that worked well:
      1. [Prompt for technical successes]
      2. [Prompt for process successes]
      3. [Prompt for collaboration successes]
      ```

   c. **What Could Be Improved** (3-5 items):
      ```markdown
      Q: What could have been improved?

      Please provide 3-5 areas for improvement:
      1. [Prompt for technical challenges]
      2. [Prompt for process challenges]
      3. [Prompt for blockers encountered]
      ```

   d. **Key Lessons Learned** (3-5 items):
      ```markdown
      Q: What are the key lessons learned from this feature?

      Please provide 3-5 lessons:
      1. [Prompt for technical learnings]
      2. [Prompt for process learnings]
      3. [Prompt for team dynamics learnings]
      ```

   e. **Metrics Validation**:
      For each success criterion from spec.md:
      ```markdown
      Q: For criterion "[Criterion text from spec]"
         Target: [Target value]
         What was the actual result?

      Options:
      - Met: Achieved target or exceeded
      - Partial: Partially achieved (provide actual value)
      - Missed: Did not achieve (provide actual value and reason)
      ```

      If plan.md has performance/quality metrics, ask about those too.

   f. **Action Items** (3-5 items):
      ```markdown
      Q: What action items should we take based on this retrospective?

      Please provide 3-5 action items with owners and priorities:
      1. [Action] - [Owner] - [P0/P1/P2]
      2. [Action] - [Owner] - [P0/P1/P2]
      ```

5. **Generate Retrospective Document** using template structure:

   a. **Metadata Section (§1)**:
      ```markdown
      # [FEATURE NAME] - Implementation Retrospective

      Post-implementation review capturing learnings, achievements, and improvements for future work.

      ---

      ## 1.  METADATA

      - **Feature**: [Link to spec.md]
      - **Date Completed**: [From user input]
      - **Team Members**: [Extract from context or ask user]
      - **Conducted By**: [Current user or ask]
      - **Date of Retrospective**: [TODAY - YYYY-MM-DD]
      ```

   b. **Summary Section (§2)**:
      - Feature Overview: 1-2 sentences from spec.md Purpose
      - Timeline:
        - Started: From user input
        - Completed: From user input
        - Duration: Calculate from dates
        - Original Estimate: From plan.md (if available)
        - Variance: Calculate difference

   c. **What Went Well Section (§3)**:
      - Successes Table: Categorize user responses by Technical/Process/Collaboration
      - Highlights: Top 3-5 items from user input
      - Best Practices to Keep: Extract practices mentioned

   d. **What Could Be Improved Section (§4)**:
      - Challenges Faced Table: Categorize by Technical/Process/Collaboration with resolution
      - Areas for Improvement: List from user input
      - Blockers Encountered: Extract blockers and how they were resolved

   e. **Lessons Learned Section (§5)**:
      - Technical Learnings: From user input
      - Process Learnings: From user input
      - Team Dynamics: From user input
      - Key Takeaways: Top 3 most important lessons

   f. **Metrics Achieved Section (§6)**:
      - Success Criteria Table:
        - Import from spec.md Success Criteria
        - Add Target (from spec)
        - Add Actual (from user input)
        - Add Status ( Met / Partial / Missed)
      - Performance Metrics Table (if plan.md has metrics):
        - Import from plan.md Success Metrics
        - Add actual values from user input
      - Quality Metrics Table (if plan.md has metrics):
        - Test coverage, bug count, review turnaround

   g. **Action Items Section (§7)**:
      - Immediate Actions Table: From user input with owners/priorities/dates
      - Process Improvements Table: Specific changes with expected benefits
      - Follow-up Work: Checklist of follow-up tasks

   h. **Additional Notes Section (§8)**:
      - What We Would Do Differently: Free-form notes
      - Unexpected Challenges: Notes on surprises
      - Pleasant Surprises: Notes on things that went better than expected
      - Team Feedback: Open feedback

   i. **References Section (§9)**:
      - Feature Specification: Link to spec.md
      - Implementation Plan: Link to plan.md
      - Task List: Link to tasks.md
      - Pull Requests: Ask user for PR links or extract from git log
      - Related Retrospectives: Link to other retrospectives in parent directory

6. **Generate Follow-up Recommendations**:
   - Based on metrics comparison, suggest improvements
   - If metrics missed targets, suggest investigation or spec updates
   - If timeline variance high, suggest estimation improvements
   - If technical debt mentioned, suggest follow-up tasks

7. **Report Completion**:
   ```markdown
    Retrospective Document Created

    Retrospective Summary:
   - Feature: [Feature name]
   - Duration: [X days] ([Variance vs. estimate])
   - Success Criteria: [X/Y met] ([percentage]%)
   - File Path: [Full path to retrospective.md]

    Metrics Summary:
   - Success Criteria Met: [X/Y] ([percentage]%)
   - Performance Targets: [X/Y met]
   - Quality Targets: [X/Y met]

    Key Insights:
   - Top Success: [#1 item from What Went Well]
   - Top Challenge: [#1 item from What Could Be Improved]
   - Key Learning: [#1 lesson learned]

    Action Items: [N items]
   - P0 (Critical): [count]
   - P1 (High): [count]
   - P2 (Medium): [count]

    Structure Generated:
   -  Metadata (feature, dates, team, facilitator)
   -  Summary (overview, timeline with variance)
   -  What Went Well (successes, highlights, best practices)
   -  What Could Be Improved (challenges, improvements, blockers)
   -  Lessons Learned (technical, process, team, key takeaways)
   -  Metrics Achieved (success criteria, performance, quality)
   -  Action Items (immediate, process improvements, follow-ups)
   -  Additional Notes (what to do differently, surprises, feedback)
   -  References (spec, plan, tasks, PRs, related retrospectives)

    Next Steps:
   1. Review the generated retrospective document
   2. Share with team for additional feedback
   3. Schedule follow-up meeting to review action items
   4. Track action items to completion
   5. Reference learnings in future feature planning

    Recommendations:
   [Generate specific recommendations based on metrics and variance]
   ```

## Key Rules

- **Honest Assessment**: Document both successes AND failures
- **Action-Oriented**: Every problem should have an action item
- **Metrics-Based**: Compare actual vs. target metrics from spec/plan
- **Forward-Looking**: Focus on learnings for future improvements
- **Team Collaboration**: Gather input from all team members if possible
- **Blame-Free**: Focus on process/system improvements, not individual blame

## Template Compliance

All generated retrospective documents MUST include every section from retrospective-template.md:
- § 1: Metadata
- § 2: Summary
- § 3: What Went Well
- § 4: What Could Be Improved
- § 5: Lessons Learned
- § 6: Metrics Achieved
- § 7: Action Items
- § 8: Additional Notes
- § 9: References

## Interactive Flow Example

```
User: /speckit.retrospective

Assistant: "I'll generate a retrospective for this feature. Let me gather some information."

Q1: When did implementation start?
User: "2024-01-15"

Q2: When was implementation completed?
User: "2024-02-10"

Assistant: "Duration: 26 days. The original estimate was 21 days, so we were +5 days over."

Q3: What went well during this implementation? (3-5 items)
User:
1. "Code review process was very efficient"
2. "Team collaboration was excellent"
3. "Testing strategy worked well"

Q4: What could have been improved? (3-5 items)
User:
1. "Initial requirements were unclear"
2. "Integration testing took longer than expected"
3. "Documentation was done at the end instead of incrementally"

Q5: What are the key lessons learned? (3-5 items)
User:
1. "Clarify requirements upfront with /speckit.clarify"
2. "Start integration tests earlier in development"
3. "Write documentation as code is written"

[For each success criterion, asks Met/Partial/Missed]

Q6: What action items should we take? (3-5 items)
User:
1. "Update onboarding docs with integration testing guide - Bob - P1"
2. "Schedule requirements review session for next feature - Alice - P0"
3. "Set up documentation PR template - Charlie - P2"

-> Generates retrospective.md with all sections
-> Metrics comparison table shows 4/5 criteria met
-> Action items table with owners and priorities
```

## Examples

**Example 1: Successful Feature**
```
/speckit.retrospective

-> All success criteria met
-> Timeline on target
-> Focus on maintaining best practices
-> Few action items (process improvements)
```

**Example 2: Challenging Feature**
```
/speckit.retrospective

-> Some criteria missed (3/5 met)
-> Timeline over by 30%
-> Multiple blockers encountered
-> Many action items for improvement
-> Rich lessons learned section
```

**Example 3: Mid-Implementation Retrospective**
```
/speckit.retrospective

-> Run during implementation (not just after)
-> "Still in progress" for completion date
-> Capture learnings while fresh
-> Adjust approach based on interim findings
```

**Example 4: Team Retrospective**
```
/speckit.retrospective "Focus on team collaboration and communication"

-> Emphasizes team dynamics section
-> Includes feedback from all team members
-> Action items focused on process improvements
```

## Related Commands

- **Before Implementation**: Use `/speckit.specify` and `/speckit.plan` to set clear success criteria
- **During Implementation**: Use `/speckit.clarify` to resolve ambiguities early
- **After Retrospective**: Create follow-up tasks or spikes for action items
- **Next Feature**: Reference lessons learned when creating new specs

## Best Practices

- **Run Timely**: Conduct retrospective soon after completion (while memories are fresh)
- **Include Team**: Gather input from all contributors, not just one person
- **Be Specific**: Use concrete examples, not vague statements
- **Action-Oriented**: Every "could be improved" should have an action item
- **Reference Data**: Use actual metrics, don't rely on feelings/estimates
- **Track Actions**: Follow up on action items in next retrospective
- **Build Pattern Library**: Use retrospectives to build team knowledge base

## Metrics Comparison Strategy

When comparing metrics:

1. **Success Criteria** (from spec.md):
   - Technology-agnostic outcomes
   - User/business focused
   - Example: "Users complete checkout in <3 minutes"

2. **Performance Metrics** (from plan.md):
   - Technical measurements
   - System capabilities
   - Example: "API p95 response time <200ms"

3. **Quality Metrics** (from plan.md):
   - Code quality indicators
   - Process quality
   - Example: "Test coverage ≥70%"

For each metric:
- **Met**: Celebrate success, document what worked
- **Partial**: Document gap, create action item to address
- **Missed**: Root cause analysis, create action item with investigation

## Follow-up Schedule

After generating retrospective:

1. **Immediate** (Same day):
   - Share with team for feedback
   - Review action items

2. **Week 1**:
   - Assign owners to action items
   - Set due dates
   - Create follow-up tasks

3. **Week 2-4**:
   - Track action item progress
   - Update retrospective with amendments

4. **Next Feature**:
   - Reference lessons learned in new spec/plan
   - Apply process improvements
   - Measure if improvements worked
