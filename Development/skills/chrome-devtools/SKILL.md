---
name: chrome-devtools
description: Browser automation, debugging, and performance analysis using Puppeteer CLI scripts. Use for automating browsers, taking screenshots, analyzing performance, monitoring network traffic, web scraping, form automation, and JavaScript debugging.
license: Apache-2.0
---

# Chrome DevTools - Browser Automation & Performance Analysis

Browser automation via executable Puppeteer scripts. All scripts output JSON for easy parsing. 
This skill provides comprehensive browser automation capabilities including navigation, element interaction, performance analysis, network monitoring, and visual capture.

**Key Capabilities:**
- Browser automation and control
- Performance measurement and tracing
- Network traffic monitoring
- Screenshot and PDF generation
- Console message capture
- JavaScript execution in page context

---

## 1. 🚀 QUICK START

### Installation

#### Step 1: Install System Dependencies (Linux/WSL only)

On Linux/WSL, Chrome requires system libraries. Install them first:

```bash
cd .claude/skills/chrome-devtools/scripts
./install-deps.sh  # Auto-detects OS and installs required libs
```

Supports: Ubuntu, Debian, Fedora, RHEL, CentOS, Arch, Manjaro

**macOS/Windows**: Skip this step (dependencies bundled with Chrome)

#### Step 2: Install Node Dependencies

```bash
npm install  # Installs puppeteer, debug, yargs
```

### Test Installation

```bash
node navigate.js --url https://example.com
# Output: {"success": true, "url": "https://example.com", "title": "Example Domain"}
```

---

## 2. 🛠️ AVAILABLE SCRIPTS

All scripts are in `.claude/skills/chrome-devtools/scripts/`

### Core Automation

- `navigate.js` - Navigate to URLs
- `screenshot.js` - Capture screenshots (full page or element)
- `click.js` - Click elements
- `fill.js` - Fill form fields
- `evaluate.js` - Execute JavaScript in page context

### Analysis & Monitoring

- `snapshot.js` - Extract interactive elements with metadata
- `console.js` - Monitor console messages/errors
- `network.js` - Track HTTP requests/responses
- `performance.js` - Measure Core Web Vitals + record traces

### Multi-Page Management

- `pages.js` - Manage multiple browser pages/tabs (list, create, switch, close)

### Advanced Interactions

- `hover.js` - Hover over elements to trigger CSS :hover states and dropdowns
- `drag.js` - Drag and drop elements between locations
- `upload.js` - Upload files via file input elements

### Device Emulation

- `emulate-network.js` - Network throttling profiles (Offline, Slow 3G, Fast 3G, etc.)
- `emulate-cpu.js` - CPU throttling for performance testing (1-20x slowdown)

### Dialog Control

- `dialog.js` - Handle JavaScript alerts/confirms/prompts manually

### Script Usage

See `./scripts/README.md` for detailed usage of each script.

---

## 3. 💻 USAGE PATTERNS

### Single Command

```bash
cd .claude/skills/chrome-devtools/scripts
node screenshot.js --url https://example.com --output ./docs/screenshots/page.png
```

**Important**: Always save screenshots to `./docs/screenshots` directory.

### Chain Commands (reuse browser)

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

---

## 4. ⚙️ COMMON WORKFLOWS

### Web Scraping

```bash
node evaluate.js --url https://example.com --script "
  Array.from(document.querySelectorAll('.item')).map(el => ({
    title: el.querySelector('h2')?.textContent,
    link: el.querySelector('a')?.href
  }))
" | jq '.result'
```

### Performance Testing

```bash
PERF=$(node performance.js --url https://example.com)
LCP=$(echo $PERF | jq '.vitals.LCP')
if (( $(echo "$LCP < 2500" | bc -l) )); then
  echo "✓ LCP passed: ${LCP}ms"
else
  echo "✗ LCP failed: ${LCP}ms"
fi
```

### Form Automation

```bash
node fill.js --url https://example.com --selector "#search" --value "query" --close false
node click.js --selector "button[type=submit]"
```

### Error Monitoring

```bash
node console.js --url https://example.com --types error,warn --duration 5000 | jq '.messageCount'
```

### Multi-Page Workflows

```bash
# Open multiple pages
node pages.js --action new --url https://example.com/page1 --close false
node pages.js --action new --url https://example.com/page2 --close false

# List all pages
node pages.js --action list

# Switch between pages
node pages.js --action switch --index 0 --close false
node click.js --selector ".button" --close false
node pages.js --action switch --index 1
```

### Device Emulation Testing

```bash
# Test on slow 3G with CPU throttling
node emulate-network.js --profile "Slow 3G" --close false
node emulate-cpu.js --rate 4 --close false
node navigate.js --url https://example.com --close false
node performance.js | jq '.vitals.LCP'
```

### File Upload Automation

```bash
# Upload avatar
node upload.js --url https://example.com/profile --selector "#avatar-input" --file /tmp/photo.jpg --close false
node click.js --selector "button[type=submit]"
```

### Dropdown Menu Testing

```bash
# Hover to open dropdown, then click item
node hover.js --url https://example.com --selector ".menu-trigger" --wait-for ".dropdown-menu" --close false
node click.js --selector ".dropdown-menu li:first-child"
```

---

## 5. 📊 SCRIPT OPTIONS

All scripts support:
- `--headless false` - Show browser window
- `--close false` - Keep browser open for chaining
- `--timeout 30000` - Set timeout (milliseconds)
- `--wait-until networkidle2` - Wait strategy

See `./scripts/README.md` for complete options.

---

## 6. 🔍 FINDING ELEMENTS

Use `snapshot.js` to discover selectors:

```bash
node snapshot.js --url https://example.com | jq '.elements[] | {tagName, text, selector}'
```

---

## 7. ✅ TROUBLESHOOTING

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
- Get snapshot first to find correct selector: `node snapshot.js --url <url>`

**Script hangs**
- Increase timeout: `--timeout 60000`
- Change wait strategy: `--wait-until load` or `--wait-until domcontentloaded`

**Blank screenshot**
- Wait for page load: `--wait-until networkidle2`
- Increase timeout: `--timeout 30000`

**Permission denied on scripts**
- Make executable: `chmod +x *.sh`

---

## 8. 🧭 REFERENCE DOCUMENTATION

Detailed guides available in `./references/`:
- [CDP Domains Reference](./references/cdp-domains.md) - 47 Chrome DevTools Protocol domains
- [Puppeteer Quick Reference](./references/puppeteer-reference.md) - Complete Puppeteer API patterns
- [Performance Analysis Guide](./references/performance-guide.md) - Core Web Vitals optimization

---

## 9. 🔧 ADVANCED USAGE

### Custom Scripts

Create custom scripts using shared library:

```javascript
import { getBrowser, getPage, closeBrowser, outputJSON } from './lib/browser.js';
// Your automation logic
```

### Direct CDP Access

```javascript
const client = await page.createCDPSession();
await client.send('Emulation.setCPUThrottlingRate', { rate: 4 });
```

See reference documentation for advanced patterns and complete API coverage.

---

## 10. 📚 EXTERNAL RESOURCES

- [Puppeteer Documentation](https://pptr.dev/)
- [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/)
- [Scripts README](./scripts/README.md)