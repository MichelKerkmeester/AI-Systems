---
name: code-systematic-debugging
description: Use when encountering browser console errors, CSS layout issues, JavaScript animation bugs, or unexpected behavior in Webflow projects - four-phase framework (root cause investigation, pattern analysis, hypothesis testing, implementation) that ensures understanding before attempting fixes
allowed-tools: Read, Bash, Grep, Glob, WebFetch
---

# Systematic Debugging - Frontend & Webflow Context

Random fixes waste time and create new bugs. Quick patches mask underlying issues in browser environments where symptoms manifest differently across devices, browsers, and viewport sizes.

**Core principle**: ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

---

## 1. 🎯 WHEN TO USE

**Use for ANY frontend technical issue**:
- Browser console errors (JavaScript, network, resource loading)
- CSS layout bugs (flexbox, grid, positioning, responsive breakpoints)
- Animation issues (timing, sequencing, performance)
- Event handler failures (clicks not registering, forms not submitting)
- Video/media loading problems (HLS streams, fallbacks, autoplay)
- DOM manipulation bugs (elements not appearing, incorrect updates)
- Performance problems (slow page load, janky animations, memory leaks)
- Cross-browser inconsistencies
- Mobile/responsive issues

**Use this ESPECIALLY when**:
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue
- Issue only appears in certain browsers/devices
- Problem is intermittent or timing-dependent

**Don't skip when**:
- Issue seems simple (simple bugs have root causes too)
- You're in a hurry (rushing guarantees rework)
- "It works on my machine" (environment matters)
- Manager wants it fixed NOW (systematic is faster than thrashing)

**Core principle**: Evidence-based debugging + browser DevTools = reliable fixes

---

## 2. 🛠️ THE FOUR PHASES

You MUST complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

#### Step 1: Read Error Messages Carefully
- Open browser DevTools console (F12 or Cmd+Option+I)
- Don't skip past errors or warnings
- They often contain the exact solution
- Read stack traces completely
- Note file names, line numbers, error codes
- Check Network tab for failed requests
- Review Console tab for JavaScript errors
- Inspect Elements tab for CSS/DOM issues

**Common Browser Errors**:
```javascript
// Uncaught TypeError: Cannot read property 'X' of undefined
// → Variable is undefined, check initialization

// Failed to load resource: net::ERR_BLOCKED_BY_CLIENT
// → Ad blocker or browser extension blocking resource

// Uncaught ReferenceError: $ is not defined
// → jQuery not loaded or loading order incorrect

// Mixed Content: The page was loaded over HTTPS...
// → Trying to load HTTP resource on HTTPS page
```

#### Step 2: Reproduce Consistently
- Can you trigger it reliably?
- Does it happen on every page load?
- Is it timing-dependent (race condition)?
- Does it only occur in certain browsers?
- Does it only happen on certain viewport sizes?
- Does it require specific user actions?
- If not reproducible → gather more data, don't guess

**Browser Testing Checklist**:
```markdown
□ Chrome/Edge (Chromium)
□ Firefox
□ Safari (if macOS available)
□ Mobile Chrome (use DevTools device emulation)
□ Mobile Safari (use DevTools device emulation)
□ Different viewport sizes (320px, 768px, 1024px, 1920px)
```

#### Step 3: Check Recent Changes
- What changed that could cause this?
- `git log -5` to see recent commits
- `git diff` to see current changes
- New dependencies added?
- CDN version changes (HLS.js, jQuery, etc.)?
- Webflow republish introduced changes?
- Environment differences (dev vs. prod)?

#### Step 4: Gather Evidence in Browser DevTools

**WHEN system has multiple components (UI → JavaScript → API → CDN):**

**BEFORE proposing fixes, add diagnostic instrumentation:**

```javascript
// Console.log at component boundaries
console.log('[PageLoader] Initializing...', {
  element: loaderElement,
  duration: ANIMATION_DURATION,
  timestamp: Date.now()
});

// Log function entry/exit
function initializeHeroVideo() {
  console.log('[HeroVideo] Init start', {
    videoElement: document.querySelector('[video-hero]'),
    hlsSupported: Hls.isSupported()
  });

  // ... implementation ...

  console.log('[HeroVideo] Init complete');
}

// Log state changes
element.addEventListener('transitionend', (event) => {
  console.log('[Animation] Transition end', {
    propertyName: event.propertyName,
    elapsedTime: event.elapsedTime,
    element: event.target
  });
});
```

