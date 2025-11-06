# Quality Check Logs - PostToolUse Hook Output

Logs from the PostToolUse hook that monitors code quality patterns and provides reminders after file edits.

---

## 1. 📋 OVERVIEW

### Files in This Directory

- **`quality-checks.log`** - Quality check reminders triggered after file edits

### Purpose

The PostToolUse hook scans edited files for common patterns and logs relevant quality check reminders with timestamps and file paths.

---

## 2. 🚀 USAGE

### View All Logs
```bash
cat .claude/logs/quality-checks.log
```

### View Recent Logs (Last 30 Lines)
```bash
tail -30 .claude/logs/quality-checks.log
```

### Monitor Logs in Real-Time
```bash
tail -f .claude/logs/quality-checks.log
```

Press `Ctrl+C` to stop monitoring.

### Search Logs by Pattern
```bash
grep "ASYNC CHECK" .claude/logs/quality-checks.log
```

### View Logs by Date
```bash
grep "2025-11-06" .claude/logs/quality-checks.log
```

---

## 3. 📊 LOG FORMAT

### Entry Structure

Each entry includes:
- **Timestamp**: When the check occurred
- **File Path**: Which file triggered the reminders
- **Quality Checks**: List of relevant reminders for detected patterns

### Example Entry
```
───────────────────────────────────────────────────────────────
[2025-11-06 09:29:40] File: /path/to/file.js
───────────────────────────────────────────────────────────────
✅ ASYNC CHECK:
- Error handling with try-catch?
- Loading states managed?
- Timeout handling present?
- Network failure scenarios covered?
───────────────────────────────────────────────────────────────
```

---

## 4. 🔍 PATTERN DETECTION

The PostToolUse hook detects these patterns:

1. **Async Operations** - `async`, `await`, `fetch`, `Promise`
2. **Animation Code** - `Motion.`, `animate()`, `timeline()`
3. **Initialization** - `INIT_FLAG`, `DOMContentLoaded`
4. **Form Handling** - `form.`, `submit`, `preventDefault`
5. **Commit Operations** - `git commit`, `git add`
6. **Serena MCP** - `find_symbol`, `find_referencing_symbols`

---

## 5. 🛠️ MAINTENANCE

### Clear All Logs
```bash
> .claude/logs/quality-checks.log
```

### Keep Only Recent Logs
```bash
tail -100 .claude/logs/quality-checks.log > /tmp/recent.log
mv /tmp/recent.log .claude/logs/quality-checks.log
```

Logs append indefinitely, so periodic cleanup keeps file size manageable.

---

## 6. ⚙️ CONFIGURATION

**Hook configuration**: `.claude/settings.local.json`
**Hook script**: `.claude/scripts/validate-post-response.sh`
**Pattern rules**: `.claude/scripts/skill-rules.json`