---
description: Generate an actionable, dependency-ordered tasks.md for the feature based on available design artifacts.
---

# Task Generation

Generate actionable, dependency-ordered tasks.md organized by user stories with strict checklist format and parallel execution opportunities.

---

## 1. 📋 INPUTS

### User Arguments

```text
$ARGUMENTS
```

**MUST consider user input before proceeding** (if not empty).

### Prerequisites Script Output

**Command**: \`.specify/scripts/bash/check-prerequisites.sh --json\`

**Outputs**:
- FEATURE_DIR: Feature directory path (absolute)
- AVAILABLE_DOCS: List of available design documents

**Note**: For single quotes in args, use escape syntax: \`'I'\\''m Groot'\` or \`"I'm Groot"\`

---

## 2. 🚀 WORKFLOW

### Step 1: Setup

**Purpose**: Identify available design documents

**Actions**:
1. Run \`.specify/scripts/bash/check-prerequisites.sh --json\` from repo root
2. Parse FEATURE_DIR and AVAILABLE_DOCS list
3. All paths must be absolute

**Validation**: \`setup_complete\`

### Step 2: Load Design Documents

**Purpose**: Read available design artifacts

**Required Documents**:
- \`plan.md\`: Tech stack, libraries, structure
- \`spec.md\`: User stories with priorities

**Optional Documents**:
- \`data-model.md\`: Entities and relationships
- \`contracts/\`: API endpoint specifications  
- \`research.md\`: Technical decisions
- \`quickstart.md\`: Test scenarios

**Note**: Not all projects have all documents. Generate tasks based on what's available.

**Validation**: \`documents_loaded\`

### Step 3: Execute Task Generation

**Purpose**: Create tasks organized by user story

**Actions**:

1. **Load plan.md**: Extract tech stack, libraries, project structure
2. **Load spec.md**: Extract user stories with priorities (P1, P2, P3)
3. **If data-model.md exists**: Extract entities, map to user stories
4. **If contracts/ exists**: Map endpoints to user stories
5. **If research.md exists**: Extract decisions for setup tasks
6. **Generate tasks organized by user story** (see Task Generation Rules)
7. **Generate dependency graph**: Show user story completion order
8. **Create parallel execution examples**: Per user story
9. **Validate task completeness**: Each story has all needed tasks, independently testable

**Validation**: \`tasks_generated\`

### Step 4: Generate tasks.md

**Purpose**: Create structured, executable task list

**Template**: \`.specify/templates/tasks-template.md\`

**Structure**:
- Feature name from plan.md
- **Phase 1**: Setup tasks (project initialization)
- **Phase 2**: Foundational tasks (blocking prerequisites)
- **Phase 3+**: One phase per user story (priority order from spec.md)
  - Story goal
  - Independent test criteria
  - Tests (if requested)
  - Implementation tasks
- **Final Phase**: Polish & cross-cutting concerns

**Task Format Requirements**:
- Strict checklist format (see Task Generation Rules)
- Clear file paths for each task
- Dependencies section showing story order
- Parallel execution examples per story
- Implementation strategy (MVP first, incremental delivery)

**Validation**: \`tasks_md_generated\`

### Step 5: Report

**Purpose**: Provide generation summary

**Output**:
- Path to generated tasks.md
- Total task count
- Task count per user story
- Parallel opportunities identified
- Independent test criteria for each story
- Suggested MVP scope (typically User Story 1 only)
- Format validation: ALL tasks follow checklist format

**Validation**: \`report_complete\`

---

## 3. 📋 TASK GENERATION RULES

### CRITICAL: User Story Organization

Tasks MUST be organized by user story to enable independent implementation and testing.

### Tests Are Optional

Only generate test tasks if:
- Explicitly requested in feature specification
- User requests TDD approach

### Checklist Format (REQUIRED)

Every task MUST follow this format:

\`\`\`text
- [ ] [TaskID] [P?] [Story?] Description with file path
\`\`\`

**Format Components**:

1. **Checkbox**: Always start with \`- [ ]\` (markdown checkbox)
2. **Task ID**: Sequential number (T001, T002, T003) in execution order
3. **[P] marker**: Include ONLY if task is parallelizable (different files, no dependencies)
4. **[Story] label**: REQUIRED for user story phase tasks
   - Format: [US1], [US2], [US3] (maps to spec.md user stories)
   - Setup phase: NO story label
   - Foundational phase: NO story label
   - User Story phases: MUST have story label
   - Polish phase: NO story label
5. **Description**: Clear action with exact file path

**Examples**:

✅ **CORRECT**:
\`\`\`
- [ ] T001 Create project structure per implementation plan
- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py
- [ ] T012 [P] [US1] Create User model in src/models/user.py
- [ ] T014 [US1] Implement UserService in src/services/user_service.py
\`\`\`

❌ **WRONG**:
\`\`\`
- [ ] Create User model (missing ID and Story label)
T001 [US1] Create model (missing checkbox)
- [ ] [US1] Create User model (missing Task ID)
- [ ] T001 [US1] Create model (missing file path)
\`\`\`

### Task Organization

**1. From User Stories (spec.md)** - PRIMARY ORGANIZATION:
- Each user story (P1, P2, P3) gets its own phase
- Map all related components to their story:
  - Models needed for that story
  - Services needed for that story
  - Endpoints/UI needed for that story
  - Tests specific to that story (if requested)
- Mark story dependencies (most stories should be independent)

**2. From Contracts**:
- Map each contract/endpoint → user story it serves
- If tests requested: Contract test task [P] before implementation

**3. From Data Model**:
- Map each entity to user story(ies) that need it
- If entity serves multiple stories: Put in earliest story or Setup phase
- Relationships → service layer tasks in appropriate story phase

**4. From Setup/Infrastructure**:
- Shared infrastructure → Setup phase (Phase 1)
- Foundational/blocking tasks → Foundational phase (Phase 2)
- Story-specific setup → within that story's phase

### Phase Structure

- **Phase 1**: Setup (project initialization)
- **Phase 2**: Foundational (blocking prerequisites - MUST complete before user stories)
- **Phase 3+**: User Stories in priority order (P1, P2, P3)
  - Within each story: Tests (if requested) → Models → Services → Endpoints → Integration
  - Each phase = complete, independently testable increment
- **Final Phase**: Polish & Cross-Cutting Concerns

---

## 4. 💡 EXAMPLES

### Example 1: Basic Task Generation

\`\`\`bash
/speckit.tasks
\`\`\`

**Result**: Generates tasks.md organized by user stories

### Example 2: With TDD

\`\`\`bash
/speckit.tasks "Include test tasks for TDD approach"
\`\`\`

**Result**: Includes test tasks before implementation

---

## 5. 📖 RULES

### ALWAYS

- Run prerequisites check first
- Use absolute paths
- Load all available design documents
- Organize tasks by user story
- Use strict checklist format
- Include Task IDs (T001, T002...)
- Add [Story] labels for user story tasks
- Add [P] for parallelizable tasks
- Include exact file paths
- Generate dependency graph
- Identify parallel opportunities
- Validate task completeness
- Tasks must be immediately executable

### NEVER

- Generate tasks without loading spec.md
- Omit Task IDs from checklist items
- Forget [Story] labels for user story tasks
- Skip file paths in task descriptions
- Generate tests unless explicitly requested
- Mix user stories within same phase
- Create dependencies between independent stories

### ESCALATE IF

- spec.md missing or incomplete
- User story priorities unclear
- Cannot map components to stories
- Dependency cycles detected
- Task format validation fails

---

## 6. 🎓 SUCCESS CRITERIA

**Task generation is successful when**:
- ✅ Prerequisites check passes
- ✅ All available documents loaded
- ✅ Tasks organized by user story
- ✅ ALL tasks follow checklist format
- ✅ Task IDs sequential and complete
- ✅ [Story] labels present for user story tasks
- ✅ File paths included in descriptions
- ✅ Dependency graph generated
- ✅ Parallel opportunities identified
- ✅ Independent test criteria per story
- ✅ MVP scope suggested
- ✅ Format validation passes

**Quality Gates**:
- Each user story has complete task set
- Tasks are independently testable
- No format violations
- Clear execution order

---

## 7. 🔗 INTEGRATION POINTS

### Related Commands

- \`/speckit.specify\`: Creates spec.md (prerequisite)
- \`/speckit.plan\`: Creates plan.md (prerequisite)
- \`/speckit.implement\`: Executes tasks (next step)

### Generated Artifact

- \`tasks.md\`: Actionable, dependency-ordered task list

### Scripts Used

- \`.specify/scripts/bash/check-prerequisites.sh\`: Verify documents

---

## 8. ⚠️ COMMON MISTAKES

**Missing task components**:
- **Problem**: \`- [ ] Create User model\` (missing ID, Story, path)
- **Fix**: \`- [ ] T012 [US1] Create User model in src/models/user.py\`

**Tasks not organized by story**:
- **Problem**: All models in one phase, all services in another
- **Fix**: Group by user story - each story has its complete task set

**Generating tests by default**:
- **Problem**: Including test tasks without explicit request
- **Fix**: Only generate tests if requested in spec or by user

**Vague task descriptions**:
- **Problem**: \`- [ ] T005 Implement authentication\`
- **Fix**: \`- [ ] T005 [P] [US1] Implement authentication middleware in src/middleware/auth.py\`