**Run once to gather evidence showing WHERE it breaks**
**THEN analyze evidence to identify failing component**
**THEN investigate that specific component**

**Example (multi-layer frontend system)**:
```javascript
// Layer 1: DOM Ready
console.log('=== Document State ===', {
  readyState: document.readyState,
  bodyLoaded: !!document.body,
  scriptsLoaded: document.querySelectorAll('script').length
});

// Layer 2: External Dependencies
console.log('=== Dependencies ===', {
  jQuery: typeof $ !== 'undefined',
  HLS: typeof Hls !== 'undefined',
  customLibs: typeof MyApp !== 'undefined'
});

// Layer 3: Element Availability
console.log('=== DOM Elements ===', {
  videoElement: document.querySelector('[video-player]'),
  loaderElement: document.querySelector('[page-loader]'),
  navElement: document.querySelector('[nav-menu]')
});

// Layer 4: Event Binding
console.log('=== Event Listeners ===', {
  clickHandlers: document.querySelectorAll('[data-click]').length,
  formHandlers: document.querySelectorAll('form').length
});
```

**This reveals**: Which layer fails (DOM ✓, Dependencies ✗)

#### Step 5: Trace Data Flow

**WHEN error is deep in call stack:**

**Use browser DevTools Debugger**:
- Set breakpoints in Sources tab
- Step through code execution
- Inspect variable values at each step
- Check call stack panel

**Quick version**:
- Where does bad value originate?
- What called this with bad value?
- Keep tracing up until you find the source
- Fix at source, not at symptom

**Browser-specific tracing**:
```javascript
// Add debugger statement
function problematicFunction(data) {
  debugger; // Execution pauses here
  // Inspect data in DevTools
  processData(data);
}

// Add stack trace logging
function trackError(error) {
  console.error('Error occurred:', error);
  console.trace(); // Prints full call stack
}
```

---

### Phase 2: Pattern Analysis

**Find the pattern before fixing:**

#### Step 1: Find Working Examples
- Locate similar working code in same codebase
- Check other pages/components that work correctly
- What works that's similar to what's broken?
- Review past implementations in git history

**Example**: If video player broken on page A, check working video player on page B

#### Step 2: Compare Against References
- If implementing pattern, read reference implementation COMPLETELY
- Check MDN Web Docs for browser API documentation
- Review library documentation (HLS.js, jQuery, etc.)
- Don't skim - read every line
- Understand the pattern fully before applying

**Useful References**:
- MDN Web Docs: https://developer.mozilla.org
- Can I Use: https://caniuse.com (browser compatibility)
- CSS Tricks: https://css-tricks.com (CSS patterns)
- Library docs (HLS.js, jQuery, etc.)

#### Step 3: Identify Differences
- What's different between working and broken?
- List every difference, however small
- Don't assume "that can't matter"
- Check CSS specificity differences
- Compare DOM structure
- Verify JavaScript execution order

**Comparison Checklist**:
```markdown
□ HTML structure identical?
□ CSS classes applied the same?
□ JavaScript execution order same?
□ Event listeners attached correctly?
□ Dependencies loaded in same order?
□ Webflow interactions configured identically?
□ Custom attributes present?
```

#### Step 4: Understand Dependencies
- What other components does this need?
- What settings, config, environment?
- What assumptions does it make?
- Browser API availability?
- Polyfills required?

---

### Phase 3: Hypothesis and Testing

**Scientific method for frontend debugging:**

#### Step 1: Form Single Hypothesis
- State clearly: "I think X is the root cause because Y"
- Write it down in comments or console
- Be specific, not vague

**Example**:
```javascript
// HYPOTHESIS: Video not loading because HLS.js CDN blocked by ad blocker
// EVIDENCE: Console shows "Failed to load resource" for hls.js
// TEST: Load HLS.js from different CDN or local copy
```

#### Step 2: Test Minimally
- Make the SMALLEST possible change to test hypothesis
- One variable at a time
- Don't fix multiple things at once
- Use browser DevTools for live testing

