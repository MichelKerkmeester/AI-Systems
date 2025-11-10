# Chrome DevTools - Extended Automation Workflow Patterns

This document provides comprehensive workflow examples for common browser automation scenarios using chrome-devtools scripts.

**Referenced from**: `chrome-devtools/skill.md`

---

## 1. Web Scraping Workflows

### Basic Content Extraction

```bash
# Extract article data from a listing page
node evaluate.js --url https://example.com/blog --script "
  Array.from(document.querySelectorAll('.article')).map(el => ({
    title: el.querySelector('h2')?.textContent,
    link: el.querySelector('a')?.href,
    date: el.querySelector('.date')?.textContent,
    author: el.querySelector('.author')?.textContent
  }))
" | jq '.result'
```

### Multi-Page Scraping

```bash
# Navigate through paginated results
for page in {1..5}; do
  node evaluate.js \
    --url "https://example.com/search?page=$page" \
    --script "Array.from(document.querySelectorAll('.result')).map(el => el.textContent)" \
    --close false \
    >> /tmp/all-results.json
done

# Close browser after final page
node navigate.js --url about:blank
```

### Dynamic Content Scraping

```bash
# Wait for AJAX-loaded content
node navigate.js --url https://example.com --wait-until networkidle2 --close false
node evaluate.js --script "
  document.querySelector('.ajax-loaded-content')?.innerHTML
" | jq -r '.result' > /tmp/content.html
```

---

## 2. Performance Testing Workflows

### Core Web Vitals Audit

```bash
# Measure performance and validate against thresholds
PERF=$(node performance.js --url https://example.com)
LCP=$(echo $PERF | jq '.vitals.LCP')
FID=$(echo $PERF | jq '.vitals.FID')
CLS=$(echo $PERF | jq '.vitals.CLS')

echo "Performance Results:"
echo "LCP: ${LCP}ms (threshold: <2500ms)"
echo "FID: ${FID}ms (threshold: <100ms)"
echo "CLS: ${CLS} (threshold: <0.1)"

# Validate thresholds
if (( $(echo "$LCP < 2500" | bc -l) )); then
  echo "✓ LCP passed"
else
  echo "✗ LCP failed"
fi
```

### Performance Comparison (Before/After)

```bash
# Measure baseline
node performance.js --url https://staging.example.com > /tmp/before.json

# Deploy changes
# ... deployment process ...

# Measure after changes
node performance.js --url https://staging.example.com > /tmp/after.json

# Compare results
echo "LCP Before: $(jq '.vitals.LCP' /tmp/before.json)ms"
echo "LCP After: $(jq '.vitals.LCP' /tmp/after.json)ms"
echo "Improvement: $(jq -n '('$(jq '.vitals.LCP' /tmp/before.json)' - '$(jq '.vitals.LCP' /tmp/after.json)')')ms"
```

### Performance Tracing

```bash
# Generate performance trace for detailed analysis
node performance.js \
  --url https://example.com \
  --trace /tmp/trace.json

# Trace can be uploaded to Chrome DevTools for visualization
echo "Upload trace to: chrome://tracing"
```

---

## 3. Form Automation Workflows

### Simple Login Flow

```bash
# Navigate to login page
node navigate.js --url https://example.com/login --close false

# Fill credentials
node fill.js --selector "#email" --value "user@example.com" --close false
node fill.js --selector "#password" --value "secure_password" --close false

# Submit form
node click.js --selector "button[type=submit]" --close false

# Wait for redirect and capture dashboard
node screenshot.js --output ./docs/screenshots/dashboard.png
```

### Multi-Step Form with Validation

```bash
# Navigate to registration form
node navigate.js --url https://example.com/register --close false

# Fill step 1
node fill.js --selector "#firstName" --value "John" --close false
node fill.js --selector "#lastName" --value "Doe" --close false
node click.js --selector ".next-step" --close false

# Wait for step 2 to load
sleep 2

# Fill step 2
node fill.js --selector "#address" --value "123 Main St" --close false
node fill.js --selector "#city" --value "San Francisco" --close false

# Submit
node click.js --selector "button[type=submit]"
```

### Search Form with Dynamic Results

```bash
# Navigate and search
node fill.js \
  --url https://example.com \
  --selector "#search-input" \
  --value "automation tools" \
  --close false

# Submit search
node click.js --selector ".search-button" --close false

# Wait for results to load
node navigate.js --url "$(node evaluate.js --script 'window.location.href' | jq -r '.result')" --wait-until networkidle2 --close false

# Extract results
node evaluate.js --script "
  Array.from(document.querySelectorAll('.search-result')).map(el => ({
    title: el.querySelector('h3')?.textContent,
    snippet: el.querySelector('.snippet')?.textContent
  }))
" | jq '.result'
```

---

## 4. Error Monitoring Workflows

### Console Error Detection

```bash
# Monitor console for errors during page load
ERROR_COUNT=$(node console.js \
  --url https://example.com \
  --types error,warn \
  --duration 5000 | jq '.messageCount')

if [ "$ERROR_COUNT" -gt 0 ]; then
  echo "⚠️  Found $ERROR_COUNT console errors"
  node console.js --url https://example.com --types error --duration 5000 | jq '.messages'
else
  echo "✓ No console errors detected"
fi
```

