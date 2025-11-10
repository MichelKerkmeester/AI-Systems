---
description: Execute the implementation planning workflow using the plan template to generate design artifacts.
---

# Implementation Planning

Execute implementation planning workflow to generate design artifacts including research, data models, API contracts, and quickstart documentation.

---

## 1. 📋 INPUTS

### User Arguments

```text
$ARGUMENTS
```

**MUST consider user input before proceeding** (if not empty).

### Setup Script Output

**Command**: \`.specify/scripts/bash/setup-plan.sh --json\`

**Outputs**:
- FEATURE_SPEC: Path to feature specification
- IMPL_PLAN: Path to implementation plan
- SPECS_DIR: Specifications directory
- BRANCH: Current git branch

**Note**: For single quotes in args (e.g., "I'm Groot"), use escape syntax: \`'I'\\''m Groot'\` or double-quote: \`"I'm Groot"\`

---

## 2. 🚀 WORKFLOW

### Step 1: Setup

**Purpose**: Initialize planning environment and paths

**Actions**:
1. Run \`.specify/scripts/bash/setup-plan.sh --json\` from repo root
2. Parse JSON output for paths (FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH)
3. Verify all paths are accessible

**Validation**: \`setup_complete\`

### Step 2: Load Context

**Purpose**: Read feature spec and constitution

**Actions**:
1. Read FEATURE_SPEC file
2. Read \`.specify/memory/constitution.md\`
3. Load IMPL_PLAN template (already copied by setup script)
4. Verify all context is loaded

**Validation**: \`context_loaded\`

### Step 3: Fill Technical Context

**Purpose**: Document technical decisions and unknowns

**Actions**:
1. Fill Technical Context section in IMPL_PLAN
2. Mark unknowns as "NEEDS CLARIFICATION"
3. Fill Constitution Check section from constitution
4. Evaluate gates (ERROR if violations unjustified)

**Validation**: \`technical_context_filled\`

### Step 4: Phase 0 - Outline & Research

**Purpose**: Resolve all technical unknowns through research

**Actions**:

1. **Extract unknowns from Technical Context**:
   - Each NEEDS CLARIFICATION → research task
   - Each dependency → best practices task
   - Each integration → patterns task

2. **Generate and dispatch research agents**:
   \`\`\`text
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   \`\`\`

3. **Consolidate findings in research.md**:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: \`research.md\` with all NEEDS CLARIFICATION resolved

**Validation**: \`phase_0_complete\`

### Step 5: Phase 1 - Design & Contracts

**Purpose**: Generate data models, API contracts, and quickstart docs

**Prerequisites**: \`research.md\` complete

**Actions**:

1. **Extract entities from feature spec → data-model.md**:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable

2. **Generate API contracts from functional requirements**:
   - For each user action → endpoint
   - Use standard REST/GraphQL patterns
   - Output OpenAPI/GraphQL schema to \`/contracts/\`

3. **Update agent context**:
   - Run \`.specify/scripts/bash/update-agent-context.sh\`
   - Script auto-detects which AI agent is in use (Claude, Cursor, etc.)
   - Updates appropriate agent-specific context file
   - Adds only new technology from current plan
   - Preserves manual additions between markers

**Output**: \`data-model.md\`, \`/contracts/*\`, \`quickstart.md\`, agent-specific file

**Validation**: \`phase_1_complete\`

### Step 6: Re-evaluate Constitution Check

**Purpose**: Verify design aligns with constitution post-planning

**Actions**:
1. Review Constitution Check section
2. Verify no violations introduced during planning
3. Document any justified exceptions

**Validation**: \`constitution_check_passed\`

### Step 7: Stop and Report

**Purpose**: Provide planning completion summary

**Report Includes**:
- Current branch name
- IMPL_PLAN path
- Generated artifacts list:
  - research.md
  - data-model.md
  - contracts/*
  - quickstart.md
  - agent context file

**Note**: Command ends after Phase 2 planning

**Validation**: \`report_complete\`

---

## 3. 💡 EXAMPLES

### Example 1: Basic Planning

\`\`\`bash
/speckit.plan
\`\`\`

**Result**: Generates all Phase 0-1 artifacts

### Example 2: With Context

\`\`\`bash
/speckit.plan "Focus on database schema design"
\`\`\`

**Result**: Emphasizes data model generation

---

## 4. 📖 RULES

### ALWAYS

- Use absolute paths for all file operations
- Run setup script from repo root
- Parse JSON output for paths
- Mark unknowns as "NEEDS CLARIFICATION"
- Fill Constitution Check from constitution
- Resolve all clarifications in Phase 0
- Generate complete artifacts in Phase 1
- Update agent context after design
- Re-evaluate constitution compliance
- Provide completion report

### NEVER

- Skip setup script execution
- Leave unknowns unresolved after Phase 0
- Generate contracts without feature spec
- Omit agent context update
- Skip constitution re-evaluation
- Continue past Phase 1 (command stops here)

### ESCALATE IF

- Setup script fails
- Gate violations detected
- Constitution conflicts arise
- Required paths inaccessible
- Research cannot resolve unknowns
- Agent context update fails

---

## 5. 🎓 SUCCESS CRITERIA

**Planning is successful when**:
- ✅ Setup completes with valid paths
- ✅ Technical Context fully documented
- ✅ All NEEDS CLARIFICATION resolved
- ✅ research.md generated with decisions
- ✅ data-model.md created with entities
- ✅ API contracts generated
- ✅ quickstart.md created
- ✅ Agent context updated
- ✅ Constitution Check passes
- ✅ Completion report provided

**Quality Gates**:
- No unresolved clarifications
- No unjustified gate violations
- All Phase 0-1 artifacts complete
- Agent context properly updated

---

## 6. 🔗 INTEGRATION POINTS

### Related Commands

- \`/speckit.specify\`: Creates feature spec (prerequisite)
- \`/speckit.tasks\`: Uses plan artifacts (next step)
- \`/speckit.implement\`: Executes implementation

### Generated Artifacts

- \`research.md\`: Technical decisions and rationale
- \`data-model.md\`: Entity definitions and relationships
- \`contracts/\`: API specifications
- \`quickstart.md\`: Getting started documentation
- Agent context file: Technology stack reference

### Scripts Used

- \`.specify/scripts/bash/setup-plan.sh\`: Initialize planning
- \`.specify/scripts/bash/update-agent-context.sh\`: Update context

---

## 7. ⚠️ COMMON MISTAKES

**Skipping unknowns resolution**:
- **Problem**: Leaving NEEDS CLARIFICATION in final plan
- **Fix**: Complete Phase 0 research for all unknowns

**Missing constitution check**:
- **Problem**: Design violates project principles
- **Fix**: Fill Constitution Check and address violations

**Incomplete contracts**:
- **Problem**: Not generating contracts for all user actions
- **Fix**: Map each functional requirement to API endpoint

**Agent context not updated**:
- **Problem**: Agent doesn't know about new technology
- **Fix**: Always run update-agent-context.sh after design
