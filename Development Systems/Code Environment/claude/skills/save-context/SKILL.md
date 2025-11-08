---
name: save-context
description: This skill saves expanded conversation context when completing features or architectural discussions. It preserves full dialogue, decision rationale, visual flowcharts, and file changes for team sharing. This skill should be used when wrapping up significant implementation or research sessions that need documentation beyond what claude-mem MCP captures.
allowed-tools: Read, Write, Bash
---

# Save Context - Expanded Conversation Documentation

Preserve comprehensive conversation context in human-readable markdown files. Creates structured documentation with session summaries, full dialogue flow, decisions, and auto-generated flowcharts.

---

## 1. 🎯 WHEN TO USE

**This skill should be used when**:
- Completing a significant implementation or research session
- Wrapping up a complex feature with multiple decisions
- Documenting an architectural discussion
- Creating a reference for future conversations
- Sharing conversation context with team members

**This skill should NOT be used for**:
- Simple typo fixes or trivial changes
- Context already well-documented in spec/plan files
- Real-time progress tracking (use claude-mem instead)

**Key Characteristics**:
- **Granularity**: Full conversation flow with intelligent summaries
- **Format**: Human-readable markdown files in `specs/###-feature/context/`
- **Detail Level**: Intelligent summaries with key code snippets
- **Visual Docs**: Auto-generated flowcharts and decision trees
- **Use Case**: Session documentation and team sharing

---

## 2. 🛠️ HOW IT WORKS

This skill is **standalone** - it does NOT use claude-mem MCP or external memory systems. Claude creates the conversation summary directly from the current session.

**Process**:
1. Analyze current conversation history
2. Create structured JSON summary
3. Run Node.js script to process and generate markdown
4. Write to `specs/###-feature/context/` folder

**Output Files**:
```
/specs/###-feature-name/
└── context/
    ├── session-summary.md    # Overview, decisions, diagrams
    ├── conversation-flow.md  # Full timestamped dialogue
    └── metadata.json         # Session metadata
```

**Visual Documentation**:
- **Workflow Flowchart**: Visual representation of conversation phases
  - Linear pattern (≤4 phases): Sequential workflows
  - Parallel pattern (>4 phases): Concurrent tasks
- **Decision Trees**: Visual breakdown of key decisions with options/rationale

---

## 3. 📋 IMPLEMENTATION STEPS

### Step 1: Analyze Current Conversation

Review conversation history and extract:
- What the user requested
- What work was completed
- Key decisions made and their rationale
- Files created or modified
- Conversation phases (Research → Planning → Implementation → Testing)
- Any diagrams or flowcharts discussed

### Step 2: Create Conversation Summary JSON

Build structured JSON with this format:

```javascript
{
  recent_context: [{
    request: "Brief description of what user asked for",
    completed: "What was accomplished",
    learning: "Key insights from this session",
    duration: "Estimated session duration (e.g., '45m')",
    date: "ISO timestamp"
  }],

  observations: [{
    type: "feature|bugfix|decision|discovery|change",
    title: "Brief title of what happened",
    narrative: "Detailed description of the event",
    timestamp: "ISO timestamp",
    files: ["list", "of", "files", "touched"],
    facts: ["Key", "fact", "points"]
  }],

  user_prompts: [{
    prompt: "The actual user message",
    timestamp: "ISO timestamp"
  }]
}
```

### Step 3: Write Data File

Save conversation summary to temporary file:

```javascript
const dataFilePath = '/tmp/save-context-data.json';

await Write({
  file_path: dataFilePath,
  content: JSON.stringify(conversationData, null, 2)
});
```

### Step 4: Execute Script

Run Node.js script to process data:

```bash
node .claude/skills/save-context/scripts/generate-context.js /tmp/save-context-data.json
```

**Script Operations** (uses `Promise.all()` for parallel execution):
- Session metadata collection
- Conversation flow extraction
- Decision documentation
- Diagram detection and generation

**Performance**: ~2-5 seconds for typical conversations

### Step 5: Clean Up

```bash
rm /tmp/save-context-data.json
```

### Step 6: Report Results

Display script output showing created files and location.

---

## 4. 📊 DATA STRUCTURE GUIDELINES

