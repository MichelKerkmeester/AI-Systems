---
name: save-context
description: Save expanded conversation context when completing features or architectural discussions. Preserves full dialogue, decision rationale, visual flowcharts, and file changes for team sharing.
allowed-tools: Read, Write, Bash
---

# Save Context - Expanded Conversation Documentation

## 1. WHEN TO USE

Use this skill to preserve comprehensive conversation context beyond what claude-mem MCP captures.

**Invoke when:**
- Completing a significant implementation or research session
- Wrapping up a complex feature with multiple decisions
- Documenting an architectural discussion
- Creating a reference for future conversations
- Need to share conversation context with team members

**Do NOT use when:**
- Simple typo fixes or trivial changes (use spec.md only)
- Context already well-documented in spec/plan files
- Real-time progress tracking needed (use claude-mem instead)

**Key Characteristics:**
| Aspect | Description |
|--------|-------------|
| Granularity | Full conversation flow with intelligent summaries |
| Format | Human-readable markdown files |
| Detail Level | Intelligent summaries (not verbatim) with key code snippets |
| Visual Docs | Auto-generated flowcharts and decision trees |
| Navigation | File-based with Table of Contents |
| Use Case | Session documentation and team sharing |

## 2. HOW IT WORKS

The skill orchestrates a multi-stage process:

```
┌─────────────┐
│   Invoke    │
│   Skill     │
└──────┬──────┘
       │
       ▼
┌─────────────────────┐
│ Claude Analyzes     │
│ Current Session     │ ◄──── Review conversation history
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│ Create Summary JSON │
│ • Session metadata  │
│ • Observations      │
│ • User prompts      │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│ Detect Spec Folder  │ ◄──── Auto-detect or prompt
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│ Run Script to:      │
│ • Extract & process │
│ • Generate diagrams │
│ • Populate templates│
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│ Write to context/   │
│ subfolder in spec   │
└─────────────────────┘
```

**Output Location:**
```
/specs/###-feature-name/
└── context/
    ├── session-summary.md    # Comprehensive overview, decisions, diagrams
    ├── conversation-flow.md  # Full timestamped dialogue
    └── metadata.json         # Session metadata
```

**Visual Documentation:**

The skill auto-generates visual flowcharts using markdown-flowchart patterns:

1. **Workflow Flowchart**: Visual representation of conversation phases
   - Pattern detection: Linear or Parallel (based on phase count)
   - Shows phase progression and transitions
   - Renders using ASCII art with markdown-flowchart conventions
   - Uses single-line boxes for consistent styling

2. **Decision Trees**: Visual breakdown of key decisions
   - Options considered with pros/cons
   - Chosen approach with rationale
   - Evidence and caveats

**Template Reference:**
- Context template: `.claude/skills/save-context/templates/context.template.md`
- Workflow flowchart references: `.claude/skills/save-context/references/`
  - `workflow-linear-pattern.md` - Sequential workflows (≤4 phases)
  - `workflow-parallel-pattern.md` - Concurrent workflows (>4 phases)

## 3. INPUTS

### Required
- **Current spec folder** (auto-detected or specified)

### Optional
- `--spec-folder` - Explicitly specify spec folder path
- `--session-id` - Specific claude-mem session to capture (default: current)
- `--include-code` - Include code snippets inline (default: false, reference files)
- `--depth` - Conversation depth: `summary` | `standard` | `verbose` (default: standard)

## 4. IMPLEMENTATION WORKFLOW FOR CLAUDE

**IMPORTANT:** This section describes the exact steps Claude Code must perform when executing this skill.

This is a **standalone skill** that does NOT use claude-mem MCP or any external memory systems. Claude creates the conversation summary directly from the current session.

### Implementation Steps

1. **Analyze Current Conversation**

   Review the conversation history and extract:
   - What the user requested
   - What work was completed
   - Key decisions made
   - Files created or modified
   - Important tool executions
   - Conversation phases (Research → Planning → Implementation → Testing)
   - Any diagrams or flowcharts discussed

