---
name: code-condition-based-waiting
description: Use when JavaScript has timing issues, race conditions, or DOM elements not ready - replaces arbitrary setTimeout with condition polling to wait for actual DOM ready, images/videos loaded, animations complete, or external scripts available
allowed-tools: Read, Edit, Write
---

# Condition-Based Waiting - DOM & Async Operations

Flaky frontends often guess at timing with arbitrary delays. This creates race conditions where code works on fast connections but fails under load, on slow devices, or when CDNs are slow.

**Core principle**: Wait for the actual condition you care about, not a guess about how long it takes.

---

## 1. 🎯 WHEN TO USE

**Use when JavaScript has**:
- DOM elements not found (querySelector returns null)
- Images/videos not ready when accessing them
- External libraries not loaded (Hls is not defined, $ is not defined)
- Animations completing before attempting next action
- Webflow interactions finishing before custom code runs
- Fonts loaded before measuring text dimensions
- Arbitrary `setTimeout` or `delay` calls
- Intermittent failures that "work sometimes"
- Code that "works locally but fails in production"

**Use this ESPECIALLY when**:
- Code at top of `<head>` running before DOM ready
- External CDN scripts (HLS.js, jQuery) loading asynchronously
- Images/videos must be loaded before manipulation
- Animations must complete before starting next animation
- Webflow publish delays script execution
- Slow network conditions cause race conditions

**Don't use when**:
- Testing actual timing behavior (debounce, throttle intervals)
- Intentional delays for UX (show message for minimum duration)
- Animation keyframe timing (use CSS instead)

Always document WHY if using arbitrary timeout.

**Core principle**: Condition polling + reasonable timeouts = reliable async code

---

## 2. 🛠️ CORE PATTERN

```javascript
// ❌ BEFORE: Guessing at timing
setTimeout(() => {
  const video = document.querySelector('[video-hero]');
  initializeVideo(video); // Might be null!
}, 100); // Why 100ms? Will it be enough on slow devices?

// ✅ AFTER: Waiting for condition
waitForElement('[video-hero]').then(video => {
  initializeVideo(video); // Guaranteed to exist
});
```

**Key Difference**:
- Before: Hope 100ms is enough time
- After: Wait until element actually exists

---

## 3. 📋 COMMON PATTERNS

| Scenario | Arbitrary Delay | Condition-Based | Why Better |
|----------|----------------|-----------------|------------|
| **Wait for DOM element** | `setTimeout(() => querySelector(), 50)` | `waitForElement(selector)` | Works regardless of load speed |
| **Wait for external library** | `setTimeout(() => new Hls(), 200)` | `waitForLibrary('Hls')` | CDN speed varies |
| **Wait for image load** | `setTimeout(() => useImage(), 1000)` | `img.onload` or `waitForImageLoad(img)` | Image size varies |
| **Wait for animation end** | `setTimeout(() => next(), 500)` | `element.addEventListener('transitionend')` | Animation duration might change |
| **Wait for video ready** | `setTimeout(() => video.play(), 2000)` | `video.addEventListener('canplay')` | Network speed varies |
| **Wait for font load** | `setTimeout(() => measure(), 100)` | `document.fonts.ready` | Font loading varies |

---

## 4. 🛠️ IMPLEMENTATION PATTERNS

### Pattern 1: Wait for DOM Element

**Problem**: Element doesn't exist yet when script runs

```javascript
// ❌ WRONG: Arbitrary delay
setTimeout(() => {
  const element = document.querySelector('[page-loader]');
  if (element) {
    // ...
  }
}, 50); // Why 50ms? Not reliable

// ✅ CORRECT: Wait for element
async function waitForElement(selector, timeout = 5000) {
  const startTime = Date.now();

  while (Date.now() - startTime < timeout) {
    const element = document.querySelector(selector);
    if (element) return element;

    // Check every 50ms
    await new Promise(resolve => setTimeout(resolve, 50));
  }

  throw new Error(`Element ${selector} not found after ${timeout}ms`);
}

// Usage
waitForElement('[page-loader]')
  .then(loader => {
    // Element guaranteed to exist
    initializePageLoader(loader);
  })
  .catch(error => {
    console.error('Page loader element not found:', error);
  });
```

### Pattern 2: Wait for External Library

**Problem**: CDN library not loaded yet

