# Animation Strategy & Standards

Defines our animation strategy across the project: CSS is the default for simple interactions; Motion.dev is the only JavaScript animation library we use for sequences that CSS cannot express ergonomically.

This keeps payloads small, performance high, and behavior predictable.

#### 📋 TABLE OF CONTENTS

- [Animation Strategy \& Standards](#animation-strategy--standards)
      - [📋 TABLE OF CONTENTS](#-table-of-contents)
  - [1. 🧭 DECISION FRAMEWORK](#1--decision-framework)
    - [Primary Order (Use in Sequence)](#primary-order-use-in-sequence)
    - [Quick Decision Tree](#quick-decision-tree)
  - [2. 🧰 CSS-FIRST PLAYBOOK](#2--css-first-playbook)
  - [3. ⚙️ ANIME.JS INTEGRATION](#3-️-animejs-integration)
    - [How we load it](#how-we-load-it)
    - [Defensive loading in components](#defensive-loading-in-components)
    - [Parameters we standardize](#parameters-we-standardize)
    - [In‑repo examples (authoritative patterns)](#inrepo-examples-authoritative-patterns)
  - [4. 🚦 PERFORMANCE \& ACCESSIBILITY](#4--performance--accessibility)
  - [5. 🧪 TESTING \& DEBUGGING](#5--testing--debugging)

---

## 1. 🧭 DECISION FRAMEWORK

### Primary Order (Use in Sequence)

1. CSS transitions/keyframes — first choice for hover, focus, small reveals, and state changes
2. Motion.dev — used when we need programmatic control, in‑view triggers, or coordinated sequences

### Quick Decision Tree

```
Need animation?
├─> Can CSS express it (transform/opacity/clip/mask)? -> Use CSS
└─> Requires sequencing/stagger/scroll/in‑view logic? -> Use Motion.dev
```

---

## 2. 🧰 CSS-FIRST PLAYBOOK

- Prefer transform and opacity over layout properties
  - translate/scale/rotate + opacity are GPU‑friendly and avoid layout thrash
- Keep durations short; ease on enter, linear on continuous motion
- Respect user settings
  - Use `@media (prefers-reduced-motion: reduce)` to shorten/disable where appropriate
- Co-locate CSS variables for timing/easing on the component root
- Dropdown/open‑close pattern (no layout jump):
  ```css
  .dropdown { overflow: hidden; height: 0; opacity: 0; transition: height .3s var(--ease-out), opacity .2s var(--ease-out); }
  .dropdown[open] { height: auto; opacity: 1; }
  /* JS measures natural height once and transitions height from 0px -> measured px, then sets height:auto at end */
  ```

---

## 3. ⚙️ MOTION.DEV INTEGRATION

### How we load it

We load Motion.dev once, as an ES module, and expose it globally for components:

```html
<!-- src/0_html/global.html -->
<script type="module">
  const lib = await import('https://cdn.jsdelivr.net/npm/motion@12.15.0/+esm');
  window.Motion = lib; // { animate, inView, scroll, stagger, ... }
</script>
```

### Defensive loading in components

```javascript
// CDN-safe pattern with Motion.dev retry logic
(() => {
  const INIT_FLAG = '__animationComponentCdnInit';
  const INIT_DELAY_MS = 50;

  function init_component() {
    const { animate, inView } = window.Motion || {};
    if (!animate || !inView) { setTimeout(init_component, 100); return; }
    // ...use animate/inView here
  }

  const start = () => {
    if (window[INIT_FLAG]) return;
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
})();
```

**Note**: The CDN-safe guard-based pattern wraps the Motion.dev retry logic. See [initialization_pattern.md](./initialization_pattern.md) for the complete pattern documentation.

### Parameters we standardize

- From/to arrays for properties: `{ opacity: [0, 1], x: ['-7.5rem', '0rem'] }`
- Easing curves (keep consistent with Webflow):
  - `easeOut = [0.22, 1, 0.36, 1]`
  - `expoOut = [0.16, 1, 0.3, 1]`
- Clean up `will-change`/temporary styles on `onComplete`
- Use `inView()` for one‑time entrance per block

### In‑repo examples (authoritative patterns)

- `/src/2_javascript/hero/hero_general.js` — inView‑based, multi‑phase sequence with easing maps; loader fadeout; will‑change cleanup
- `/src/2_javascript/hero/hero_blog_article.js` — content‑first then overlay; short durations and expoOut
- `/src/2_javascript/navigation/language_selector.js` — dropdown open/close measured height with animate()

---

## 4. 🚦 PERFORMANCE & ACCESSIBILITY

- Set initial states to prevent flicker before animating (opacity 0, transforms off‑screen)
- Minimize reflows; batch style writes and avoid toggling layout properties mid‑animation
- Remove `will-change` after transitions to avoid keeping layers promoted
- Respect `prefers-reduced-motion`; when reduced, skip sequences and set end states directly

---

## 5. 🧪 TESTING & DEBUGGING

1. Verify desktop/tablet/mobile timing; keep animations brief on mobile
2. Confirm no layout jumps (measure before animate; `height: auto` after)
3. Run with `prefers-reduced-motion: reduce` to ensure graceful behavior
4. Use DevTools Performance to look for long main‑thread tasks and forced reflows

---

**Remember**: Keeps payloads small, performance high, and behavior predictable.