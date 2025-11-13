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
- ✅ Block dangerous Bash commands (security + performance)
- ✅ Auto-fix markdown filenames to lowercase snake_case
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
**What it does**: Matches your prompts to relevant skills and displays suggestions

**Triggers**: Before every user prompt

**Connects to**:
- `.claude/configs/skill-rules.json` → Reads skill definitions, keywords, patterns
- Matches keywords: "animation", "commit", "debug", "documentation", etc.
- Matches patterns: "create feature", "fix bug", "implement X"

**Priority Levels**:
- 🔴 CRITICAL: Must apply (shown to user) - e.g., code-standards, conversation-documentation
- 🟡 HIGH: Strongly recommended (logged only) - e.g., git-commit, save-context
- 🔵 MEDIUM: Consider using (logged only) - e.g., debugging, document-style-guide

**Output Example**:
```
🔴 CRITICAL SKILLS APPLY:
   • code-standards - Naming conventions, file headers, commenting rules
   • conversation-documentation - Mandatory spec folder system
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
**What it does**: Validates markdown files and blocks execution on critical violations

**Triggers**: Before user prompts, checks recently modified .md files

**Validates**:
- SKILL.md files: Requires YAML frontmatter, H1 subtitle format, required sections
- Command files: Requires frontmatter (description, argument-hint)
- Knowledge files: H1 subtitle format, no frontmatter allowed

**Connects to**:
- `.claude/knowledge/document_style_guide.md` → Markdown standards
- Git status → Finds modified .md files

**Behavior**:
- ✅ Safe fixes: Auto-applied (separators, caps, spacing) - not by this hook
- 🚫 Critical violations: BLOCKS execution (missing frontmatter, wrong structure)

**Output Example** (when blocking):
```
🚫 MARKDOWN ENFORCEMENT BLOCKED:
  File: .claude/skills/my-skill/SKILL.md
  CRITICAL: Missing YAML frontmatter
  Action Required: Add frontmatter before continuing
```

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
**What it does**: Auto-renames markdown files to lowercase snake_case

**Triggers**: After Write, Edit, NotebookEdit operations on .md files

**Converts**:
- `TEST_FILE.md` → `test_file.md`
- `My-File.md` → `my_file.md`
- `myFile.md` → `my_file.md`

**Exceptions**: `README.md`, `.claude/skills/*/SKILL.md`

**Connects to**:
- `.claude/knowledge/document_style_guide.md` → Naming standards

**Output Example**:
```
✓ MARKDOWN FILENAME AUTO-CORRECTED:
   Renamed: TEST_FILE.md → test_file.md
   Enforced: lowercase snake_case
```

**Logs to**: `.claude/hooks/logs/markdown-enforcement.log`

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
│ UserPromptSubmit Hooks (4)                                  │
├─────────────────────────────────────────────────────────────┤
│ 1. save-context-trigger    → transform-transcript.js       │
│                             → save-context skill            │
│                             → specs/###/memory/ OR memory/  │
│                                                              │
│ 2. validate-skill-activation → skill-rules.json (skills)   │
│                              → Displays CRITICAL priority   │
│                              → Logs HIGH/MEDIUM priority    │
│                                                              │
│ 3. suggest-semantic-search  → semantic_search_mcp.md       │
│                             → MCP tools reminder            │
│                                                              │
│ 4. enforce-markdown-strict  → document_style_guide.md      │
│                             → Git status (modified .md)     │
│                             → BLOCKS if critical violations │
└─────────────────────────────────────────────────────────────┘
    ↓
Claude Processes Prompt
    ↓
┌─────────────────────────────────────────────────────────────┐
│ PreToolUse Hooks (1)                                        │
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
│                             → Logs corrections              │
│                                                              │
│ 2. validate-post-response   → skill-rules.json (patterns)  │
│                             → Detects risk patterns         │
│                             → Logs quality reminders        │
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
- `enforce-markdown-post.sh` → `markdown-enforcement.log`
- `validate-post-response.sh` → `quality-checks.log`
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

**Key Functions**:
- `print_message()` - Status messages with color/emoji
- `print_section()` - Boxed section headers
- `print_bullet()` - Bullet points
- `check_dependency()` - Silently verify commands
- `validate_json()` - Validate JSON files

**Used by**: All 7 hooks

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

### `markdown-enforcement.log`
**Hook**: enforce-markdown-post.sh
**Contains**: Original/corrected filenames, timestamp, reason for correction

### `quality-checks.log`
**Hook**: validate-post-response.sh
**Contains**: Files edited, risk categories detected, quality reminders

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
- initialization-pattern, markdown-flowchart, markdown-enforcer, save-context, webflow-platform-constraints

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
