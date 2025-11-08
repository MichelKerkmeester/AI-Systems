# Save Context Skill

> Capture comprehensive conversation context with intelligent summaries, visual flowcharts, and decision documentation.

**Version**: 1.1.0
**License**: Apache-2.0
**Node.js**: v18+ required
**Dependencies**: None (Node.js built-in modules only)

---

## Overview

### What It Does

The save-context skill preserves your Claude Code conversations as structured, human-readable documentation. Unlike verbatim transcripts, it creates intelligent summaries with:

- **Workflow Flowcharts**: Auto-generated ASCII art visualizing conversation phases
- **Decision Trees**: Visual documentation of architectural choices with pros/cons
- **Smart Summaries**: Key outcomes, file changes, and tool usage tracking
- **Full Timeline**: Complete message history with tool executions and results

### When to Use

✅ **Use this skill when:**
- Completing significant features or research sessions
- Documenting architectural discussions and decisions
- Sharing conversation context with team members
- Preserving decision rationale for future reference
- Creating audit trails for complex problem-solving

❌ **Don't use this skill for:**
- Simple typo fixes or trivial changes
- Real-time progress tracking (use `claude-mem` instead)
- Already well-documented work in spec/plan files
- Conversations with no significant decisions or learnings

### Key Features

🚀 **Parallel Execution** - 50-60% faster than sequential processing
💾 **Atomic Writes** - Rollback on failure, no partial file corruption
📊 **Auto-Flowcharts** - Pattern detection (linear/parallel workflows)
🎯 **Smart Detection** - Robust tool call and phase classification
✅ **Validation** - Placeholder leak detection, quality warnings

---

## Quick Start

### Basic Invocation

From within Claude Code conversation:

```javascript
Skill(skill: "save-context")
```

### What Happens

1. **Analysis**: Claude analyzes the current conversation
2. **JSON Creation**: Creates structured summary with observations, prompts, decisions
3. **Processing**: Node.js script extracts data in parallel (4 concurrent operations)
4. **Output**: Markdown files written to `specs/###-folder/context/`

### Output Files

```
specs/018-example-feature/context/
├── 2025-11-08_13-45-30__example-feature.md    # Comprehensive session summary
└── metadata.json                               # Session stats and metadata
```

**Markdown file contains**:
- Session metadata table (date, folder, message count, decisions)
- Overview with key outcomes and file changes
- Workflow flowchart (auto-generated from conversation phases)
- Decision documentation with visual trees
- Complete conversation timeline with tool executions

---

## Configuration

### Default Settings

**File**: `.claude/skills/save-context/config.json`

```json
{
  "maxResultPreview": 500,
  "maxConversationMessages": 100,
  "maxToolOutputLines": 100,
  "messageTimeWindow": 300000,
  "contextPreviewHeadLines": 50,
  "contextPreviewTailLines": 20
}
```

### Configuration Options

| Option | Type | Default | Description | Valid Range |
|--------|------|---------|-------------|-------------|
| **maxResultPreview** | number | 500 | Maximum characters to preview in tool result summaries | 0-10000 |
| **maxConversationMessages** | number | 100 | Maximum conversation messages to process | 1-1000 |
| **maxToolOutputLines** | number | 100 | Maximum lines to show in tool output before truncation | 10-500 |
| **messageTimeWindow** | number | 300000 | Time window (ms) to associate observations with user prompts | 60000-600000 |
| **contextPreviewHeadLines** | number | 50 | Lines to show at start when truncating long outputs | 10-200 |
| **contextPreviewTailLines** | number | 20 | Lines to show at end when truncating long outputs | 5-100 |

### Recommended Settings by Use Case

#### Quick Sessions (< 30 minutes)

```json
{
  "maxConversationMessages": 50,
  "maxToolOutputLines": 50,
  "messageTimeWindow": 180000
}
```

**Use for**: Bug fixes, small refactors, quick research

#### Standard Sessions (30-60 minutes) - DEFAULT