```javascript
// ❌ WRONG: Guess when HLS.js loaded
setTimeout(() => {
  if (typeof Hls !== 'undefined') {
    initializeVideo();
  }
}, 200); // Unreliable

// ✅ CORRECT: Wait for library
async function waitForLibrary(globalName, timeout = 10000) {
  const startTime = Date.now();

  while (Date.now() - startTime < timeout) {
    if (typeof window[globalName] !== 'undefined') {
      return window[globalName];
    }

    await new Promise(resolve => setTimeout(resolve, 50));
  }

  throw new Error(`Library ${globalName} not loaded after ${timeout}ms`);
}

// Usage
waitForLibrary('Hls')
  .then(Hls => {
    console.log('HLS.js loaded, initializing video...');
    initializeVideo(Hls);
  })
  .catch(error => {
    console.error('HLS.js failed to load:', error);
    // Fallback to native video
    initializeFallbackVideo();
  });
```

### Pattern 3: Wait for Image Load

**Problem**: Image dimensions needed before available

```javascript
// ❌ WRONG: Arbitrary delay
const img = document.querySelector('[hero-image]');
setTimeout(() => {
  const width = img.offsetWidth; // Might be 0 if not loaded
  calculateLayout(width);
}, 500);

// ✅ CORRECT: Wait for image load
const img = document.querySelector('[hero-image]');

function waitForImageLoad(img) {
  return new Promise((resolve, reject) => {
    if (img.complete) {
      // Image already loaded
      resolve(img);
    } else {
      img.addEventListener('load', () => resolve(img));
      img.addEventListener('error', () => reject(new Error('Image failed to load')));
    }
  });
}

// Usage
waitForImageLoad(img)
  .then(loadedImg => {
    const width = loadedImg.offsetWidth; // Guaranteed to have dimensions
    calculateLayout(width);
  })
  .catch(error => {
    console.error('Image load failed:', error);
    useDefaultLayout();
  });
```

### Pattern 4: Wait for Animation End

**Problem**: Starting next action before animation completes

```javascript
// ❌ WRONG: Hardcoded animation duration
element.classList.add('fade-out');
setTimeout(() => {
  element.remove(); // Hope 300ms was enough
}, 300);

// ✅ CORRECT: Wait for transition end
element.classList.add('fade-out');

function waitForTransitionEnd(element, property = null) {
  return new Promise(resolve => {
    function handler(event) {
      // If property specified, only resolve for that property
      if (property && event.propertyName !== property) return;

      element.removeEventListener('transitionend', handler);
      resolve(event);
    }

    element.addEventListener('transitionend', handler);
  });
}

// Usage
waitForTransitionEnd(element, 'opacity')
  .then(() => {
    // Animation guaranteed complete
    element.remove();
  });

// Or using async/await
async function fadeOutAndRemove(element) {
  element.classList.add('fade-out');
  await waitForTransitionEnd(element, 'opacity');
  element.remove();
}
```

### Pattern 5: Wait for Video Ready

**Problem**: Attempting to play video before it's ready

```javascript
// ❌ WRONG: Arbitrary delay
const video = document.querySelector('[video-player]');
setTimeout(() => {
  video.play(); // Might not be ready
}, 1000);

// ✅ CORRECT: Wait for 'canplay' event
const video = document.querySelector('[video-player]');

function waitForVideoReady(video) {
  return new Promise((resolve, reject) => {
    if (video.readyState >= 3) {
      // HAVE_FUTURE_DATA or greater
      resolve(video);
    } else {
      video.addEventListener('canplay', () => resolve(video), { once: true });
      video.addEventListener('error', () => reject(new Error('Video load failed')), { once: true });
    }
  });
}

// Usage
waitForVideoReady(video)
  .then(readyVideo => {
    readyVideo.play();
    console.log('Video playing');
  })
  .catch(error => {
    console.error('Video failed to load:', error);
    showVideoError();
  });
```

### Pattern 6: Wait for Font Load

**Problem**: Measuring text before fonts loaded

```javascript
// ❌ WRONG: Arbitrary delay
setTimeout(() => {
  const width = element.offsetWidth; // Font might not be loaded
  adjustLayout(width);
}, 100);

// ✅ CORRECT: Wait for fonts
document.fonts.ready.then(() => {
  const width = element.offsetWidth; // Fonts guaranteed loaded
  adjustLayout(width);
});

// Or check specific font
async function waitForFont(fontFamily, timeout = 5000) {
  try {
    await document.fonts.load(`1em ${fontFamily}`, '', { timeout });
    return true;
  } catch (error) {
    console.warn(`Font ${fontFamily} not loaded:`, error);
    return false;
  }
}

// Usage
waitForFont('Inter').then(() => {
  measureAndAdjustLayout();
});
```