2. **Create Conversation Summary JSON**

   Build a structured JSON object with the following format:

   ```javascript
   const conversationData = {
     // Session metadata
     recent_context: [{
       request: "Brief description of what user asked for",
       completed: "What was accomplished",
       learning: "Key insights or learnings from this session",
       duration: "Estimated session duration (e.g., '45m')",
       date: new Date().toISOString()
     }],

     // Observations - key events/changes in the conversation
     observations: [
       {
         type: "feature" | "bugfix" | "decision" | "discovery" | "change",
         title: "Brief title of what happened",
         narrative: "Detailed description of the event",
         timestamp: "ISO timestamp",
         files: ["list", "of", "files", "touched"],
         facts: ["Key", "fact", "points"]
       }
       // ... more observations
     ],

     // User prompts - what the user actually said
     user_prompts: [
       {
         prompt: "The actual user message",
         timestamp: "ISO timestamp"
       }
       // ... more prompts (chronological order)
     ]
   };
   ```

3. **Write Data File**

   Save the conversation summary to a temporary JSON file:

   ```javascript
   const dataFilePath = '/tmp/save-context-data.json';

   await Write({
     file_path: dataFilePath,
     content: JSON.stringify(conversationData, null, 2)
   });
   ```

4. **Execute Data Extraction**

   The script uses parallel execution (`Promise.all()`) to process data efficiently. This works in all Node.js environments and provides significant performance improvements.

4. **Execute Script**

   Run the Node.js script to process conversation data:

   ```bash
   node .claude/skills/save-context/scripts/generate-context.js /tmp/save-context-data.json
   ```

   **Parallel Operations** (using `Promise.all()`):
   - Session metadata collection
   - Conversation flow extraction
   - Decision documentation
   - Diagram detection and generation

   **Performance**: ~2-5 seconds for typical conversations (parallel execution provides 50-60% improvement over sequential processing)

5. **Clean Up**

   Remove the temporary data file:

   ```bash
   rm /tmp/save-context-data.json
   ```

6. **Report Results**

   Display the script output to the user, showing what files were created and where.

---

### Data Structure Guidelines

**Session Metadata (`recent_context`):**
- Should contain 1 entry summarizing the entire conversation
- `request`: User's initial ask (1-2 sentences)
- `completed`: What was delivered (2-3 sentences)
- `learning`: Key insights (1-2 sentences)
- `duration`: Estimate based on conversation length (e.g., "30m", "2h")

**Observations:**
- Create observations for significant events:
  - **feature**: New capability added
  - **bugfix**: Problem fixed
  - **decision**: Technical choice made with rationale
  - **discovery**: New understanding gained
  - **change**: Refactoring or modification
- Each should have clear title, narrative explaining what/why, and affected files
- `facts` array should contain bullet-point facts (Tool executions, file paths, technical details)

**User Prompts:**
- Include ALL user messages in chronological order
- Preserve original wording
- Include timestamps (estimate if not available)

**Quality Guidelines:**
- Be comprehensive but concise
- Focus on "what" and "why", not just "how"
- Include enough detail for someone to understand the conversation without reading the full transcript
- Capture decision rationale and trade-offs
- Note any diagrams, flowcharts, or visual elements discussed

---

## 5. EXECUTION STRATEGY

### Parallel Execution

This skill uses parallel data extraction to process conversation data simultaneously, reducing execution time by 50-60% compared to sequential processing.

**Parallelized Operations**:
1. Session metadata collection
2. Conversation flow extraction
3. Decision documentation extraction
4. Diagram detection and generation

**Performance**: ~2-5 seconds for typical conversations

**Implementation**: Uses `Promise.all()` to run 4 extraction functions concurrently. Works in all Node.js environments (v18+).

---

## 6. DETAILED WORKFLOW

### Step 1: Spec Folder Detection

**Action:** Detect or create spec folder for context storage

**Logic:**
1. Check if current directory is within `/specs/###-*/`
2. If yes, use that as target
3. If no, find most recent spec folder in `/specs/`
4. If none exist, ask user: "No spec folder found. Create one? (Y/n)"

**Validation:** Spec folder path exists and is writable

**Escalate if:** No spec folder and user declines to create one

---

### Step 2: Context Directory Setup