**Testing Techniques**:
```javascript
// Technique 1: Console testing (no file changes)
// Test directly in browser console
document.querySelector('[video-player]').play();

// Technique 2: Temporary code injection
// Add script tag in DevTools Elements panel
<script>
  console.log('Testing hypothesis...');
  // Your test code
</script>

// Technique 3: DevTools overrides
// Sources → Overrides → Enable local overrides
// Edit files live, see changes immediately
```

#### Step 3: Verify Before Continuing
- Did it work? Yes → Phase 4
- Didn't work? Form NEW hypothesis
- DON'T add more fixes on top

**Verification Checklist**:
```markdown
□ Issue resolved in current browser?
□ Issue resolved across all browsers?
□ Issue resolved on mobile viewports?
□ No new console errors introduced?
□ Animation timing still correct?
□ Performance not degraded?
```

#### Step 4: When You Don't Know
- Say "I don't understand X"
- Don't pretend to know
- Ask for help
- Research more (MDN, Stack Overflow, etc.)
- Check browser compatibility tables

---

### Phase 4: Implementation

**Fix the root cause, not the symptom:**

#### Step 1: Document the Fix
- Add code comments explaining WHY
- Note browser compatibility considerations
- Document any workarounds needed
- Reference related issues in comments

**Example**:
```javascript
// FIX: Safari doesn't support autoplay with sound
// See: https://webkit.org/blog/7734/auto-play-policy-changes-for-macos/
// Solution: Mute video initially, unmute on user interaction
videoElement.muted = true;
videoElement.play();

document.addEventListener('click', () => {
  videoElement.muted = false;
}, { once: true });
```

#### Step 2: Implement Single Fix
- Address the root cause identified
- ONE change at a time
- No "while I'm here" improvements
- No bundled refactoring

#### Step 3: Verify Fix
- Test in all target browsers
- Test on all viewport sizes
- Check console for errors
- Verify animations smooth
- Test user interactions

**Browser Testing Matrix**:
```markdown
| Browser | Desktop | Mobile | Result |
|---------|---------|--------|--------|
| Chrome  | ✓       | ✓      | Pass   |
| Firefox | ✓       | N/A    | Pass   |
| Safari  | ✓       | ✓      | Pass   |
```

#### Step 4: If Fix Doesn't Work
- STOP
- Count: How many fixes have you tried?
- If < 3: Return to Phase 1, re-analyze with new information
- **If ≥ 3: STOP and question the approach (step 5 below)**
- DON'T attempt Fix #4 without reconsidering strategy

#### Step 5: If 3+ Fixes Failed: Question Architecture
**Pattern indicating architectural problem**:
- Each fix reveals new issue in different place
- Fixes require "massive refactoring" to implement
- Each fix creates new symptoms elsewhere
- Browser inconsistencies suggest design flaw

**STOP and question fundamentals**:
- Is this pattern fundamentally sound for browsers?
- Are we fighting against browser defaults?
- Should we refactor architecture vs. continue fixing symptoms?
- Is there a simpler, more browser-friendly approach?

**Discuss with project lead before attempting more fixes**

---

## 3. 📋 DECISION MATRIX

| Scenario | Phase to Start | Key Actions | Notes |
|----------|---------------|-------------|-------|
| Console error | Phase 1 | Read full stack trace | Don't skip error details |
| CSS layout bug | Phase 1 | Inspect element, check computed styles | Use DevTools Elements panel |
| Animation jank | Phase 1 | Check Performance tab, frame rate | Look for forced reflows |
| Click not working | Phase 1 | Check event listeners, z-index | Use DevTools Event Listeners panel |
| Mobile-only bug | Phase 1 | Device emulation, remote debugging | Real device testing crucial |
| Cross-browser issue | Phase 2 | Compare browser console outputs | Check Can I Use for compatibility |
| Intermittent bug | Phase 1 | Add extensive logging, race condition? | Timing issues require patience |
| After Webflow publish | Phase 1 | Check what changed in Webflow | Compare before/after HTML |

---

## 4. ⚠️ COMMON MISTAKES

**Skipping console inspection**:
- **Problem**: Missing obvious error messages
- **Fix**: ALWAYS open DevTools console first

**Testing only in one browser**:
- **Problem**: Issue may be browser-specific
- **Fix**: Test in Chrome, Firefox, Safari minimum

**Ignoring mobile viewports**:
- **Problem**: Responsive issues missed until production
- **Fix**: Always test at 320px, 768px, 1024px, 1920px