**Session Metadata** (`recent_context`):
- 1 entry summarizing entire conversation
- `request`: User's initial ask (1-2 sentences)
- `completed`: What was delivered (2-3 sentences)
- `learning`: Key insights (1-2 sentences)
- `duration`: Estimate based on conversation length

**Observations**:
Create for significant events:
- `feature`: New capability added
- `bugfix`: Problem fixed
- `decision`: Technical choice with rationale
- `discovery`: New understanding gained
- `change`: Refactoring or modification

Each should have clear title, narrative explaining what/why, and affected files.

**User Prompts**:
- Include ALL user messages chronologically
- Preserve original wording
- Include timestamps

**Quality Guidelines**:
- Be comprehensive but concise
- Focus on "what" and "why", not just "how"
- Capture decision rationale and trade-offs
- Note diagrams or visual elements discussed

---

## 5. 🔄 SPEC FOLDER DETECTION

**Logic**:
1. Check if current directory is within `/specs/###-*/`
2. If yes, use that as target
3. If no, find most recent spec folder in `/specs/`
4. **NEW**: Check alignment between conversation topics and folder name
   - Extract keywords from conversation request/observations
   - Calculate alignment score (0-100%) with spec folder name
   - Threshold: **70%** (strict alignment required)
5. If alignment < 70%, prompt user to select target folder
6. If none exist, error: "No spec folder found. Please create one first."

**Context Alignment**:
- **Automatic filtering**: Archive folders (`z_*`, `*archive*`, `old*`) excluded from consideration
- **Topic extraction**: Keywords from `recent_context.request` and `observations[].title`
- **Scoring**: Percentage of spec folder keywords found in conversation topics
- **Interactive prompt** (when alignment < 70%):
  ```
  ⚠️  Conversation topic may not align with most recent spec folder
  Most recent: 020-page-loader (25% match)

  Alternative spec folders:
  1. 018-auth-improvements (85% match)
  2. 017-authentication-refactor (90% match)
  3. 020-page-loader (25% match)
  4. Specify custom folder path

  Select target folder (1-4): _
  ```

**Behavior** - Single context folder with timestamped files:
- Always uses single `context/` folder (no versioning)
- Creates timestamped markdown files: `{date}_{time}__{topic}.md`
- Example: `2025-11-08_18-37-02__skill-refinement.md`
- No conflicts - each save creates a new timestamped file

**Edge Case** - No conversation data:
- Skip alignment check (backward compatible)
- Use most recent spec folder automatically

**Edge Case** - Auto-save mode (hooks):
- Set `AUTO_SAVE_MODE=true` environment variable to bypass alignment prompts
- Used by SessionEnd and UserPromptSubmit hooks for automatic context saving
- Always uses most recent spec folder without user interaction

---

## 6. 📖 RULES

### ALWAYS

- Detect spec folder before creating context
- Use single `context/` folder with timestamped files
- Include `metadata.json` with session stats
- Preserve timestamps in conversation flow
- Reference files instead of copying large code blocks
- Follow document style guide for markdown formatting

### NEVER

- Fabricate decisions that weren't made
- Include sensitive data (passwords, API keys)
- Skip template validation before writing
- Proceed if spec folder detection fails
- Create versioned context folders (always use single context/)

### ESCALATE IF

- No spec folder found and user declines creation
- Cannot create conversation summary (unclear what happened)
- Script execution fails with errors
- File write permissions denied

---

## 7. 🎓 SUCCESS CRITERIA

**Task complete when**:
- ✅ Auto-detects current spec folder
- ✅ Creates `context/` subfolder with 3 files
- ✅ Generates readable, well-formatted markdown
- ✅ Includes accurate timestamps and metadata
- ✅ Handles edge cases gracefully
- ✅ Follows document style guide standards

**Performance**:
- ✅ Execution time: 2-5 seconds (parallel processing)
- ✅ Works in all Node.js v18+ environments
- ✅ No timeout errors

---

## 8. 💡 EXAMPLES

### Example 1: Feature Implementation

**Context**: Completed implementing authentication system

**Invocation**: `Skill(skill: "save-context")`

**Output**:
```
/specs/015-auth-system/
└── context/
    ├── session-summary.md    # Overview, JWT decision, auth diagram
    ├── conversation-flow.md  # 45-message dialogue
    └── metadata.json         # 2.5 hours, 3 decisions
```