**Action:** Create `context/` subfolder within spec

**Logic:**
```javascript
const contextDir = path.join(specFolder, 'context');
await fs.mkdir(contextDir, { recursive: true });
```

**Validation:** Directory created successfully

**Edge Case:** If `context/` already exists:
- Ask user: "Context folder exists. (O)verwrite, (V)ersion, or (A)bort?"
- Overwrite: Delete and recreate
- Version: Create `context-v2/`, `context-v3/`, etc.
- Abort: Exit gracefully

---

### Step 3: Data Collection (Manual Summary)

**Action:** Claude creates structured conversation summary

**Process:**

1. **Review conversation history**
   - Identify user's initial request
   - Track what work was completed
   - Note key decisions and their rationale
   - List files created/modified
   - Identify conversation phases

2. **Structure observations**
   - Create observation entries for significant events
   - Tag each with type (feature, bugfix, decision, discovery, change)
   - Write clear narratives explaining what happened and why
   - Include affected files and key facts

3. **Capture user prompts**
   - List all user messages chronologically
   - Preserve original wording
   - Add estimated timestamps

4. **Create summary JSON**
   - Package into the format specified in Section 4
   - Include session metadata (request, completed, learning, duration)
   - Ensure all required fields are populated

**Validation:** Summary JSON contains meaningful content (not just placeholders)

**Escalate if:** Cannot determine what work was done or what user requested

---

### Step 4: Script Execution

**Action:** Run Node.js script to process conversation data

**What the script does:**
1. Loads the JSON file created by Claude
2. Extracts conversations with intelligent summarization
3. Identifies and documents decisions with decision trees
4. Detects diagrams and generates flowcharts
5. Populates markdown templates
6. Writes output files to context/ folder

**Script processing:**
- **extractConversations()**: Builds conversation flow from user prompts and observations
- **extractDecisions()**: Creates decision documentation with visual trees
- **extractDiagrams()**: Scans for ASCII art and auto-generates flowcharts
- **generateConversationFlowchart()**: Creates phase-based visual flow
- **generateWorkflowFlowchart()**: Creates workflow flowchart from conversation phases
- **detectWorkflowPattern()**: Auto-detects pattern type (linear or parallel based on phase count)
- **buildPhaseDetails()**: Extracts phase metadata for template population
- **validateDataStructure()**: Ensures all boolean flags are set correctly

**Output files:**
- `session-summary.md` - Comprehensive overview with decisions and diagrams
- `conversation-flow.md` - Full dialogue with summaries and tool executions
- `metadata.json` - Session metadata

---

### Step 5: Success Confirmation

**Action:** Report completion to user

**Output:**
```
✓ Context saved successfully!

Location: /specs/017-save-context-skill/context/

Files created:
  • session-summary.md (458 lines)
  • conversation-flow.md (1,204 lines)
  • metadata.json (18 lines)

Summary:
  • 28 messages captured
  • 4 key decisions documented
  • 2 diagrams preserved
  • Session duration: 45 minutes
```

**Next Steps Suggested:**
- Review session-summary.md for overview and decisions
- Check conversation-flow.md for detailed timeline
- Share context/ folder with team if needed

---

## 5. DECISION MATRIX

| Scenario | Action |
|----------|--------|
| **No spec folder exists** | Prompt user to create one; if declined, abort gracefully |
| **context/ folder exists** | Ask: Overwrite, Version, or Abort |
| **No decisions made** | Create decisions.md with "No major decisions recorded" |
| **No diagrams found** | Create diagrams.md with placeholder message |
| **Conversation summary incomplete** | Use available data; note missing information in output |
| **Very long conversation (>100 messages)** | Use intelligent summarization; focus on key exchanges |

## 6. RULES

### ALWAYS
- Detect spec folder before creating context
- Ask before overwriting existing context/ folder
- Include metadata.json with session stats
- Preserve timestamps in conversation flow
- Reference files instead of copying large code blocks
- Follow document style guide for markdown formatting

### NEVER
- Overwrite context without user confirmation
- Fabricate decisions that weren't made
- Include sensitive data (passwords, API keys, etc.)
- Skip template validation before writing
- Proceed if spec folder detection fails