**Changing multiple things at once**:
- **Problem**: Can't isolate what worked
- **Fix**: One change at a time, test after each

**Not checking network tab**:
- **Problem**: Missing failed resource loads
- **Fix**: Always check Network tab for 404s, CORS errors

**Assuming Webflow code is bug-free**:
- **Problem**: Webflow-generated code can have issues
- **Fix**: Inspect generated HTML/CSS, may need custom code

**Using `!important` as first resort**:
- **Problem**: Masks specificity issues
- **Fix**: Understand CSS cascade, use proper specificity

---

## 5. 📖 RULES

### ALWAYS

- Open browser DevTools console BEFORE attempting fixes
- Read complete error messages and stack traces
- Test across multiple browsers (Chrome, Firefox, Safari minimum)
- Test on mobile viewports (320px, 768px minimum)
- Check Network tab for failed resource loads
- Verify Elements panel for CSS/DOM issues
- Add console.log statements to trace execution
- Test one change at a time
- Verify fix works before marking complete
- Document browser-specific workarounds in comments

### NEVER

- Skip console error messages
- Test only in one browser
- Ignore mobile viewport issues
- Change multiple things simultaneously without testing
- Use `!important` without understanding why it's needed
- Assume "it works on my machine" means it's fixed
- Proceed with 4th fix attempt without questioning approach
- Ignore timing/animation issues as "good enough"
- Skip Network tab inspection
- Forget to test after Webflow republish

### ESCALATE IF

- Bug only occurs in production, not locally
- Issue requires changing Webflow-generated code
- Cross-browser compatibility cannot be achieved
- Performance issues require architecture changes
- Bug intermittent despite extensive logging
- Client browser configurations causing issues
- CDN or third-party library causing problems

---

## 6. 💡 EXAMPLE WORKFLOWS

### Example 1: Video Not Playing

```text
User: "Video hero isn't loading on the homepage"

Claude: "I'll use systematic debugging to investigate this."

[Phase 1: Root Cause Investigation]
> Opening browser DevTools...
> Console shows: "Uncaught TypeError: Hls is not defined"

[Step 1: Read Error]
Error indicates HLS.js library not loaded

[Step 2: Check Network Tab]
> Checking Network tab...
> hls.js CDN request: Status 200 (loaded successfully)
> BUT: Script executes before HLS.js fully parsed

[Step 3: Recent Changes]
> git log -3
> Last commit: "Update CDN versions"
> HLS.js moved from <head> to async loading

[Root Cause Identified]:
Script execution timing - our code runs before HLS.js ready

[Phase 2: Pattern Analysis]
> Checking working video implementation on About page...
> About page loads HLS.js in <head> WITHOUT async
> Homepage uses async for performance
> DIFFERENCE: Async causes race condition

[Phase 3: Hypothesis]
HYPOTHESIS: Adding 'defer' instead of 'async' will fix timing
REASONING: Defer maintains execution order, async doesn't

[Testing]:
> DevTools → Sources → Overrides
> Changed async to defer on HLS.js script
> Reload page...
> ✓ Video loads correctly
> ✓ No console errors

[Phase 4: Implementation]
> Updating src/0_html/home.html
> Changed: <script src="hls.js" async></script>
> To:      <script src="hls.js" defer></script>

[Verification]:
✓ Tested in Chrome - works
✓ Tested in Firefox - works
✓ Tested in Safari - works
✓ Tested mobile viewport (375px) - works
✓ No console errors
✓ Page load performance maintained

Fixed in single attempt using systematic approach.
```

### Example 2: CSS Layout Breaking on Mobile

