---
name: markdown-flowchart
description: Create comprehensive ASCII flowcharts in markdown for visualizing complex workflows, user journeys, system architectures, and decision trees. Supports multi-path flows, parallel execution, approval gates, and nested processes with clear visual hierarchy.
license: MIT
---

# Markdown Flowchart - Workflow & Process Visualization

Create comprehensive ASCII flowcharts in markdown for visualizing complex workflows, user journeys, system architectures, and decision trees. Perfect for documentation, process visualization, and communicating complex system behaviors in a text-based format that works everywhere markdown is supported.

---

## 1. 🎯 WHEN TO USE

**Key Capabilities:**
- Multi-path decision flows with branching logic
- Parallel execution blocks with synchronization points
- Hierarchical nested processes and sub-workflows
- Approval gates and validation checkpoints
- User journey mapping with step-by-step flows
- System architecture and data flow diagrams
- Step-by-step procedural documentation

**Use this skill when**:
- Documenting complex multi-step workflows or processes
- Visualizing user journeys and onboarding flows
- Mapping system architectures and data flows
- Creating decision trees with multiple branches
- Showing parallel execution paths and dependencies
- Documenting approval gates and review processes
- Explaining complex business logic visually
- Creating quick reference guides for processes

**Do NOT use this skill for**:
- Simple linear lists (use bullet points instead)
- Code architecture (use mermaid diagrams instead)
- Data models (use ER diagrams instead)
- When interactive/exportable diagrams are required
- Very simple 2-3 step processes

**Core principle**: Clarity through visual hierarchy + consistent formatting = comprehensible workflows

---

## 2. 🛠️ HOW IT WORKS

This skill enables creation of professional ASCII flowcharts using standardized components and patterns. The process follows a systematic approach:

**Process Overview**:
1. Analyze the process/workflow to be visualized
2. Select appropriate pattern(s) from the pattern library
3. Build flowchart using standard components (boxes, arrows, decisions)
4. Apply consistent styling and spacing
5. Add context and annotations
6. Validate completeness and readability

**Component-Based Design**:
- **Reusable elements**: Standard boxes, decisions, arrows, terminals
- **Pattern library**: 7 proven patterns for common scenarios
- **Visual hierarchy**: Different box styles for importance levels
- **Flexible composition**: Combine patterns for complex workflows

**Learning Resources**:
- **Pattern Library**: See Section 4 for 7 core flowchart patterns
- **Reference Examples**: Check the `references/` folder for 6 production-ready examples demonstrating all patterns and techniques
- **Component Guide**: Section 3 covers all available building blocks

**Output**: Text-based flowchart that renders in any markdown viewer, version control friendly, and screen reader accessible.

---

## 3. 📊 FLOWCHART COMPONENTS

### Basic Building Blocks

#### 1. Process Box
```
┌─────────────────────┐
│   Process Step      │
│   Description       │
└─────────────────────┘
```

#### 2. Decision Diamond
```
        ╱───────────╲
       ╱  Decision?  ╲
       ╲             ╱
        ╲───────────╱
```

#### 3. Terminal (Start/End)
```
╭─────────────────────╮
│       Start         │
╰─────────────────────╯
```

#### 4. Connector Arrow
```
         │
         ▼
```

#### 5. Multi-Direction Flow
```
    │         │         │
    ▼         ▼         ▼
```

#### 6. Parallel Block
```
───────────────────────────────────
    PARALLEL EXECUTION BLOCK
───────────────────────────────────
    Agent 1  │  Agent 2  │  Agent 3
───────────────────────────────────
```

#### 7. Loop Back
```
    │
    │  ┌─────────────┐
    └──┤ Loop back   │
       └─────────────┘
```

---

## 4. 📋 FLOWCHART PATTERNS

### Pattern 1: Linear Sequential Flow

**When to use**: Simple step-by-step process without branching

```
╭────────────────────╮
│       Start        │
╰────────────────────╯
         │
         ▼
┌────────────────────┐
│     Step 1         │
│     Action A       │
└────────────────────┘
         │
         ▼
┌────────────────────┐
│     Step 2         │
│     Action B       │
└────────────────────┘
         │
         ▼
╭────────────────────╮
│        End         │
╰────────────────────╯
```

### Pattern 2: Decision Branch

**When to use**: Binary or multi-way decisions

