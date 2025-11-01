# Serena MCP - Semantic Code Intelligence Tool

Serena provides IDE-like code intelligence through MCP. Use it for symbol-level operations in large, structured codebases—not for simple file reading.

---

## 1. 🎯 WHAT IS SERENA MCP

**Semantic code intelligence using Language Server Protocol (LSP).**

- **Purpose**: Find symbols, trace references, refactor across files
- **How it works**: LSP understands code structure, not just text
- **Languages**: 25+ (TypeScript, JavaScript, Python, Go, Rust, etc.)
- **Context**: Uses `--context ide-assistant` for Claude Code
- **Key benefit**: Token-efficient symbol operations in large codebases

---

## 2. 🧭 WHEN TO USE SERENA

**Quick Decision: Need symbol understanding? >10k LOC? → Use Serena. Otherwise → Use native tools.**

### ✅ Use Serena For:
- Finding where functions/classes are defined or used
- Renaming symbols across multiple files
- Analyzing call hierarchies and dependencies
- Refactoring in codebases >10k LOC
- Cross-file symbol operations

### ❌ Use Native Tools For:
- Reading single files → `Read`
- Text searches → `Grep`
- File discovery → `Glob`
- Creating new code → `Write/Edit`
- Small projects (<5 files)

### Decision Examples:
```
"Find all uses of calculateTotal()" → Serena ✅ (symbol search)
"Search for 'error' in logs" → Grep ❌ (text search)
"Rename userId to customerId everywhere" → Serena ✅ (refactoring)
"Read config.js" → Read ❌ (single file)
```

---

## 3. 🛠️ AVAILABLE TOOLS

**Primary Operations:**

- **`find_symbol`** → Where is X defined?
- **`find_referencing_symbols`** → Where is X used?
- **`insert_after_symbol`** → Add code after X

**What These Tools Do:**
```javascript
find_symbol("calculateTotal")
// Returns: src/utils/billing.js:42

find_referencing_symbols("authMiddleware")
// Returns: All imports, uses, extensions

insert_after_symbol("class User", "newMethod")
// Adds: Code after User class definition
```

**Hook Validation**: PostToolUse hook checks Serena usage and reminds you when simpler tools would suffice.

---

## 4. ✅ BEST PRACTICES

### Initial Setup:
```bash
# Index large projects first (one-time)
serena project index
```

### Configuration (`.serena/project.yml`):
```yaml
include: ["src/**"]
exclude: ["node_modules/**", "dist/**", "*.min.js"]
```

### DO:
- ✅ Index projects >10k LOC before first use
- ✅ Describe intent, not implementation ("rename all user IDs")
- ✅ Check dashboard at `localhost:24282` if issues arise

### DON'T:
- ❌ Use for reading files (overhead not worth it)
- ❌ Force on small projects (<5 files)
- ❌ Expect instant first run (indexing takes 30-60s)

---

## 5. ⚠️ LIMITATIONS & CAVEATS

### Language Support:
**Excellent**: TypeScript, JavaScript, Python, Go, Rust
**Poor**: C/C++ (unreliable references), Java (slow startup)

### Hard Limits:
- **Memory**: ~500MB (medium), >2GB (large projects)
- **Files**: >100k files may fail
- **Speed**: First run takes 30-60s for indexing
- **Dynamic code**: Can't understand runtime-generated code

### Common Failures:
```
Symbol not found → Re-index: serena project index
Slow performance → Exclude more dirs in .serena/project.yml
Wrong results → Check language has good LSP support
```

---

## 6. 📋 EXAMPLES

### Finding Definitions:
```bash
# Serena (1 precise command):
serena.find_symbol("calculateTotal")
→ src/utils/billing.js:42

# Native (multiple searches, may miss):
grep -r "function calculateTotal" .
grep -r "const calculateTotal" .
grep -r "calculateTotal.*=" .
```

### Refactoring:
```bash
# Serena (understands context):
serena.find_referencing_symbols("userId")
→ All actual uses, no false positives

# Native (includes comments/strings):
grep -r "userId" .
→ Includes comments, strings, false matches
```

### Hook Feedback:
When you use Serena, the hook reminds you:
- Is project indexed?
- Is it >10k LOC?
- Could Read/Grep work instead?

---

## 7. 🔍 TROUBLESHOOTING

**Quick Fixes:**

| Problem | Solution |
|---------|----------|
| Serena won't start | Check uvx installed: `which uvx` |
| Symbols not found | Re-index: `serena project index` |
| Too slow | Exclude more in `.serena/project.yml` |
| False suggestions | <10k LOC? Use Read/Grep instead |

**Debug Steps:**
1. Check dashboard: `http://localhost:24282`
2. Verify language supported (TypeScript/JS best)
3. First run always slow (30-60s indexing)

---

**Remember**: Serena MCP is powerful for symbol-level operations in large codebases, but it's overkill for simple tasks. Always ask yourself: "Do I need semantic understanding or just file content?" If it's just content, use Read/Grep/Glob. Save Serena for when you truly need IDE-like intelligence—refactoring, finding all references, or navigating complex dependencies. The best tool is the simplest one that gets the job done!