```json
{
  "maxConversationMessages": 100,
  "maxToolOutputLines": 100,
  "messageTimeWindow": 300000
}
```

**Use for**: Feature implementations, architectural discussions

#### Long Sessions (> 1 hour)

```json
{
  "maxConversationMessages": 200,
  "maxToolOutputLines": 200,
  "messageTimeWindow": 600000
}
```

**Use for**: Complex multi-file refactors, large feature development

### Performance Impact

**Higher values = More complete context but slower execution**

- `maxConversationMessages`: +50 messages ≈ +500ms processing
- `maxToolOutputLines`: Minimal impact (affects output size, not processing)
- `messageTimeWindow`: No performance impact (affects data association accuracy)

---

## Architecture

### How It Works

```
┌─────────────────┐
│  Claude Code    │
│  Conversation   │
└────────┬────────┘
         │ Skill invoked
         ▼
┌─────────────────┐
│  Claude         │  Analyzes conversation
│  Analysis       │  Creates structured JSON
└────────┬────────┘
         │ Passes JSON to script
         ▼
┌─────────────────┐
│  generate-      │  Parallel extraction:
│  context.js     │  • Session metadata
│                 │  • Conversations
│                 │  • Decisions
│                 │  • Diagrams
└────────┬────────┘
         │ Renders template
         ▼
┌─────────────────┐
│  Output Files   │  • {date}_{time}__{name}.md
│  Written        │  • metadata.json
└─────────────────┘
```

### Data Flow

1. **Input**: Conversation data (user prompts, observations, recent context)
2. **Spec Detection**: Finds most recent `specs/###-name/` folder
3. **Parallel Extraction**: 4 concurrent operations (metadata, conversations, decisions, diagrams)
4. **Template Population**: Mustache-like rendering with validation
5. **Atomic Writes**: Temp file → verify → rename → commit (rollback on error)

### File Structure

```
.claude/skills/save-context/
├── README.md                        # This file
├── SKILL.md                         # Claude-facing documentation
├── config.json                      # Configuration options
├── package.json                     # Node.js metadata (v1.1.0)
├── scripts/
│   └── generate-context.js          # Main processing script (2,300+ lines)
├── templates/
│   └── context.template.md          # Markdown output template
└── references/                      # Workflow pattern examples
    ├── README.md                    # Pattern documentation
    ├── workflow-linear-pattern.md   # Sequential flow examples
    └── workflow-parallel-pattern.md # Concurrent flow examples
```

---

## Features

### 1. Intelligent Summarization

**Not verbatim transcripts** - smart summaries with:

- Key decisions highlighted
- File modifications tracked with descriptions
- Tool usage patterns analyzed
- Outcomes extracted and categorized
- Phase-based conversation flow

**Example Output**:

```markdown
## 1. OVERVIEW

Fixed alignment bugs in flowchart and decision tree rendering. Implemented strict
padding calculations and resolved double-truncation issue causing stray characters.

**Key Outcomes**:
- Fixed vertical bar misalignment in workflow flowcharts
- Resolved trailing character bug in decision headers
- All boxes now render with perfect 50/58 character alignment

| **File** | **Changes** |
|:---------|:------------|
| `generate-context.js` | Fixed padding calculations in lines 1663, 1912, 1913 |
```

### 2. Visual Documentation

#### Workflow Flowcharts (Auto-Generated)

**Linear Pattern** (≤4 phases):

```
┌────────────────────────────────────────────────────────┐
│  Research                                              │
│  • Explored codebase for alignment bugs                │
│  • Read flowchart generation functions                 │
│  Duration: 2 actions                                   │
└────────────────────────────────────────────────────────┘
                        │
                        ▼
┌────────────────────────────────────────────────────────┐
│  Implementation                                        │
│  • Fixed padding calculation in Duration line          │
│  • Updated decision header formatting                  │
│  Duration: 3 actions                                   │
└────────────────────────────────────────────────────────┘
```

