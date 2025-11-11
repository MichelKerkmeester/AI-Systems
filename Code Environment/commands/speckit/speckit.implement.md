---
description: Execute the implementation plan by processing and executing all tasks defined in tasks.md
---

# Implementation Execution

Execute implementation plan with checklist validation, phase-by-phase execution, and comprehensive progress tracking.

---

## 1. 📋 INPUTS

### User Arguments

```text
$ARGUMENTS
```

**MUST consider user input before proceeding** (if not empty).

### Prerequisites Script Output

**Command**: `.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks`

**Outputs**:
- FEATURE_DIR: Feature directory path (absolute)
- AVAILABLE_DOCS: List of available documents

**Note**: For single quotes in args, use escape syntax: `'I'\''m Groot'` or `"I'm Groot"`

---

## 2. 🚀 WORKFLOW

### Step 1: Prerequisites Check

**Purpose**: Verify tasks.md and required documents exist

**Actions**:
1. Run prerequisites check from repo root
2. Parse FEATURE_DIR and AVAILABLE_DOCS
3. Verify tasks.md exists (required)
4. Use absolute paths

**Validation**: `prerequisites_checked`

### Step 2: Check Checklists Status

**Purpose**: Validate all checklists before implementation

**Actions** (if FEATURE_DIR/checklists/ exists):

1. **Scan checklist files**:
   - Total items: Count `- [ ]`, `- [X]`, `- [x]`
   - Completed: Count `- [X]`, `- [x]`
   - Incomplete: Count `- [ ]`

2. **Create status table**:
   ```text
   | Checklist   | Total | Completed | Incomplete | Status |
   |-------------|-------|-----------|------------|--------|
   | ux.md       | 12    | 12        | 0          | ✓ PASS |
   | test.md     | 8     | 5         | 3          | ✗ FAIL |
   | security.md | 6     | 6         | 0          | ✓ PASS |
   ```

3. **Calculate overall status**:
   - PASS: All checklists have 0 incomplete items
   - FAIL: One or more checklists have incomplete items

4. **Handle incomplete checklists**:
   - Display table with incomplete counts
   - **STOP** and ask: "Some checklists are incomplete. Proceed anyway? (yes/no)"
   - Wait for user response
   - If "no"/"wait"/"stop": Halt execution
   - If "yes"/"proceed"/"continue": Continue to next step

5. **Handle complete checklists**:
   - Display table showing all passed
   - Automatically proceed

**Validation**: `checklists_validated`

### Step 3: Load Implementation Context

**Purpose**: Read all available design documents

**Required Documents**:
- `tasks.md`: Complete task list and execution plan
- `plan.md`: Tech stack, architecture, file structure

**Optional Documents**:
- `data-model.md`: Entities and relationships
- `contracts/`: API specifications and test requirements
- `research.md`: Technical decisions and constraints
- `quickstart.md`: Integration scenarios

**Validation**: `context_loaded`

### Step 4: Project Setup Verification

**Purpose**: Create/verify ignore files based on project setup

**Detection Logic**:

Check for these files/technologies:
- Git repository → .gitignore
- Dockerfile or Docker in plan.md → .dockerignore
- eslintrc or eslint.config files → .eslintignore
- prettierrc files → .prettierignore
- npmrc or package.json → .npmignore (if publishing)
- terraform files → .terraformignore
- Helm charts → .helmignore

**Git Detection**:
```bash
git rev-parse --git-dir 2>/dev/null
```

**If ignore file exists**: Verify essential patterns, append missing critical ones
**If ignore file missing**: Create with full pattern set for detected technology

**Common Patterns by Technology** (from plan.md):
- **Node.js/JS/TS**: dependencies folder, dist, build, logs, env files
- **Python**: cache folders, pyc files, venv, dist, egg-info
- **Java**: target, class files, jar files, gradle, build
- **C#/.NET**: bin, obj, user files, suo files, packages
- **Go**: exe files, test files, vendor, out files
- **Ruby**: bundle, log, tmp, gem files, vendor/bundle
- **PHP**: vendor, log files, cache, env files
- **Rust**: target, rlib files, idea, log files, env files
- **Universal**: DS_Store, Thumbs.db, tmp files, swp files, vscode, idea

**Tool-Specific Patterns**:
- **Docker**: dependencies, git, log files, env files, coverage
- **ESLint**: dependencies, dist, build, coverage, minified js
- **Prettier**: dependencies, dist, lock files
- **Terraform**: terraform folder, tfstate files, tfvars, lock files
- **Kubernetes**: secret yaml, secrets folder, kube folder, keys, certificates

**Validation**: `setup_verified`

### Step 5: Parse tasks.md Structure

**Purpose**: Extract task phases and dependencies

