# Semantic Search MCP - Usage Guide

The anobel.com project uses semantic code search capabilities through two integrated tools that enable AI-powered codebase exploration using natural language queries instead of keyword searches.

**⚠️ IMPORTANT:**
- This MCP is for **CLI AI Agents** (not IDE integrations) that support MCP.
- It works with **any CLI AI agent** including Claude Code AI, GitHub Copilot CLI, Opencode, Kilo CLI, and others.

#### 📋 TABLE OF CONTENTS

1. [⚠️ SCOPE: CLI AI AGENTS ONLY](#1-️-scope-cli-ai-agents-only)
2. [🏗️ ARCHITECTURE](#2-️-architecture)
3. [🔍 AVAILABLE MCP TOOLS](#4--available-mcp-tools)
4. [✅ USAGE GUIDELINES FOR AI](#5--usage-guidelines-for-ai)
5. [🎯 ANOBEL.COM SPECIFIC CONTEXT](#6--anobelcom-specific-context)
6. [📚 REFERENCES](#9--references)

---

## 1. ⚠️ SCOPE: CLI AI AGENTS ONLY

### What This MCP Is For

**This semantic search MCP works with CLI AI agents that support MCP (Model Context Protocol):**

| Aspect | CLI AI Agents (✅ Uses This MCP) | IDE Integrations (❌ Does NOT Use This) |
|--------|----------------------------------|----------------------------------------|
| **What it is** | CLI-based AI chat tools | IDE autocomplete/code suggestions |
| **Examples** | Claude Code AI, GitHub Copilot CLI | GitHub Copilot in VS Code/IDEs |
| **Triggered by** | You asking questions in chat/terminal | You typing in the editor |
| **Uses semantic search** | ✅ YES - to find relevant code | ❌ NO - uses different system |
| **Output** | Search results → AI → Answers you | Code completions directly to you |
| **Example** | "Find video player code" → AI searches | You type `function` → suggests code |

### Supported CLI AI Agents

**✅ Works with any CLI AI agent that supports MCP:**
- **Claude Code AI** - AI assistant in VS Code/Cursor
- **GitHub Copilot CLI** - `gh copilot` command-line tool
- **Opencode** - Open-source AI coding assistant
- **Kilo CLI** - Command-line AI assistant
- **Any other CLI AI agent** that supports the Model Context Protocol (MCP)

**❌ Does NOT work with:**
- **GitHub Copilot in IDE** - Autocomplete while typing in VS Code/IDEs
- **GitHub Copilot Chat in IDE** - Currently doesn't support MCP (as of 2025)

### Why This Matters

**Don't expect:**
- ❌ IDE autocomplete improvements from this MCP
- ❌ Code suggestions while typing based on vector embeddings
- ❌ Any changes to your typing experience in the editor
- ❌ GitHub Copilot Chat (in IDE) to use semantic search

**Do expect:**
- ✅ Any CLI AI agent to find code by intent
- ✅ Better AI answers to "where is..." questions
- ✅ AI understanding of code relationships
- ✅ Faster AI exploration of codebase
- ✅ Works with Claude Code AI, GitHub Copilot CLI, Opencode, Kilo CLI, and others

### System Separation

```
┌─────────────────────────────────────────────────────────────┐
│                    YOUR WORKFLOW                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Ask AI in CLI/Chat          │  Type in Editor             │
│  "Find video code"           │  function validate...       │
│         │                    │         │                   │
│         ▼                    │         ▼                   │
│  CLI AI Agents               │  IDE Integrations           │
│  (Any MCP-compatible agent)  │  (GitHub Copilot IDE)       │
│  Uses Semantic Search MCP ✅ │  No MCP Support ❌          │
│         │                    │         │                   │
│         ▼                    │         ▼                   │
│  Searches .codebase/         │  Suggests completions       │
│  Returns results to AI       │  Directly to you            │
│         │                    │         │                   │
│         ▼                    │         ▼                   │
│  AI explains code to you     │  You accept/reject          │
│                                                             │
│  ← SEPARATE SYSTEMS - DO NOT INTERACT →                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. 🏗️ ARCHITECTURE

### Purpose and Scope

**This MCP is for CLI AI agents:**
- ✅ **Used by:** Any CLI AI agent that supports MCP (Claude Code AI, GitHub Copilot CLI, Opencode, Kilo CLI, etc.)
- ✅ **Purpose:** Enable AI to search codebase semantically
- ✅ **Benefit:** AI finds code by intent, not keywords
- ❌ **NOT for:** IDE integrations (autocomplete/suggestions)
- ❌ **NOT for:** Developer's direct use in editor

**Key distinction:** Semantic search helps CLI AI agents help you. It doesn't provide autocomplete or suggestions while you type.

### Components Overview

**Tools involved:**
1. **codebase-index-cli** - Node.js indexer that creates vector embeddings
2. **semantic-search MCP** - Python MCP server that provides search tools to CLI AI agents

```
┌─────────────────────────────────────────────────────────────┐
│                  CLI AI Agents                              │
│  - Any MCP-compatible CLI AI agent                          │
│  - Claude Code AI, GitHub Copilot CLI, Opencode, Kilo, etc. │
│  "Find code that handles video playback initialization"    │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              semantic-search MCP Server                     │
│  - Converts query to vector (voyage-code-3)                 │
│  - Searches SQLite database                                 │
│  - Reranks results (voyage-3 judge)                         │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              .codebase/vectors.db                           │
│  - 249 files indexed (496 code blocks)                      │
│  - 1024-dimensional vectors                                 │
│  - Real-time file watching                                  │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

1. **Indexing** (one-time, then real-time updates):
   - `codesql` watches project files
   - Parses code with tree-sitter (29+ languages)
   - Sends code chunks to Voyage AI API
   - Stores vectors in `.codebase/vectors.db`

2. **Searching** (on-demand):
   - AI sends natural language query
   - MCP server converts query to vector (Voyage AI)
   - Searches SQLite database for similar vectors
   - Judge model (voyage-3) reranks results
   - Returns relevant code snippets to AI

---

## 3. 🔍 AVAILABLE MCP TOOLS

### 1. `search_codebase`
**Purpose:** Search the current project (anobel.com) semantically

**When to use:**
- Finding code by what it does, not what it's called
- Locating implementation patterns
- Understanding how features work
- Finding related code across files

**Example queries:**
- "Find code that handles video playback initialization"
- "Show me where we validate email addresses in forms"
- "Find the cookie consent modal implementation"
- "Where do we handle page load animations?"
- "Show me the navigation dropdown logic"

### 2. `search_commits`
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

### 3. `search_other_workspace`
**Purpose:** Search other indexed projects/workspaces

**When to use:**
- Finding similar patterns in other projects
- Reusing code from other projects
- Cross-project comparisons

**Note:** Only works if other projects are indexed with `codesql`

---

## 4. ✅ USAGE GUIDELINES

**Reminder:** These guidelines are for any CLI AI agent that supports MCP (Claude Code AI, GitHub Copilot CLI, Opencode, Kilo CLI, etc.). This tool is not available to IDE integrations or directly to developers.

### ✅ DO: Use Semantic Search When

1. **Exploring unfamiliar code:**
   - "Find code that handles form submissions"
   - "Show me where we initialize the page loader"

2. **Understanding features:**
   - "How do we handle video playback?"
   - "Where is the language selection implemented?"

3. **Finding patterns:**
   - "Find all animation configurations"
   - "Show me where we use GSAP animations"

4. **Locating implementations:**
   - "Where do we validate user input?"
   - "Find the modal initialization code"

5. **Cross-file relationships:**
   - "How does the navigation interact with page transitions?"
   - "Find code that depends on the video player"

### ❌ DON'T: Use Semantic Search When

1. **You already know the exact file:**
   - Use `view` tool instead
   - Semantic search adds unnecessary latency

2. **Looking for specific symbols:**
   - Use `view` with `search_query_regex` for exact matches
   - Example: Finding all calls to `initVideoPlayer()`

3. **Simple keyword searches:**
   - Use `view` with regex for literal text
   - Example: Finding all TODO comments

4. **File structure exploration:**
   - Use `view` on directories
   - Semantic search is for code understanding, not navigation

### 🎯 Best Practices

1. **Be specific about intent:**
   - ✅ "Find code that validates email addresses in contact forms"
   - ❌ "Find email code"

2. **Use natural language:**
   - ✅ "Show me where we handle page load errors"
   - ❌ "grep error handler"

3. **Describe what code does:**
   - ✅ "Find code that initializes video players on page load"
   - ❌ "Find initVideoPlayer"

4. **Combine with other tools:**
   - Use semantic search to find relevant files
   - Then use `view` to read the full context
   - Then use `codebase-retrieval` for detailed analysis

5. **Trust the judge model:**
   - Results are reranked by voyage-3 for relevance
   - Top results are usually most relevant
   - If results seem off, rephrase the query

---

## 5. 📚 REFERENCES

### External Resources

- **Indexer repo:** https://github.com/dudufcb1/codebase-index-cli
- **MCP server repo:** https://github.com/dudufcb1/semantic-search
- **Voyage AI docs:** https://docs.voyageai.com/
- **Setup documentation:** `specs/025-semantic-search-setup/README.md`

### Quick Reference

**Search for code by intent:**
```
search_codebase("Find code that handles video playback")
```

**Search commit history:**
```
search_commits("Find commits related to contact form")
```

**Combine with view for full context:**
```
1. search_codebase("Find email validation")
2. view(path="path/from/results.js")
3. Analyze and make changes
```

---

**Remember:** Semantic search is for understanding, not navigation. Use it to find what you don't know exists!