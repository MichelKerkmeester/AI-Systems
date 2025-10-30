# Webflow Debugging — Quick Guide

Focused, practical debugging for Webflow projects using platform-specific checks and browser automation tools.

Concise Webflow debugging playbook. Use these checks first, then apply browser automation workflows (console, network, performance, snapshots) for evidence-based diagnosis. See also: [../z_prompts/code_debugger.yaml](../z_prompts/code_debugger.yaml).

---

## 1. 🚨 FOR CLAUDE USERS: USE THE CHROME DEVTOOLS SKILL

**Claude has access to the comprehensive Chrome DevTools skill with 16 automation scripts for debugging and performance analysis.**

**Skill Location:** `.claude/skills/chrome-devtools/`

**To use the skill in your conversation:**
```
Use the Chrome DevTools skill to debug https://example.com
```

**The skill provides 16 specialized scripts:**

**Multi-Page Management:**
- `pages.js` - Manage multiple browser pages/tabs (list, create, switch, close)

**Element Interaction:**
- `click.js` - Click elements
- `fill.js` - Fill form fields
- `hover.js` - Hover over elements (trigger :hover states, dropdowns)
- `drag.js` - Drag and drop elements

**Analysis & Monitoring:**
- `snapshot.js` - Extract interactive elements with XPath and position data
- `console.js` - Monitor console messages/errors
- `network.js` - Track HTTP requests/responses
- `performance.js` - Measure Core Web Vitals + record traces

**Visual Capture:**
- `screenshot.js` - Capture screenshots (full page or element)

**Device Emulation:**
- `emulate-network.js` - Network throttling (Offline, Slow 3G, Fast 3G, Slow 4G, Fast 4G)
- `emulate-cpu.js` - CPU throttling (1-20x slowdown for performance testing)

**File Operations:**
- `upload.js` - Upload files via file inputs

**Dialog Control:**
- `dialog.js` - Handle JavaScript alerts/confirms/prompts

**Navigation:**
- `navigate.js` - Navigate to URLs
- `evaluate.js` - Execute JavaScript in page context

**For complete documentation:** See `.claude/skills/chrome-devtools/SKILL.md`

**Example workflow:**
```
Use the Chrome DevTools skill:
1. Navigate to https://example.com
2. Check console errors
3. Take a snapshot to find element selectors
4. Run performance analysis
```

---

## 2. 📖 FOR OTHER AI ASSISTANTS (GPT/CODEX)

If you don't have access to Claude skills, use one of these approaches:

### **Option 1: MCP Tools (Interactive Sessions)**

If you have MCP access, use these tools directly in the conversation:

**Available Tools:**
- `mcp__chrome-devtools__navigate_page(url)`
- `mcp__chrome-devtools__take_snapshot()` - Get page elements with UIDs
- `mcp__chrome-devtools__take_screenshot({ fullPage: true })`
- `mcp__chrome-devtools__list_console_messages({ types: ['error', 'warn'] })`
- `mcp__chrome-devtools__list_network_requests({ resourceTypes: ['xhr', 'fetch'] })`
- `mcp__chrome-devtools__performance_start_trace({ reload: true, autoStop: true })`
- `mcp__chrome-devtools__evaluate_script({ function: '() => document.title' })`
- `mcp__chrome-devtools__click({ uid: 'element-uid' })`
- `mcp__chrome-devtools__fill({ uid: 'input-uid', value: 'text' })`
- `mcp__chrome-devtools__list_pages()`
- `mcp__chrome-devtools__new_page({ url: 'https://example.com' })`
- `mcp__chrome-devtools__emulate_network({ throttlingOption: 'Slow 3G' })`
- `mcp__chrome-devtools__emulate_cpu({ throttlingRate: 4 })`

**Multiple instances available:** `mcp__chrome-devtools__*` (default), `-2`, `-3`, `-4`
- Each can run with `--isolated` flag to prevent session interference
- If conflicts occur, try alternate instances

### **Option 2: CLI Scripts (Automation/CI/CD)**

Run Puppeteer scripts directly from the command line:

```bash
cd .claude/skills/chrome-devtools/scripts

# Navigate and check console
node navigate.js --url https://example.com --close false
node console.js --types error,warn | jq '.messages'

# Performance analysis
node performance.js --url https://example.com | jq '.vitals'

# Network monitoring
node network.js --url https://example.com --types xhr,fetch | jq '.requests'

# Take snapshot for element discovery
node snapshot.js --url https://example.com --output snapshot.json

# Device emulation
node emulate-network.js --profile "Slow 3G" --close false
node emulate-cpu.js --rate 4 --close false
node navigate.js --url https://example.com
```

**See documentation:** `.claude/skills/chrome-devtools/scripts/README.md`

### **Option 3: Static Analysis (Fallback)**

If browser automation is unavailable, use static code analysis:
- **Read** tool for file contents
- **Grep** tool for pattern searching
- **Glob** tool for file discovery
- Infer behavior from code structure
- **Important:** Document assumptions and analysis limitations clearly

