# Workflow Flowchart - Parallel Pattern Example

Demonstrates concurrent execution of multiple phases with synchronization points.

---

## Use Case: Multi-File Refactoring with Parallel Tasks

```
╭────────────────────────────────────────────────────────╮
│                  CONVERSATION WORKFLOW                 │
╰────────────────────────────────────────────────────────╯
                        │
                        ▼
┌────────────────────────────────────────────────────────┐
│  Preparation                                           │
│  • Analyzing codebase structure                        │
│  • Identifying target files                            │
│  Duration: 3 minutes                                   │
└────────────────────────────────────────────────────────┘
                        │
                        ▼
──────────────────────────────────────────────────────────
PARALLEL EXECUTION - 3 concurrent phases
──────────────────────────────────────────────────────────
                        │
      ┌─────────────────┼─────────────────┐
      │                 │                 │
      ▼                 ▼                 ▼
┌──────────┐      ┌──────────┐      ┌──────────┐
│Component │      │ Utility  │      │  Types   │
│  Files   │      │  Files   │      │  Files   │
│          │      │          │      │          │
│ • Update │      │ • Refact │      │ • Update │
│   API    │      │   helpers│      │   interf │
│ • Add    │      │ • Add    │      │ • Add    │
│   tests  │      │   docs   │      │   gener  │
│          │      │          │      │          │
│Duration: │      │Duration: │      │Duration: │
│ 8 min    │      │ 6 min    │      │ 4 min    │
└──────────┘      └──────────┘      └──────────┘
      │                 │                 │
      │                 │                 │
      └─────────────────┼─────────────────┘
                        │
                        ▼    (All phases complete)
──────────────────────────────────────────────────────────
SYNCHRONIZATION POINT
──────────────────────────────────────────────────────────
                        │
                        ▼
┌────────────────────────────────────────────────────────┐
│  Integration & Testing                                 │
│  • Running integration tests                           │
│  • Validating cross-file changes                       │
│  • Checking type consistency                           │
│  Duration: 4 minutes                                   │
└────────────────────────────────────────────────────────┘
                        │
                        ▼
╭────────────────────────────────────────────────────────╮
│                    WORKFLOW COMPLETE                   │
╰────────────────────────────────────────────────────────╯
```

---

## Key Features Demonstrated

- **Parallel execution**: Multiple phases running concurrently
- **Synchronization points**: Coordination between parallel streams
- **Section dividers**: Visual separation of parallel blocks
- **Sync annotations**: "(All phases complete)" markers
- **Narrow side-by-side boxes**: 10-char width for parallel tasks
- **Detailed timing**: Duration for each concurrent phase
- **Branch visualization**: Tree-like structure showing splits and merges

## When to Use This Pattern

- Concurrent development tasks
- Multi-file refactoring
- Parallel research and implementation
- Independent feature development
- Distributed problem-solving
- Any workflow with > 4 phases

## Style Guidelines

### Parallel Block Structure
```
──────────────────────────────────────────────────────────
SECTION LABEL - Context information
──────────────────────────────────────────────────────────
                        │
      ┌─────────────────┼─────────────────┐
      │                 │                 │
      ▼                 ▼                 ▼
```

### Parallel Phase Boxes
- **Width**: 10 characters (narrower for side-by-side layout)
- **Content**: Truncated to fit (e.g., "Refact" for "Refactor")
- **Spacing**: 6 spaces between boxes
- **Max boxes**: 3 per row (more than 3 creates second row)

### Synchronization Annotations
- **Location**: Below merge point of parallel branches
- **Format**: `(All phases complete)` or `(All X complete)`
- **Spacing**: Right-aligned with flow (4 spaces after arrow)

### Section Dividers
- **Character**: `─` (en-dash, Unicode U+2500)
- **Width**: 58 characters (matching box width)
- **Label**: UPPERCASE with context info below
- **Usage**: Mark entry and exit of parallel blocks
