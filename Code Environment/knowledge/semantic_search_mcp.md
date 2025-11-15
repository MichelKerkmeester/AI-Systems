# Semantic Search MCP - Intent-Based Code Discovery

Semantic code search capabilities for anobel.com project through integrated tools that enable AI-powered codebase exploration using natural language queries instead of keyword searches. Available exclusively for CLI AI agents that support MCP (Model Context Protocol).

#### 📋 TABLE OF CONTENTS

1. [⚠️ SCOPE AND COMPATIBILITY](#1-️-scope-and-compatibility)
2. [🏗️ ARCHITECTURE AND DATA FLOW](#2-️-architecture-and-data-flow)
3. [🔍 AVAILABLE MCP TOOLS](#3--available-mcp-tools)
4. [✅ USAGE GUIDELINES FOR AI AGENTS](#4--usage-guidelines-for-ai-agents)
5. [📊 DECISION FLOWCHART: WHICH TOOL TO USE](#5--decision-flowchart-which-tool-to-use)
6. [🎯 PROJECT-SPECIFIC CONTEXT (ANOBEL.COM)](#6--project-specific-context-anobelcom)
7. [📚 REFERENCES AND RESOURCES](#7--references-and-resources)

---

## 1. ⚠️ SCOPE AND COMPATIBILITY

### Who Can Use This

**This MCP is ONLY for CLI AI agents:**

| CLI AI Agents (✅ Uses This) | IDE Integrations (❌ Does NOT Use This) |
|------------------------------|----------------------------------------|
| **What:** CLI-based AI chat tools | **What:** IDE autocomplete/suggestions |
| **Examples:** Claude Code AI, GitHub Copilot CLI, Opencode, Kilo CLI | **Examples:** GitHub Copilot in VS Code/IDEs |
| **Triggered by:** Questions in chat/terminal | **Triggered by:** Typing in the editor |
| **Uses semantic search:** YES - finds relevant code | **Uses semantic search:** NO - different system |
| **Output:** Search results → AI → Answers | **Output:** Code completions directly |
| **Example:** "Find video player code" → AI searches | **Example:** Type `function` → suggests code |

### Supported CLI AI Agents

**✅ Works with any MCP-compatible CLI AI agent:**
- Claude Code AI
- GitHub Copilot CLI (`gh copilot` command)
- Opencode
- Kilo CLI
- Any other CLI AI agent supporting Model Context Protocol (MCP)

**❌ Does NOT work with:**
- GitHub Copilot in IDE (autocomplete while typing)
- GitHub Copilot Chat in IDE (no MCP support as of 2025)
- Any IDE-embedded autocomplete/suggestion systems

### What to Expect

**Do expect from semantic search:**
- ✅ CLI AI agents find code by intent ("what it does")
- ✅ Better AI answers to "where is..." questions
- ✅ AI understanding of code relationships
- ✅ Faster AI exploration of unfamiliar codebase
- ✅ Works across all MCP-compatible CLI AI agents

**Don't expect from semantic search:**
- ❌ IDE autocomplete improvements
- ❌ Code suggestions while typing
- ❌ Changes to editor typing experience
- ❌ GitHub Copilot Chat (in IDE) using semantic search

### System Separation

```
┌───────────────────────────────────────────────────┐
│              YOUR WORKFLOW                        │
├───────────────────────────────────────────────────┤
│  Ask AI in CLI/Chat    │  Type in Editor          │
│  "Find video code"     │  function validate...    │
│         │              │         │                │
│         ▼              │         ▼                │
│  CLI AI Agents         │  IDE Integrations        │
│  (Any MCP-compatible)  │  (GitHub Copilot IDE)    │
│  Uses Semantic MCP ✅  │  No MCP Support ❌       │
│         │              │         │                │
│         ▼              │         ▼                │
│  Searches .codebase/   │  Suggests completions    │
│  Returns to AI         │  Directly to you         │
│         │              │         │                │
│         ▼              │         ▼                │
│  AI explains to you    │  You accept/reject       │
│                                                    │
│  ← SEPARATE SYSTEMS - DO NOT INTERACT →          │
└───────────────────────────────────────────────────┘
```

---

## 2. 🏗️ ARCHITECTURE AND DATA FLOW

### Purpose and Scope

**This MCP serves CLI AI agents exclusively:**

| Aspect | Details |
|--------|---------|
| **Used by** | Any CLI AI agent with MCP support |
| **Purpose** | Enable AI to search codebase semantically |
| **Benefit** | AI finds code by intent, not keywords |
| **NOT for** | IDE integrations (autocomplete/suggestions) |
| **NOT for** | Developer's direct use in editor |

**Key distinction:** Semantic search helps CLI AI agents help you. It doesn't provide autocomplete while typing.

### Component Stack

**Two main tools:**

1. **codebase-index-cli** - Node.js indexer
   - Creates vector embeddings from code
   - Watches files for real-time updates
   - Stores in SQLite database

2. **semantic-search MCP** - Python MCP server
   - Provides search tools to CLI AI agents
   - Queries vector database
   - Reranks results for relevance

### Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│          CLI AI Agents (Any MCP-compatible)     │
│  "Find code that handles video initialization" │
└───────────────────┬─────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────┐
│          semantic-search MCP Server             │
│  - Converts query to vector (voyage-code-3)     │
│  - Searches SQLite database                     │
│  - Reranks results (voyage-3 judge)             │
└───────────────────┬─────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────┐
│          .codebase/vectors.db                   │
│  - 249 files indexed (496 code blocks)          │
│  - 1024-dimensional vectors                     │
│  - Real-time file watching                      │
└─────────────────────────────────────────────────┘
```

### Data Flow

**Indexing (one-time + real-time updates):**
1. `codesql` watches project files
2. Parses code with tree-sitter (29+ languages)
3. Sends code chunks to Voyage AI API
4. Stores 1024-dim vectors in `.codebase/vectors.db`

**Searching (on-demand):**
1. AI sends natural language query
2. MCP server converts query to vector (Voyage AI)
3. Searches SQLite database for similar vectors
4. Judge model (voyage-3) reranks results
5. Returns relevant code snippets to AI

---

## 3. 🔍 AVAILABLE MCP TOOLS

### Tool 1: `search_codebase`

**Purpose:** Search current project (anobel.com) semantically

**When to use:**
- Finding code by what it does (not what it's called)
- Locating implementation patterns
- Understanding how features work
- Finding related code across files

**Example queries:**
- "Find code that handles video playback initialization"
- "Show me where we validate email addresses in forms"
- "Find the cookie consent modal implementation"
- "Where do we handle page load animations?"
- "Show me the navigation dropdown logic"

**Returns:**
- Relevant code snippets with file paths
- Ranked by relevance (judge model)
- Includes surrounding context

---

### Tool 2: `search_commits`

**Purpose:** Search git commit history semantically

**When to use:**
- Understanding why code was changed
- Finding when features were added
- Locating bug fixes
- Understanding evolution of features

**Example queries:**
- "Find commits related to the contact form"
- "Show changes to the video player"
- "When was the cookie consent added?"
- "What bug fixes were made to the hero animation?"

**Returns:**
- Commit messages and diffs
- Ranked by relevance to query
- Chronological ordering within relevance

---

### Tool 3: `search_other_workspace`

**Purpose:** Search other indexed projects/workspaces

**When to use:**
- Finding similar patterns in other projects
- Reusing code from other projects
- Cross-project comparisons
- Learning from related codebases

**Requirements:**
- Other projects must be indexed with `codesql`
- Workspace path or collection name required

**Example queries:**
- "Find authentication patterns in other projects"
- "Show similar modal implementations"
- "How do other projects handle form validation?"

---

## 4. ✅ USAGE GUIDELINES FOR AI AGENTS

**Reminder:** These guidelines apply to any CLI AI agent with MCP support. This tool is not available to IDE integrations or directly to developers.

### When to Use Semantic Search (DO)

**1. Exploring unfamiliar code:**
```
Query: "Find code that handles form submissions"
Result: Locates form_submission.js with validation logic
```

**2. Understanding features:**
```
Query: "How do we handle video playback?"
Result: Shows hero_video.js initialization and player setup
```

**3. Finding patterns:**
```
Query: "Find all animation configurations"
Result: Discovers Motion.dev usage across components
```

**4. Locating implementations:**
```
Query: "Where do we validate user input?"
Result: Points to form_validation.js and input sanitization
```

**5. Cross-file relationships:**
```
Query: "How does navigation interact with page transitions?"
Result: Shows navigation.js and page transition dependencies
```

### When NOT to Use Semantic Search (DON'T)

**1. You already know the exact file:**
```
❌ Semantic search: "Find hero_video.js content"
✅ Use view tool: view("src/hero/hero_video.js")
```
**Why:** View is faster, no API latency

**2. Looking for specific symbols:**
```
❌ Semantic search: "Find all calls to initVideoPlayer"
✅ Use grep: grep("initVideoPlayer", output_mode="content")
```
**Why:** Literal text matching is more precise

**3. Simple keyword searches:**
```
❌ Semantic search: "Find all TODO comments"
✅ Use grep: grep("TODO:", output_mode="content")
```
**Why:** Keyword search is sufficient

**4. File structure exploration:**
```
❌ Semantic search: "Show me all JavaScript files"
✅ Use glob: glob("**/*.js")
```
**Why:** File navigation doesn't need semantic understanding

### Best Practices

| Practice | Good Example | Bad Example |
|----------|-------------|-------------|
| **Be specific about intent** | "Find code that validates email addresses in contact forms" | "Find email code" |
| **Use natural language** | "Show me where we handle page load errors" | "grep error handler" |
| **Describe what code does** | "Find code that initializes video players on page load" | "Find initVideoPlayer" |
| **Focus on behavior** | "How do we prevent duplicate form submissions?" | "Find form code" |
| **Ask about relationships** | "What code depends on Motion.dev library?" | "Show Motion imports" |

### Workflow Pattern

**Recommended workflow combining tools:**

1. **Discover** with semantic search:
   ```
   search_codebase("Find email validation logic")
   ```

2. **Read** full context with view:
   ```
   view("src/form/form_validation.js")
   ```

3. **Analyze** and make changes:
   ```
   edit(...) or write(...)
   ```

### Trust the Judge Model

**Results are reranked for relevance:**
- Top results are usually most relevant
- Judge model (voyage-3) understands intent
- If results seem off, rephrase query more specifically
- Add context: "in forms" or "for video player"

---

## 5. 📊 DECISION FLOWCHART: WHICH TOOL TO USE

```
Need to find code?
    ↓
Do you know the exact file path?
├─> YES: Use view(path)
│         Fast, no API latency
│
└─> NO: Do you know what the code does?
        ↓
    ├─> YES: Use search_codebase("what it does")
    │         Intent-based discovery
    │
    └─> NO: Is it a literal text/symbol search?
            ↓
        ├─> YES: Use grep("literal text")
        │         Exact keyword matching
        │
        └─> NO: Are you exploring file structure?
                ↓
            ├─> YES: Use glob("**/*.js")
            │         File pattern matching
            │
            └─> Still unsure: Use search_codebase
                              Let intent-based search help discover
```

---

## 6. 🎯 PROJECT-SPECIFIC CONTEXT (ANOBEL.COM)

### Indexed Content

**Current index stats:**
- **Files:** 249 files
- **Code blocks:** 496 chunks
- **Vector dimensions:** 1024
- **Languages:** JavaScript, CSS, HTML, Markdown

**Main directories indexed:**
- `src/2_javascript/` - All JavaScript components
- `src/1_css/` - Styling and animations
- `src/0_html/` - HTML templates
- `.claude/` - Knowledge base and skills

### Common Search Patterns

**Finding components:**
- "Find video player implementation"
- "Show me modal components"
- "Where is the navigation dropdown?"

**Understanding integrations:**
- "How do we use Motion.dev?"
- "Find Webflow-specific code"
- "Show me CDN initialization patterns"

**Locating features:**
- "Find form validation logic"
- "Show me cookie consent implementation"
- "Where do we handle page transitions?"

---

## 7. 📚 REFERENCES AND RESOURCES

### External Documentation

- **Indexer repository:** https://github.com/dudufcb1/codebase-index-cli
- **MCP server repository:** https://github.com/dudufcb1/semantic-search
- **Voyage AI documentation:** https://docs.voyageai.com/
- **Setup guide:** `specs/025-semantic-search-setup/README.md`

### Quick Reference

**Search for code by intent:**
```javascript
search_codebase("Find code that handles video playback")
```

**Search commit history:**
```javascript
search_commits("Find commits related to contact form")
```

**Combine with view for full context:**
```javascript
// 1. Discover
search_codebase("Find email validation")

// 2. Read full file
view("path/from/results.js")

// 3. Analyze and modify
edit(...) or write(...)
```

---

**Core principle:** Semantic search is for understanding, not navigation. Use it to find what you don't know exists. When you know the file path, use view. When you know the exact text, use grep. When you know the intent but not the location, use semantic search.
