---
name: chrome-devtools
description: Browser automation, debugging, and performance analysis using Puppeteer CLI scripts. This skill should be used for automating browsers, taking screenshots, analyzing performance, monitoring network traffic, web scraping, form automation, and JavaScript debugging.
license: Apache-2.0
---

# Chrome DevTools - Browser Automation & Performance Analysis

Browser automation via executable Puppeteer scripts. All scripts output JSON for easy parsing and integration with Claude workflows.

---

## 1. 🎯 WHEN TO USE

**This skill should be used when**:
- Automating browser interactions for testing workflows
- Capturing screenshots or generating PDFs from web pages
- Analyzing web performance metrics (Core Web Vitals: LCP, FID, CLS)
- Monitoring network traffic and API calls
- Detecting console errors and warnings
- Scraping dynamic web content requiring JavaScript execution
- Filling forms and simulating user interactions
- Testing under throttled network or CPU conditions
- Managing multiple browser pages/tabs simultaneously
- Uploading files or interacting with complex UI elements

**This skill should NOT be used for**:
- Simple HTTP requests (use curl, fetch, or Axios instead)
- Static HTML parsing (use cheerio or jsdom)
- Server-side rendering without browser context
- File downloads without page interaction (use wget/curl)
- Long-running background automation (use dedicated automation tools)

**Key Characteristics**:
- **Output Format**: JSON to stdout for easy parsing
- **Browser**: Headless Chrome via Puppeteer
- **Persistence**: Browser sessions survive across scripts with `--close false`
- **Platform**: Cross-platform (macOS, Windows, Linux/WSL)
- **Scripts**: 22 specialized automation scripts

---

## 2. 🛠️ HOW IT WORKS

**Architecture**:
```
Claude → Bash Tool → Node Script → Puppeteer → Chrome → JSON Output
```

**Execution Model**:
- Execute Node.js scripts via Bash tool
- All scripts output JSON to stdout
- Browser automation via Chrome DevTools Protocol (CDP)
- Persistent browser sessions with `--close false` flag
- Shared library (`lib/browser.js`) ensures consistency

**Key Capabilities**:
- Browser automation and control
- Performance measurement and tracing
- Network traffic monitoring
- Screenshot and PDF generation
- Console message capture
- JavaScript execution in page context
- Multi-page/tab management
- Device emulation (network/CPU throttling)

---

## 3. 📋 INSTALLATION STEPS

### Step 1: Install System Dependencies (Linux/WSL Only)

On Linux/WSL, Chrome requires system libraries. Install them first:

```bash
cd .claude/skills/chrome-devtools/scripts
./install-deps.sh  # Auto-detects OS and installs required libs
```

**Supported**: Ubuntu, Debian, Fedora, RHEL, CentOS, Arch, Manjaro

**macOS/Windows**: Skip this step (dependencies bundled with Chrome)

### Step 2: Install Node Dependencies

```bash
cd .claude/skills/chrome-devtools/scripts
npm install  # Installs puppeteer, debug, yargs
```

### Step 3: Verify Installation

```bash
node navigate.js --url https://example.com
# Expected: {"success": true, "url": "https://example.com", "title": "Example Domain"}
```

---

## 4. 🎯 CORE CAPABILITIES

All scripts located in `.claude/skills/chrome-devtools/scripts/`

| Category | Scripts | Purpose |
|----------|---------|---------|
| **Navigation & Capture** | navigate, screenshot | Page navigation and visual capture |
| **Interaction** | click, fill, hover, drag, upload | Element interaction and form automation |
| **Analysis** | snapshot, console, network, performance | Page analysis and monitoring |
| **Multi-Page** | pages | Tab/page management |
| **Emulation** | emulate-network, emulate-cpu | Device/network simulation |
| **Advanced** | evaluate, dialog | Custom JavaScript and dialog handling |

**Detailed Usage**: See `scripts/README.md` for complete documentation of all 22 scripts

---

## 5. 💻 USAGE PATTERNS

### Single Command

```bash
cd .claude/skills/chrome-devtools/scripts
node screenshot.js --url https://example.com --output ./docs/screenshots/page.png
```

**Important**: Always save screenshots to `./docs/screenshots` directory.

### Chain Commands (Reuse Browser)

```bash
# Keep browser open with --close false
node navigate.js --url https://example.com/login --close false
node fill.js --selector "#email" --value "user@example.com" --close false
node fill.js --selector "#password" --value "secret" --close false
node click.js --selector "button[type=submit]"
```

### Parse JSON Output