### Pattern 7: DOM Content Ready

**Problem**: Running code before DOM ready

```javascript
// ❌ WRONG: Arbitrary delay at top of file
setTimeout(() => {
  initializeApp();
}, 100); // Might not be enough

// ✅ CORRECT: Wait for DOM ready
function domReady() {
  return new Promise(resolve => {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', resolve);
    } else {
      // DOM already ready
      resolve();
    }
  });
}

// Usage
domReady().then(() => {
  console.log('DOM ready, initializing...');
  initializeApp();
});

// Or shorter form
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeApp);
} else {
  initializeApp();
}
```

---

## 5. 📖 RULES

### ALWAYS

- Wait for actual conditions, not arbitrary timeouts
- Include timeout limits (default 5-10 seconds)
- Provide clear error messages when timeouts occur
- Use promises for async waiting
- Handle both success and error cases
- Log when waiting completes successfully
- Document WHY waiting is necessary
- Use appropriate polling intervals (50-100ms typical)
- Clean up event listeners when done
- Consider fallback behavior for failures

### NEVER

- Use `setTimeout` without documenting WHY
- Wait without timeout (infinite loops)
- Ignore timeout errors silently
- Poll faster than 10ms (wastes CPU)
- Assume elements exist without checking
- Skip error handling for wait operations
- Use magic numbers without comments (`setTimeout(fn, 47)` - why 47?)
- Chain multiple arbitrary timeouts
- Rely on "works on my machine" timing

### ESCALATE IF

- Condition never becomes true (infinite wait)
- Timeout too short for slow connections
- Race condition cannot be eliminated with waiting
- Multiple dependent conditions make code complex
- External library fundamentally unreliable

---

## 6. ⚠️ COMMON MISTAKES

**Polling too fast**:
- **Problem**: `setTimeout(check, 1)` wastes CPU
- **Fix**: Poll every 50-100ms, not every 1ms

**No timeout**:
- **Problem**: Loop forever if condition never met
- **Fix**: Always include timeout with clear error

**Stale data**:
- **Problem**: Cache state before loop, check cached value
- **Fix**: Call getter inside loop for fresh data

**Ignoring ready state**:
- **Problem**: Adding event listener after element already loaded
- **Fix**: Check if already ready, add listener only if not

```javascript
// ❌ WRONG: Will miss event if already complete
video.addEventListener('canplay', handler);

// ✅ CORRECT: Check current state first
if (video.readyState >= 3) {
  handler();
} else {
  video.addEventListener('canplay', handler, { once: true });
}
```

**Multiple animations without waiting**:
- **Problem**: Starting next animation before previous completes
- **Fix**: Chain animations with `await` or promises

```javascript
// ❌ WRONG: Animations overlap
element.classList.add('fade-out');
element.classList.add('slide-up'); // Starts immediately

// ✅ CORRECT: Wait for each to complete
element.classList.add('fade-out');
await waitForTransitionEnd(element, 'opacity');
element.classList.add('slide-up');
await waitForTransitionEnd(element, 'transform');
```

---

## 7. 💡 WHEN ARBITRARY TIMEOUT IS CORRECT

**Sometimes arbitrary timeouts ARE necessary**:

```javascript
// UX: Show message for minimum duration (user needs time to read)
showSuccessMessage();
await Promise.all([
  waitForDataLoad(), // Wait for actual condition
  new Promise(r => setTimeout(r, 2000)) // AND minimum 2 seconds
]);
hideSuccessMessage();
// Message shows for ≥2s, even if data loads instantly

// Animation: Stagger animation starts for visual effect
items.forEach((item, index) => {
  setTimeout(() => {
    item.classList.add('animate-in');
  }, index * 100); // Intentional 100ms stagger
});

// Debounce: Limit function calls (user stopped typing)
let timeout;
input.addEventListener('input', () => {
  clearTimeout(timeout);
  timeout = setTimeout(() => {
    performSearch(); // Wait 300ms after typing stops
  }, 300);
});
```

**Requirements for arbitrary timeouts**:
1. Document WHY timeout is needed
2. Based on known behavior (not guessing)
3. Comment explaining duration choice
4. Consider user experience impact

---

## 8. 💡 EXAMPLE WORKFLOWS