```
┌────────────────────┐
│   Check Status     │
└────────────────────┘
         │
         ▼
    ╱──────────╲
   ╱  Valid?    ╲
   ╲            ╱
    ╲──────────╱
      │      │
    Yes      No
      │      │
      ▼      ▼
  ┌─────┐  ┌─────┐
  │ Pass│  │Reject│
  └─────┘  └─────┘
```

### Pattern 3: Parallel Execution

**When to use**: Multiple tasks that run simultaneously

```
┌────────────────────┐
│   Trigger Event    │
└────────────────────┘
         │
         ▼
───────────────────────────────────────────
      PARALLEL EXECUTION - Stage A
───────────────────────────────────────────
         │           │           │
         ▼           ▼           ▼
    ┌────────┐  ┌────────┐  ┌────────┐
    │ Task A │  │ Task B │  │ Task C │
    └────────┘  └────────┘  └────────┘
         │           │           │
───────────────────────────────────────────
         │
         ▼    (All complete)
┌────────────────────┐
│    Synthesis       │
└────────────────────┘
```

### Pattern 4: Nested Sub-Process

**When to use**: Complex steps with embedded workflows

```
┌────────────────────────────────────────┐
│  MAIN PROCESS: User Onboarding         │
│  ┌──────────────────────────────────┐  │
│  │  SUB-PROCESS: Account Creation   │  │
│  │                                  │  │
│  │  Step 1: Collect Info            │  │
│  │  Step 2: Validate                │  │
│  │  Step 3: Create Account          │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
         │
         ▼
┌────────────────────┐
│  Next Main Step    │
└────────────────────┘
```

### Pattern 5: Approval Gate

**When to use**: Manual review/approval required

```
┌────────────────────┐
│  Prepare Review    │
└────────────────────┘
         │
         ▼
╔════════════════════╗
║  ⚠️  APPROVAL GATE  ║
║  Review Required   ║
╚════════════════════╝
    │         │
 Approve   Reject
    │         │
    ▼         ▼
┌───────┐  ┌───────┐
│Proceed│  │Revise │
└───────┘  └───────┘
```

### Pattern 6: Loop/Iteration

**When to use**: Repeated actions until condition met

```
┌────────────────────┐
│  Initialize        │
└────────────────────┘
         │
         ▼
    ╱──────────╲
   ╱  Complete?  ╲
   ╲  (Check)    ╱
    ╲──────────╱
      │      │
     Yes     No
      │      │
      │      └──────┐
      │             │
      ▼             ▼
  ┌─────┐    ┌──────────┐
  │ End │    │ Process  │
  └─────┘    │ Item     │
             └──────────┘
                  │
                  │ Loop back
                  └────────┘
```

### Pattern 7: Multi-Stage Pipeline

**When to use**: Sequential stages with gates between them

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│ Stage 1  │────▶│ Stage 2  │────▶│ Stage 3  │
│ Planning │     │  Build   │     │  Deploy  │
└──────────┘     └──────────┘     └──────────┘
     │                │                │
     ▼                ▼                ▼
  [Gate 1]        [Gate 2]        [Gate 3]
     │                │                │
     └────────────────┴────────────────┘
                      │
                      ▼
              ┌──────────────┐
              │   Complete   │
              └──────────────┘
```

---

## 5. 🎨 STYLING CONVENTIONS

### Box Types

**Standard Process Box**:
```
┌─────────────────────┐
│   Standard Step     │
└─────────────────────┘
```

**Important/Highlight Box**:
```
╔═════════════════════╗
║  Important Step     ║
╚═════════════════════╝
```

**Rounded Terminal Box**:
```
╭─────────────────────╮
│    Start/End        │
╰─────────────────────╯
```

**Minimal Inline Box**:
```
[ Quick Action ]
```

### Arrow Styles

**Standard Flow**:
```
│
▼
```

**Multiple Paths**:
```
    │
    ├───────┐
    │       │
    ▼       ▼
```

**Conditional Branch**:
```
        │
    ┌───┴───┐
    │       │
   Yes      No
    │       │
    ▼       ▼
```

**Bidirectional**:
```
    │
    ↕
    │
```

**Loop Return**:
```
    │
    └──────┐
           │
```

### Annotations

**Labels on Arrows**:
```
    │
    │ [Success]
    ▼