```bash
# Extract specific fields with jq
node performance.js --url https://example.com | jq '.vitals.LCP'

# Save to file
node network.js --url https://example.com --output /tmp/requests.json
```

### Common Options

All scripts support:
- `--headless false` - Show browser window
- `--close false` - Keep browser open for chaining
- `--timeout 30000` - Set timeout (milliseconds)
- `--wait-until networkidle2` - Wait strategy

---

## 6. 📖 RULES

### ALWAYS

- Install system dependencies on Linux/WSL before Node packages
- Save screenshots to `./docs/screenshots` directory
- Use `--close false` flag when chaining multiple commands
- Parse JSON output with `jq` for field extraction
- Run `snapshot.js` first to discover selectors before interactions
- Increase timeout for slow-loading pages (`--timeout 60000`)
- Use `networkidle2` wait strategy for dynamic content
- Close browser after final command in chain (default behavior)

### NEVER

- Run scripts without installing dependencies first
- Save screenshots outside the `./docs/screenshots` directory
- Chain commands without the `--close false` flag
- Assume Chrome is available without verifying Puppeteer install
- Use short timeouts (<5000ms) for complex pages
- Run multiple browser instances unnecessarily (reuse with --close false)
- Commit screenshots to version control (add to .gitignore)
- Use `--headless false` in automated workflows (CI/CD)

### ESCALATE IF

- Installation scripts fail on supported Linux distributions
- Browser launch fails after successful dependency installation
- Scripts consistently timeout despite increased timeout values
- Chrome download fails during `npm install`
- System dependencies cannot be resolved on unsupported OS
- JSON output parsing fails (malformed output)
- Memory usage grows unbounded during automation

---

## 7. 🎓 SUCCESS CRITERIA

**Installation complete when**:
- ✅ System dependencies installed (Linux/WSL only)
- ✅ Node packages installed (`npm install` succeeds)
- ✅ Test navigation returns valid JSON with page title
- ✅ Chrome browser binary detected by Puppeteer

**Script execution successful when**:
- ✅ JSON output written to stdout
- ✅ `"success": true` in output object
- ✅ No errors in stderr
- ✅ Exit code 0

**Automation workflow complete when**:
- ✅ All commands execute in correct sequence
- ✅ Browser persists across chained commands (`--close false`)
- ✅ Screenshots saved to `./docs/screenshots` directory
- ✅ Final JSON output contains expected data
- ✅ Browser properly closed after final command

**Performance**:
- ✅ Scripts execute in <5 seconds for simple pages
- ✅ Performance metrics capture Core Web Vitals accurately
- ✅ No memory leaks from unclosed browser instances
- ✅ Network requests tracked without data loss

---

## 8. 💡 EXAMPLES

### Example 1: Web Scraping

```bash
node evaluate.js --url https://example.com --script "
  Array.from(document.querySelectorAll('.item')).map(el => ({
    title: el.querySelector('h2')?.textContent,
    link: el.querySelector('a')?.href
  }))
" | jq '.result'
```

### Example 2: Performance Testing

```bash
PERF=$(node performance.js --url https://example.com)
LCP=$(echo $PERF | jq '.vitals.LCP')
if (( $(echo "$LCP < 2500" | bc -l) )); then
  echo "✓ LCP passed: ${LCP}ms"
else
  echo "✗ LCP failed: ${LCP}ms"
fi
```

### Example 3: Form Automation

```bash
node fill.js --url https://example.com --selector "#search" --value "query" --close false
node click.js --selector "button[type=submit]"
```

### Example 4: Multi-Page Workflow

```bash
# Open multiple pages
node pages.js --action new --url https://example.com/page1 --close false
node pages.js --action new --url https://example.com/page2 --close false

# Switch between pages
node pages.js --action switch --index 0 --close false
node click.js --selector ".button"
```

**More Examples**: See `references/workflow_examples.md` for complete automation patterns

---

## 9. 🔧 TROUBLESHOOTING

### Common Errors

**"Cannot find package 'puppeteer'"**
- Run: `npm install` in the scripts directory

**"error while loading shared libraries: libnss3.so"** (Linux/WSL)
- Missing system dependencies
- Fix: Run `./install-deps.sh` in scripts directory
- Manual install: `sudo apt-get install -y libnss3 libnspr4 libasound2t64 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1`

**"Failed to launch the browser process"**
- Check system dependencies installed (Linux/WSL)
- Verify Chrome downloaded: `ls ~/.cache/puppeteer`
- Try: `npm rebuild` then `npm install`

