# Code Standards - Naming Conventions and Quality Guidelines

Mandatory code conventions for JavaScript, CSS, and inline documentation. Keep naming predictable across languages and layers, keep comments focused on intent and platform constraints, and enforce minimal headers without metadata or ticket references.

#### 📋 TABLE OF CONTENTS

1. [🧾 NAMING CONVENTIONS BY LANGUAGE AND TYPE](#1--naming-conventions-by-language-and-type)
2. [🗂️ FILE AND SECTION HEADERS](#2-️-file-and-section-headers)
3. [💬 COMMENTING RULES](#3--commenting-rules)
4. [🔖 SPECIAL MARKERS](#4--special-markers)
5. [✅ ENFORCEMENT AND TOOLING](#5--enforcement-and-tooling)

---

## 1. 🧾 NAMING CONVENTIONS BY LANGUAGE AND TYPE

### JavaScript and Python Identifiers

| Identifier Type | Convention | Example | When to Use |
|----------------|------------|---------|-------------|
| Variables | `snake_case` | `user_name`, `form_data` | All local and module-level variables |
| Functions | `snake_case` | `get_data()`, `handle_submit()` | All function declarations |
| Constants | `UPPER_SNAKE_CASE` | `MAX_SIZE`, `API_ENDPOINT` | Values that never change |
| Classes | `PascalCase` | `UserModel`, `FormValidator` | Constructor functions and classes |
| Private Members | `_snake_case` | `_internal_state`, `_cache` | Internal implementation details |

### Semantic Function Naming

Use standard prefixes to indicate function purpose:

| Prefix | Purpose | Example | Expectation |
|--------|---------|---------|-------------|
| `is_` | Boolean check | `is_active()` | Returns true/false |
| `has_` | Presence check | `has_data()` | Returns true/false |
| `can_` | Capability check | `can_submit()` | Returns true/false |
| `get_` | Data retrieval | `get_user()` | Returns data, doesn't modify state |
| `set_` | Data mutation | `set_value()` | Modifies state, returns void or success |
| `handle_` | Event handler | `handle_click()` | Responds to events |
| `on_` | Callback | `on_success()` | Callback function parameter |
| `load_` | Resource loading | `load_script()` | Async resource fetch |
| `init_` | Initialization | `init_component()` | Setup and configuration |

### CSS Naming

| Type | Convention | Example | Notes |
|------|------------|---------|-------|
| Classes | `kebab-case` | `.card`, `.navigation` | All CSS classes use hyphens |
| BEM Block | `kebab-case` | `.nav`, `.hero-section` | Top-level component |
| BEM Element | `--` separator | `.nav--item`, `.hero--title` | Child element |
| BEM Modifier | `-` suffix | `.card--featured-large` | State or variant |

**CSS class examples:**
```css
.hero { }                    /* Block */
.hero--title { }             /* Element */
.hero--overlay { }           /* Element */
.hero-featured { }           /* Modifier */
.hero-featured--dark { }     /* Element with modifier */
```

### File and Directory Naming

| Type | Convention | Example |
|------|------------|---------|
| JavaScript files | `snake_case.js` | `form_validator.js`, `hero_animation.js` |
| CSS files | `snake_case.css` | `navigation_styles.css` |
| Directories | `snake_case` | `src/components/`, `utils/` |
| Exception: Documentation | `UPPERCASE.md` or `PascalCase.md` | `README.md`, `SKILL.md` |

---

## 2. 🗂️ FILE AND SECTION HEADERS

### JavaScript File Header

Every JavaScript file starts with a minimal component header:

```javascript
// ───────────────────────────────────────────────────────────────
// COMPONENT: NAME
// ───────────────────────────────────────────────────────────────
```

**Examples:**
```javascript
// ───────────────────────────────────────────────────────────────
// COMPONENT: HERO ANIMATION
// ───────────────────────────────────────────────────────────────

// ───────────────────────────────────────────────────────────────
// COMPONENT: FORM VALIDATOR
// ───────────────────────────────────────────────────────────────
```

### CSS File Header

```css
/* ───────────────────────────────────────────────────────────────
   COMPONENT - NAME
─────────────────────────────────────────────────────────────── */
```

**Example:**
```css
/* ───────────────────────────────────────────────────────────────
   COMPONENT - NAVIGATION
─────────────────────────────────────────────────────────────── */
```

### Section Headers (Numbered)

Use numbered section headers within files to organize code blocks:

```javascript
/* ─────────────────────────────────────────────────────────────
   1. INITIALIZATION
──────────────────────────────────────────────────────────────── */

/* ─────────────────────────────────────────────────────────────
   2. CONFIGURATION
──────────────────────────────────────────────────────────────── */

/* ─────────────────────────────────────────────────────────────
   3. EVENT HANDLERS
──────────────────────────────────────────────────────────────── */
```

### What to NEVER Include in Headers

Headers must remain minimal. Do not include:

- ❌ Task IDs or ticket numbers (`PROJ-123`)
- ❌ Author names (`Author: John Doe`)
- ❌ Dates (`Created: 2024-01-15`)
- ❌ Version numbers (`v1.2.0`)
- ❌ Project management metadata
- ❌ Descriptive paragraphs or documentation

**Why:** Headers are for structure only. Documentation belongs in separate docs, git history tracks changes, and metadata clutters code.

### Initialization Pattern (Webflow CDN-Safe)

Every component must use this standardized initialization pattern:

```javascript
/* ─────────────────────────────────────────────────────────────
   INITIALIZE
──────────────────────────────────────────────────────────────── */
const INIT_FLAG = '__componentNameCdnInit';  // Unique per component
const INIT_DELAY_MS = 50;                     // Adjust per component

function init_component() {
  // Your initialization code here
}

const start = () => {
  if (window[INIT_FLAG]) return;              // Guard: prevent double-init
  window[INIT_FLAG] = true;

  if (document.readyState !== 'loading') {
    setTimeout(init_component, INIT_DELAY_MS);
    return;
  }

  document.addEventListener(
    'DOMContentLoaded',
    () => setTimeout(init_component, INIT_DELAY_MS),
    { once: true }
  );
};

if (window.Webflow?.push) {
  window.Webflow.push(start);
} else {
  start();
}
```

**Why this pattern:**
- `INIT_FLAG` prevents duplicate initialization across Webflow page transitions
- `INIT_DELAY_MS` ensures DOM stability before component runs
- `Webflow.push()` integration handles Webflow lifecycle properly
- See [initialization_pattern.md](./initialization_pattern.md) for complete documentation

---

## 3. 💬 COMMENTING RULES

### Commenting Principles

**Quantity limit:** Maximum 5 comments per 10 lines of code

**Focus on WHY, not WHAT:**
- ✅ Explain intent, constraints, and platform-specific requirements
- ✅ Reference external dependencies (Webflow, libraries)
- ❌ Avoid narrating implementation details

### Configuration and Constant Comments

Explain purpose and constraints above constants:

```javascript
// Cache Botpoison client instances per public key to avoid recreation
const botpoison_clients = new Map();

// Timeout values for various fallback mechanisms
const HERO_FALLBACK_MS = 3000;
const WELCOME_FALLBACK_MS = 4500;

// Selector for forms using Formspark endpoints
const FORMSPARK_SELECTOR = 'form[action*="submit-form.com"]';

// Default to 100px offset if invalid
return { enable, offset: isNaN(offset) ? 100 : offset };
```

### Function Purpose Comments

Single line above function describing intent and return behavior:

```javascript
// Load Botpoison SDK from CDN if not already loaded
// Returns promise resolving to true on success, false on failure
function load_botpoison_sdk() {}

// Read cookie value with fallback to manual parsing when js-cookie unavailable
function read_cookie(name) {}

// Show modal with entrance animation using Motion.dev
// Make container visible before animating to avoid layout jumps
async function show_modal() {}

// Extract Dutch mobile digits from a raw string
// Normalize user input to digits and strip Dutch prefixes
function extract_nl_mobile_digits(raw) {}
```

### Inline Logic Comments (WHY, Not WHAT)

**Good examples (explain reasoning):**
```javascript
// Prevent background scroll while modal is open
if (window.lenis) {
  window.lenis.stop();
}

// Warn if endpoint doesn't appear to be Formspark
if (endpoint && !endpoint.includes('submit-form.com')) {
  console.warn(`${LOG_PREFIX} Form endpoint may not be Formspark:`, endpoint);
}

// Add 10 second timeout to prevent infinite hang
const timeout = new Promise((_, reject) =>
  setTimeout(() => reject(new Error('Botpoison timeout')), 10000)
);

// Use modern Array.from or fallback to slice
return Array.from ? Array.from(node_list) : Array.prototype.slice.call(node_list);
```

**Bad examples (narrate implementation):**
```javascript
// ❌ Set price to price times 100
const price_cents = price * 100;

// ❌ Loop through items
for (const item of items) {}

// ❌ Call function
process_data();
```

### Platform and Library-Specific Comments

Reference external constraints or integration details:

```javascript
// WEBFLOW: collection list constraint (max 100 items)
// WEBFLOW: Designer API limitation - cannot modify locked elements
// BOTPOISON: Challenge may take several seconds on slow connections
// MIYAGI: requires Miyagi.ready() initialization
// MOTION: Animation requires Motion.dev library loaded
// LENIS: Smooth scroll integration point

// Detect debug mode from URL query parameter (?debug=true)
const debug_enabled = (() => {
  try {
    return new URLSearchParams(window.location.search).has('debug');
  } catch (e) {
    return false;
  }
})();

// Conditional logging for debug mode
function log(...args) {
  if (debug_enabled) {
    console.log(LOG_PREFIX, ...args);
  }
}
```

### Error Handling and Fallback Comments

Explain recovery strategies:

```javascript
// Ensure usable end state on animation failure
modal.style.opacity = '1';
modal.style.transform = 'scale(1) translateY(0)';

// Animate when Motion.dev is available, otherwise set end states
if (window.Motion?.animate) {
  // animation code
} else {
  // fallback code
}

// Retry on rate limiting with exponential backoff
if (response.status === 429 && attempt <= MAX_RETRIES) {
  const delay = 1000 * Math.pow(2, attempt - 1);
  console.warn(`Rate limited. Retrying in ${delay}ms`);
  await new Promise((resolve) => setTimeout(resolve, delay));
}
```

### Data Transformation Comments

Explain complex processing steps:

```javascript
// Format digits into +31 mobile layout and capture caret positions
function format_nl_mobile_value(raw) {}

// Map a digit index back to the formatted caret position
function caret_from_digit_positions(result, digit_count) {}

// Support both comma and pipe separators
const parts = attr
  .split(/[|,]/)
  .map((s) => s.trim())
  .filter(Boolean);
```

### Guard Clause and Early Return Comments

Explain validation checks when not obvious:

```javascript
// Check if scope itself is a form
if (scope.matches && scope.matches('form')) return scope;

// Skip if already initialized
if (dialog.dataset.welcomeInitialized === 'true') return;

// Bail early if element not found
if (!element) {
  console.warn('Element not found');
  return null;
}
```

### Performance and Optimization Comments

Explain caching, debouncing, or optimization choices:

```javascript
// Cache Botpoison client instances per public key to avoid recreation
const botpoison_clients = new Map();

// Debounce utility for performance
const debounce = (fn, d=300) => {
  let t;
  return (...a) => {
    clearTimeout(t);
    t = setTimeout(() => fn(...a), d);
  };
};

// Query elements fresh each time to handle DOM changes
function get_elements() {
  const dialog = document.querySelector(CONFIG.selectors.dialog);
  return { dialog, modal, background };
}

// PERFORMANCE: Cache result - recalculation is expensive (10k+ items)
const cached_result = compute_heavy_operation();
```

### State Management Comments

Explain state structure and purpose:

```javascript
// Gate structure tracks interception state for FsCC banner and manager modals
function create_gate(selector) {
  return {
    selector,
    element: null,
    original_open: null,
    release_requested: false
  };
}

// Visitor state determines sequencing flow (welcome → cookie consent)
const state = {
  has_seen_welcome: false,
  has_consent: false,
  awaiting_welcome_close: false
};
```

### CSS Comments

```css
.component { /* Compact inline CSS comment */ }

/* Override FsCC inline styles with !important */
/* Applied via JavaScript setProperty */
```

### JSDoc Usage (Minimal)

Use JSDoc only for public APIs or complex shared utilities:

```javascript
/**
 * Process user data and return formatted result
 * @param {Object} data - Raw user data
 * @returns {Object} Formatted user object
 */
function process_user_data(data) {}
```

**When to use JSDoc:**
- Public APIs exported to other modules
- Complex utilities with multiple parameters
- Functions used across multiple components

**When NOT to use JSDoc:**
- Private helper functions
- Simple one-parameter functions
- Functions with self-documenting names

### Comment Anti-Patterns

**What NOT to do:**

```javascript
// ❌ Narrating what code does
// Set price to price times 100
const price_cents = price * 100;

// ❌ Obvious comments
// Loop through items
for (const item of items) {}

// ❌ Commented-out code (delete instead)
// const old_value = calculate_old_way();

// ❌ TODO without context
// TODO: fix this

// ❌ Metadata in comments
// Created: 2024-01-15
// Author: John Doe
```

**Correct alternatives:**

```javascript
// ✅ Explains WHY
// Convert to cents to avoid floating point errors
const price_cents = price * 100;

// ✅ Adds context for non-obvious code
// Webflow duplicates IDs in collection lists - use class selector
const elements = document.querySelectorAll('.card');

// ✅ Explains constraint
// PERFORMANCE: Cache result - recalculation is expensive (10k+ items)
const cached_result = compute_heavy_operation();

// ✅ Specific actionable TODO
// FIXME: memory leak in event listener - detach on cleanup
```

---

## 4. 🔖 SPECIAL MARKERS

### Priority Flags

Use uppercase markers for critical information:

```javascript
// CRITICAL: handles authentication - do not modify without review
// PERFORMANCE: optimized for 10k+ items - benchmark before changing
// SECURITY: sanitizes user input - validate all changes
// DEPRECATED: use new_function() instead (remove in v2.0)
// BREAKING: this change requires migration script
```

### Platform and Integration Markers

Reference external systems and constraints:

```javascript
// WEBFLOW: collection list constraint (max 100 items)
// WEBFLOW: Designer API limitation - cannot modify locked elements
// MIYAGI: requires Miyagi.ready() initialization
// BOTPOISON: Challenge may take several seconds on slow connections
// FORMSPARK: API rate limit is 100 requests/hour
// MOTION: Animation requires Motion.dev library
// LENIS: Smooth scroll integration point
```

### Temporary Markers (Use Sparingly)

```javascript
// FIXME: memory leak in event listener - track down source
// HACK: workaround for Safari bug - remove when iOS 18 ships
// NOTE: this approach was chosen over X because Y
```

**Avoid:** Generic TODO comments without context, ownership, or deadline.

**Better:** Specific FIXME with issue description or ticket reference.

---

## 5. ✅ ENFORCEMENT AND TOOLING

### Automated Validation Rules

**File header requirements:**
- Exactly three lines for component header
- No metadata (dates, authors, tickets)
- Consistent separator line format

**Naming requirements:**
- Follow naming table for all identifiers
- Use semantic prefixes (is_, has_, handle_, etc.)
- Maintain consistency across files

**Comment requirements:**
- Maximum 5 comments per 10 lines
- Focus on WHY, not WHAT
- Remove commented-out code

### Common Violations and Fixes

**Header violations:**
```javascript
// ❌ WRONG: Metadata in header
// Task: PROJ-123
// Author: Developer
// Date: 2024-01-15

// ✅ RIGHT: Minimal component header
// ───────────────────────────────────────────────────────────────
// COMPONENT: NAVIGATION
// ───────────────────────────────────────────────────────────────
```

**Naming violations:**
```javascript
// ❌ WRONG: Mixed conventions
const userName = 'test';       // camelCase in JS
function GetData() {}          // PascalCase for function
const Max_Size = 100;          // Mixed case for constant

// ✅ RIGHT: Consistent snake_case
const user_name = 'test';
function get_data() {}
const MAX_SIZE = 100;
```

**Comment violations:**
```javascript
// ❌ WRONG: Narrating implementation
// Loop through each item in the array
for (const item of items) {
  // Call process function on item
  process_item(item);
}

// ✅ RIGHT: Explain reasoning
// Process items in order to maintain sequence dependencies
for (const item of items) {
  process_item(item);
}
```

### Tool Support

**ESLint configuration:**
- Enforces snake_case naming
- Validates file header format
- Checks comment density
- Flags commented-out code

**Stylelint configuration:**
- Validates CSS kebab-case naming
- Enforces BEM conventions
- Checks file header format

---

**Core principle:** Keep naming predictable across languages and layers, keep comments focused on intent and platform constraints, and enforce minimal headers without metadata.
