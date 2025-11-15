# Claude Code Hooks

Automated workflows and quality checks for Claude Code interactions. Hooks trigger during operations to provide auto-save, skill suggestions, security validation, and quality reminders.

#### 📋 TABLE OF CONTENTS

1. [📖 OVERVIEW](#1--overview)
2. [🔄 HOOK LIFECYCLE](#2--hook-lifecycle)
3. [🎯 INSTALLED HOOKS](#3--installed-hooks)
4. [🔗 HOW HOOKS CONNECT](#4--how-hooks-connect)
5. [📚 SHARED LIBRARIES](#5--shared-libraries)
6. [📊 LOGS DIRECTORY](#6--logs-directory)
7. [⚙️ CONFIGURATION](#7-️-configuration)
8. [🛠️ HELPER SCRIPTS](#8-️-helper-scripts)

---

## 1. 📖 OVERVIEW

This directory contains hooks that automatically trigger during Claude Code operations.

### Hook Support Status

| Hook Type | Status | Description |
|-----------|--------|-------------|
| **UserPromptSubmit** | ✅ WORKING | Triggers before user prompts are processed |
| **PreToolUse** | ✅ WORKING | Triggers before Bash tool execution |
| **PostToolUse** | ✅ WORKING | Triggers after Write/Edit/NotebookEdit operations |

### Active Features
- ✅ Auto-save conversation context (keywords + context threshold)
- ✅ Suggest relevant skills based on prompt content
- ✅ Semantic search MCP tool reminders for code exploration
- ✅ Hard-block enforcement of spec folders + template validation
- ✅ Block dangerous Bash commands (security + performance)
- ✅ Auto-fix markdown filenames to lowercase snake_case with condensed output
- ✅ **NEW**: C7score quality analysis for modified markdown files
- ✅ **NEW**: Condensed hook output (~70% verbosity reduction)
- ✅ **NEW**: Success indicators for validation passes
- ✅ Quality check reminders for edited code files
- ✅ Security risk pattern detection (eval, innerHTML, etc.)
- ✅ Performance monitoring (all hooks log execution timing)

---

## 2. 🔄 HOOK LIFECYCLE

```
User Action
     │
     ▼
┌────────────────────────────────────┐
│  UserPromptSubmit Hooks            │
│  - save-context-trigger.sh (0)     │
│  - validate-skill-activation.sh(0) │
│  - enforce-spec-folder.sh (1)      │
│  - enforce-markdown-strict.sh (1)  │
│  Note: (1) = blocking, (0) = allow │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  Claude Processes Prompt           │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  PreToolUse Hooks                  │
│  - validate-bash.sh (2)            │
│  Note: (2) = blocks if dangerous   │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  Tool Executes                     │
│  (Write/Edit/Bash/etc.)            │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  PostToolUse Hooks                 │
│  - enforce-markdown-post.sh (0)    │
│  - validate-post-response.sh (0)   │
│  Note: (0) = non-blocking auto-fix │
└────────┬───────────────────────────┘
         │
         ▼
┌────────────────────────────────────┐
│  Result Returned to User           │
└────────────────────────────────────┘
```

---

## 3. 🎯 INSTALLED HOOKS

### UserPromptSubmit Hooks

#### `save-context-trigger.sh`
**What it does**: Auto-saves conversations to preserve context and decisions

**Triggers**:
- Keywords: "save context", "save conversation", "export conversation", "document this", "preserve context"
- Automatic: At 200 messages (≈75% capacity, 25% remaining)

**Connects to**:
- `save-context` skill → Uses generate-context.js
- `lib/transform-transcript.js` → Transforms JSONL to JSON format
- Saves to: `specs/###-folder/memory/` (or `memory/` fallback)
- Logs performance to: `.claude/hooks/logs/performance.log`

**Output Examples**:
```
💾 Context auto-saved (keyword: 'save context')
💾 Context auto-saved (75% capacity: 205 messages)
```

#### `validate-skill-activation.sh`
**What it does**: Matches your prompts to relevant skills, displays suggestions, and now provides documentation guidance when the `conversation-documentation` skill fires.

**Triggers**: Before every user prompt

**Connects to**:
- `.claude/configs/skill-rules.json` → Reads skill definitions, keywords, patterns
- Matches keywords: "animation", "commit", "debug", "documentation", etc.
- Matches patterns: "create feature", "fix bug", "implement X"

**Priority Levels**:
- 🔴 CRITICAL: Must apply (shown to user) - e.g., code-standards, conversation-documentation
- 🟡 HIGH: Strongly recommended (logged only) - e.g., git-commit, save-context
- 🔵 MEDIUM: Consider using (logged only) - e.g., debugging, document-style-guide

**Conversation Documentation Enhancements**:
- Estimates documentation level + complexity straight from the prompt
- Calculates next spec folder number
- Prints copy commands for required/optional templates
- Shows documentation time estimate and links back to `.claude/knowledge/conversation_documentation.md`

**Output Example**:
```
🔴 CRITICAL SKILLS APPLY:
   • code-standards - Naming conventions, file headers, commenting rules
   • conversation-documentation - Mandatory spec folder system

📊 Detected Intent: Feature implementation or refactor
📏 Estimated LOC: ~200 lines
📋 Recommended Level: Level 2 (Standard)

🗂️  Next Spec Number: 049
📁 Create Folder: specs/049-your-feature-name/

📝 Required Templates:
   cp .specify/templates/spec_template.md specs/049-your-feature-name/spec.md
   cp .specify/templates/plan_template.md specs/049-your-feature-name/plan.md

💡 Optional Templates:
   cp .specify/templates/tasks_template.md specs/049-your-feature-name/tasks.md
   cp .specify/templates/checklist_template.md specs/049-your-feature-name/checklist.md

📖 Guide: .claude/knowledge/conversation_documentation.md
⚙️  Level Decision Tree: Section 2 of conversation_documentation.md
⏱️  Estimated Documentation Time: ≈20 minutes
```

**Logs to**: `.claude/hooks/logs/skill-recommendations.log` (all matches)

#### `suggest-semantic-search.sh`
**What it does**: Reminds AI to use semantic search MCP tools for code exploration

**Triggers**:
- Keywords: "find code", "where is implementation", "locate function", "search codebase"
- Patterns: "explore code", "analyze implementation", "show how X works"

**Connects to**:
- `.claude/knowledge/semantic_search_mcp.md` → Usage guidelines
- MCP semantic search tools → Intent-based code discovery

**Output Example**:
```
💡 SEMANTIC SEARCH REMINDER:
  • semantic_search - Find code by what it does, not what it's called
  • Helpful for: locating implementations, understanding features
  📖 See: .claude/knowledge/semantic_search_mcp.md
  ⚠️  Note: CLI AI agents only (not IDE integrations)
```

#### `enforce-markdown-strict.sh`
**What it does**: Validates markdown files, blocks on critical violations, and provides C7score quality analysis

**Triggers**: Before user prompts, checks recently modified .md files

**Validates**:
- SKILL.md files: Requires YAML frontmatter, H1 subtitle format, required sections
- Command files: Requires frontmatter (description, argument-hint)
- Knowledge files: H1 subtitle format, no frontmatter allowed

**NEW - C7Score Integration**:
- Runs `markdown-c7-optimizer` CLI tool on modified markdown files
- Shows condensed analysis output (issue rate, recommendations)
- Non-blocking informational feedback only
- Helps optimize documentation for AI consumption

**Connects to**:
- `.claude/knowledge/document_style_guide.md` → Markdown standards
- `.claude/skills/markdown-c7-optimizer/markdown-c7-optimizer` → CLI wrapper for C7score analysis
- `.claude/skills/markdown-c7-optimizer/scripts/analyze_docs.py` → Python analyzer
- Git status → Finds modified .md files
- `lib/output-helpers.sh` → Condensed output formatting

**Behavior**:
- ✅ Safe fixes: Auto-applied by other tools (separators, caps, spacing)
- 🚫 Critical violations: BLOCKS execution (missing frontmatter, wrong structure)
- ℹ️ C7score analysis: Informational only, shows quality metrics
- ✅ Success indicator: Shows "✅ Markdown validation passed: N file(s) checked, 0 violations"

**Output Example** (blocking - condensed):
```
❌ MARKDOWN ENFORCEMENT BLOCKED: .claude/skills/my-skill/SKILL.md
   Type: skill (strict enforcement)

   Critical Issues:
     CRITICAL: Missing YAML frontmatter
     CRITICAL: H1 missing subtitle

   Fix: Review .claude/knowledge/document_style_guide.md
   Then: markdown-c7-optimizer --phase enforcement SKILL.md
```

**Output Example** (C7score analysis):
```
ℹ️  C7SCORE ANALYSIS:
   Issue rate: 20.0%
   ✅ Recommendations

   Tip: Run 'markdown-c7-optimizer /path/to/file.md' for full analysis
```

**Output Example** (success):
```
✅ Markdown validation passed: 3 file(s) checked, 0 violations
```

#### `enforce-spec-folder.sh`
**What it does**: Hard-blocks modification prompts until a spec folder exists with valid templates. **NEW**: Discovers and surfaces related existing specs to prevent duplicates. Provides actionable guidance (level estimate, next spec number, copy commands, and spec reuse recommendations).

**Triggers**:
- Runs before each prompt
- Fires only when the prompt implies file modifications (verbs like add/update/implement)

**Validates**:
- Latest `specs/###-short-name/` folder exists
- `spec.md` or `README.md` > 200 bytes with numbered sections
- Optional placeholder checks (configurable)
- Supports warning/soft/hard modes via `skill-rules.json`

**NEW: Related Spec Discovery**:
- Extracts keywords from user prompt
- Searches existing spec folders by keyword matching
- Checks spec.md frontmatter for status field (active/draft/paused/complete/archived)
- Ranks by status priority (active > draft > paused > complete)
- Surfaces top 3 related specs to AI before blocking

**Connects to**:
- `.claude/configs/skill-rules.json` → `conversation-documentation.enforcementConfig`
- `.claude/knowledge/conversation_documentation.md` → Section 7 (Spec Reuse Guidelines)
- `.claude/hooks/scripts/find-related-spec.sh` → Manual search tool
- `.claude/hooks/logs/spec-enforcement.log` + `performance.log`

**Exceptions**:
- Configurable patterns (`typo fix`, `whitespace only`, etc.) with LOC + single-file constraints

**Output Example (No Related Specs)**:
```
❌ SPEC DOCUMENTATION REQUIRED
Detected modification intent: implement
Estimated Level: Level 2 (Standard)
Reason: No spec folder detected

Next Actions:
1. Create folder: specs/049-your-feature-name/
2. Copy templates:
   cp .specify/templates/spec_template.md specs/049-your-feature-name/spec.md
   cp .specify/templates/plan_template.md specs/049-your-feature-name/plan.md
3. Fill placeholders + metadata
Guide: .claude/knowledge/conversation_documentation.md
```

**Output Example (Related Specs Found)**:
```
───────────────────────────────────────────────
RELATED SPECS FOUND
───────────────────────────────────────────────
Found existing specs that may be related to your request:
──────────────────────────────────────────────────────────

  • 049-markdown-c7-optimizer-alignment
    Status: ✓ ACTIVE - recommended for updates
    Path: /path/to/specs/049-markdown-c7-optimizer-alignment
──────────────────────────────────────────────────────────

  • 052-markdown-c7-optimizer-alignment
    Status: ◐ DRAFT - can be started
    Path: /path/to/specs/052-markdown-c7-optimizer-alignment
──────────────────────────────────────────────────────────

RECOMMENDATION
Consider updating one of the related specs above instead of creating a new one.
Guidelines: .claude/knowledge/conversation_documentation.md Section 7

AI should ask user:
  A) Update existing spec (if work is related)
  B) Create new spec (if work is distinct)
──────────────────────────────────────────────────────────
```

**Helper Script**: `.claude/hooks/scripts/find-related-spec.sh`
- Standalone tool for manual spec search
- Usage: `find-related-spec.sh "keyword1 keyword2"`
- Returns top 5 matches with status and description
- Three-tier ranking: folder name (10) > title (5) > content (1)

### PreToolUse Hooks

#### `validate-bash.sh`
**What it does**: Prevents dangerous bash commands and wasteful file operations

**Triggers**: Before executing any Bash command

**Blocks**:
- Dangerous commands: `rm -rf /`, `sudo`, `chmod 777`, `curl ... | sh`
- Large directories: `node_modules`, `build/`, `dist/`, `venv/`
- Sensitive files: `.ssh/`, `.env`, `.pem`, credentials

**Allows (Whitelisted)**:
- `.claude/logs/`, `.claude/hooks/logs/`, `.claude/configs/`

**Output Example**:
```
ERROR: Access to 'node_modules' is blocked by security policy
Alternative: Use targeted file reads or grep/glob patterns
```

### PostToolUse Hooks

#### `enforce-markdown-post.sh`
**What it does**: Auto-renames markdown files to lowercase snake_case with condensed output

**Triggers**: After Write, Edit, NotebookEdit operations on .md files

**Converts**:
- `TEST_FILE.md` → `test_file.md`
- `My-File.md` → `my_file.md`
- `myFile.md` → `my_file.md`

**Exceptions**: `README.md`, `.claude/skills/*/SKILL.md`

**Connects to**:
- `.claude/knowledge/document_style_guide.md` → Naming standards
- `lib/output-helpers.sh` → `print_correction_condensed()` function

**Output Example** (condensed - 1 line):
```
✓ AUTO-CORRECTED: TEST_FILE.md → test_file.md (See document_style_guide.md:37-42)
```

**Previous output** (verbose - 11 lines): Replaced with condensed format for ~91% reduction

**Logs to**: `.claude/hooks/logs/quality-checks.log`

#### `validate-post-response.sh`
**What it does**: Detects code patterns and logs quality check reminders

**Triggers**: After file edit operations (Edit, Write)

**Detects Patterns**:
- Animation code → Reminds about performance, mobile timing
- Async operations → Reminds about error handling, timeouts
- Form handling → Reminds about validation, accessibility
- Initialization → Reminds about CDN-safe patterns
- Security risks → Reminds about XSS, input validation
- Code changes → Reminds about spec folder requirement

**Connects to**:
- `.claude/configs/skill-rules.json` → Reads `riskPatterns` definitions

**Behavior**: Non-blocking, silently logs reminders only

**Logs to**: `.claude/hooks/logs/quality-checks.log`

---

## 4. 🔗 HOW HOOKS CONNECT

### Connection Flow

```
User Prompt
    ↓
┌─────────────────────────────────────────────────────────────┐
│ UserPromptSubmit Hooks (5)                                  │
├─────────────────────────────────────────────────────────────┤
│ 1. save-context-trigger    → transform-transcript.js       │
│                             → save-context skill            │
│                             → specs/###/memory/ OR memory/  │
│                                                              │
│ 2. validate-skill-activation → skill-rules.json (skills)   │
│                              → Displays CRITICAL priority   │
│                              → Logs HIGH/MEDIUM priority    │
│                              → Prints doc guidance when needed│
│                                                              │
│ 3. suggest-semantic-search  → semantic_search_mcp.md       │
│                             → MCP tools reminder            │
│                                                              │
│ 4. enforce-spec-folder     → specs/** + skill-rules.json   │
│                             → conversation_documentation.md │
│                             → Discovers related specs       │
│                             → Hard-blocks missing docs      │
│                             → Logs to spec-enforcement.log  │
│                                                              │
│ 5. enforce-markdown-strict  → document_style_guide.md      │
│                             → markdown-c7-optimizer CLI tool   │
│                             → C7score quality analysis      │
│                             → Git status (modified .md)     │
│                             → BLOCKS if critical violations │
│                             → Condensed blocking output     │
│                             → Success indicators            │
├─────────────────────────────────────────────────────────────┤

│ 1. validate-bash            → Validates command patterns    │
│                             → BLOCKS dangerous commands     │
│                             → Whitelists .claude/ paths     │
└─────────────────────────────────────────────────────────────┘
    ↓
Tool Executes (Bash, Write, Edit, etc.)
    ↓
┌─────────────────────────────────────────────────────────────┐
│ PostToolUse Hooks (2)                                       │
├─────────────────────────────────────────────────────────────┤
│ 1. enforce-markdown-post    → Auto-renames .md files       │
│                             → lowercase_snake_case.md       │
│                             → Condensed output (1 line)     │
│                             → Logs to quality-checks.log    │
│                                                              │
│ 2. validate-post-response   → skill-rules.json (patterns)  │
│                             → Detects risk patterns         │
│                             → Logs to quality-checks.log    │
└─────────────────────────────────────────────────────────────┘
    ↓
Result Returned to User
```

### Central Hub: `skill-rules.json`

The configuration file `.claude/configs/skill-rules.json` is the **central connection point**:

**Used by 2 hooks**:
1. `validate-skill-activation.sh` → Reads `.skills{}` definitions
2. `validate-post-response.sh` → Reads `.riskPatterns{}` definitions

**Defines**:
- 19 skills with keywords, patterns, priorities, file triggers
- 7 risk pattern categories with detection patterns and reminders

### Shared Library: `output-helpers.sh`

**Used by all hooks** for consistent formatting:
- Functions: `print_message()`, `print_section()`, `print_bullet()`
- Emoji standards: ℹ️ INFO, ✅ SUCCESS, ⚠️ WARN, ❌ ERROR
- Priority indicators: 🔴 CRITICAL, 🟡 HIGH, 🔵 MEDIUM

### Log Files Connection

All hooks write to `.claude/hooks/logs/`:
- `save-context-trigger.sh` → `auto-save-context.log`
- `validate-skill-activation.sh` → `skill-recommendations.log`
- `enforce-markdown-post.sh` → `quality-checks.log`
- `enforce-markdown-strict.sh` → `quality-checks.log`
- `validate-post-response.sh` → `quality-checks.log`
- `enforce-spec-folder.sh` → `spec-enforcement.log`
- All 7 hooks → `performance.log` (execution timing)

---

## 5. 📚 SHARED LIBRARIES

### `lib/output-helpers.sh`
**Purpose**: Standardized visual output formatting for all hooks

**Provides**:
- Consistent color-coded messages (INFO, SUCCESS, WARN, ERROR)
- Emoji indicators: ℹ️ ✅ ⚠️ ❌ | 🔴 🟡 🔵
- Visual separators and section headers
- Dependency checking and JSON validation
- **NEW**: Condensed output helpers for reduced terminal verbosity

**Key Functions**:
- `print_message()` - Status messages with color/emoji
- `print_section()` - Boxed section headers
- `print_bullet()` - Bullet points
- `check_dependency()` - Silently verify commands
- `validate_json()` - Validate JSON files
- **NEW**: `print_correction_condensed()` - Single-line auto-correction notices
- **NEW**: `print_blocking_error_condensed()` - Condensed blocking errors (8-10 lines)

**Condensed Output Benefits**:
- Filename corrections: 11 lines → 1 line (91% reduction)
- Blocking errors: 24 lines → 10 lines (58% reduction)
- Average verbosity reduction: ~70%
- Progressive disclosure: Essential info immediately, references for details

**Used by**: All 7 hooks

**Recent Enhancement** (2025-11-15): Added condensed output helpers to reduce terminal verbosity while maintaining information clarity through progressive disclosure

### `lib/transform-transcript.js`
**Purpose**: Convert Claude Code transcript (JSONL) to save-context format (JSON)

**Used by**: `save-context-trigger.sh` hook

**Transforms**:
- Extracts user prompts and assistant responses
- Filters system messages and tool calls
- Structures conversation flow for documentation
- Prepares data for `save-context` skill's generate-context.js

---

## 6. 📊 LOGS DIRECTORY

All hooks write to `.claude/hooks/logs/` for debugging and audit trail:

### `auto-save-context.log`
**Hook**: save-context-trigger.sh
**Contains**: Trigger method (keyword vs. threshold), session ID, target folder, status

### `skill-recommendations.log`
**Hook**: validate-skill-activation.sh
**Contains**: Timestamp, detected keywords/patterns, recommended skills, priority levels

### `quality-checks.log`
**Hooks**: enforce-markdown-post.sh, enforce-markdown-strict.sh
**Contains**:
- Markdown filename corrections (original/corrected, timestamp, reason)
- Markdown validation enforcement actions (BLOCKED status, file type, violations)
- Quality check reminders from validate-post-response.sh

### `spec-enforcement.log`
**Hook**: enforce-spec-folder.sh
**Contains**: Detected intent, enforcement mode, spec folder status, block/allow outcome

### `performance.log`
**Hooks**: All 7 hooks
**Contains**: Execution timing for each hook invocation
**Format**: `[YYYY-MM-DD HH:MM:SS] hook_name Xms`
**Purpose**: Performance monitoring and optimization

### Usage Examples

```bash
# View recent entries
tail -n 50 .claude/hooks/logs/skill-recommendations.log

# Search for specific patterns
grep "git-commit" .claude/hooks/logs/skill-recommendations.log
grep "SECURITY CHECK" .claude/hooks/logs/quality-checks.log

# View all auto-save triggers
cat .claude/hooks/logs/auto-save-context.log

# Check hook performance
tail -20 .claude/hooks/logs/performance.log
grep "validate-bash" .claude/hooks/logs/performance.log
```

### Maintenance Scripts

**Automated log rotation**:
```bash
bash .claude/hooks/scripts/rotate-logs.sh
```
- Rotates logs exceeding 10,000 lines
- Keeps last 1,000 lines, archives remainder
- Archives to: `.claude/hooks/logs/archive/` (gzip compressed)

**Recommended**: Run weekly or when logs exceed threshold

**Maintenance**: Log files grow over time. Use rotation script regularly. Archives are compressed and timestamped. Not tracked in git.

---

## 7. ⚙️ CONFIGURATION

### `.claude/configs/skill-rules.json`

**Central hub** connecting hooks to skills and patterns.

**Structure**:
```json
{
  "skills": {
    "skill-name": {
      "type": "knowledge|workflow|tool",
      "enforcement": "strict|suggest",
      "priority": "critical|high|medium",
      "description": "Brief description",
      "promptTriggers": {
        "keywords": ["word1", "word2"],
        "intentPatterns": ["regex1", "regex2"]
      },
      "fileTriggers": {
        "pathPatterns": ["src/**/*.js"],
        "contentPatterns": ["pattern1"]
      },
      "alwaysActive": true|false
    }
  },
  "riskPatterns": {
    "category-name": {
      "patterns": ["regex1", "regex2"],
      "reminder": "Quality check reminder text"
    }
  }
}
```

**Used by**:
- `validate-skill-activation.sh` → Reads `skills{}` for prompt matching
- `validate-post-response.sh` → Reads `riskPatterns{}` for code pattern detection

**Current Skills** (19 total):
- animation-strategy, code-cdn-versioning, code-condition-based-waiting
- code-defense-in-depth, code-root-cause-tracing, code-systematic-debugging
- code-verification-before-completion, mcp-chrome-devtools
- code-standards ⭐ (alwaysActive), conversation-documentation ⭐ (alwaysActive)
- debugging, document-style-guide, git-commit, git-worktrees
- initialization-pattern, markdown-flowchart, markdown-c7-optimizer, save-context, webflow-platform-constraints

**Current Risk Patterns** (7 categories):
- animation, asyncOperations, commitOperations, formHandling
- initialization, securityRisks, specFolderRequired

### `.claude/configs/skill-rules.schema.json`

**Purpose**: JSON Schema (Draft 7) for validating skill-rules.json structure

**Validates**:
- Skill types: `knowledge|workflow|tool`
- Enforcement modes: `strict|suggest`
- Priority levels: `critical|high|medium|low`
- Required fields and structure
- Pattern syntax

**Validation Script**:
```bash
bash .claude/hooks/scripts/validate-config.sh
```

**Recommended**: Run before editing skill-rules.json to prevent configuration errors

---

## 8. 🛠️ HELPER SCRIPTS

### `.claude/hooks/scripts/find-related-spec.sh`

**Purpose**: Standalone tool to search for related spec folders by keywords

**Usage**:
```bash
.claude/hooks/scripts/find-related-spec.sh "keyword1 keyword2"
```

**Examples**:
```bash
# Search for markdown-related specs
.claude/hooks/scripts/find-related-spec.sh "markdown optimizer"

# Search for hero animation specs
.claude/hooks/scripts/find-related-spec.sh "hero animation"

# Search for authentication specs
.claude/hooks/scripts/find-related-spec.sh "auth"
```

**How it Works**:
1. Searches spec folder names (highest priority - score 10)
2. Searches spec.md titles (medium priority - score 5)
3. Searches spec.md content first 50 lines (low priority - score 1)
4. Extracts status from YAML frontmatter
5. Returns top 5 matches ranked by score

**Output Format**:
```
Related specs found for: markdown optimizer
──────────────────────────────────────────────────────────────

049-markdown-c7-optimizer-alignment
  Status: ✓ ACTIVE
  Path: /path/to/specs/049-markdown-c7-optimizer-alignment
  Description: Align markdown-c7-optimizer skill with standards...

──────────────────────────────────────────────────────────────
Found 2 related spec(s)

Guidelines: .claude/knowledge/conversation_documentation.md Section 7
```

**Exit Codes**:
- `0` - Matches found
- `1` - No matches or error

**Used by**:
- `enforce-spec-folder.sh` hook (automatic discovery)
- AI agents (manual search before creating new specs)
- Users (command-line spec discovery)

**Status Field Support**:
- `active` - Currently being worked on (highest priority)
- `draft` - Planning phase
- `paused` - Temporarily on hold
- `complete` - Implementation finished
- `archived` - Historical record
- Default: `active` (if status field missing)

**Performance**: <50ms for typical spec directory (~50 folders)

---

### `.claude/hooks/scripts/rotate-logs.sh`

**Purpose**: Rotate and compress hook log files

**Usage**:
```bash
bash .claude/hooks/scripts/rotate-logs.sh
```

**Behavior**:
- Rotates logs exceeding 10,000 lines
- Keeps last 1,000 lines in active log
- Archives remainder to `.claude/hooks/logs/archive/`
- Compresses archives with gzip
- Adds timestamp to archive filename

**Recommended Schedule**: Weekly or when logs exceed threshold

---

### `.claude/hooks/scripts/validate-config.sh`

**Purpose**: Validate skill-rules.json against JSON schema

**Usage**:
```bash
bash .claude/hooks/scripts/validate-config.sh
```

**Validates**:
- JSON syntax correctness
- Required fields present
- Valid enum values
- Proper structure

**Recommended**: Run before committing changes to skill-rules.json