**Chrome not found**
- Puppeteer auto-downloads Chrome during `npm install`
- If failed, manually trigger: `npx puppeteer browsers install chrome`

### Script Issues

**Element not found**
- Use snapshot.js to discover selectors:
```bash
node snapshot.js --url <url> | jq '.elements[] | {tagName, text, selector}'
```

**Script hangs**
- Increase timeout: `--timeout 60000`
- Change wait strategy: `--wait-until load` or `--wait-until domcontentloaded`

**Blank screenshot**
- Wait for page load: `--wait-until networkidle2`
- Increase timeout: `--timeout 30000`

**Permission denied on scripts**
- Make executable: `chmod +x *.sh`

---

## 10. 🔗 INTEGRATION POINTS

**Triggers**: Bash tool executing Node.js scripts

**Input Requirements**:
- Valid URLs (HTTPS recommended)
- CSS selectors for element targeting
- File paths for screenshots/uploads
- JavaScript code strings for evaluation

**Outputs**:
- JSON to stdout (all scripts)
- Screenshots to `./docs/screenshots` (screenshot.js)
- Performance traces (performance.js with --trace)
- Network logs (network.js with --output)

**Pairs With**:
- `workflow-spec-kit` - Automate browser testing during implementation phases
- `save-context` - Document automation workflows in context files
- `markdown-flowchart` - Visualize automation decision trees
- `git-commit` - Include screenshot artifacts in commits

**Data Flow**:
```
User Request → Bash Tool → Node Script → Puppeteer API → Chrome CDP → JSON Output → Claude Analysis
```

**Common Patterns**:
- **Sequential Testing**: Chain navigate → fill → click → screenshot
- **Performance Audit**: Run performance.js → parse vitals → report
- **Error Detection**: Run console.js → filter errors → escalate
- **Multi-Page Testing**: Use pages.js to manage tab workflows

---

## 11. 📚 REFERENCES

**Bundled Resources**:

This skill includes comprehensive reference documentation for progressive disclosure:

### `references/cdp_domains.md`
**Complete Chrome DevTools Protocol domain reference**
- 47 CDP domains with capabilities
- Method signatures and parameters
- Event types and payloads
- Use cases for each domain

**When to consult**: For advanced CDP automation or custom script development

### `references/puppeteer_reference.md`
**Complete Puppeteer API patterns**
- Page navigation methods
- Element interaction patterns
- Event handling
- Network interception
- Performance profiling

**When to consult**: For understanding Puppeteer API or building custom scripts

### `references/performance_guide.md`
**Core Web Vitals optimization guide**
- LCP (Largest Contentful Paint) optimization
- FID (First Input Delay) improvement
- CLS (Cumulative Layout Shift) reduction
- Performance tracing techniques

**When to consult**: For performance analysis and optimization strategies

### `references/workflow_examples.md`
**Extended automation workflow patterns**
- Web scraping workflows
- Performance testing automation
- Form automation sequences
- Error monitoring setups
- Device emulation testing
- File upload automation
- Dropdown menu testing

**When to consult**: For complex multi-step automation patterns

### `scripts/README.md`
**Detailed script usage documentation (1,319 words)**
- Complete parameter reference for all 22 scripts
- Example commands for each script
- Advanced usage patterns
- Error handling

**When to consult**: For detailed script options and parameters

### Installation Scripts
- `scripts/install-deps.sh` - Auto-detect OS and install system libraries
- `scripts/install.sh` - Quick install wrapper

### External Resources
- [Puppeteer Documentation](https://pptr.dev/)
- [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/)

---

## 12. 🎯 QUICK REFERENCE

**Installation**:
```bash
cd .claude/skills/chrome-devtools/scripts
./install-deps.sh  # Linux/WSL only
npm install
```

**Test**:
```bash
node navigate.js --url https://example.com
```

**Chain Commands**:
```bash
node script1.js --close false
node script2.js
```

**Parse Output**:
```bash
node performance.js --url <url> | jq '.vitals.LCP'
```

**Find Selectors**:
```bash
node snapshot.js --url <url> | jq '.elements[]'
```

**Key Flags**:
- `--close false` - Keep browser open
- `--timeout 30000` - Set timeout (ms)
- `--wait-until networkidle2` - Wait for network idle
- `--headless false` - Show browser window

**Output**: All scripts return JSON to stdout

**Screenshots**: Always save to `./docs/screenshots`

**Script Count**: 22 specialized automation scripts

**Documentation**: See `scripts/README.md` for detailed usage