**Use Case**: Team lead reviews why JWT was chosen

---

### Example 2: Bug Investigation

**Context**: Traced performance issue to N+1 query problem

**Output**:
```
/specs/023-fix-performance/
└── context/
    ├── session-summary.md    # Root cause, solution, query diagram
    ├── conversation-flow.md  # Debugging steps
    └── metadata.json         # 30 minutes, 2 decisions
```

**Use Case**: Documentation for future similar bugs

---

## 9. 🔧 TROUBLESHOOTING

### "Low alignment score - what does it mean?"

**Context**: Alignment score < 70% triggers folder selection prompt

**Understanding Scores**:
- **90-100%**: Excellent match - conversation clearly relates to spec folder topic
- **70-89%**: Good match - auto-selected without prompt
- **50-69%**: Moderate match - may be related, user should verify
- **30-49%**: Weak match - conversation likely about different topic
- **0-29%**: Poor match - definitely different topic

**When to override**:
- Accept suggestion if high-scoring folder (>80%) matches your intent
- Override if you're intentionally documenting unrelated work in that folder
- Create new spec folder if no good match exists (option 4 in prompt)

**Example**:
```
Conversation about "authentication improvements"
→ 018-auth-improvements (90% match) ✅ Accept
→ 020-page-loader (15% match) ❌ Wrong folder
```

---

### "No spec folder found"

**Solution**:
1. Run `ls specs/` to verify
2. Create spec folder: `mkdir -p specs/###-topic`
3. Re-invoke skill

---

### "Cannot create conversation summary"

**Solution**:
1. Review conversation history manually
2. Focus on key events (what user asked, what was delivered, major decisions)
3. Create simplified summary with available information
4. Document what information is incomplete

---

### "Permission denied writing to context/"

**Solution**:
1. Check folder permissions: `ls -la specs/###-*/`
2. Fix: `chmod -R u+w specs/###-*/`
3. Re-invoke skill

---

## 10. 🔗 INTEGRATION POINTS

**Standalone Architecture**:
- **Input**: Current conversation session (Claude's analysis)
- **Processing**: Node.js script with intelligent summarization
- **Output**: Human-readable markdown documentation

**Data Flow**:
```
Conversation → Claude Analysis → JSON → Script → Markdown Files
```

**Pairs With**:
- `workflow-spec-kit` - Can invoke after `/speckit.implement` completes
- `git-commit` - Can enhance with commit SHAs in conversation flow
- `markdown-flowchart` - Can contribute diagrams to output

---

## 11. 📚 REFERENCES

**Templates**:
- `.claude/skills/save-context/templates/context.template.md`

**Workflow Patterns**:
- `.claude/skills/save-context/references/workflow-linear-pattern.md`
- `.claude/skills/save-context/references/workflow-parallel-pattern.md`

**Script Functions**:
- `loadCollectedData()` - Loads conversation JSON
- `collectSessionData()` - Processes session metadata
- `extractConversations()` - Builds conversation flow
- `extractDecisions()` - Creates decision documentation
- `extractDiagrams()` - Detects and generates flowcharts
- `generateWorkflowFlowchart()` - Creates workflow visualization
- `validateDataStructure()` - Ensures data integrity

**Workflow Flowchart Patterns**:

| Pattern | Criteria | Visual Style | Use Case |
|---------|----------|--------------|----------|
| Linear | ≤4 phases | Vertical single-line boxes | Sequential implementations |
| Parallel | >4 phases | Horizontal parallel blocks | Concurrent tasks |

---

## 12. 🎯 QUICK REFERENCE

**Invocation**: `Skill(skill: "save-context")`

**Output Location**: `specs/###-feature/context/`

**Files Created**:
- `session-summary.md` - Comprehensive overview
- `conversation-flow.md` - Full dialogue
- `metadata.json` - Session stats

**Key Data Structure**:
```json
{
  "recent_context": [{ "request", "completed", "learning", "duration" }],
  "observations": [{ "type", "title", "narrative", "files", "facts" }],
  "user_prompts": [{ "prompt", "timestamp" }]
}
```

**Script Location**: `.claude/skills/save-context/scripts/generate-context.js`

**Performance**: ~2-5 seconds (parallel execution)