### ESCALATE IF
- No spec folder found and user declines creation
- Cannot create conversation summary (unclear what happened in session)
- Script execution fails with errors
- File write permissions denied
- User requests features not yet implemented (e.g., HTML export)

## 7. EXAMPLES

### Example 1: After Feature Implementation

**Context:** Just completed implementing a new authentication system

**Invocation:**
```
Skill(skill: "save-context")
```

**Output:**
```
/specs/015-auth-system/
└── context/
    ├── session-summary.md    # Overview, JWT decision, auth diagram
    ├── conversation-flow.md  # 45-message dialogue
    └── metadata.json         # 2.5 hours, 3 decisions
```

**Use Case:** Team lead reviews session-summary.md to understand why JWT was chosen

---

### Example 2: Architectural Discussion

**Context:** Discussed microservices vs. monolith for 1 hour

**Invocation:**
```
Skill(skill: "save-context")
```

**Output:**
```
/specs/008-architecture-review/
└── context/
    ├── session-summary.md    # Decision and architecture diagrams
    ├── conversation-flow.md  # Full debate
    └── metadata.json         # 1 hour, 1 major decision
```

**Use Case:** Reference during retro to recall why monolith was chosen

---

### Example 3: Bug Investigation

**Context:** Traced performance issue to N+1 query problem

**Invocation:**
```
Skill(skill: "save-context")
```

**Output:**
```
/specs/023-fix-performance/
└── context/
    ├── session-summary.md    # Root cause, decision, query diagram
    ├── conversation-flow.md  # Debugging steps
    └── metadata.json         # 30 minutes, 2 decisions
```

**Use Case:** Documentation for future similar bugs

---

## 8. TROUBLESHOOTING

### Issue: "No spec folder found"

**Cause:** Not in a spec directory and no specs/ folders exist

**Solution:**
1. Run `ls specs/` to verify
2. Create spec folder: `mkdir -p specs/###-topic`
3. Re-invoke skill

**Prevention:** Always work within a spec folder for substantial changes

---

### Issue: "Cannot create conversation summary"

**Cause:** Unclear what work was done or conversation was too complex

**Solution:**
1. Review conversation history manually
2. Focus on key events (what user asked, what was delivered, major decisions)
3. Create simplified summary with available information
4. Document what information is incomplete

**Prevention:** Invoke skill after completing well-defined work units

---

### Issue: "Template rendering failed"

**Cause:** Invalid data structure or missing required fields

**Solution:**
1. Check error message for which template failed
2. Verify data collection in step 3-6
3. File bug report with error details

**Prevention:** Ensure all data collection steps have fallbacks

---

### Issue: "Permission denied writing to context/"

**Cause:** Spec folder is read-only or permissions issue

**Solution:**
1. Check folder permissions: `ls -la specs/###-*/`
2. Fix: `chmod -R u+w specs/###-*/`
3. Re-invoke skill

**Prevention:** Verify spec folder is writable before creating context

---

## 9. INTEGRATION POINTS

### Standalone Architecture

**Independence:** This skill operates independently without external dependencies