---

## 3. 🔍 WEBFLOW-SPECIFIC CHECKS (90-SECOND SWEEP)

- Webflow loaded: `!!window.Webflow`
- Interactions queued: `Array.isArray(window.Webflow?.push)`
- Collections present: `document.querySelectorAll('.w-dyn-item').length`
- Editor mode: `!!document.querySelector('.w-editor')`
- Locale: `document.documentElement.lang || 'default'`
- Timing: If collections are 0 on DOMContentLoaded, retry after 500ms (render async)

Helper (optional):
```javascript
(() => {
  console.group('🔍 Webflow Sweep');
  console.log('Webflow:', !!window.Webflow);
  console.log('Push queue:', Array.isArray(window.Webflow?.push));
  console.log('Collections (items):', document.querySelectorAll('.w-dyn-item').length);
  console.log('Editor mode:', !!document.querySelector('.w-editor'));
  console.log('Locale:', document.documentElement.lang || 'default');
  console.groupEnd();
})();
```

---

## 4. 🧰 BROWSER AUTOMATION APPROACH SELECTION

Choose the right tool for your environment:

### **For Claude: Use the Chrome DevTools Skill**
The skill provides unified access to all 16 scripts with guided workflows. Simply invoke the skill in your conversation and Claude will guide you through the debugging process.

### **For Interactive Sessions: Use MCP Tools**
- **Available:** `mcp__chrome-devtools__*` (instances: default, -2, -3, -4)
- **Why multiple instances:** Each can run isolated to prevent conflicts
- **Common functions:** navigate_page, take_snapshot, evaluate_script, list_console_messages, performance_start_trace
- **Best for:** Interactive debugging in conversation with AI assistant

### **For CI/CD & Automation: Use CLI Scripts**
- **Location:** `.claude/skills/chrome-devtools/scripts/`
- **Scriptable:** Via Bash with `--close false` for chaining
- **JSON output:** Easy parsing with `jq`
- **Best for:** Automated testing, CI pipelines, cron jobs, batch processing

### **Fallback: Playwright MCP**
- **Use when:** Chrome DevTools unavailable or fails repeatedly
- **Available functions:** `mcp__playwright__*`
- **Functions:** `playwright_navigate`, `playwright_evaluate`, `playwright_get_visible_html`
- **Benefits:** Similar automation with different architecture

### **Final Fallback: Static Analysis**
- **Use when:** Both browser automation MCPs fail or unavailable
- **Method:** Static analysis using Read, Grep, Glob tools
- **Approach:** Infer behavior from code structure and configuration
- **Important:** Document assumptions and analysis limitations clearly

**Best Practice:** When browser automation is needed alongside manual development browsing, use an isolated Chrome DevTools instance to prevent conflicts.

---

## 5. 🔧 COMMON DEBUGGING WORKFLOWS

### **5.1 Console Errors**

**Claude Skill:**
```
Use Chrome DevTools skill to check console errors on https://example.com
```

**MCP (Interactive):**
```javascript
mcp__chrome-devtools__navigate_page({ url: 'https://example.com' })
mcp__chrome-devtools__list_console_messages({ types: ['error', 'warn'] })
```

**CLI (Automation):**
```bash
node console.js --url https://example.com --types error,warn | jq '.messages'
```

### **5.2 Network Issues**

**Claude Skill:**
```
Use Chrome DevTools skill to monitor network requests on https://example.com
```

**MCP (Interactive):**
```javascript
mcp__chrome-devtools__navigate_page({ url: 'https://example.com' })
mcp__chrome-devtools__list_network_requests({ resourceTypes: ['xhr', 'fetch'] })
```

**CLI (Automation):**
```bash
node network.js --url https://example.com --types xhr,fetch | jq '.requests[] | {url, status, time}'
```

### **5.3 Performance Analysis**

**Claude Skill:**
```
Use Chrome DevTools skill to analyze performance of https://example.com
```

**MCP (Interactive):**
```javascript
mcp__chrome-devtools__navigate_page({ url: 'https://example.com' })
mcp__chrome-devtools__performance_start_trace({ reload: true, autoStop: true })
mcp__chrome-devtools__performance_analyze_insight({ insightName: 'LCPBreakdown' })
```

**CLI (Automation):**
```bash
node performance.js --url https://example.com | jq '.vitals'
```

### **5.4 Element Discovery**

**Claude Skill:**
```
Use Chrome DevTools skill to take a snapshot of https://example.com and find element selectors
```

**MCP (Interactive):**
```javascript
mcp__chrome-devtools__navigate_page({ url: 'https://example.com' })
mcp__chrome-devtools__take_snapshot()
```

**CLI (Automation):**
```bash
node snapshot.js --url https://example.com | jq '.elements[] | {tagName, text, selector, xpath}'
```

### **5.5 Multi-Page Testing** (Claude Skill / CLI Only)

**Claude Skill:**
```
Use Chrome DevTools skill to open multiple pages and test interaction between them
```