**Parallel Pattern** (>4 phases):

```
╭────────────────────────────────────────────────────────╮
│  Stage 1: Foundation (Phase 1-2)                       │
╰────────────────────────────────────────────────────────╯
         │                    │                    │
    [Phase 1]           [Phase 2]           [Phase 3]
```

#### Decision Trees

```
╭────────────────────────────────────────────────╮
│  DECISION: Padding Calculation Strategy        │
│  Context: Need to fix alignment bugs...        │
│  Confidence: 85% | 2025-11-08 @ 14:30:00       │
╰────────────────────────────────────────────────╯
              ╱────────────────────────╲
             ╱  Select from 3 options?  ╲
            ╱                          ╲
            ╲                          ╱
             ╲────────────────────────╱
      │          │          │
 Option A   Option B   Option C
```

### 3. Parallel Execution

**Performance Optimization**: Uses `Promise.all()` to run 4 extraction operations concurrently

```javascript
await Promise.all([
  collectSessionData(collectedData, specFolderName),
  extractConversations(collectedData),
  extractDecisions(collectedData),
  extractDiagrams(collectedData)
]);
```

**Benefits**:
- 50-60% faster than sequential processing
- Typical execution: ~2-5 seconds for standard conversations
- Works in all Node.js environments (v18+)

### 4. Atomic Writes with Rollback

**Prevents data corruption** through atomic write pattern:

1. Write to `.tmp` file first
2. Verify write with file size check
3. Atomic rename on success
4. **Full rollback** of all files on any failure

**Code Pattern**:

```javascript
// Write to temp file
await fs.writeFile(tempPath, content, 'utf-8');

// Verify
const stat = await fs.stat(tempPath);
if (stat.size !== expectedSize) {
  throw new Error('Write verification failed');
}

// Atomic rename
await fs.rename(tempPath, filePath);

// On error: rollback ALL written files
```

### 5. Quality Validation

**Placeholder Leak Detection**: Catches unreplaced template variables

```javascript
if (content.includes('{{') || content.includes('}}')) {
  console.warn('⚠️  Leaked placeholders detected in ' + filename);
}
```

**Data Quality Warnings**:

```javascript
if (userPrompts.length === 0) {
  console.warn('⚠️  No user prompts - output may be minimal');
}
```

**Activity Validation**: Ensures high-quality phase activities

- Minimum length check (>10 chars)
- Meaningful content validation (>5 alphanumeric chars)
- Word boundary truncation (not mid-word)
- Automatic ellipsis when truncated

---

## Examples

### Example 1: Feature Implementation

**Context**: Completed a new user authentication feature with JWT tokens

**Invocation**:

```javascript
Skill(skill: "save-context")
```

**Generated Output**:

```markdown
# SESSION SUMMARY

| **Meta Data** | **Value** |
|:---------------|:----------|
| Session Date | 2025-11-08 |
| Spec Folder | 015-auth-jwt |
| Total Messages | 47 |
| Tool Executions | 23 |
| Decisions Made | 2 |

## 1. OVERVIEW

Implemented JWT-based authentication system with refresh tokens, secure cookie storage,
and rate limiting. Integrated with existing user service and added comprehensive tests.

**Key Outcomes**:
- JWT authentication with 15-minute access tokens
- Refresh token rotation with 7-day expiry
- Rate limiting: 5 failed attempts = 15-minute lockout
- 98% test coverage on auth module

| **File** | **Changes** |
|:---------|:------------|
| `src/auth/jwt.service.ts` | Created JWT service with token generation and validation |
| `src/auth/auth.controller.ts` | Added login, logout, and refresh endpoints |
| `src/auth/auth.middleware.ts` | Implemented JWT verification middleware |
| `tests/auth/jwt.spec.ts` | Added 24 test cases for JWT service |
```

### Example 2: Architectural Discussion

**Context**: Discussed and decided on state management approach for React app

**Generated Decision Tree**:

