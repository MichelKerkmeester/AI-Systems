# Initialization Pattern - Webflow CDN-Safe JavaScript Loading

Mandatory CDN-safe initialization pattern for all JavaScript components in Webflow projects. This pattern ensures proper loading from CDN, prevents double initialization, respects Webflow's asynchronous architecture, and handles DOM readiness with appropriate delays.

#### 📋 TABLE OF CONTENTS

1. [✅ THE STANDARD PATTERN (COPY THIS EXACTLY)](#1--the-standard-pattern-copy-this-exactly)
2. [❌ COMMON MISTAKES (NEVER DO THESE)](#2--common-mistakes-never-do-these)
3. [🎯 WHY THIS PATTERN EXISTS](#3--why-this-pattern-exists)
4. [🛠️ IMPLEMENTATION PATTERNS](#4-️-implementation-patterns)
5. [🔄 EXECUTION FLOW](#5--execution-flow)
6. [📋 PRE-DEPLOYMENT CHECKLIST](#6--pre-deployment-checklist)
7. [📁 PATTERN EVOLUTION AND REFERENCES](#7--pattern-evolution-and-references)
8. [🚨 TROUBLESHOOTING COMMON ISSUES](#8--troubleshooting-common-issues)

---

## 1. ✅ THE STANDARD PATTERN (COPY THIS EXACTLY)

### Complete Implementation

**This is the ONLY correct pattern - copy exactly:**

```javascript
(() => {
  const INIT_FLAG = '__componentNameCdnInit';  // Unique flag per component
  const INIT_DELAY_MS = 50;                     // Adjust per component needs

  function init_component() {
    // Your initialization code here
  }

  const start = () => {
    // Guard: Prevent double initialization
    if (window[INIT_FLAG]) return;
    window[INIT_FLAG] = true;

    // If DOM already loaded, delay before initializing
    if (document.readyState !== 'loading') {
      setTimeout(init_component, INIT_DELAY_MS);
      return;
    }

    // Otherwise, wait for DOMContentLoaded with delay
    document.addEventListener(
      'DOMContentLoaded',
      () => setTimeout(init_component, INIT_DELAY_MS),
      { once: true }
    );
  };

  // Prefer Webflow.push, fallback to immediate start
  if (window.Webflow?.push) {
    window.Webflow.push(start);
  } else {
    start();
  }
})();
```

### Pattern Components

| Component | Purpose | Configuration |
|-----------|---------|---------------|
| **INIT_FLAG** | Prevents double initialization | Unique per component: `__accordionCdnInit`, `__heroVideoCdnInit` |
| **INIT_DELAY_MS** | Ensures dependencies ready | Default 50ms, adjust based on needs |
| **start()** | Manages timing and guards | Wrapper function - standard across all components |
| **init_component()** | Your business logic | Unchanged from previous implementation |

### When to Adjust INIT_DELAY_MS

| Delay | When to Use | Example Components |
|-------|-------------|--------------------|
| **0ms** | No dependencies, simple DOM queries | Copyright year updater, page title changer |
| **50ms** (default) | Standard components | Forms, accordions, navigation |
| **100ms+** | Heavy dependencies or complex queries | Hero animations (Motion.dev), video players (HLS.js) |

---

## 2. ❌ COMMON MISTAKES (NEVER DO THESE)

### Mistake 1: Missing Guard Flag

**WRONG - Allows double initialization:**
```javascript
// ❌ NEVER DO THIS
const start = () => {
  if (document.readyState !== 'loading') {
    setTimeout(init_component, INIT_DELAY_MS);
    return;
  }
  // Component initializes multiple times on Webflow page transitions
};
```

**Problem:** Webflow can re-run scripts during page transitions. Without guard flag, component initializes multiple times, causing:
- Duplicate event listeners
- Memory leaks
- Unexpected behavior

---

### Mistake 2: Missing Delay

**WRONG - Runs before dependencies ready:**
```javascript
// ❌ NEVER DO THIS
const start = () => {
  if (window[INIT_FLAG]) return;
  window[INIT_FLAG] = true;

  if (document.readyState !== 'loading') {
    init_component();  // Too early! Dependencies may not be ready
    return;
  }
  // ...
};
```

**Problem:** Even after DOM ready, external dependencies (Motion.dev, HLS.js) may still be loading. No delay causes:
- "Motion is not defined" errors
- Race conditions with library loading
- Inconsistent behavior

---

### Mistake 3: Direct DOMContentLoaded

**WRONG - Ignores Webflow system and lacks guard:**
```javascript
// ❌ NEVER DO THIS
document.addEventListener('DOMContentLoaded', init_component);
```

**Problem:** Bypasses Webflow's queueing system AND has no double-init protection:
- Conflicts with Webflow's internal initialization
- No guard against re-execution
- Doesn't integrate with Webflow.push queue

---

### Mistake 4: Old Pre-CDN Pattern

**WRONG - Old pattern lacks CDN safety:**
```javascript
// ❌ NEVER DO THIS - Old pattern (pre-CDN)
if (window.Webflow && window.Webflow.push) {
  window.Webflow.push(init_component);
} else if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init_component);
} else {
  init_component();
}
```

**Problem:** This was the old simpler pattern. It lacks:
- Guard flags (no double-init protection)
- Delays (no dependency readiness guarantee)
- CDN reliability (causes race conditions)

---

## 3. 🎯 WHY THIS PATTERN EXISTS

### Core Requirements

| Requirement | Implementation | Why Needed |
|------------|----------------|------------|
| **Guard Flag** | `if (window[INIT_FLAG]) return;` | Prevents double initialization during Webflow page transitions |
| **Delayed Execution** | `setTimeout(init_component, INIT_DELAY_MS)` | Ensures DOM and dependencies (Motion.dev, etc.) fully ready |
| **Webflow.push Support** | `window.Webflow.push(start)` | Integrates with Webflow's native queueing system |
| **Fallback Logic** | `else { start(); }` | Works even when Webflow.push unavailable |
| **Once-Only Listener** | `{ once: true }` | Prevents memory leaks from duplicate listeners |

### Why Guard Flags Are Critical

**Problem:** CDN-loaded scripts can execute multiple times
- Webflow re-triggers scripts during page transitions
- Browser back/forward navigation can re-run scripts
- Webflow Designer preview mode re-initializes frequently

**Solution:** Guard flag ensures initialization only once
```javascript
if (window[INIT_FLAG]) return;  // Already initialized - skip
window[INIT_FLAG] = true;       // Mark as initialized
```

### Why Delays Are Critical

**Problem:** DOM ready ≠ Dependencies ready

**Timeline without delay:**
```
0ms:   DOMContentLoaded fires
0ms:   init_component() runs
10ms:  Motion.dev still loading...
Error: "Motion is not defined"
```

**Timeline with 50ms delay:**
```
0ms:   DOMContentLoaded fires
50ms:  init_component() runs
✓:     Motion.dev loaded at 20ms - ready when needed
```

**The 50ms delay ensures:**
- DOM is fully parsed and stable
- External dependencies (Motion.dev, HLS.js) are loaded
- Webflow's own initialization is complete
- Race conditions are avoided

---

## 4. 🛠️ IMPLEMENTATION PATTERNS

### Standard Component (No Dependencies)

**Example: Accordion component**

```javascript
// src/accordion/accordion.js
(() => {
  function setupAccordion() {
    // Business logic unchanged
    document.querySelectorAll('[data-accordion-css-init]').forEach((accordion) => {
      // ... existing accordion logic
    });
  }

  /* ─────────────────────────────────────────────────────────────
     INITIALIZE
  ────────────────────────────────────────────────────────────────*/
  const INIT_FLAG = '__accordionCdnInit';
  const INIT_DELAY_MS = 50;

  function initAccordion() {
    setupAccordion();
  }

  const start = () => {
    if (window[INIT_FLAG]) return;
    window[INIT_FLAG] = true;

    if (document.readyState !== 'loading') {
      setTimeout(initAccordion, INIT_DELAY_MS);
      return;
    }

    document.addEventListener(
      'DOMContentLoaded',
      () => setTimeout(initAccordion, INIT_DELAY_MS),
      { once: true }
    );
  };

  if (window.Webflow?.push) {
    window.Webflow.push(start);
  } else {
    start();
  }
})();
```

**Key points:**
- `INIT_FLAG` is unique: `__accordionCdnInit`
- Standard 50ms delay
- Business logic (`setupAccordion`) unchanged

---

### Component with Global API

**Example: Form validation with exported API**

```javascript
// src/form/form_validation.js
(() => {
  function validate_form(form) {
    // ... validation logic
  }

  function validate_field(field) {
    // ... field validation
  }

  // Export API BEFORE guard (available immediately)
  window.FormValidation = {
    validate_form,
    validate_field,
    cleanup: () => {
      // ... cleanup logic
    }
  };

  /* ─────────────────────────────────────────────────────────────
     INITIALIZE
  ────────────────────────────────────────────────────────────────*/
  const INIT_FLAG = '__formValidationCdnInit';
  const INIT_DELAY_MS = 50;

  function init_form_validation() {
    // Auto-attach to forms
    document.querySelectorAll('form[data-validate]').forEach(validate_form);
  }

  const start = () => {
    if (window[INIT_FLAG]) return;
    window[INIT_FLAG] = true;

    if (document.readyState !== 'loading') {
      setTimeout(init_form_validation, INIT_DELAY_MS);
      return;
    }

    document.addEventListener(
      'DOMContentLoaded',
      () => setTimeout(init_form_validation, INIT_DELAY_MS),
      { once: true }
    );
  };

  if (window.Webflow?.push) {
    window.Webflow.push(start);
  } else {
    start();
  }
})();
```

**Key points:**
- Export API before initialization (available immediately)
- Initialization still uses standard pattern
- Other scripts can call `window.FormValidation.validate_form()` before DOM ready

---

### Self-Executing Component (API Only)

**Example: Welcome modal that exports API but doesn't need DOM delay**

```javascript
// src/modal/modal_welcome.js
(() => {
  const INIT_FLAG = '__welcomeModalCdnInit';
  if (window[INIT_FLAG]) return;
  window[INIT_FLAG] = true;

  // Entire modal logic executes immediately
  window.AnobelWelcomeModal = {
    show: () => {
      // ... show logic
    },
    hide: () => {
      // ... hide logic
    },
    isVisible: () => {
      // ... visibility check
    }
  };
})();
```

**When to use this pattern:**
- Component is API-only (no automatic DOM initialization)
- Other scripts control when/how component runs
- No dependencies on external libraries

**Still includes:**
- Guard flag (prevents double definition)
- IIFE wrapper (scoped variables)

---

## 5. 🔄 EXECUTION FLOW

### Flow Diagram

```
Script Loads from CDN
    ↓
Webflow.push exists?
├─> Yes: Queue start() via Webflow.push
└─> No:  Call start() directly
    ↓
Guard flag already set?
├─> Yes: STOP (already initialized)
└─> No:  Set guard flag, continue
    ↓
DOM still loading?
├─> Yes: Wait for DOMContentLoaded
└─> No:  DOM already ready
    ↓
Delay INIT_DELAY_MS (50ms default)
    ↓
init_component() runs ONCE
```

### Timeline Example

**Typical page load sequence:**

```
0ms:    Page starts loading
10ms:   HTML parsed
20ms:   External scripts loading (Motion.dev, HLS.js)
30ms:   DOMContentLoaded fires
40ms:   Webflow.push queues start()
50ms:   start() executes, sets guard flag
60ms:   External libraries fully loaded
100ms:  setTimeout fires → init_component() runs
```

**Why 50ms delay is critical:**
- DOMContentLoaded at 30ms
- Motion.dev loads at 60ms
- Without delay: init at 30ms → Motion undefined (error)
- With 50ms delay: init at 100ms → Motion ready (success)

---

## 6. 📋 PRE-DEPLOYMENT CHECKLIST

Before deploying any component, verify:

**Pattern structure:**
- [ ] Wrapped in IIFE `(() => { ... })()`
- [ ] Has unique `INIT_FLAG` constant (e.g., `__accordionCdnInit`)
- [ ] Has `INIT_DELAY_MS` constant (default 50ms)
- [ ] Has `start()` wrapper function

**Guard implementation:**
- [ ] Guard check: `if (window[INIT_FLAG]) return;`
- [ ] Guard set: `window[INIT_FLAG] = true;`

**DOM readiness:**
- [ ] readyState check with setTimeout
- [ ] DOMContentLoaded listener with setTimeout
- [ ] Uses `{ once: true }` on event listener

**Webflow integration:**
- [ ] Checks `window.Webflow?.push` with optional chaining
- [ ] Has fallback `else` for when Webflow.push unavailable

**Business logic:**
- [ ] Business logic unchanged from previous version
- [ ] No logic changes mixed with pattern adoption

---

## 7. 📁 PATTERN EVOLUTION AND REFERENCES

### Why Pattern Changed

**Previous pattern (pre-CDN):**
```javascript
// Old simpler pattern - NO LONGER USED
if (window.Webflow && window.Webflow.push) {
  window.Webflow.push(init_component);
} else if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init_component);
} else {
  init_component();
}
```

**Problems with old pattern:**
- ❌ No protection against double initialization
- ❌ No delays for dependency readiness
- ❌ Caused issues with CDN delivery
- ❌ Race conditions with Motion.dev and other libraries

**Current CDN-safe pattern benefits:**
- ✅ Guard flags prevent double-init
- ✅ Delays ensure dependency readiness
- ✅ Proven reliable with CDN delivery
- ✅ Deployed across 34+ production files

### Files Using This Pattern

**Pattern is deployed across all JavaScript components:**

**Core components (13 files):**
- accordion/accordion.js
- browser/change_page_title_on_leave.js
- browser/force_start_at_top.js
- cms/conditional_visibility.js
- footer/back_to_top.js
- input/input_focus_handler.js, input_placeholder.js
- label/label_office_hours.js
- modal/modal_cookie_consent.js
- navigation/language_selector.js, dropdown_menu.js, mobile_menu.js
- text/copyright.js

**Additional components (21+ files):**
- Hero animations (blog_article, cards, general, video, webshop)
- Form handling (submission, validation)
- Video players (hover, background HLS, player HLS)
- Tab components (autoplay, menu)
- Marquees (brands, clients)
- Links (grid, hero)
- And more...

### Related Documentation

- **AGENTS.md** - Required reading for AI agents
- **code_standards.md** Section 2 - Initialization pattern specification
- **animation_strategy.md** Section 3 - Motion.dev integration with this pattern

---

## 8. 🚨 TROUBLESHOOTING COMMON ISSUES

### Issue: "Motion is not defined" Error

**Problem:** Component runs before Motion.dev library loads

**Solution:** Increase `INIT_DELAY_MS`:
```javascript
const INIT_DELAY_MS = 100;  // Increased from 50ms
```

**When to increase:**
- Heavy external dependencies
- Complex animation sequences
- Multiple libraries loading simultaneously

---

### Issue: Component Initializes Multiple Times

**Problem:** Guard flag missing or not unique

**Solution 1:** Verify guard flag exists:
```javascript
if (window[INIT_FLAG]) return;  // ← Must be present
window[INIT_FLAG] = true;
```

**Solution 2:** Ensure unique flag name:
```javascript
// ❌ WRONG: Generic name (collision risk)
const INIT_FLAG = '__init';

// ✅ CORRECT: Component-specific name
const INIT_FLAG = '__heroVideoAnimationCdnInit';
```

---

### Issue: Component Never Initializes

**Problem:** Script errors before reaching initialization

**Solution:** Check browser console for errors:
1. Open DevTools Console
2. Look for syntax errors or undefined references
3. Fix errors above initialization pattern
4. Verify script is loaded (Network tab)

---

### Issue: Works Locally, Fails in Production

**Problem:** CDN caching or timing differences

**Solution:** Clear CDN cache and verify delay:
```javascript
// Increase delay for CDN environments
const INIT_DELAY_MS = 100;  // More conservative for production
```

---

**Core principle:** When implementing new components, copy the standard pattern from Section 1 exactly. The guard flag and delay timing are not optional—they're critical for CDN reliability and Webflow compatibility.