```text
User: "Navigation menu overlaps content on mobile"

Claude: "I'll debug this systematically."

[Phase 1: Root Cause Investigation]
> Opening DevTools, switching to mobile emulation...
> iPhone SE (375px) viewport selected

[Step 1: Visual Inspection]
> Elements panel shows nav has fixed height: 80px
> Content starts at top: 0
> Overlap confirmed

[Step 2: Check Computed Styles]
> Nav element: position: fixed; top: 0; z-index: 999;
> Content element: margin-top: 0;
> ISSUE: Content not accounting for fixed nav height

[Step 3: Recent Changes]
> git diff
> Last change: Removed padding-top from body
> Developer note: "Cleaning up unused styles"
> THIS IS THE CAUSE

[Phase 2: Pattern Analysis]
> Checking desktop view (1920px)...
> Works fine on desktop
> DIFFERENCE: Desktop has hero section that creates space
> Mobile layout doesn't have same hero height

[Phase 3: Hypothesis]
HYPOTHESIS: Adding margin-top to main content will fix overlap
REASONING: Standard pattern for fixed header layouts

[Testing]:
> DevTools → Elements → Edit as HTML
> Added: main { margin-top: 80px; }
> ✓ Overlap fixed on mobile
> Checking desktop... ✓ Still works

[Phase 4: Implementation]
> Updating src/1_css/global/layout.css
> Added responsive margin:

/* Fix for fixed navigation overlap */
main {
  margin-top: 80px; /* Height of fixed nav */
}

@media (max-width: 767px) {
  main {
    margin-top: 60px; /* Mobile nav height */
  }
}

[Verification]:
✓ Mobile (375px) - content below nav
✓ Tablet (768px) - content below nav
✓ Desktop (1920px) - content below nav
✓ All viewport transitions smooth

Fixed in single attempt.
```

---

## 7. 🎓 SUCCESS CRITERIA

**Debugging is successful when**:
- ✅ Root cause identified and documented
- ✅ Fix addresses cause, not symptom
- ✅ Tested across all target browsers
- ✅ Tested on mobile and desktop viewports
- ✅ No console errors introduced
- ✅ Performance not degraded
- ✅ Code comments explain WHY fix needed
- ✅ Browser-specific workarounds documented
- ✅ Single fix resolved issue (not multiple attempts)

**Quality gates**:
- Did you open DevTools console?
- Did you read complete error messages?
- Did you test in multiple browsers?
- Did you test on mobile viewports?
- Can you explain WHY the fix works?
- Did you document browser compatibility notes?

---

## 8. 🔗 INTEGRATION POINTS

### Pairs With
- **code-verification-before-completion** - Always verify fixes in browser
- **code-condition-based-waiting** - For timing/async issues
- **code-defense-in-depth** - Prevent bugs through validation
- **code-root-cause-tracing** - For complex call stack issues

### Browser Tools Used
- Chrome DevTools
- Firefox Developer Tools
- Safari Web Inspector
- Device Emulation
- Network Monitor
- Performance Profiler

### Documentation References
- MDN Web Docs (browser APIs)
- Can I Use (browser compatibility)
- CSS Tricks (CSS patterns)
- Library documentation (HLS.js, jQuery, etc.)

---

## 9. 🔧 TROUBLESHOOTING

### "Can't Reproduce the Bug"

**Actions**:
1. Ask user for specific steps to reproduce
2. Test in different browsers
3. Test on different viewport sizes
4. Clear browser cache and retry
5. Check if user has browser extensions affecting behavior
6. Use remote debugging for user's actual device

### "Works in DevTools But Not in Production"

**Possible Causes**:
- Cache issues (hard refresh: Cmd+Shift+R or Ctrl+Shift+R)
- CDN propagation delay
- Environment variables different
- Build process issues
- Webflow publish not completed

**Actions**:
1. Hard refresh browser
2. Open DevTools Network tab, disable cache checkbox
3. Check CDN version numbers
4. Verify Webflow publish completed successfully

### "Different Behavior Across Browsers"

**Actions**:
1. Check Can I Use for browser support
2. Add browser-specific polyfills if needed
3. Test vendor prefixes for CSS
4. Check JavaScript feature support
5. Consider progressive enhancement approach
6. Document known browser limitations

---

## 10. 📚 REFERENCES

### Essential Resources
- **MDN Web Docs**: https://developer.mozilla.org
- **Can I Use**: https://caniuse.com
- **CSS Tricks**: https://css-tricks.com
- **Browser DevTools Docs**:
  - Chrome: https://developer.chrome.com/docs/devtools/
  - Firefox: https://firefox-source-docs.mozilla.org/devtools-user/
  - Safari: https://developer.apple.com/safari/tools/

### Webflow-Specific
- Webflow University: https://university.webflow.com
- Webflow Forums: https://discourse.webflow.com
- Custom Code Documentation

### Project Standards
- AGENTS.md - Project conventions
- Document Style Guide - Documentation standards