```

**Side Notes**:
```
┌──────────┐
│  Step    │ ← User input required
└──────────┘
```

**Timing Indicators**:
```
┌──────────────────────┐
│  Process             │
│  Duration: 30-45 sec │
└──────────────────────┘
```

---

## 6. 📝 CREATION WORKFLOW

### Step 1: Understand the Process

**Actions**:
- Gather complete process information
- Identify all steps, decisions, and branches
- Note parallel activities and dependencies
- Identify approval gates and validation points
- Understand start/end conditions

**Questions to ask**:
- What triggers this workflow?
- What are the key decision points?
- Which steps can run in parallel?
- Where are manual approvals required?
- What are the success/failure paths?

**Validation**: `process_understood`

### Step 2: Choose Pattern & Structure

**Actions**:
- Select appropriate pattern(s) from Section 3
- Determine overall flow direction (top-down, left-right)
- Identify where to use nested structures
- Plan parallel execution blocks
- Map out decision branches

**Pattern Selection Guide**:
- Linear process → Pattern 1 (Sequential)
- Decision point → Pattern 2 (Branch)
- Simultaneous tasks → Pattern 3 (Parallel)
- Complex subprocess → Pattern 4 (Nested)
- Manual review → Pattern 5 (Approval Gate)
- Repeated steps → Pattern 6 (Loop)
- Multi-phase project → Pattern 7 (Pipeline)

**Validation**: `structure_planned`

### Step 3: Create Visual Hierarchy

**Actions**:
- Use appropriate box styles (standard, important, terminal)
- Apply consistent spacing and alignment
- Add section headers for major phases
- Use dividers for parallel blocks
- Ensure clear visual flow with arrows

**Spacing Rules**:
- Single blank line between simple steps
- Double blank line between major sections
- Indent nested processes by 2-4 spaces
- Align parallel columns vertically
- Center decision diamonds over branches

**Validation**: `hierarchy_clear`

### Step 4: Add Details & Context

**Actions**:
- Add descriptive labels to each step
- Include timing/duration where relevant
- Label decision branches clearly (Yes/No, options)
- Add annotations for important notes
- Include role indicators (who performs action)
- Add input/output notes where helpful

**Detail Guidelines**:
- Keep box text concise (1-3 lines max)
- Use active voice ("Create document" not "Document is created")
- Add context in parentheses when needed
- Use consistent terminology throughout
- Include measurement criteria for decisions

**Validation**: `details_complete`

### Step 5: Review & Refine

**Actions**:
- Check all paths lead to logical conclusions
- Verify no orphaned branches
- Ensure arrows connect correctly
- Test readability at different zoom levels
- Confirm alignment and spacing
- Validate against original requirements

**Quality Checks**:
- ✓ Can follow any path from start to end?
- ✓ All decision outcomes covered?
- ✓ Parallel blocks have sync points?
- ✓ Approval gates clearly marked?
- ✓ Visual hierarchy supports understanding?
- ✓ No ambiguous connections?

**Validation**: `flowchart_complete`

---

## 7. 💡 EXAMPLE WORKFLOWS

This skill includes comprehensive reference examples in the `references/` directory. Each example demonstrates different patterns and real-world use cases.

### Reference Examples Library

**1. Simple Workflow** (`references/simple-workflow.md`)
- **Pattern**: Linear Sequential Flow
- **Use Case**: User registration process
- **Complexity**: Low
- **Demonstrates**: Basic top-to-bottom flow with context annotations

**2. Parallel Execution** (`references/parallel-execution.md`)
- **Pattern**: Parallel Execution with Synchronization
- **Use Case**: CI/CD deployment pipeline with parallel tests
- **Complexity**: Medium-High
- **Demonstrates**: Concurrent tasks, sync points, approval gates

**3. User Onboarding** (`references/user-onboarding.md`)
- **Pattern**: Nested Sub-Process
- **Use Case**: Complete app onboarding with embedded multi-step forms
- **Complexity**: High
- **Demonstrates**: Nested processes, celebration moments, progressive disclosure

**4. Decision Tree Flow** (`references/decision-tree-flow.md`)
- **Pattern**: Complex Decision Branch
- **Use Case**: E-commerce order processing system
- **Complexity**: High
- **Demonstrates**: Multiple decisions, error handling, retry logic, alternative paths

**5. Approval Workflow with Loops** (`references/approval-workflow-loops.md`)
- **Pattern**: Loop/Iteration + Approval Gates
- **Use Case**: Marketing content approval with revision cycles
- **Complexity**: High
- **Demonstrates**: Multi-stage approval, loop-back mechanisms, escalation paths

**6. System Architecture Swimlane** (`references/system-architecture-swimlane.md`)
- **Pattern**: Swimlane Diagram
- **Use Case**: Microservices authentication and data flow
- **Complexity**: High
- **Demonstrates**: Layer separation, horizontal flow, system integration

### Quick Example Selector

| Your Need | See Example | Key Features |
|-----------|-------------|--------------|
| Simple step-by-step | simple-workflow.md | Clear sequence, timing info |
| Parallel tasks | parallel-execution.md | Sync points, concurrent execution |
| Nested complexity | user-onboarding.md | Sub-processes, celebrations |
| Multiple decisions | decision-tree-flow.md | Branching logic, error paths |
| Review cycles | approval-workflow-loops.md | Loops, escalation, iterations |
| System architecture | system-architecture-swimlane.md | Layers, components, data flow |

### Inline Example: Simple Decision Flow### Inline Example: Simple Decision Flow

```
┌──────────────────┐
│  User Login      │
│  Submit Creds    │
└──────────────────┘
         │
         ▼
    ╱────────╲
   ╱ Valid?   ╲
   ╲          ╱
    ╲────────╱
      │    │
     Yes   No
      │    │
      ▼    ▼
  ┌─────┐ ┌──────┐
  │Allow│ │Reject│
  │Entry│ │Access│
  └─────┘ └──────┘