**CLI (Automation):**
```bash
node pages.js --action new --url https://example.com/page1 --close false
node pages.js --action new --url https://example.com/page2 --close false
node pages.js --action list
node pages.js --action switch --index 0 --close false
node click.js --selector ".button"
```

**MCP (Interactive):**
```javascript
mcp__chrome-devtools__new_page({ url: 'https://example.com/page1' })
mcp__chrome-devtools__new_page({ url: 'https://example.com/page2' })
mcp__chrome-devtools__list_pages()
mcp__chrome-devtools__select_page({ pageIdx: 0 })
```

### **5.6 Device Emulation** (Claude Skill / CLI Only)

**Claude Skill:**
```
Use Chrome DevTools skill to test https://example.com on slow 3G with CPU throttling
```

**CLI (Automation):**
```bash
node emulate-network.js --profile "Slow 3G" --close false
node emulate-cpu.js --rate 4 --close false
node navigate.js --url https://example.com --close false
node performance.js | jq '.vitals.LCP'
```

**MCP (Interactive):**
```javascript
mcp__chrome-devtools__emulate_network({ throttlingOption: 'Slow 3G' })
mcp__chrome-devtools__emulate_cpu({ throttlingRate: 4 })
mcp__chrome-devtools__navigate_page({ url: 'https://example.com' })
mcp__chrome-devtools__performance_start_trace({ reload: true, autoStop: true })
```

---

## 6. 🐛 COMMON WEBFLOW ROOT CAUSES → CHECKS

- Collections empty intermittently
  - Cause: Async render delay
  - Check: Retry after 500ms or observe DOM mutations

- Interactions don't fire
  - Cause: Not queued with Webflow.push; element missing
  - Check: Verify `window.Webflow?.push`, confirm target exists

- Duplicate IDs break selectors
  - Cause: Collection items duplicate IDs by design
  - Check: Use classes or data-attributes + event delegation

- Form success/error blocks missing
  - Cause: Not wrapped in `.w-form`
  - Check: `form.closest('.w-form')`

---

## 7. 🧪 MINIMAL HELPERS (OPTIONAL)

- Collections quick view
```javascript
(() => {
  const lists = document.querySelectorAll('.w-dyn-list');
  console.table(Array.from(lists).map((l,i)=>({
    list: i+1,
    items: l.querySelectorAll('.w-dyn-item').length,
    nested: l.querySelectorAll('.w-dyn-list').length
  })));
})();
```

- Breakpoints snapshot
```javascript
(() => {
  const bps = [
    { name: 'Desktop', width: 992 },
    { name: 'Tablet', width: 991 },
    { name: 'Mobile Landscape', width: 767 },
    { name: 'Mobile Portrait', width: 478 }
  ];
  console.table(bps.map(bp=>({ name: bp.name, active: innerWidth>=bp.width })));
})();
```

---

## 8. 🔗 REFERENCES

### **For Claude Users:**
- **Chrome DevTools Skill:** `.claude/skills/chrome-devtools/SKILL.md`
- **Scripts Documentation:** `.claude/skills/chrome-devtools/scripts/README.md`
- **Puppeteer Reference:** `.claude/skills/chrome-devtools/references/puppeteer-reference.md`
- **CDP Domains Reference:** `.claude/skills/chrome-devtools/references/cdp-domains.md`
- **Performance Guide:** `.claude/skills/chrome-devtools/references/performance-guide.md`

### **For All Users:**
- **MCP tools:** Available `mcp__chrome-devtools__*` functions (use in conversation)
- **Debug prompt:** `../z_prompts/code_debugger.yaml`
- **Webflow constraints:** `./webflow_platform_constraints.md`
- **Code standards:** `./code_standards.md`

---

## 9. 🧭 DECISION TREE: WHICH TOOL TO USE?

```
┌─ Are you Claude? ───────────────────────────────────┐
│  YES → Use Chrome DevTools Skill                    │
│        (Guided workflow with 16 scripts)            │
└─────────────────────────────────────────────────────┘
                      │ NO
                      ▼
┌─ Do you have MCP access? ───────────────────────────┐
│  YES → Use MCP tools directly                       │
│        (Interactive debugging in conversation)      │
└─────────────────────────────────────────────────────┘
                      │ NO
                      ▼
┌─ Need automation/CI? ───────────────────────────────┐
│  YES → Use CLI scripts                              │
│        (Scriptable Bash + JSON output)              │
└─────────────────────────────────────────────────────┘
                      │ NO
                      ▼
┌─ Use Static Analysis ───────────────────────────────┐
│  Read, Grep, Glob tools                             │
│  (Code-based inference)                             │
└─────────────────────────────────────────────────────┘
```

**Quick Reference:**
- **Claude user?** → Chrome DevTools skill
- **MCP available?** → MCP tools
- **Need CI/CD?** → CLI scripts
- **No browser automation?** → Static analysis

---

**Remember:** Choose the right tools and remember Webflow's unique constraints during the debugging process. Always start with Webflow-specific checks (Section 1) before diving into browser automation.