### Network Error Tracking

```bash
# Monitor failed network requests
node network.js --url https://example.com --close false

# Filter for failed requests (status >= 400)
node network.js --url https://example.com | jq '.requests[] | select(.status >= 400)'
```

### Combined Error Audit

```bash
# Comprehensive error check
echo "=== Console Errors ==="
node console.js --url https://example.com --types error

echo "=== Failed Network Requests ==="
node network.js --url https://example.com | jq '.requests[] | select(.status >= 400)'

echo "=== Performance Issues ==="
PERF=$(node performance.js --url https://example.com)
LCP=$(echo $PERF | jq '.vitals.LCP')
if (( $(echo "$LCP > 2500" | bc -l) )); then
  echo "⚠️  LCP exceeds threshold: ${LCP}ms"
fi
```

---

## 5. Multi-Page Testing Workflows

### Tab Management

```bash
# Open multiple pages in tabs
node pages.js --action new --url https://example.com/page1 --close false
node pages.js --action new --url https://example.com/page2 --close false
node pages.js --action new --url https://example.com/page3 --close false

# List all open pages
node pages.js --action list

# Switch to first tab and interact
node pages.js --action switch --index 0 --close false
node click.js --selector ".button-on-page1" --close false

# Switch to second tab and interact
node pages.js --action switch --index 1 --close false
node fill.js --selector "#input-on-page2" --value "test" --close false

# Close specific page
node pages.js --action close --index 2
```

### Parallel Page Testing

```bash
# Open test page and reference page side-by-side
node pages.js --action new --url https://staging.example.com --close false
node pages.js --action new --url https://production.example.com --close false

# Capture screenshots from both
node pages.js --action switch --index 0 --close false
node screenshot.js --output ./docs/screenshots/staging.png --close false

node pages.js --action switch --index 1 --close false
node screenshot.js --output ./docs/screenshots/production.png
```

---

## 6. Device Emulation Testing

### Network Throttling

```bash
# Test on Slow 3G
node emulate-network.js --profile "Slow 3G" --close false
node navigate.js --url https://example.com --close false
node performance.js | jq '.vitals.LCP'

# Test on Fast 3G
node emulate-network.js --profile "Fast 3G" --close false
node navigate.js --url https://example.com --close false
node performance.js | jq '.vitals.LCP'

# Test offline scenario
node emulate-network.js --profile "Offline" --close false
node navigate.js --url https://example.com | jq '.error'
```

### CPU Throttling

```bash
# Test with 4x CPU slowdown
node emulate-cpu.js --rate 4 --close false
node navigate.js --url https://example.com --close false
node performance.js | jq '.vitals'

# Compare with no throttling
node emulate-cpu.js --rate 1 --close false
node navigate.js --url https://example.com --close false
node performance.js | jq '.vitals'
```

### Combined Device Simulation

```bash
# Simulate mobile 3G experience
echo "Testing mobile 3G performance..."
node emulate-network.js --profile "Slow 3G" --close false
node emulate-cpu.js --rate 4 --close false
node performance.js --url https://example.com | jq '{
  LCP: .vitals.LCP,
  FID: .vitals.FID,
  CLS: .vitals.CLS
}'
```

---

## 7. File Upload Automation

### Single File Upload

```bash
# Navigate to upload page
node navigate.js --url https://example.com/upload --close false

# Upload file
node upload.js \
  --selector "#file-input" \
  --file /tmp/document.pdf \
  --close false

# Submit upload form
node click.js --selector "button[type=submit]"
```

### Multiple File Upload

```bash
# Upload multiple files sequentially
for file in /tmp/uploads/*.jpg; do
  node upload.js \
    --url https://example.com/gallery/upload \
    --selector "#photo-input" \
    --file "$file" \
    --close false

  node click.js --selector ".upload-button" --close false
  sleep 2  # Wait for upload to complete
done
```

### Upload with Progress Monitoring

```bash
# Upload and monitor console for progress events
node navigate.js --url https://example.com/upload --close false

# Start upload
node upload.js --selector "#file-input" --file /tmp/large-file.zip --close false
node click.js --selector ".submit-button" --close false

# Monitor progress
node console.js --types log --duration 30000 | jq '.messages[] | select(.text | contains("progress"))'
```

---

## 8. Dropdown Menu Testing

### Hover-Triggered Dropdowns

```bash
# Hover over menu to reveal dropdown
node hover.js \
  --url https://example.com \
  --selector ".menu-trigger" \
  --wait-for ".dropdown-menu" \
  --close false

# Click dropdown item
node click.js --selector ".dropdown-menu li:first-child"
```

### Multi-Level Menu Navigation

```bash
# Navigate through nested menus
node hover.js --url https://example.com --selector ".main-menu > li:nth-child(2)" --close false
sleep 1
node hover.js --selector ".submenu > li:nth-child(3)" --close false
sleep 1
node click.js --selector ".submenu-item a"
```