```

**For complete, production-ready examples**, see the `references/` directory which contains 6 beautifully crafted flowcharts demonstrating all patterns and techniques from this skill.
```
            ▼                     ▼
      ╱──────────╲          ╱──────────╲
     ╱  Approved? ╲        ╱  Revision? ╲
     ╲            ╱        ╲            ╱
      ╲──────────╱          ╲──────────╱
            │                     │
         Approved             Revision
            │                     │
            ▼                     ▼
      ╱──────────╲          ╱──────────╲
     ╱  No       ╲        ╱  No        ╲
     ╲  Response ╱        ╲  Response  ╱
      ╲──────────╱          ╲──────────╱
            │                     │
            │                     │
            └──────────┬──────────┘
                       │
     ┌─────────────────┼─────────────────┐
     │                 │                 │
     ▼                 ▼                 ▼
┌─────────┐    ┌──────────────┐    ┌─────────┐
│Publishing│    │  Implement   │    │  Send   │
│  Queue   │    │  Revisions   │    │Reminders│
└─────────┘    └──────────────┘    └─────────┘
     │                 │                 │
     │                 │                 │
     │                 └────┐    ┌───────┘
     │                      │    │
     │                  Loop back│
     │                      │    │
     ▼                      ▼    ▼
┌─────────┐          ┌──────────────┐
│Schedule │          │     Past     │
│  Posts  │          │  Deadline?   │
└─────────┘          └──────────────┘
     │                      │
     │                      ▼
     │              ┌──────────────┐
     │              │   Escalate   │
     │              │    to AM     │
     │              └──────────────┘
     │
     ▼
╭──────────────────────────────────╮
│      Content Published           │
╰──────────────────────────────────╯
```

---

## 8. ⚠️ COMMON MISTAKES

### Mistake 1: Inconsistent Spacing

**Problem**: Makes flow hard to follow visually
**Example**:
```
┌────┐
│Step│
└────┘
│
▼
┌────┐

│Step│


└────┘
```

**Fix**: Use consistent spacing between elements
```
┌────────┐
│  Step  │
└────────┘
     │
     ▼
┌────────┐
│  Step  │
└────────┘
```

### Mistake 2: Ambiguous Arrows

**Problem**: Unclear which box arrow connects to
**Example**:
```
┌────┐     ┌────┐
│ A  │     │ B  │
└────┘     └────┘
    │
    ▼
┌────┐
│ C  │  (Does arrow come from A or B?)
└────┘
```

**Fix**: Align arrows clearly
```
┌────┐     ┌────┐
│ A  │     │ B  │
└────┘     └────┘
  │           │
  └─────┬─────┘
        │
        ▼
    ┌────┐
    │ C  │
    └────┘
```

### Mistake 3: Missing Decision Outcomes

**Problem**: Not all paths from decision are shown
**Example**:
```
    ╱────────╲
   ╱ Valid?   ╲
   ╲          ╱
    ╲────────╱
        │
       Yes
        │
        ▼
    (What about No?)
```

**Fix**: Show all outcomes
```
    ╱────────╲
   ╱ Valid?   ╲
   ╲          ╱
    ╲────────╱
      │    │
     Yes   No
      │    │
      ▼    ▼