```markdown
### Decision 1: State Management Library Selection

**Context**: Need centralized state management for complex app with 50+ components.
Considered Redux, Zustand, and Jotai for different tradeoffs.

#### Visual Decision Tree

╭────────────────────────────────────────────────╮
│  DECISION: State Management Library            │
│  Context: Need centralized state for 50+...   │
│  Confidence: 90% | 2025-11-08 @ 10:30:00       │
╰────────────────────────────────────────────────╯

#### Options Considered

1. **Redux Toolkit**
   Modern Redux with reduced boilerplate and excellent DevTools

2. **Zustand**
   Minimal API with hooks-based access and no providers

3. **Jotai**
   Atomic state management with fine-grained reactivity

#### Chosen Approach

**Selected**: Zustand

**Rationale**: Best balance of simplicity and power. No provider wrapper needed,
smaller bundle size than Redux (3KB vs 45KB), and hooks-based API matches our
React patterns. Team already familiar with Zustand from other projects.

**Advantages**:
- Minimal boilerplate (no actions, reducers, or providers)
- Simple API with hooks
- Small bundle size (3KB gzipped)
- Built-in middleware for persistence and devtools

**Disadvantages**:
- Less structured than Redux (can lead to inconsistent patterns)
- Smaller ecosystem than Redux
- No built-in time-travel debugging
```

### Example 3: Bug Investigation

**Context**: Investigated and fixed a race condition in async data loading

**Generated Workflow**:

```markdown
## 2. WORKFLOW VISUALIZATION

**Pattern Type**: Linear

**Use Case**: Bug investigation and fix

```
╭────────────────────────────────────────────────────────╮
│                  CONVERSATION WORKFLOW                   │
╰────────────────────────────────────────────────────────╯
                        │
                        ▼
┌────────────────────────────────────────────────────────┐
│  Investigation                                         │
│  • Reproduced race condition in local environment      │
│  • Added debug logging to track async operations       │
│  • Identified race in useEffect cleanup                │
│  Duration: 4 actions                                   │
└────────────────────────────────────────────────────────┘
                        │
                        ▼
┌────────────────────────────────────────────────────────┐
│  Solution Design                                       │
│  • Researched AbortController pattern                  │
│  • Reviewed React docs on effect cleanup               │
│  Duration: 2 actions                                   │
└────────────────────────────────────────────────────────┘
                        │
                        ▼
┌────────────────────────────────────────────────────────┐
│  Implementation                                        │
│  • Added AbortController to data fetch                 │
│  • Implemented proper cleanup in useEffect             │
│  • Added loading state guards                          │
│  Duration: 3 actions                                   │
└────────────────────────────────────────────────────────┘
                        │
                        ▼
┌────────────────────────────────────────────────────────┐
│  Verification                                          │
│  • Tested rapid component mount/unmount                │
│  • Verified no setState on unmounted component         │
│  • Confirmed fix in production build                   │
│  Duration: 2 actions                                   │
└────────────────────────────────────────────────────────┘
```
```

---

## Troubleshooting

### Common Issues

#### Issue: "No spec folder found"

**Cause**: Not currently in a spec directory and no `specs/` folders exist in workspace

**Solution**:

```bash
# Check for existing spec folders
ls specs/

# Create new spec folder
mkdir -p specs/###-topic-name

# Navigate to it
cd specs/###-topic-name

# Now invoke skill
Skill(skill: "save-context")
```

#### Issue: "Context folder already exists"

**Cause**: Previous context output exists for this spec

**Solution**: Choose one of three options when prompted:

- **(O)verwrite**: Replaces existing context (recommended for updates)
- **(V)ersion**: Creates timestamped backup before overwriting
- **(A)bort**: Cancels skill execution

#### Issue: "Warning: No user prompts captured"

**Cause**: Conversation has no user messages (unlikely in normal use)

**Solution**: This is informational. The skill will still generate output but it may be minimal. Verify that the conversation data was passed correctly to the skill.

