---
name: code-root-cause-tracing
description: Use when errors occur deep in JavaScript execution, event handlers fail mysteriously, or animations break unexpectedly - systematically traces bugs backward through call stack and event chain using browser DevTools to identify source of invalid data or incorrect behavior
allowed-tools: Read, Bash, Grep
---

# Root Cause Tracing - Frontend Debugging

Bugs often manifest deep in the execution flow (click handler doesn't fire, animation starts in wrong state, video fails to load). Your instinct is to fix where the error appears, but that's treating a symptom.

**Core principle**: Trace backward through the call chain and event flow until you find the original trigger, then fix at the source.

---

## 1. 🎯 WHEN TO USE

**Use when**:
- Error happens deep in call stack (not at entry point)
- Event handler fails but unclear why
- Animation starts with wrong values
- Video/media initializes incorrectly
- DOM element in unexpected state
- Click not registering but unclear where to fix
- Form submission fails silently
- Data arrives corrupted at destination
- State management issue (wrong value propagated)

**Symptoms that indicate need**:
- Error appears far from actual problem
- Multiple functions between trigger and symptom
- Unclear where invalid data originated
- "It worked before" but can't find what changed
- Issue only appears in certain conditions

**Core principle**: Browser DevTools + console.log tracing + breakpoints = root cause identification

---

## 2. 🛠️ THE TRACING PROCESS

### Step 1: Observe the Symptom

```javascript
// Console error:
// Uncaught TypeError: Cannot read property 'play' of null
//   at VideoPlayer.play (video-player.js:45)
```

**What this tells us**:
- `video` element is null at line 45
- Error in `play()` method
- But WHY is it null?

### Step 2: Find Immediate Cause

**What code directly causes this?**

```javascript
// video-player.js:45
play() {
  this.video.play(); // ← this.video is null
}
```

**Question**: Why is `this.video` null?

### Step 3: Trace One Level Up

**What called `play()`?**

```javascript
// Using DevTools Call Stack or console.trace()
play() ← initializePlayer() ← document.addEventListener('DOMContentLoaded')
```

**Check `initializePlayer()`**:

```javascript
function initializePlayer() {
  const player = new VideoPlayer('[video-hero]');
  player.play(); // Called play before video initialized
}
```

**Problem found**: `play()` called immediately after constructor, but video element not yet set.

### Step 4: Keep Tracing Up

**What sequence of events led here?**

```javascript
// Execution flow:
1. DOMContentLoaded fires
2. initializePlayer() runs
3. new VideoPlayer() constructor runs
4. Constructor querySelector('[video-hero]') returns null ← ROOT CAUSE
5. this.video = null
6. play() called on null video
7. Error!
```

**Why did querySelector return null?**
- Element doesn't exist yet (script in <head>, runs before <body>)
- Wrong selector
- Element inside iframe
- Webflow interaction hasn't added it yet

### Step 5: Fix at Source

**DON'T fix the symptom** (adding null check in play()):
```javascript
// ❌ SYMPTOM FIX: Masks the real problem
play() {
  if (!this.video) return; // Silent failure, hard to debug
  this.video.play();
}
```

**DO fix the root cause** (ensure element exists before initialization):
```javascript
// ✅ ROOT CAUSE FIX: Ensures proper initialization
async function initializePlayer() {
  // Wait for element to exist
  const element = await waitForElement('[video-hero]');

  const player = new VideoPlayer('[video-hero]');
  await player.initialize(); // Wait for initialization
  player.play(); // Now safe to play
}
```

---

## 3. 📋 TRACING TECHNIQUES

### Technique 1: Browser DevTools Debugger

**Most powerful tracing tool**:

```javascript
function VideoPlayer(selector) {
  debugger; // Execution pauses here

  this.video = document.querySelector(selector);

  // In DevTools:
  // - Check "this.video" value in Scope panel
  // - Check "selector" parameter
  // - Step through line-by-line
  // - Inspect Call Stack panel
}
```

**DevTools Features**:
- **Breakpoints**: Click line number in Sources tab
- **Conditional breakpoints**: Right-click line → "Add conditional breakpoint"
- **Call Stack**: See full execution path
- **Scope**: Inspect all variables at current point
- **Watch**: Monitor specific expressions
- **Step Over/Into/Out**: Navigate execution

**Setting Breakpoints**:
1. Open DevTools (F12 / Cmd+Option+I)
2. Go to Sources tab
3. Find your JavaScript file
4. Click line number to set breakpoint
5. Refresh page
6. Execution pauses at breakpoint

### Technique 2: console.trace() - Print Call Stack

```javascript
function problematicFunction(data) {
  console.trace('[VideoPlayer] play() called with:', {
    video: this.video,
    data: data,
    readyState: this.video?.readyState
  });

  // Shows full call stack in console
  this.video.play();
}
```

**Output**:
```
[VideoPlayer] play() called with: { video: null, ... }
  play @ video-player.js:45
  initializePlayer @ app.js:120
  (anonymous) @ app.js:15
  DOMContentLoaded
```

### Technique 3: Console Logging at Boundaries

**Add logs at component boundaries**:

```javascript
class VideoPlayer {
  constructor(selector) {
    console.log('[VideoPlayer] Constructor called', {
      selector: selector,
      timestamp: Date.now(),
      documentReady: document.readyState
    });

    this.video = document.querySelector(selector);

    console.log('[VideoPlayer] Query result', {
      found: !!this.video,
      element: this.video,
      allVideos: document.querySelectorAll('video').length
    });
  }

  async initialize() {
    console.log('[VideoPlayer] Initialize start', {
      hasVideo: !!this.video,
      videoSrc: this.video?.dataset.src
    });

    // ... initialization logic ...

    console.log('[VideoPlayer] Initialize complete');
  }

  play() {
    console.log('[VideoPlayer] play() called', {
      hasVideo: !!this.video,
      readyState: this.video?.readyState,
      paused: this.video?.paused
    });

    if (!this.video) {
      console.error('[VideoPlayer] play() called with null video!');
      console.trace(); // Print call stack
      return;
    }

    this.video.play();
  }
}
```

### Technique 4: Event Listener Inspection

**Trace event handler issues**:

```javascript
// Which events are attached?
getEventListeners(document.querySelector('[nav-button]'));

// Output shows all listeners:
// {
//   click: [
//     { listener: ƒ, once: false, passive: false, type: "click" }
//   ]
// }
```

**Check if events fire**:

```javascript
document.querySelector('[nav-button]').addEventListener('click', (e) => {
  console.log('[NavButton] Click event fired', {
    target: e.target,
    currentTarget: e.currentTarget,
    timestamp: Date.now(),
    eventPhase: e.eventPhase
  });

  console.trace('[NavButton] Click trace');
}, { capture: true }); // Capture phase to see event early
```

### Technique 5: Mutation Observer - Track DOM Changes

**When element appears/disappears mysteriously**:

```javascript
const observer = new MutationObserver((mutations) => {
  mutations.forEach((mutation) => {
    console.log('[MutationObserver] DOM changed', {
      type: mutation.type,
      target: mutation.target,
      addedNodes: mutation.addedNodes,
      removedNodes: mutation.removedNodes
    });

    console.trace('[MutationObserver] Change source');
  });
});

observer.observe(document.body, {
  childList: true,
  subtree: true,
  attributes: true
});
```

---

## 4. 📖 RULES

### ALWAYS

- Use browser DevTools debugger for complex issues
- Add console.trace() to find call stack
- Log at component boundaries (entry/exit)
- Check DevTools Call Stack panel
- Inspect event listeners with getEventListeners()
- Trace backward from symptom to source
- Fix at the source, not symptom
- Document root cause in comments
- Remove debug logs after fixing (or use DEBUG flag)
- Test that fix actually addresses root cause

### NEVER

- Fix only where error appears without tracing
- Add symptom fixes (null checks without understanding why)
- Skip DevTools investigation
- Guess at root cause without evidence
- Leave production console.log statements
- Stop at first function in stack (keep tracing up)
- Assume current function is the problem
- Fix without understanding WHY it broke

### ESCALATE IF

- Cannot trace backward (dead end)
- Root cause in third-party library
- Browser-specific behavior causing issue
- Webflow-generated code is source
- Issue requires architectural change

---

## 5. ⚠️ COMMON MISTAKES

**Fixing at symptom point**:
- **Problem**: Add null check where error appears
- **Fix**: Trace back to find WHY it's null

**Not using DevTools**:
- **Problem**: Trying to debug with console.log only
- **Fix**: Use debugger breakpoints, call stack, scope inspection

**Removing logs too early**:
- **Problem**: Delete console.log before confirming fix
- **Fix**: Keep logs until root cause fix verified

**Stopping at first function**:
- **Problem**: Fix first function in stack, not actual source
- **Fix**: Trace all the way back to triggering event

**No documentation**:
- **Problem**: Fix applied but no comment explaining why
- **Fix**: Add comment explaining root cause and fix

---

## 6. 💡 EXAMPLE WORKFLOWS

### Example 1: Click Handler Not Firing

```text
User: "Newsletter signup button doesn't work"

Claude: "I'll trace why the click handler isn't firing."

[SYMPTOM]
Button clicked, nothing happens. No console errors.

[STEP 1: Observe]
> Opening DevTools Console...
> Click button...
> No console output

[STEP 2: Check if handler attached]
> Console: getEventListeners(document.querySelector('[newsletter-button]'))
> Output: {} ← No click listeners!

[STEP 3: Find where handler should be attached]
> Searching code for newsletter button...
> Found in app.js:

function setupNewsletterForm() {
  const button = document.querySelector('[newsletter-button]');
  button.addEventListener('click', handleSignup); // ← This line
}

document.addEventListener('DOMContentLoaded', setupNewsletterForm);

[STEP 4: Check if setupNewsletterForm runs]
> Adding console.log:

function setupNewsletterForm() {
  console.log('[Newsletter] Setting up form');
  const button = document.querySelector('[newsletter-button]');
  console.log('[Newsletter] Button found:', !!button);

  button.addEventListener('click', handleSignup);
}

> Refresh page...
> Console output:
  [Newsletter] Setting up form
  [Newsletter] Button found: false ← ROOT CAUSE!

[STEP 5: Why is button null?]
> Inspecting DOM in Elements tab...
> Button exists with attribute: [newsletter-btn] (not [newsletter-button])

[ROOT CAUSE IDENTIFIED]
Selector mismatch: Code looks for '[newsletter-button]'
but HTML has '[newsletter-btn]'

[FIX AT SOURCE]
Option 1: Update JavaScript selector
function setupNewsletterForm() {
  const button = document.querySelector('[newsletter-btn]'); // Fixed
  ...
}

Option 2: Update HTML attribute (if control over Webflow)
<button newsletter-button>...</button>

[VERIFICATION]
> Applied fix, refreshed page
> Console: getEventListeners(document.querySelector('[newsletter-btn]'))
> Output: { click: [...] } ✓ Handler attached
> Clicked button ✓ Form appears
> Root cause fix successful
```

### Example 2: Animation Starting with Wrong Values

```text
User: "Page loader animation jumps instead of smooth fade"

Claude: "I'll trace why animation values are incorrect."

[SYMPTOM]
Loader immediately at opacity: 0.5 instead of opacity: 1,
then animates to 0.

[STEP 1: Inspect element at start]
> DevTools Elements panel
> Loader element computed opacity: 0.5 ← Wrong starting value

[STEP 2: Check CSS]
[page-loader] {
  opacity: 1; /* Expected */
  transition: opacity 0.8s ease-out;
}

[page-loader].fade-out {
  opacity: 0;
}

> CSS looks correct. Why opacity: 0.5?

[STEP 3: Check JavaScript initialization]
> Searching for page-loader in JS...
> Found initialization:

function initializePageLoader() {
  const loader = document.querySelector('[page-loader]');

  // Set initial state
  loader.style.opacity = '0.5'; // ← FOUND IT!

  // Later...
  loader.classList.add('fade-out');
}

[STEP 4: Trace why opacity set to 0.5]
> Adding console.trace:

function initializePageLoader() {
  console.trace('[PageLoader] Setting opacity to 0.5');
  const loader = document.querySelector('[page-loader]');
  loader.style.opacity = '0.5';
}

> Refresh page
> Console shows call stack:
  initializePageLoader @ app.js:50
  initApp @ app.js:10
  DOMContentLoaded

[STEP 5: Check why 0.5 was chosen]
> Reading git history:
> git log -p app.js | grep -A5 -B5 "opacity = '0.5'"

> Commit message: "Temporary: Set loader to 50% for debugging"
> From 2 weeks ago

[ROOT CAUSE IDENTIFIED]
Debug code left in production. Opacity set to 0.5 for testing,
never removed.

[FIX AT SOURCE]
function initializePageLoader() {
  const loader = document.querySelector('[page-loader]');

  // Remove debug line
  // loader.style.opacity = '0.5'; ← DELETED

  // Let CSS handle initial state
  // opacity: 1 from stylesheet

  setTimeout(() => {
    loader.classList.add('fade-out');
  }, 500);
}

[VERIFICATION]
> Refreshed page
> Loader starts at opacity: 1 ✓
> Fades smoothly to 0 over 0.8s ✓
> No jump ✓
> Root cause fix successful
```

### Example 3: Video Not Loading (Multi-Layer Trace)

```text
User: "Hero video shows black screen"

Claude: "I'll trace through video initialization layers."

[SYMPTOM]
Video element visible but shows black screen.
No console errors.

[LAYER 1: Check if video element exists]
> DevTools Console:
> document.querySelector('[video-hero]')
> Output: <video video-hero>...</video> ✓ Element exists

[LAYER 2: Check if src set]
> document.querySelector('[video-hero]').src
> Output: "" ← Empty string!

[LAYER 3: Check if HLS.js initialized]
> Adding console logs:

async function initializeHeroVideo() {
  console.log('[Video] Init start', {
    element: document.querySelector('[video-hero]'),
    Hls: typeof Hls !== 'undefined'
  });

  const video = document.querySelector('[video-hero]');

  if (typeof Hls === 'undefined') {
    console.error('[Video] HLS.js not loaded');
    return;
  }

  const hls = new Hls();
  console.log('[Video] HLS instance created');

  const source = video.dataset.src;
  console.log('[Video] Source from dataset:', source);

  hls.loadSource(source);
  console.log('[Video] Source loaded');

  hls.attachMedia(video);
  console.log('[Video] Media attached');
}

> Refresh page
> Console output:
  [Video] Init start { element: <video>, Hls: true }
  [Video] HLS instance created
  [Video] Source from dataset: undefined ← FOUND IT!

[LAYER 4: Why is dataset.src undefined?]
> Inspecting element in DevTools:
> <video video-hero></video>
> No data-src attribute!

[LAYER 5: Check if attribute added dynamically]
> Adding MutationObserver:

const observer = new MutationObserver((mutations) => {
  mutations.forEach((mutation) => {
    if (mutation.attributeName === 'data-src') {
      console.log('[Video] data-src changed:', mutation.target.dataset.src);
      console.trace('[Video] Attribute change source');
    }
  });
});

const video = document.querySelector('[video-hero]');
observer.observe(video, { attributes: true });

> Refresh page
> No mutation events ← Attribute never added

[ROOT CAUSE IDENTIFIED]
Webflow element missing data-src attribute in HTML.
Code expects it but it was never set.

[FIX AT SOURCE]
Option 1: Add data-src in Webflow custom attributes
In Webflow: video-hero element → Settings → Custom Attributes
Add: data-src = "path/to/video.m3u8"

Option 2: Fallback to hardcoded source
const source = video.dataset.src || '/videos/hero.m3u8';

Option 3: Check and warn if missing
if (!video.dataset.src) {
  console.error('[Video] data-src attribute missing. Add in Webflow custom attributes.');
  return;
}

[VERIFICATION]
> Added data-src attribute in Webflow
> Republished site
> Refreshed page
> Console: [Video] Source from dataset: /videos/hero.m3u8 ✓
> Video loads and plays ✓
> Root cause fix successful
```

---

## 7. 🎓 SUCCESS CRITERIA

**Root cause tracing is successful when**:
- ✅ Used browser DevTools to investigate
- ✅ Traced call stack to find originating function
- ✅ Identified WHY invalid data occurred
- ✅ Fixed at source, not symptom
- ✅ Documented root cause in code comments
- ✅ Verified fix prevents issue at origin
- ✅ Removed debug console.log statements
- ✅ Can explain full execution path

**Quality gates**:
- Can you draw the execution flow from trigger to error?
- Did you use DevTools debugger?
- Did you fix the root cause or just the symptom?
- Will this fix prevent the issue in all cases?
- Is the fix documented with comments?

---

## 8. 🔗 INTEGRATION POINTS

### Pairs With
- **code-systematic-debugging** - Use tracing in Phase 1 (root cause investigation)
- **code-verification-before-completion** - Verify traced fix works
- **code-defense-in-depth** - Add validation at source after tracing
- **code-condition-based-waiting** - Trace timing/race conditions

### Browser DevTools Features
- **Debugger** - Breakpoints, step through
- **Console** - console.trace(), console.log()
- **Call Stack** - View execution path
- **Scope** - Inspect variables
- **Event Listeners** - getEventListeners()
- **Network** - Trace resource loading
- **Performance** - Trace timing issues

### Tracing Tools
- `console.trace()` - Print call stack
- `debugger;` - Pause execution
- `getEventListeners(element)` - Check attached events
- `MutationObserver` - Track DOM changes
- `Performance.mark()` - Measure timing

---

## 9. 🔧 TROUBLESHOOTING

### "Cannot Find Root Cause"

**Actions**:
1. Add more console.log statements at earlier points
2. Use debugger breakpoints instead of logging
3. Check Call Stack in DevTools
4. Review git history for related changes
5. Ask: "What changed that could cause this?"

### "Too Many Logs, Hard to Follow"

**Solution**:
1. Use consistent prefixes: `[ComponentName] Message`
2. Use colors: `console.error` (red), `console.warn` (yellow)
3. Group related logs: `console.group('[VideoPlayer]')`
4. Filter in DevTools console
5. Use conditional logging:

```javascript
const DEBUG = true;
if (DEBUG) console.log('[Video] ...');
```

### "Issue Only in Production"

**Actions**:
1. Check if DevTools available in production
2. Add temporary logging, redeploy
3. Check production console errors
4. Compare local vs. production network requests
5. Check CDN versions match local

---

## 10. 📚 REFERENCES

### Browser DevTools Documentation
- **Chrome DevTools**: https://developer.chrome.com/docs/devtools/
- **Firefox Developer Tools**: https://firefox-source-docs.mozilla.org/devtools-user/
- **Safari Web Inspector**: https://developer.apple.com/safari/tools/

### Debugging Techniques
- **MDN: Debugging JavaScript**: https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/What_went_wrong
- **MDN: console.trace()**: https://developer.mozilla.org/en-US/docs/Web/API/console/trace

### Project Standards
- AGENTS.md - Debugging standards
- Document Style Guide - Code documentation
- Git commit guidelines - Documenting fixes

---

## 11. 🚦 TRACING CHECKLIST

**Before claiming root cause found**:

```markdown
INVESTIGATION:
□ Opened browser DevTools
□ Read full error message and stack trace
□ Checked Call Stack panel in debugger
□ Added console.trace() at error point
□ Traced backward through call chain

VALIDATION:
□ Identified originating function
□ Understand WHY invalid data occurred
□ Can explain full execution path
□ Fixed at source, not symptom
□ Verified fix prevents issue at origin

DOCUMENTATION:
□ Added code comments explaining root cause
□ Documented fix reasoning
□ Removed debug console.log statements
□ Noted any related issues or edge cases

VERIFICATION:
□ Tested fix in browser
□ Confirmed error no longer occurs
□ Checked for any new issues introduced
□ Verified across different scenarios
```