```

### Mistake 4: Orphaned Processes

**Problem**: Boxes with no entry or exit points

**Fix**: Ensure every box connects to the flow

### Mistake 5: Over-Complexity

**Problem**: Trying to show too much detail in one diagram

**Fix**: Break into multiple diagrams or use nested sub-processes

### Mistake 6: Poor Box Alignment

**Problem**: Boxes don't line up, creating visual chaos
```
┌────────┐
│  Step  │
└────────┘
    │
    ▼
  ┌────────┐
  │  Step  │
  └────────┘
```

**Fix**: Align vertically or horizontally
```
┌────────┐
│  Step  │
└────────┘
    │
    ▼
┌────────┐
│  Step  │
└────────┘
```

---

## 9. 📖 RULES

### ALWAYS

- Use consistent box styles throughout diagram
- Align elements vertically or horizontally
- Label all decision branches clearly
- Show complete paths from start to end
- Include context/timing when relevant
- Use visual hierarchy (size, style) for importance
- Test readability at different zoom levels
- Validate all paths lead to logical conclusions

### NEVER

- Mix box styles inconsistently
- Leave decision outcomes unlabeled
- Create orphaned boxes without connections
- Use diagonal lines (stick to vertical/horizontal)
- Overcrowd a single diagram
- Assume unlabeled paths are obvious
- Forget to show loop-back paths
- Skip terminal nodes (start/end)

### ESCALATE IF

- Process is too complex for single diagram
- Client wants interactive/exportable format
- Diagram needs to be maintained in design tool
- Animation or interactivity required
- Diagram exceeds ~30-40 boxes
- Multiple stakeholders need collaborative editing

---

## 10. 🎓 SUCCESS CRITERIA

**Flowchart is successful when**:
- ✅ All paths from start to end are clear
- ✅ Decisions have labeled outcomes
- ✅ Parallel processes are clearly marked
- ✅ Approval gates are visually distinct
- ✅ Spacing and alignment are consistent
- ✅ Can be understood without verbal explanation
- ✅ Matches actual process accurately
- ✅ Visual hierarchy supports comprehension

**Quality Gates**:
- Can a new person follow any path?
- Are all decision points exhaustive?
- Do parallel blocks resolve properly?
- Are approval gates clearly identified?
- Is timing/context provided where needed?
- Does visual hierarchy aid understanding?

---

## 11. 🔧 ADVANCED TECHNIQUES

### Multi-Column Layouts

For wide processes with parallel tracks:

```
┌─────────────┬─────────────┬─────────────┐
│  Track 1    │  Track 2    │  Track 3    │
│  Frontend   │  Backend    │  Database   │
├─────────────┼─────────────┼─────────────┤
│             │             │             │
│  ┌───────┐  │  ┌───────┐  │  ┌───────┐  │
│  │ Step  │  │  │ Step  │  │  │ Step  │  │
│  └───────┘  │  └───────┘  │  └───────┘  │
│      │      │      │      │      │      │
│      ▼      │      ▼      │      ▼      │
│  ┌───────┐  │  ┌───────┐  │  ┌───────┐  │
│  │ Step  │  │  │ Step  │  │  │ Step  │  │
│  └───────┘  │  └───────┘  │  └───────┘  │
└─────────────┴─────────────┴─────────────┘
```

### Swimlane Diagrams

For showing responsibility across roles:

```
───────────────────────────────────────────────────
  User          │    System        │   Database
───────────────────────────────────────────────────
                │                 │
  ┌──────┐      │                 │
  │Login │──────▶ ┌──────────┐    │
  └──────┘      │ │ Validate │────▶ ┌─────────┐
                │ └──────────┘    │ │  Query  │
                │      │          │ └─────────┘
                │      ▼          │      │
                │ ┌──────────┐    │      │
  ┌──────┐ ◀────│─│ Generate │ ◀──┴──────┘
  │Token │      │ │   Token  │    │
  └──────┘      │ └──────────┘    │
───────────────────────────────────────────────────
```

### Conditional Loops with Exit Conditions

```
        ┌────────────────┐
        │  Initialize    │
        │  Counter = 0   │
        └────────────────┘
                │
                ▼
        ┌───────────────┐
    ┌──▶│  Process Item │◀──┐
    │   └───────────────┘   │
    │           │            │
    │           ▼            │
    │   ╱──────────────╲     │
    │  ╱  Counter < 10  ╲    │
    │  ╲  AND More Data ╱    │
    │   ╲──────────────╱     │
    │       │        │       │
    │      Yes      No       │
    │       │        │       │
    │       │        ▼       │
    │       │    ┌───────┐   │
    │       │    │  End  │   │
    │       │    └───────┘   │
    │       │                │
    │       ▼                │
    │   ┌──────────┐         │
    │   │Increment │         │
    │   │ Counter  │         │
    │   └──────────┘         │
    │       │                │
    └───────┘                │
                             │
        Loop continues  ─────┘