#### Issue: "Warning: Leaked placeholders detected"

**Cause**: Template variables weren't replaced (indicates a bug in the skill)

**Solution**: This indicates missing data in the conversation JSON. Check:

1. Is this a very short conversation with minimal content?
2. Are there any observations or decisions recorded?
3. If persistent, report as a bug with the generated output

#### Issue: Slow execution (> 10 seconds)

**Cause**: Large conversation with many messages and tool executions

**Solution**: Reduce `maxConversationMessages` in config.json:

```json
{
  "maxConversationMessages": 50
}
```

#### Issue: Truncated tool outputs

**Cause**: Default limit of 100 lines per tool output

**Solution**: Increase `maxToolOutputLines` in config.json:

```json
{
  "maxToolOutputLines": 200
}
```

---

## API Reference

### Template Variables

The output template (`context.template.md`) uses these placeholders:

#### Session Metadata

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `{{DATE}}` | string | Session date (YYYY-MM-DD) | 2025-11-08 |
| `{{SPEC_FOLDER}}` | string | Spec folder name | 015-auth-jwt |
| `{{MESSAGE_COUNT}}` | number | Total messages in conversation | 47 |
| `{{TOOL_COUNT}}` | number | Tool executions | 23 |
| `{{DECISION_COUNT}}` | number | Decisions documented | 2 |
| `{{FOLLOWUP_COUNT}}` | number | Follow-up items recorded | 5 |

#### Overview Section

| Variable | Type | Description |
|----------|------|-------------|
| `{{SUMMARY}}` | string | High-level session summary (2-3 sentences) |
| `{{OUTCOMES}}` | array | List of key outcomes |
| `{{FILES}}` | array | Files modified with descriptions |

#### Workflow Diagram

| Variable | Type | Description |
|----------|------|-------------|
| `{{HAS_WORKFLOW_DIAGRAM}}` | boolean | True if phases detected |
| `{{WORKFLOW_FLOWCHART}}` | string | ASCII art flowchart |
| `{{PATTERN_TYPE}}` | string | "Linear" or "Parallel" |
| `{{USE_CASE_TITLE}}` | string | Workflow use case description |
| `{{PHASE_COUNT}}` | number | Number of conversation phases |
| `{{PHASES}}` | array | Phase objects with name, duration, activities |

#### Decisions Section

| Variable | Type | Description |
|----------|------|-------------|
| `{{DECISIONS}}` | array | Decision objects |
| `{{TITLE}}` | string | Decision title |
| `{{CONTEXT}}` | string | Decision context/rationale |
| `{{TIMESTAMP}}` | string | ISO timestamp of decision |
| `{{HAS_DECISION_TREE}}` | boolean | True if decision tree generated |
| `{{DECISION_TREE}}` | string | ASCII art decision tree |
| `{{OPTIONS}}` | array | Options considered |
| `{{CHOSEN}}` | string | Selected option |
| `{{RATIONALE}}` | string | Why this option was chosen |
| `{{CONFIDENCE}}` | number | Confidence percentage (0-100) |

#### Conversation Section

| Variable | Type | Description |
|----------|------|-------------|
| `{{MESSAGES}}` | array | Message objects |
| `{{ROLE}}` | string | "User" or "Assistant" |
| `{{TIMESTAMP}}` | string | Message timestamp (readable format) |
| `{{CONTENT}}` | string | Message content |
| `{{TOOL_CALLS}}` | array | Tool executions within message |
| `{{TOOL_NAME}}` | string | Name of tool executed |
| `{{RESULT_PREVIEW}}` | string | Truncated tool output |

### Script Functions (Internal API)

#### Core Functions

**`main(collectedData)`**
Entry point. Orchestrates entire skill execution.

**`detectSpecFolder()`**
Finds most recent `specs/###-name/` folder.

**`collectSessionData(collectedData, specFolderName)`**
Extracts session metadata (date, folder, counts).

