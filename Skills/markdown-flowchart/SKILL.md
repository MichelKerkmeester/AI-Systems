---
name: markdown-flowchart
description: This skill creates comprehensive ASCII flowcharts in markdown for visualizing complex workflows, user journeys, system architectures, and decision trees. This skill should be used when documenting processes with multi-path flows, parallel execution, approval gates, and nested processes with clear visual hierarchy.
allowed-tools: Read, Write, Edit
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
┌────────────────────┐
│ ⚠️  APPROVAL GATE  │
│  Review Required   │
└────────────────────┘
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

**Rounded Terminal Box** (Start/End):
```
╭─────────────────────╮
│    Start/End        │
╰─────────────────────╯
```

**Minimal Inline Box**:
```
[ Quick Action ]
```

**Note**: Use emoji (⚠️, ✅, 🔒) within standard boxes to indicate importance/special status rather than changing box style.

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

**1. Simple Workflow** (`references/simple_workflow.md`)
- **Pattern**: Linear Sequential Flow
- **Use Case**: User registration process
- **Complexity**: Low
- **Demonstrates**: Basic top-to-bottom flow with context annotations

**2. Parallel Execution** (`references/parallel_execution.md`)
- **Pattern**: Parallel Execution with Synchronization
- **Use Case**: CI/CD deployment pipeline with parallel tests
- **Complexity**: Medium-High
- **Demonstrates**: Concurrent tasks, sync points, approval gates

**3. User Onboarding** (`references/user_onboarding.md`)
- **Pattern**: Nested Sub-Process
- **Use Case**: Complete app onboarding with embedded multi-step forms
- **Complexity**: High
- **Demonstrates**: Nested processes, celebration moments, progressive disclosure

**4. Decision Tree Flow** (`references/decision_tree_flow.md`)
- **Pattern**: Complex Decision Branch
- **Use Case**: E-commerce order processing system
- **Complexity**: High
- **Demonstrates**: Multiple decisions, error handling, retry logic, alternative paths

**5. Approval Workflow with Loops** (`references/approval_workflow_loops.md`)
- **Pattern**: Loop/Iteration + Approval Gates
- **Use Case**: Marketing content approval with revision cycles
- **Complexity**: High
- **Demonstrates**: Multi-stage approval, loop-back mechanisms, escalation paths

**6. System Architecture Swimlane** (`references/system_architecture_swimlane.md`)
- **Pattern**: Swimlane Diagram
- **Use Case**: Microservices authentication and data flow
- **Complexity**: High
- **Demonstrates**: Layer separation, horizontal flow, system integration

### Quick Example Selector

| Your Need | See Example | Key Features |
|-----------|-------------|--------------|
| Simple step-by-step | simple_workflow.md | Clear sequence, timing info |
| Parallel tasks | parallel_execution.md | Sync points, concurrent execution |
| Nested complexity | user_onboarding.md | Sub-processes, celebrations |
| Multiple decisions | decision_tree_flow.md | Branching logic, error paths |
| Review cycles | approval_workflow_loops.md | Loops, escalation, iterations |
| System architecture | system_architecture_swimlane.md | Layers, components, data flow |

### Inline Example: Simple Decision Flow

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

---

## 8. ⚠️ COMMON MISTAKES

### Inconsistent Spacing
Makes flow hard to follow. Use consistent spacing between all elements (single blank line for simple steps, double for major sections).

### Ambiguous Arrows
Unclear connections create confusion. Always align arrows clearly and merge paths explicitly when multiple boxes lead to one destination.

**Example**:
```
┌────┐     ┌────┐
│ A  │     │ B  │
└────┘     └────┘
  │           │
  └─────┬─────┘  ← Explicit merge
        │
        ▼
    ┌────┐
    │ C  │
    └────┘
```

### Missing Decision Outcomes
Every decision branch must show all possible outcomes. Don't leave paths unlabeled or assume they're obvious.

### Other Critical Errors to Avoid
- **Orphaned processes**: Every box must have entry and exit points
- **Over-complexity**: Break diagrams with >40 boxes into multiple views
- **Poor alignment**: Maintain vertical/horizontal alignment throughout

---

## 9. 📖 RULES

### ALWAYS

- Use consistent box styles throughout diagram (standard single-line boxes only)
- Align elements vertically or horizontally
- Label all decision branches clearly
- Show complete paths from start to end
- Include context/timing when relevant
- Use emoji within boxes for importance (⚠️, ✅, 🔒)
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

**Multi-Column Layouts**: Use table-like structures for parallel tracks (Frontend | Backend | Database)

**Swimlane Diagrams**: Show responsibility across roles/systems with horizontal dividers

**Conditional Loops**: Combine decision diamonds with loop-back arrows for iteration with exit conditions

**Error Handling**: Nest error handlers with retry logic inside decision branches

**For detailed examples of these techniques**, see `references/system_architecture_swimlane.md` and `references/approval_workflow_loops.md` which demonstrate production implementations.

---

## 12. 🔗 INTEGRATION POINTS

### Called By
- **Documentation workflows** - For process documentation
- **Spec Kit workflows** - For workflow visualization
- **Onboarding systems** - For user journey mapping
- **Architecture reviews** - For system flow documentation

### Pairs With
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

- **Clarity over complexity**: Split diagrams with >40 boxes into multiple views or nested sub-processes
- **Consistent terminology**: Use identical terms throughout; define acronyms on first use
- **Audience adaptation**: Technical = system details; Business = high-level flow; Mixed = layered views
- **Maintenance**: Keep flowcharts near related code; update when process changes; version in header
- **Validation**: Have someone unfamiliar trace a path; verify all outcomes shown; test readability at zoom levels

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
Terminal:         ╭─────╮
Decision:         ╱─────╲
Down arrow:       │ ▼
Branch:           ├───┐
Parallel divider: ─────
Emoji markers:    ⚠️ ✅ 🔒
```