```

### Error Handling Flows

```
┌────────────────┐
│  Execute Task  │
└────────────────┘
        │
        ▼
    ╱──────╲
   ╱ Success ╲
   ╲         ╱
    ╲──────╱
     │   │
    Yes  No (Error)
     │   │
     │   ▼
     │ ╭──────────────────╮
     │ │  ERROR HANDLER   │
     │ ╰──────────────────╯
     │         │
     │         ▼
     │     ╱──────╲
     │    ╱Retryable╲
     │    ╲         ╱
     │     ╲──────╱
     │       │   │
     │      Yes  No
     │       │   │
     │       │   ▼
     │       │ ┌──────────┐
     │       │ │  Log &   │
     │       │ │  Alert   │
     │       │ └──────────┘
     │       │      │
     │       │      ▼
     │       │  ┌────────┐
     │       │  │  Fail  │
     │       │  └────────┘
     │       │
     │       └──(Retry)──┐
     │                   │
     └───────────────────┘
             │
             ▼
      ┌──────────┐
      │ Continue │
      └──────────┘
```

---

## 12. 🔗 INTEGRATION POINTS

### Called By
- **Documentation workflows** - For process documentation
- **Spec Kit workflows** - For workflow visualization
- **Onboarding systems** - For user journey mapping
- **Architecture reviews** - For system flow documentation

### Pairs With
- **workflow-spec-kit** - Visualizing the 15-step workflow
- **git-worktrees** - Documenting branch strategies
- **Project documentation** - Process guides and READMEs

### Outputs To
- Markdown files in project documentation
- README files
- Specification documents
- Knowledge base articles
- Process handbooks

---

## 13. 📚 REFERENCES

### Character Sets Used

**Box Drawing Characters**:
- `─` `│` `┌` `┐` `└` `┘` - Single line
- `═` `║` `╔` `╗` `╚` `╝` - Double line
- `├` `┤` `┬` `┴` `┼` - Line intersections
- `╭` `╮` `╰` `╯` - Rounded corners

**Arrows**:
- `▲` `▼` `◀` `▶` - Filled triangles
- `↑` `↓` `←` `→` - Line arrows
- `↕` `↔` - Bidirectional

**Shapes**:
- `╱` `╲` - Diamond corners
- `◆` `●` `■` - Filled shapes

### Related Documentation
- ASCII Art and Box Drawing Standards
- Markdown Extended Syntax
- Flowchart Design Best Practices

---

## 14. 💡 TIPS & BEST PRACTICES

### Clarity Over Complexity
- If diagram needs more than 40 boxes, split into multiple diagrams
- Use nested sub-process notation for complex steps
- Link to separate detailed diagrams when needed

### Consistent Terminology
- Use same terms throughout (e.g., "User" vs "Customer")
- Match terminology to your domain/project
- Define acronyms on first use

### Consider Your Audience
- Technical audience: Can include system details
- Business audience: Focus on high-level flow
- Mixed audience: Use layers (overview + detailed views)

### Maintenance
- Keep flowcharts near related code/docs
- Update when process changes
- Include version/date in header
- Document major process changes in git commits

### Testing Your Diagram
1. Ask someone unfamiliar to trace a path
2. Check if all questions are answered visually
3. Verify no ambiguous connections
4. Confirm all outcomes are shown
5. Test readability at different zoom levels

---

## 15. 🎯 QUICK REFERENCE

### Common Scenarios

| Need | Pattern to Use |
|------|----------------|
| Linear process | Pattern 1: Sequential |
| Yes/No decision | Pattern 2: Decision Branch |
| Multiple paths split | Pattern 2: Multi-way Branch |
| Simultaneous work | Pattern 3: Parallel Execution |
| Complex subprocess | Pattern 4: Nested Process |
| Manual checkpoint | Pattern 5: Approval Gate |
| Repeated action | Pattern 6: Loop/Iteration |
| Multi-phase project | Pattern 7: Pipeline |
| User journey | Example 2 format |
| Review process | Example 3 format |

### Quick Syntax

```
Standard box:     ┌─────┐
Important box:    ╔═════╗
Terminal:         ╭─────╮
Decision:         ╱─────╲
Down arrow:       │ ▼
Branch:           ├───┐
Parallel divider: ═════
Section header:   ─────
```