### Example 1: Page Loader

```javascript
/**
 * Page Loader - Waits for DOM ready and critical resources
 * before hiding loader and showing content
 */

async function initializePageLoader() {
  const loader = await waitForElement('[page-loader]', 10000);
  console.log('[PageLoader] Element found');

  // Wait for critical resources
  await Promise.all([
    domReady(),
    waitForImages('[hero-image]'),
    waitForLibrary('Hls'), // If using HLS videos
  ]);

  console.log('[PageLoader] All critical resources loaded');

  // Fade out loader
  loader.classList.add('fade-out');
  await waitForTransitionEnd(loader, 'opacity');

  // Remove from DOM
  loader.remove();
  console.log('[PageLoader] Removed');

  // Show content
  document.body.classList.add('loaded');
}

// Helper: Wait for all images in selector
async function waitForImages(selector, timeout = 10000) {
  const images = Array.from(document.querySelectorAll(`${selector} img`));
  const promises = images.map(img => waitForImageLoad(img));

  try {
    await Promise.race([
      Promise.all(promises),
      new Promise((_, reject) =>
        setTimeout(() => reject(new Error('Image load timeout')), timeout)
      )
    ]);
    console.log(`[Images] All loaded for ${selector}`);
  } catch (error) {
    console.warn(`[Images] Some failed to load for ${selector}:`, error);
    // Continue anyway after timeout
  }
}

// Initialize when script loads
initializePageLoader().catch(error => {
  console.error('[PageLoader] Initialization failed:', error);
  // Hide loader anyway to prevent infinite loading
  const loader = document.querySelector('[page-loader]');
  if (loader) loader.remove();
});
```

### Example 2: HLS Video Initialization

```javascript
/**
 * HLS Video Player - Waits for HLS.js library and DOM element
 * before initializing video player
 */

async function initializeHeroVideo() {
  console.log('[HeroVideo] Initializing...');

  try {
    // Wait for both video element and HLS library
    const [videoElement, Hls] = await Promise.all([
      waitForElement('[video-hero]', 5000),
      waitForLibrary('Hls', 10000)
    ]);

    console.log('[HeroVideo] Element and library ready');

    if (!Hls.isSupported()) {
      console.warn('[HeroVideo] HLS not supported, using native playback');
      // Fallback to native HLS (Safari)
      videoElement.src = videoElement.dataset.src;
      await waitForVideoReady(videoElement);
      videoElement.play();
      return;
    }

    // Initialize HLS.js
    const hls = new Hls({
      debug: false,
      enableWorker: true,
      lowLatencyMode: false
    });

    hls.loadSource(videoElement.dataset.src);
    hls.attachMedia(videoElement);

    // Wait for HLS to be ready
    await new Promise((resolve, reject) => {
      hls.on(Hls.Events.MANIFEST_PARSED, resolve);
      hls.on(Hls.Events.ERROR, (event, data) => {
        if (data.fatal) reject(new Error(`HLS error: ${data.type}`));
      });
    });

    console.log('[HeroVideo] HLS manifest loaded');

    // Wait for video ready to play
    await waitForVideoReady(videoElement);

    // Start playback
    videoElement.play();
    console.log('[HeroVideo] Playing');

  } catch (error) {
    console.error('[HeroVideo] Initialization failed:', error);
    // Show error state or fallback
    showVideoError();
  }
}

// Initialize when DOM ready
domReady().then(initializeHeroVideo);
```

### Example 3: Navigation with Smooth Transitions

```javascript
/**
 * Navigation - Waits for animations to complete
 * before performing navigation actions
 */

class Navigation {
  constructor() {
    this.nav = null;
    this.mobileMenu = null;
    this.isAnimating = false;
  }

  async initialize() {
    // Wait for DOM elements
    this.nav = await waitForElement('[nav-menu]');
    this.mobileMenu = await waitForElement('[mobile-menu]');

    console.log('[Navigation] Elements ready');

    // Setup event listeners
    this.setupEventListeners();
  }

  setupEventListeners() {
    const hamburger = this.nav.querySelector('[hamburger-button]');

    hamburger.addEventListener('click', async () => {
      if (this.isAnimating) return; // Prevent clicks during animation

      this.isAnimating = true;
      await this.toggleMobileMenu();
      this.isAnimating = false;
    });
  }

  async toggleMobileMenu() {
    const isOpen = this.mobileMenu.classList.contains('open');

    if (isOpen) {
      console.log('[Navigation] Closing mobile menu');
      this.mobileMenu.classList.remove('open');

      // Wait for close animation to complete
      await waitForTransitionEnd(this.mobileMenu, 'transform');

      // Hide completely after animation
      this.mobileMenu.style.display = 'none';
      console.log('[Navigation] Menu closed');

    } else {
      console.log('[Navigation] Opening mobile menu');
      // Show before animation starts
      this.mobileMenu.style.display = 'block';

      // Force reflow to ensure display change applied
      this.mobileMenu.offsetHeight;

      this.mobileMenu.classList.add('open');

      // Wait for open animation to complete
      await waitForTransitionEnd(this.mobileMenu, 'transform');
      console.log('[Navigation] Menu open');
    }
  }
}

// Initialize when DOM ready
domReady().then(() => {
  const nav = new Navigation();
  nav.initialize().catch(error => {
    console.error('[Navigation] Failed to initialize:', error);
  });
});
```

