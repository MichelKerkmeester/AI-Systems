# Claude-Mem - Persistent Memory System

Provides persistent memory across Claude Code sessions through automatic context capture, AI-powered compression, and intelligent retrieval. Seven specialized search tools enable querying historical observations, summaries, and decisions.

---

## 1. 🎯 CORE FEATURES

### Automatic Context Injection

Context from the previous 10 sessions appears automatically at session start. No manual retrieval needed.

```
# [claude-mem] recent context

[Compressed summaries from previous sessions]
```

### AI-Powered Compression

Worker service continuously processes observations in the background:
- Compresses raw observations into searchable summaries
- Uses Claude Sonnet 4.5 for intelligent context extraction
- Stores in SQLite database with FTS5 full-text indexing
- Generates layered information: Index → Details → Full recall

### Token Cost Visibility

Context injection displays token usage for informed decision-making:
```
Context loaded: 2,456 tokens from 3 sessions
```

### Multi-Session Persistence

Memory persists through:
- `/clear` commands (context preserved)
- Claude Code restarts
- Multiple concurrent projects
- Days or weeks between sessions

### Multi-Project Support

The single-worker setup automatically handles multiple projects:
- Context is captured across all projects you work on
- Project-specific context is weighted higher when relevant
- Database stores observations from all projects
- Intelligent filtering ensures relevant context injection

---

## 2. 🔍 SEARCH CAPABILITIES

### Seven Specialized Tools

Access via MCP tools (prefix: `mcp__claude-mem__*`):

| Tool | Purpose | Use Case |
|------|---------|----------|
| **Full-Text Search** | Search all observations and summaries | Find references to specific features or bugs |
| **Concept Search** | Query by concepts and ideas | Locate architectural decisions or patterns |
| **File-Based Search** | Search within specific files | Find all changes to particular components |
| **Type-Based Search** | Filter by observation types | Get all decisions, bugfixes, or features |
| **Recent Context** | Get most recent observations | Quick access to latest work |
| **Session Summaries** | Access compressed session summaries | Review high-level overview of past sessions |
| **User Prompts** | Search historical user requests | Find previous similar questions |

### Citation Links

Navigate directly to specific observations using `claude-mem://` URIs:

```
claude-mem://observation/abc123
claude-mem://summary/xyz789
```

### Search Examples

```javascript
// Search for API implementation decisions
mcp__claude-mem__search({ query: "API authentication decision", type: "concept" })

// Find recent file changes
mcp__claude-mem__search({ file: "src/auth/login.js", limit: 10 })

// Get all bugfixes from last week
mcp__claude-mem__search({ type: "bugfix", timeframe: "7d" })
```

---

## 3. 🛠️ WORKER MANAGEMENT

### Check Service Status

```bash
cd "/Users/michelkerkmeester/MEGA/MCP Servers/claude-mem"
npx pm2 list
```

Output shows:
- Process ID
- Status (online/stopped)
- CPU and memory usage
- Uptime

### View Real-Time Logs

```bash
npm run worker:logs
```

Monitor:
- Context processing activity
- Compression operations
- Errors or warnings
- API calls to Claude

### Restart Worker

```bash
npm run worker:restart
```

Use when:
- Configuration changes applied
- Worker becomes unresponsive
- Memory usage grows too high

### Stop Worker

```bash
npm run worker:stop
```

Stops background processing. Memory capture pauses until restart.

### Start Worker

```bash
npm run worker:start
```

Launches worker if stopped. Required for memory capture to function.

### Health Check

```bash
curl http://localhost:37777/health
```

Response: `{"status":"ok"}` indicates worker is operational.

---

## 4. ⚙️ CONFIGURATION OPTIONS

### Change AI Model

Edit `.claude/settings.json` or use environment variables:

```json
{
  "enabledPlugins": {
    "claude-mem@thedotmack": true
  }
}
```

Available models via environment:
- `CLAUDE_MEM_MODEL=claude-sonnet-4-5` (default, balanced)
- `CLAUDE_MEM_MODEL=claude-opus-4` (highest quality, slower)
- `CLAUDE_MEM_MODEL=claude-haiku-4` (fastest, lower cost)

### Adjust Hook Timeouts

Edit `.claude/settings.local.json`:

```json
{
  "hooks": {
    "SessionStart": {
      "timeout": 300000  // 5 minutes in milliseconds
    },
    "PostToolUse": {
      "timeout": 120000  // 2 minutes
    }
  }
}
```

Increase timeouts if:
- Large context requires more processing time
- Network latency to Claude API is high
- Worker logs show timeout warnings

### Environment Variables

Set in shell or configuration:

```bash
export CLAUDE_MEM_MODEL="claude-sonnet-4-5"
export CLAUDE_MEM_WORKER_PORT="37777"
```

---

## 5. 📊 UNDERSTANDING MEMORY CAPTURE

### Lifecycle Hooks

Five hooks capture different aspects of sessions:

| Hook | Trigger | Captures |
|------|---------|----------|
| **SessionStart** | New session begins | Retrieves and injects context |
| **UserPromptSubmit** | User sends message | Records user prompts |
| **PostToolUse** | Tool completes | Captures tool observations |
| **Stop** | Intermediate processing | Generates session summaries |
| **SessionEnd** | Session terminates | Creates final summary |

### What Gets Captured

**Observations**:
- Tool calls and results
- File reads, edits, writes
- Command executions
- Search queries and findings

