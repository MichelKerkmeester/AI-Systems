# Scripts Documentation - Executable Puppeteer Scripts for Browser Automation

Collection of executable Puppeteer scripts for browser automation, testing, and analysis.
All scripts output JSON to stdout for easy parsing and integration. Errors output to stderr.

#### 📋 TABLE OF CONTENTS

1. [🚀 INSTALLATION](#1--installation)
2. [🧭 NAVIGATION SCRIPTS](#2--navigation-scripts)
3. [🎯 INTERACTION SCRIPTS](#3--interaction-scripts)
4. [📸 CAPTURE SCRIPTS](#4--capture-scripts)
5. [🔍 ANALYSIS SCRIPTS](#5--analysis-scripts)
6. [📊 PERFORMANCE SCRIPTS](#6--performance-scripts)
7. [🌐 MULTI-PAGE SCRIPTS](#7--multi-page-scripts)
8. [📱 DEVICE EMULATION SCRIPTS](#8--device-emulation-scripts)
9. [🔔 DIALOG SCRIPTS](#9--dialog-scripts)
10. [⚙️ COMMON OPTIONS](#10-️-common-options)
11. [💻 USAGE EXAMPLES](#11--usage-examples)
12. [✅ BEST PRACTICES](#12--best-practices)

---

## 1. 🚀 INSTALLATION

### Quick Install

```bash
cd .claude/skills/chrome-devtools/scripts
./install.sh  # Auto-checks dependencies and installs
```

### Manual Installation

**Linux/WSL** - Install system dependencies first:
```bash
./install-deps.sh  # Auto-detects OS (Ubuntu, Debian, Fedora, etc.)
```

Or manually:
```bash
sudo apt-get install -y libnss3 libnspr4 libasound2t64 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1
```

**All platforms** - Install Node dependencies:
```bash
npm install
```

---

## 2. 🧭 NAVIGATION SCRIPTS

### navigate.js

Navigate to a URL and get page information.

**Usage:**
```bash
node navigate.js --url https://example.com [--wait-until networkidle2] [--timeout 30000]
```

**Output:**
```json
{
  "success": true,
  "url": "https://example.com",
  "title": "Example Domain",
  "loadTime": 1234
}
```

---

## 3. 🎯 INTERACTION SCRIPTS

### click.js

Click an element by selector.

**Usage:**
```bash
node click.js --selector ".button" [--url https://example.com] [--wait-for ".result"]
```

**Output:**
```json
{
  "success": true,
  "selector": ".button",
  "clicked": true
}
```

### fill.js

Fill form fields with text.

**Usage:**
```bash
node fill.js --selector "#input" --value "text" [--url https://example.com] [--clear true]
```

**Output:**
```json
{
  "success": true,
  "selector": "#input",
  "value": "text"
}
```

### evaluate.js

Execute JavaScript in page context.

**Usage:**
```bash
node evaluate.js --script "document.title" [--url https://example.com]
```

**Output:**
```json
{
  "success": true,
  "result": "Example Domain"
}
```

### hover.js

Hover over an element to trigger CSS :hover states and dropdowns.

**Usage:**
```bash
node hover.js --selector ".menu-trigger" [--url https://example.com] [--wait-for ".dropdown"]
```

**Output:**
```json
{
  "success": true,
  "selector": ".menu-trigger",
  "hovered": true,
  "url": "https://example.com"
}
```

### drag.js

Drag element from source to target (drag & drop).

**Usage:**
```bash
node drag.js --from ".draggable" --to ".dropzone" [--url https://example.com]
```

**Output:**
```json
{
  "success": true,
  "from": ".draggable",
  "to": ".dropzone",
  "dragged": true,
  "url": "https://example.com"
}
```

### upload.js

Upload file via file input element.

**Usage:**
```bash
node upload.js --selector "input[type='file']" --file /path/to/document.pdf [--url https://example.com]
```

**Output:**
```json
{
  "success": true,
  "selector": "input[type='file']",
  "file": "/path/to/document.pdf",
  "fileName": "document.pdf",
  "fileSize": 102400,
  "uploaded": true,
  "url": "https://example.com"
}
```

---

## 4. 📸 CAPTURE SCRIPTS

### screenshot.js

Take a screenshot of page or element.

**Important:** Always save screenshots to `./docs/screenshots` directory.

**Usage:**
```bash
node screenshot.js --output screenshot.png [--url https://example.com] [--full-page true] [--selector .element]
```

**Output:**
```json
{
  "success": true,
  "path": "./docs/screenshots/page.png",
  "format": "png",
  "width": 1920,
  "height": 1080
}
```

### snapshot.js

Get DOM snapshot with interactive elements.

**Usage:**
```bash
node snapshot.js [--url https://example.com] [--output snapshot.json]
```

**Output:**
```json
{
  "success": true,
  "url": "https://example.com",
  "elements": [
    {
      "uid": "element-1",
      "role": "button",
      "name": "Submit",
      "tagName": "button",
      "selector": "button.submit"
    }
  ]
}
```

---

## 5. 🔍 ANALYSIS SCRIPTS

### console.js

Monitor console messages and errors.

**Usage:**
```bash
node console.js --url https://example.com [--types error,warn] [--duration 5000]
```

**Output:**
```json
{
  "success": true,
  "url": "https://example.com",
  "messages": [
    {
      "type": "error",
      "text": "Uncaught TypeError",
      "location": "script.js:42",
      "timestamp": 1234567890
    }
  ],
  "messageCount": 1
}
```

### network.js

Monitor network requests and responses.

**Usage:**
```bash
node network.js --url https://example.com [--types xhr,fetch] [--output requests.json]
```

**Output:**
```json
{
  "success": true,
  "url": "https://example.com",
  "requests": [
    {
      "id": 1,
      "method": "GET",
      "url": "https://example.com/api/data",
      "resourceType": "xhr",
      "status": 200,
      "size": 1024,
      "time": 123
    }
  ],
  "totalRequests": 1
}
```

---

## 6. 📊 PERFORMANCE SCRIPTS

### performance.js

Measure performance metrics and record trace.

**Usage:**
```bash
node performance.js --url https://example.com [--trace trace.json] [--metrics] [--resources true]
```

**Output:**
```json
{
  "success": true,
  "url": "https://example.com",
  "vitals": {
    "LCP": 2400,
    "FID": 90,
    "CLS": 0.05
  },
  "metrics": {
    "FCP": 1200,
    "TTFB": 300
  }
}
```

---

## 7. 🌐 MULTI-PAGE SCRIPTS

### pages.js

Manage multiple browser pages/tabs (list, create, switch, close, bring to front).

**List Pages:**
```bash
node pages.js --action list
```

**Create New Page:**
```bash
node pages.js --action new --url https://example.com
```

**Switch to Page:**
```bash
node pages.js --action switch --index 1
```

**Close Page:**
```bash
node pages.js --action close --index 1
```

**Bring Page to Front:**
```bash
node pages.js --action front --index 0
```

**Output (list):**
```json
{
  "success": true,
  "action": "list",
  "pageCount": 3,
  "pages": [
    { "index": 0, "url": "https://example.com", "title": "Example", "isClosed": false },
    { "index": 1, "url": "https://another.com", "title": "Another", "isClosed": false },
    { "index": 2, "url": "https://third.com", "title": "Third", "isClosed": false }
  ]
}
```

**Output (new):**
```json
{
  "success": true,
  "action": "new",
  "pageIndex": 1,
  "url": "https://example.com",
  "title": "Example Domain",
  "totalPages": 2
}
```

---

## 8. 📱 DEVICE EMULATION SCRIPTS

### emulate-network.js

Simulate network conditions (throttling, offline mode).

**Predefined Profiles:**
- No emulation (default)
- Offline
- Slow 3G
- Fast 3G
- Slow 4G
- Fast 4G

**Usage (Profile):**
```bash
node emulate-network.js --profile "Slow 3G"
node emulate-network.js --profile "Offline"
```

**Usage (Custom):**
```bash
node emulate-network.js --download 1500000 --upload 750000 --latency 40
```

**Disable Throttling:**
```bash
node emulate-network.js --profile "No emulation"
```

**Output:**
```json
{
  "success": true,
  "profile": "Slow 3G",
  "conditions": {
    "offline": false,
    "downloadThroughput": 204800,
    "uploadThroughput": 96000,
    "latency": 150,
    "downloadMbps": "1.60",
    "uploadMbps": "0.75"
  },
  "active": true
}
```

### emulate-cpu.js

Simulate CPU throttling (1-20x slowdown).

**Usage:**
```bash
node emulate-cpu.js --rate 4  # 4x CPU slowdown
node emulate-cpu.js --rate 1  # Disable throttling
node emulate-cpu.js --rate 6 --url https://example.com
```

**Output:**
```json
{
  "success": true,
  "throttleRate": 4,
  "slowdownFactor": "4x",
  "active": true,
  "description": "CPU slowed down by 4x (simulates 4x slower device)"
}
```

---

## 9. 🔔 DIALOG SCRIPTS

### dialog.js

Handle JavaScript dialogs (alert, confirm, prompt) manually.

**Note:** Dialogs are auto-dismissed by default. This script provides manual control.

**Accept Dialog:**
```bash
node dialog.js --action accept [--url https://example.com]
```

**Accept Prompt with Input:**
```bash
node dialog.js --action accept --input "username" [--url https://example.com]
```

**Dismiss Dialog:**
```bash
node dialog.js --action dismiss [--url https://example.com]
```

**Wait for Dialog:**
```bash
node dialog.js --action wait --timeout 5000
```

**Output:**
```json
{
  "success": true,
  "action": "accept",
  "dialogType": "prompt",
  "dialogMessage": "What is your name?",
  "inputProvided": "username",
  "handled": true,
  "url": "https://example.com"
}
```

---

## 10. ⚙️ COMMON OPTIONS

All scripts support these common options:

- `--headless false` - Show browser window
- `--close false` - Keep browser open for chaining
- `--timeout 30000` - Set timeout in milliseconds
- `--wait-until networkidle2` - Wait strategy: load, domcontentloaded, networkidle0, networkidle2

---

## 11. 💻 USAGE EXAMPLES

### Chain Commands

Keep browser open between operations:
```bash
node navigate.js --url https://example.com/login --close false
node fill.js --selector "#email" --value "user@example.com" --close false
node fill.js --selector "#password" --value "secret" --close false
node click.js --selector "button[type=submit]"
```

### Web Scraping

Extract data from page:
```bash
node evaluate.js --url https://example.com --script "
  Array.from(document.querySelectorAll('.item')).map(el => ({
    title: el.querySelector('h2').textContent,
    link: el.querySelector('a').href
  }))
" | jq '.result'
```

### Performance Testing

Measure Core Web Vitals:
```bash
LCP=$(node performance.js --url https://example.com | jq '.vitals.LCP')
echo "LCP: ${LCP}ms"

if (( $(echo "$LCP > 2500" | bc -l) )); then
  echo "LCP too slow!"
  exit 1
fi
```

### Error Detection

Check for console errors:
```bash
ERRORS=$(node console.js --url https://example.com --types error | jq '.messages | length')
if [ "$ERRORS" -gt 0 ]; then
  echo "Found $ERRORS errors!"
fi
```

### Network Analysis

Monitor API calls:
```bash
node network.js --url https://example.com --types xhr,fetch | jq '.requests[] | {url, status, time}'
```

---

## 12. ✅ BEST PRACTICES

### General

1. **Chain Commands:** Use `--close false` to keep browser open between operations
2. **Save Screenshots:** Always save to `./docs/screenshots` directory
3. **Parse JSON:** Use `jq` to extract specific fields from output
4. **Handle Timeouts:** Increase `--timeout` for slow pages
5. **Wait Strategies:** Use `networkidle2` for dynamic content

### Error Handling

```bash
#!/bin/bash
set -e

if ! output=$(node navigate.js --url https://example.com 2>&1); then
  echo "Navigation failed: $output"
  exit 1
fi

title=$(echo "$output" | jq -r '.title')
echo "Page title: $title"
```

### Parallel Execution

```bash
# Run multiple scripts in parallel
node screenshot.js --url https://example.com --output ./page1.png &
node screenshot.js --url https://another.com --output ./page2.png &
wait
echo "Screenshots captured"
```

### Output Format

All scripts output JSON:

**Success:**
```json
{
  "success": true,
  "url": "https://example.com",
  "title": "Example Domain"
}
```

**Error:**
```json
{
  "success": false,
  "error": "Error message",
  "stack": "..."
}
```