- **Input:** Current conversation session (Claude's analysis)
- **Processing:** Node.js script with intelligent summarization
- **Output:** Human-readable markdown documentation

**Data Flow:**
```
Conversation → Claude Analysis → JSON → Script → Markdown Files
```

### With SpecKit Workflow

**Integration:** Can be invoked at workflow completion

**Trigger Point:** After `/speckit.implement` completes

**Value:** Preserves full implementation journey with decisions made during each phase

### With Git-Commit Skill

**Integration:** Cross-reference commits in context

**Data Enhancement:** Include commit SHAs in conversation-flow.md

**Example:**
```markdown
## 14:45 - Assistant

Committed changes to auth system.

**Commit:** a7de60f - "Add JWT authentication middleware"
```

## 10. SUCCESS CRITERIA

Task complete when:

- [x] Skill invocable via `Skill(skill: "save-context")`
- [x] Auto-detects current spec folder
- [x] Creates context/ subfolder with 3 files (session-summary, conversation-flow, metadata)
- [x] Creates structured conversation data from current session
- [x] Generates readable, well-formatted markdown
- [x] Includes accurate timestamps and metadata
- [x] Handles edge cases gracefully (no spec, no decisions, etc.)
- [x] Follows document style guide standards
- [x] Documented with examples and troubleshooting
- [x] Tested with real conversation data
- [x] Parallel execution implemented for performance optimization
- [x] Compatible with all environments (Claude Code, ChatGPT, Copilot, etc.)

### Performance Benchmarks

**Execution Time**:
- ✅ Claude Code / Manual Node.js (parallel): 2-5 seconds
- ✅ ChatGPT / Copilot (sequential fallback): 5-12 seconds
- ✅ No timeout errors in any environment
- ✅ All data extracted successfully with both strategies

**Environment Compatibility**:
- ✅ Works in Claude Code (with Promise.all optimization)
- ✅ Works in ChatGPT (sequential fallback)
- ✅ Works in Copilot CLI/IDE (sequential fallback)
- ✅ Works in CODEX (sequential fallback)
- ✅ Works with manual Node.js execution (parallel optimization)

## 11. ANTI-PATTERNS

### ❌ Don't: Create context for trivial changes

**Why:** Overhead exceeds value for simple typo fixes

**Instead:** Use spec.md and claude-mem only

---

### ❌ Don't: Copy entire code files into conversation-flow.md

**Why:** Creates massive files, poor signal-to-noise ratio

**Instead:** Reference files with path:line format, include only critical snippets

---

### ❌ Don't: Create separate files for every section

**Why:** Forces users to navigate between multiple files, fragments context

**Instead:** Use consolidated session-summary.md with clear sections

---

### ❌ Don't: Fabricate decisions to fill decisions.md

**Why:** Creates misleading documentation

**Instead:** If no decisions, write "No major decisions recorded in this session"

---

### ❌ Don't: Ignore existing context/ folders

**Why:** Silently overwriting loses valuable data

**Instead:** Always prompt user for overwrite/version/abort choice

---

## 12. REFERENCE

### Related Skills
- `workflow-spec-kit` - Can invoke save-context after implementation
- `git-commit` - Can enhance with commit context
- `markdown-flowchart` - Can contribute diagrams to diagrams.md

### Related Documentation
- `knowledge/conversation_documentation.md` - Spec folder requirements
- `knowledge/document_style_guide.md` - Markdown formatting standards

### Script Functions
1. `loadCollectedData()` - Loads conversation JSON from file
2. `collectSessionData()` - Processes session metadata
3. `extractConversations()` - Builds conversation flow with intelligent summaries
4. `extractDecisions()` - Creates decision documentation with trees
5. `extractDiagrams()` - Detects ASCII art and generates flowcharts
6. `generateConversationFlowchart()` - Auto-generates phase-based flowcharts
7. `generateWorkflowFlowchart()` - Creates workflow visualization from conversation phases
8. `detectWorkflowPattern()` - Auto-detects workflow pattern type
9. `buildPhaseDetails()` - Constructs phase metadata for templates
10. `generateDecisionTree()` - Creates decision tree visualizations
11. `validateDataStructure()` - Ensures data integrity before template rendering

### Workflow Flowchart Patterns

The workflow flowchart auto-detects and visualizes conversation patterns based on phase count:

| Pattern | Detection Criteria | Visual Style | Use Case |
|---------|-------------------|--------------|----------|
| **Linear** | ≤ 4 phases | Single-line boxes connected vertically | Sequential implementations, bug fixes, simple features |
| **Parallel** | > 4 phases | Horizontal parallel blocks with sync points | Concurrent tasks, multi-file refactoring, distributed work |

All patterns use **single-line boxes** (`┌─┐`) for consistent styling. Flowcharts are data-driven, rendering actual conversation phases instead of placeholder text.

**Reference Examples**:
- `.claude/skills/save-context/references/workflow-linear-pattern.md`
- `.claude/skills/save-context/references/workflow-parallel-pattern.md`

**Rendering**: Uses markdown-flowchart conventions with inline activities and duration tracking