**`extractConversations(collectedData)`**
Parses messages into structured conversation objects.

**`extractDecisions(collectedData)`**
Identifies and structures decision documentation.

**`extractPhasesFromData(collectedData)`**
Detects conversation phases and generates workflow flowchart.

**`renderTemplate(template, data)`**
Mustache-like template rendering with conditionals and arrays.

**`writeFiles(contextDir, files)`**
Atomic file writing with rollback on error.

#### Helper Functions

**`formatTimestamp(date, format)`**
Formats dates in 5 different styles (iso, readable, date, time, filename).

**`detectToolCall(text)`**
Identifies tool calls in text with confidence scoring (high/medium).

**`isProseContext(text, matchIndex)`**
Filters false positives from tool detection (e.g., "Read more about...").

**`cleanupExcessiveNewlines(text)`**
Prevents 3+ consecutive newlines in output.

**`isFalsy(value)`**
Standardized falsy checking for template conditionals.

**`padText(text, width, align)`**
Pads or truncates text to specified width with alignment.

---

## Development

### Requirements

- **Node.js**: v18.0.0 or higher
- **OS**: macOS, Linux, Windows (cross-platform)
- **Dependencies**: None (uses Node.js built-in modules only)

### Testing the Skill

#### Manual Test

1. Create test data file:

```bash
cat > /tmp/test-data.json << 'EOF'
{
  "recent_context": [
    {
      "summary": {
        "request": "Test the save-context skill",
        "completion": "Successfully tested",
        "learning": "All features working correctly",
        "key_note": "Alignment bugs fixed"
      },
      "timestamp": "2025-11-08T12:00:00Z"
    }
  ],
  "observations": [
    {
      "title": "Fixed alignment bugs",
      "type": "bugfix",
      "narrative": "Resolved vertical bar misalignment in flowcharts",
      "timestamp": "2025-11-08T12:00:00Z"
    }
  ],
  "user_prompts": [
    {
      "prompt": "Fix alignment issues in flowcharts",
      "timestamp": "2025-11-08T11:00:00Z"
    }
  ]
}
EOF
```

2. Run the script:

```bash
node .claude/skills/save-context/scripts/generate-context.js /tmp/test-data.json
```

3. Verify output in `specs/###-folder/context/`

#### Automated Testing (Future Enhancement)

No automated tests currently exist. Recommended test suite:

- **Unit tests**: Template rendering, tool detection, decision extraction, timestamp formatting
- **Integration tests**: End-to-end skill execution, error scenarios, rollback verification

### Project Structure

```
.claude/skills/save-context/
├── scripts/
│   └── generate-context.js     # Main script (2,300+ lines)
│       ├── Configuration loading (lines 20-60)
│       ├── Helper functions (lines 87-194)
│       ├── Data extraction (lines 746-1546)
│       ├── Flowchart generation (lines 1598-1876)
│       ├── Decision tree formatting (lines 1878-2123)
│       ├── Template rendering (lines 2125-2364)
│       └── File I/O with rollback (lines 514-627)
├── templates/
│   └── context.template.md     # Mustache-like template (210 lines)
│       ├── Session metadata table
│       ├── Overview section
│       ├── Workflow diagram (conditional)
│       ├── Decisions section (conditional)
│       └── Conversation timeline
└── references/                 # Pattern examples for documentation
    ├── README.md
    ├── workflow-linear-pattern.md
    └── workflow-parallel-pattern.md
```

### Contributing

When modifying the skill:

1. **Update version** in 3 places:
   - `package.json` → `"version"`
   - `generate-context.js` → `SKILL_VERSION`
   - `SKILL.md` → "Skill Version" + changelog

2. **Test thoroughly**:
   - Run with test data
   - Verify flowchart alignment
   - Check decision tree formatting
   - Validate template rendering

3. **Document changes**:
   - Update SKILL.md changelog
   - Add examples if new features
   - Update README.md if config changes