**Extract**:
- Task phases: Setup, Tests, Core, Integration, Polish
- Task dependencies: Sequential vs parallel execution
- Task details: ID, description, file paths, parallel markers [P]
- Execution flow: Order and dependency requirements

**Validation**: `tasks_parsed`

### Step 6: Execute Implementation

**Purpose**: Execute tasks following the plan

**Execution Rules**:

- **Phase-by-phase**: Complete each phase before next
- **Respect dependencies**: Sequential tasks in order, parallel tasks [P] together
- **TDD approach**: Test tasks before implementation tasks
- **File coordination**: Tasks affecting same files run sequentially
- **Validation checkpoints**: Verify each phase before proceeding

**Execution Order**:
1. **Setup**: Initialize structure, dependencies, configuration
2. **Tests**: Write tests for contracts, entities, integration (if needed)
3. **Core**: Implement models, services, CLI, endpoints
4. **Integration**: Database, middleware, logging, external services
5. **Polish**: Unit tests, optimization, documentation

**Validation**: `implementation_complete`

### Step 7: Progress Tracking

**Purpose**: Monitor execution and handle errors

**Actions**:
- Report progress after each completed task
- **Mark completed tasks**: Update tasks.md with [X] for completed
- Halt if non-parallel task fails
- For parallel tasks [P]: Continue with successful, report failed
- Provide clear error messages with context
- Suggest next steps if blocked

**Validation**: `progress_tracked`

### Step 8: Completion Validation

**Purpose**: Verify implementation meets requirements

**Checks**:
- All required tasks completed
- Features match original specification
- Tests pass and coverage meets requirements
- Implementation follows technical plan
- Final status summary provided

**Validation**: `completion_validated`

---

## 3. 💡 EXAMPLES

### Example 1: Basic Implementation

```bash
/speckit.implement
```

**Result**: Executes all tasks from tasks.md with checklist validation

### Example 2: Skip Checklist Validation

```bash
/speckit.implement "Skip checklist validation and proceed with implementation"
```

**Result**: Proceeds without checking checklists

---

## 4. 📖 RULES

### ALWAYS

- Run prerequisites check first
- Validate checklists before implementation
- Stop and ask if checklists incomplete
- Load all available design documents
- Create/verify ignore files for detected technologies
- Parse tasks.md structure completely
- Execute phases in order
- Respect task dependencies
- Mark completed tasks as [X]
- Report progress after each task
- Validate completion against spec

### NEVER

- Skip checklist validation without user consent
- Execute tasks out of order
- Run parallel tasks that affect same files simultaneously
- Continue if non-parallel task fails
- Forget to mark completed tasks
- Skip ignore file creation
- Omit progress reports

### ESCALATE IF

- tasks.md missing or incomplete
- Checklists have incomplete items (ask user)
- Task execution fails
- Cannot determine execution order
- Ignore file patterns unclear for technology
- Tests fail after implementation
- Implementation deviates from spec

---

## 5. 🎓 SUCCESS CRITERIA

**Implementation is successful when**:
- ✅ Prerequisites check passes
- ✅ All checklists validated
- ✅ Design documents loaded
- ✅ Ignore files created/verified
- ✅ tasks.md structure parsed
- ✅ All phases executed in order
- ✅ Dependencies respected
- ✅ Completed tasks marked [X]
- ✅ Progress tracked throughout
- ✅ Tests pass
- ✅ Features match specification
- ✅ Completion validation passes

**Quality Gates**:
- Checklist compliance (or user override)
- Phase-by-phase completion
- No failed non-parallel tasks
- All tasks marked complete

---

## 6. 🔗 INTEGRATION POINTS

### Related Commands

- `/speckit.specify`: Creates spec.md (prerequisite)
- `/speckit.plan`: Creates plan.md (prerequisite)
- `/speckit.tasks`: Creates tasks.md (prerequisite)
- `/speckit.checklist`: Creates validation checklists

### Scripts Used

- `.specify/scripts/bash/check-prerequisites.sh`: Verify documents

### Files Modified

- `tasks.md`: Mark tasks as [X] when complete
- Ignore files: Create/update based on technology

---

## 7. ⚠️ COMMON MISTAKES

**Skipping checklist validation**:
- **Problem**: Implementing before validating readiness
- **Fix**: Always check checklists, ask user if incomplete

**Executing tasks out of order**:
- **Problem**: Running parallel tasks that depend on incomplete sequential tasks
- **Fix**: Respect phase order and dependencies

**Not marking completed tasks**:
- **Problem**: Losing track of progress in tasks.md
- **Fix**: Mark each task [X] immediately after completion

**Missing ignore files**:
- **Problem**: Committing generated files or secrets
- **Fix**: Always create/verify ignore files in Step 4