### Dropdown with Dynamic Content

```bash
# Open dropdown and wait for AJAX content
node hover.js \
  --url https://example.com \
  --selector ".menu-trigger" \
  --wait-for ".dropdown-menu.loaded" \
  --timeout 10000 \
  --close false

# Extract dropdown items
node evaluate.js --script "
  Array.from(document.querySelectorAll('.dropdown-menu li')).map(li => li.textContent)
" | jq '.result'
```

---

## 9. Drag and Drop Workflows

### Simple Drag and Drop

```bash
# Drag item to target
node drag.js \
  --url https://example.com/kanban \
  --from ".card[data-id='123']" \
  --to ".column[data-status='done']"
```

### Reordering Items

```bash
# Reorder list items
node drag.js \
  --url https://example.com/sortable-list \
  --from "li:nth-child(5)" \
  --to "li:nth-child(1)" \
  --close false

# Verify new order
node evaluate.js --script "
  Array.from(document.querySelectorAll('li')).map(li => li.textContent)
" | jq '.result'
```

---

## 10. Dialog Handling

### JavaScript Alerts

```bash
# Handle alert dialog
node navigate.js --url https://example.com/alert-page --close false

# Click trigger that shows alert
node click.js --selector ".show-alert" --close false

# Dialog is auto-accepted by default
# To manually handle, use:
node dialog.js --action accept --message "Alert handled"
```

### Confirm Dialogs

```bash
# Accept confirmation
node dialog.js --url https://example.com --action accept --trigger ".delete-button"

# Reject confirmation
node dialog.js --url https://example.com --action dismiss --trigger ".cancel-button"
```

### Prompt Dialogs

```bash
# Provide input to prompt
node dialog.js \
  --url https://example.com \
  --action accept \
  --input "User input text" \
  --trigger ".show-prompt"
```

---

## Best Practices

### 1. Always Chain Related Commands

Use `--close false` to keep browser open between related commands for better performance:

```bash
# ✅ Good - reuses browser
node navigate.js --url https://example.com --close false
node fill.js --selector "#search" --value "query" --close false
node click.js --selector "button"

# ❌ Bad - relaunches browser each time
node navigate.js --url https://example.com
node fill.js --selector "#search" --value "query" --url https://example.com
node click.js --selector "button" --url https://example.com
```

### 2. Use Appropriate Wait Strategies

Choose wait strategy based on page behavior:

```bash
# Fast static page
node navigate.js --url https://example.com --wait-until load

# AJAX-heavy page
node navigate.js --url https://example.com --wait-until networkidle2

# Page with continuous activity
node navigate.js --url https://example.com --wait-until domcontentloaded
```

### 3. Extract Data Efficiently

Use `jq` to parse JSON output:

```bash
# Extract specific field
node performance.js --url https://example.com | jq '.vitals.LCP'

# Filter array
node network.js --url https://example.com | jq '.requests[] | select(.method == "POST")'

# Transform data
node evaluate.js --script "..." | jq '.result | map({title, link})'
```

### 4. Handle Errors Gracefully

Check exit codes and validate JSON:

```bash
if node navigate.js --url https://example.com > /tmp/result.json; then
  jq '.title' /tmp/result.json
else
  echo "Navigation failed"
  exit 1
fi
```

### 5. Save Artifacts Systematically

Organize screenshots and traces:

```bash
# Date-stamped screenshots
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
node screenshot.js \
  --url https://example.com \
  --output "./docs/screenshots/${TIMESTAMP}-homepage.png"

# Organized by feature
node screenshot.js \
  --url https://example.com/checkout \
  --output "./docs/screenshots/checkout/step-1.png"
```

---

## Workflow Templates

### Regression Testing Template

```bash
#!/bin/bash
# regression-test.sh

URLS=(
  "https://example.com/"
  "https://example.com/about"
  "https://example.com/contact"
)

for url in "${URLS[@]}"; do
  echo "Testing $url..."

  # Check console errors
  ERROR_COUNT=$(node console.js --url "$url" --types error | jq '.messageCount')

  # Check performance
  LCP=$(node performance.js --url "$url" | jq '.vitals.LCP')

  # Capture screenshot
  FILENAME=$(echo "$url" | sed 's|https://||; s|/|-|g').png
  node screenshot.js --url "$url" --output "./docs/screenshots/$FILENAME"

  echo "  Errors: $ERROR_COUNT"
  echo "  LCP: ${LCP}ms"
done
```

### Monitoring Template

```bash
#!/bin/bash
# monitor-site.sh

while true; do
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

  # Check if site is up
  RESULT=$(node navigate.js --url https://example.com)
  SUCCESS=$(echo "$RESULT" | jq -r '.success')

  if [ "$SUCCESS" == "true" ]; then
    echo "[$TIMESTAMP] ✓ Site is up"
  else
    echo "[$TIMESTAMP] ✗ Site is down!"
    # Send alert (email, Slack, etc.)
  fi

  sleep 300  # Check every 5 minutes
done
```