---

## 9. 🎓 SUCCESS CRITERIA

**Condition-based waiting is successful when**:
- ✅ No arbitrary setTimeout used (or documented why needed)
- ✅ All waits have timeout limits
- ✅ Clear error messages when timeouts occur
- ✅ Both success and error cases handled
- ✅ Event listeners cleaned up properly
- ✅ Code works reliably on slow connections
- ✅ Works on slow devices (not just fast development machine)
- ✅ No race conditions or intermittent failures
- ✅ Console logs show clear waiting/completion messages

**Quality gates**:
- Can you explain what condition is being waited for?
- What happens if timeout is reached?
- Will this work on a slow 3G connection?
- Did you test with browser DevTools network throttling?
- Are all async operations properly awaited?

---

## 10. 🔗 INTEGRATION POINTS

### Pairs With
- **code-systematic-debugging** - Debug timing/race condition issues
- **code-verification-before-completion** - Verify waits work correctly
- **code-defense-in-depth** - Validate data after waiting completes
- **code-root-cause-tracing** - Trace where timing issues originate

### Browser APIs Used
- `document.readyState` - DOM ready state
- `element.addEventListener('transitionend')` - Animation completion
- `element.addEventListener('animationend')` - CSS animation completion
- `video.addEventListener('canplay')` - Video ready
- `img.onload` / `img.onerror` - Image load
- `document.fonts.ready` - Font loading
- `Promise.race()` - Timeout implementation
- `Promise.all()` - Multiple conditions

### Testing Scenarios
- Network throttling (Slow 3G in DevTools)
- CPU throttling (6x slowdown in DevTools)
- Cache disabled
- Ad blockers enabled
- Different CDN speeds

---

## 11. 🔧 TROUBLESHOOTING

### "Element never found, timeout occurs"

**Possible Causes**:
- Selector incorrect
- Element dynamically added by Webflow interaction
- Element inside iframe
- Element in shadow DOM
- Webflow publish not completed

**Actions**:
1. Verify selector in DevTools console
2. Check if element added by interaction
3. Increase timeout if necessary
4. Add fallback behavior

### "Promise never resolves"

**Possible Causes**:
- No timeout specified (infinite wait)
- Event listener never fires
- Condition logic incorrect
- Event already fired before listener added

**Actions**:
1. Add console.log inside wait loop
2. Verify condition can become true
3. Check if state already reached before waiting
4. Add timeout to all waits

### "Works locally but fails in production"

**Possible Causes**:
- Local cache makes resources instant
- Production CDN slower
- Network conditions different
- Webflow-specific timing in production

**Actions**:
1. Test with DevTools network throttling
2. Disable cache during testing
3. Test on actual slow connection
4. Increase timeout values if needed

---

## 12. 📚 REFERENCES

### Browser APIs
- **MDN: Document.readyState** - https://developer.mozilla.org/en-US/docs/Web/API/Document/readyState
- **MDN: Promises** - https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
- **MDN: async/await** - https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function

### Event References
- **transitionend** - CSS transition completion
- **animationend** - CSS animation completion
- **DOMContentLoaded** - DOM parsing complete
- **load** - All resources loaded (images, scripts, etc.)
- **canplay** - Media can start playing
- **canplaythrough** - Media can play without buffering

### Performance
- Chrome DevTools Network Throttling
- Lighthouse Performance Testing
- Core Web Vitals (LCP, FID, CLS)

### Project Standards
- AGENTS.md - Async handling patterns
- Document Style Guide - Code documentation