4. **Code standards**:
   - JSDoc comments on all functions
   - Consistent error handling patterns
   - Atomic operations with rollback
   - Input validation

---

## FAQ

### How is this different from claude-mem?

**claude-mem**: Real-time session tracking and memory persistence. Stores observations as you work.

**save-context**: End-of-session documentation generator. Creates human-readable summaries with flowcharts and decision trees.

**Use both**: claude-mem for ongoing context, save-context for final documentation.

### Can I use this with other AI assistants?

Yes! While designed for Claude Code, the skill works in any environment that can:
1. Generate the JSON data format
2. Execute Node.js scripts
3. Write files to disk

Tested in: Claude Code, ChatGPT Code Interpreter (with JSON upload), GitHub Copilot

### Can I export to HTML or PDF?

Not yet. Currently only Markdown output is supported.

**Future enhancement**: Planned support for:
- HTML export with syntax highlighting
- PDF generation with table of contents
- JSON export for programmatic access

### How do I customize the output template?

Edit `.claude/skills/save-context/templates/context.template.md`

**Template syntax**:
- `{{VARIABLE}}` - Insert variable
- `{{#SECTION}}...{{/SECTION}}` - Conditional section (if truthy)
- `{{^SECTION}}...{{/SECTION}}` - Inverted conditional (if falsy)
- `{{#ARRAY}}{{ITEM}}{{/ARRAY}}` - Array iteration

**Example**:

```markdown
{{#HAS_DECISIONS}}
## Decisions Made

{{#DECISIONS}}
### {{TITLE}}
{{RATIONALE}}
{{/DECISIONS}}
{{/HAS_DECISIONS}}
```

### Does this work offline?

Yes! The skill has **zero external dependencies**. All processing is local using Node.js built-in modules:
- `fs/promises` - File system operations
- `path` - Path manipulation
- `readline` - User input
- `process` - Environment access

### How do I version the output files?

When the skill detects existing context, you have 3 options:

1. **(O)verwrite**: Replace existing file
2. **(V)ersion**: Create backup as `{filename}.v1.md`, `{filename}.v2.md`, etc.
3. **(A)bort**: Cancel execution

For team workflows, use versioning to preserve history.

### Can I run this outside of a spec folder?

Yes, but you'll need to either:
1. Have at least one `specs/###-name/` folder in the workspace (skill will use the most recent)
2. Or create one: `mkdir -p specs/###-topic`

The skill automatically detects the most recently modified spec folder and creates a `context/` subdirectory within it.

---

## Support

### Getting Help

1. **Documentation**: Read `SKILL.md` for detailed usage guide
2. **Examples**: Check `references/` folder for pattern examples
3. **Issues**: Report bugs or request features on GitHub

### Reporting Bugs

When reporting issues, include:
- Node.js version (`node --version`)
- Skill version (from `package.json`)
- Generated output files (if safe to share)
- Steps to reproduce

### Feature Requests

Potential enhancements:
- HTML/PDF export formats
- Custom template support
- Diff mode (compare contexts)
- Interactive CLI mode
- GitHub Actions integration

---

## License

**Apache License 2.0**

Copyright 2025 save-context contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

---

## Changelog

### v1.1.0 (2025-11-08)

**Improvements**:
- Fixed tool detection regex (no more false positives from prose text)
- Added atomic file writes with rollback on failure
- Fixed template reference paths (broken `../references/` links)
- Consolidated timestamp formatting into single function
- Improved decision extraction robustness
- Enhanced activity validation with word boundaries
- Better error messaging for empty data
- Fixed flowchart alignment bugs (vertical bar misalignment)
- Fixed decision header padding calculations
- Resolved double-truncation issue causing stray characters

### v1.0.0 (2025-11-07)

**Initial release**:
- Parallel data extraction (4 concurrent operations)
- Auto-generated workflow flowcharts
- Decision tree visualization
- Template-based markdown generation
- Quality validation and warnings
- Cross-platform support (macOS, Linux, Windows)