**Summaries**:
- Session objectives
- Key decisions made
- Problems solved
- Code changes overview

**Prompts**:
- User questions
- Feature requests
- Bug reports
- Clarifications

### Database Structure

Located at `~/.claude-mem/claude-mem.db`:

```
observations    → Raw tool captures
summaries       → AI-compressed context
sessions        → Session metadata
prompts         → User requests
fts_index       → Full-text search index
```

---

## 6. 🚀 USAGE PATTERNS

### Passive Memory (Default)

Let Claude-Mem work automatically:
- Context appears at session start
- Observations captured during work
- No manual intervention needed

### Active Search

Query specific information when needed:

```bash
# Ask Claude to search memory
"Search our previous discussions about authentication"

# Use MCP tools directly
mcp__claude-mem__search({ query: "authentication", type: "concept" })
```

### Context-Aware Development

Reference previous decisions:

```
"What did we decide about the API structure?"
"Show me the bugfix we implemented last week"
"Find all changes to the user model"
```

### Cross-Project Learning

Memory persists across projects:
- Patterns learned in one project available in others
- Solutions to common problems remembered
- Coding preferences maintained

---

## 7. 🔧 TROUBLESHOOTING COMMANDS

### Context Not Appearing

```bash
# 1. Check worker is running
npx pm2 list

# 2. Verify worker health
curl http://localhost:37777/health

# 3. Check worker logs for errors
npm run worker:logs

# 4. Restart worker if needed
npm run worker:restart
```

### Search Not Working

```bash
# 1. Verify plugin is enabled
cat ~/.claude/settings.json | grep "claude-mem"

# 2. Check database exists
ls -lh ~/.claude-mem/claude-mem.db

# 3. Test database integrity
sqlite3 ~/.claude-mem/claude-mem.db "PRAGMA integrity_check;"

# 4. Restart Claude Code
```

### Worker Performance Issues

```bash
# Check resource usage
npx pm2 show claude-mem-worker

# View detailed logs
npm run worker:logs | grep -E "error|warn|slow"

# Restart with fresh state
npm run worker:restart
```

### Database Maintenance

```bash
# Check database size
du -sh ~/.claude-mem/

# Compact database (if large)
sqlite3 ~/.claude-mem/claude-mem.db "VACUUM;"

# Rebuild search index
sqlite3 ~/.claude-mem/claude-mem.db "REINDEX;"
```

### Hook Timeout Issues

```bash
# Check hook execution time
# Look for timeout warnings in Claude Code output

# Increase timeout in .claude/settings.local.json
# SessionStart: 300000 (5 minutes)
# Others: 120000 (2 minutes)
```

---

## 8. 📈 ADVANCED CAPABILITIES

### Layered Retrieval

Context injection uses three-tier approach:

1. **Index Level**: Quick overview, minimal tokens
2. **Details Level**: More context when relevant
3. **Full Recall**: Complete information when needed

### Intelligent Filtering

Context injection only includes relevant information:
- Recent sessions prioritized
- Similar topics weighted higher
- Unrelated work filtered out
- Token budget optimized automatically

### Multi-Project Awareness

Automatically distinguishes between projects:
- Project-specific context emphasized
- Cross-project patterns available
- Working directory tracked
- File paths used for context

### Continuous Learning

Memory improves over time:
- Common patterns identified
- Frequently accessed information prioritized
- Compression quality increases
- Search relevance improves

---

## 9. 🎯 USE CASES

### Bug Investigation

```
"Search for similar errors we've seen before"
"Find previous solutions to authentication failures"
"Show all bugfixes related to the payment system"
```

### Feature Development

```
"What patterns did we use for the user dashboard?"
"Find the implementation approach from the last feature"
"Show architectural decisions for API endpoints"
```

### Code Review

```
"Why did we choose this approach?"
"Find the discussion about error handling strategy"
"Show the rationale behind this component structure"
```

### Onboarding & Context

```
"Summarize recent work on the admin panel"
"What decisions were made about database schema?"
"Overview of authentication implementation"
```

### Debugging Patterns

```
"Have we seen this error before?"
"Find similar issues and their solutions"
"What fixed the performance problem last time?"
```

---

## 10. 🏎️ QUICK REFERENCE

### Essential Commands

| Command | Purpose |
|---------|---------|
| `npx pm2 list` | Check worker status |
| `npm run worker:logs` | View activity logs |
| `npm run worker:restart` | Restart background service |
| `curl http://localhost:37777/health` | Verify worker health |
| `du -sh ~/.claude-mem/` | Check database size |

### Configuration Files

| File | Contains |
|------|----------|
| `~/.claude/settings.json` | Plugin enable/disable |
| `~/.claude-mem/claude-mem.db` | SQLite database with all observations |

### Key Locations

| Location | Purpose |
|----------|---------|
| `/Users/michelkerkmeester/MEGA/MCP Servers/claude-mem` | Installation directory |
| `~/.claude-mem/` | Data directory and database |
| `http://localhost:37777` | Worker HTTP API endpoint |
| `~/.claude/settings.json` | Claude Code plugin settings |
| `~/.pm2/dump.pm2` | PM2 saved process list |

### Auto-Start Configuration

**Enable auto-start on system boot:**
```bash
cd "/Users/michelkerkmeester/MEGA/MCP Servers/claude-mem"
./setup-autostart.sh
```

**Disable auto-start:**
```bash
npx pm2 unstartup launchd
```

---

**Reference**: GitHub: https://github.com/thedotmack/claude-mem