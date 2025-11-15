# Animation Strategy - Project Animation Guidelines

Standard approach for all project animations: CSS-first for simple interactions, Motion.dev for complex sequences that CSS cannot express ergonomically. This keeps payloads small, performance high, and behavior predictable.

#### 📋 TABLE OF CONTENTS

1. [🎯 WHEN TO USE EACH ANIMATION APPROACH](#1--when-to-use-each-animation-approach)
2. [🎨 CSS ANIMATION IMPLEMENTATION](#2--css-animation-implementation)
3. [⚡ MOTION.DEV INTEGRATION](#3--motiondev-integration)
4. [🚀 PERFORMANCE AND ACCESSIBILITY REQUIREMENTS](#4--performance-and-accessibility-requirements)
5. [🧪 TESTING AND DEBUGGING PROCEDURES](#5--testing-and-debugging-procedures)

---

## 1. 🎯 WHEN TO USE EACH ANIMATION APPROACH

### Primary Decision Order

Use this sequence when implementing animations:

1. **CSS transitions/keyframes** - First choice for hover, focus, small reveals, and state changes
2. **Motion.dev** - Use when you need programmatic control, in-view triggers, or coordinated sequences

### Decision Tree

```
Need animation?
├─> Can CSS express it (transform/opacity/clip/mask)?
│   └─> Use CSS
└─> Requires sequencing/stagger/scroll/in-view logic?
    └─> Use Motion.dev
```

**When CSS is sufficient:**
- Hover/focus states
- Simple state transitions (open/close, show/hide)
- Single-property animations
- Looping animations without timing dependencies

**When Motion.dev is required:**
- Scroll-triggered animations
- In-view entrance sequences
- Staggered animations (multiple elements with delays)
- Coordinated multi-step sequences
- Programmatic timing control

---

## 2. 🎨 CSS ANIMATION IMPLEMENTATION

### Core Principles

**Use GPU-accelerated properties:**
- Transform (translate, scale, rotate)
- Opacity
- Avoid: width, height, top, left (cause layout thrash)

**Timing guidance:**
- Keep durations short (200-400ms for most interactions)
- Use `ease-out` for enter animations
- Use `linear` for continuous motion

**Accessibility compliance:**
```css
@media (prefers-reduced-motion: reduce) {
  .animated-element {
    animation-duration: 0.01ms;
    transition-duration: 0.01ms;
  }
}
```

### Dropdown Pattern (No Layout Jump)

**Problem:** Height transitions from 0 to auto cause layout jumps.

**Solution:** Measure natural height, transition to pixel value, then set auto:

```css
.dropdown {
  overflow: hidden;
  height: 0;
  opacity: 0;
  transition:
    height 0.3s cubic-bezier(0.22, 1, 0.36, 1),
    opacity 0.2s cubic-bezier(0.22, 1, 0.36, 1);
}

.dropdown[open] {
  height: auto; /* Set by JS after transition */
  opacity: 1;
}
```

```javascript
// JavaScript measures and applies height
const dropdown = document.querySelector('.dropdown');
const naturalHeight = dropdown.scrollHeight;
dropdown.style.height = `${naturalHeight}px`;

// After transition, remove fixed height
dropdown.addEventListener('transitionend', () => {
  dropdown.style.height = 'auto';
}, { once: true });
```

---

## 3. ⚡ MOTION.DEV INTEGRATION

### Library Loading

Load Motion.dev once as an ES module and expose globally:

```html
<!-- src/0_html/global.html -->
<script type="module">
  const lib = await import('https://cdn.jsdelivr.net/npm/motion@12.15.0/+esm');
  window.Motion = lib; // { animate, inView, scroll, stagger, ... }
</script>
```

**Why this approach:**
- Single CDN request for all components
- Global availability prevents import duplication
- Version-locked for stability

### Component Initialization Pattern

Use CDN-safe initialization with Motion.dev retry logic:

```javascript
(() => {
  const INIT_FLAG = '__animationComponentCdnInit';
  const INIT_DELAY_MS = 50;

  function init_component() {
    const { animate, inView } = window.Motion || {};

    // Retry if Motion.dev not loaded yet
    if (!animate || !inView) {
      setTimeout(init_component, 100);
      return;
    }

    // Your animation logic here
    inView('.hero-element', ({ target }) => {
      animate(target,
        { opacity: [0, 1], y: [40, 0] },
        { duration: 0.6, easing: [0.22, 1, 0.36, 1] }
      );
    });
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

  // Webflow compatibility
  if (window.Webflow?.push) {
    window.Webflow.push(start);
  } else {
    start();
  }
})();
```

**Pattern explanation:**
- `INIT_FLAG` prevents double initialization
- `INIT_DELAY_MS` ensures DOM is stable
- Retry logic handles CDN loading delays
- Webflow.push integration for proper timing

See [initialization_pattern.md](./initialization_pattern.md) for complete CDN-safe pattern documentation.

### Standardized Animation Parameters

**From/to arrays for properties:**
```javascript
animate(element, {
  opacity: [0, 1],           // From 0 to 1
  x: ['-7.5rem', '0rem'],    // From left to center
  scale: [0.95, 1]           // From smaller to full size
}, options);
```

**Easing curves (aligned with Webflow):**
```javascript
const easings = {
  easeOut: [0.22, 1, 0.36, 1],    // General purpose
  expoOut: [0.16, 1, 0.3, 1]      // Dramatic entrances
};

animate(element, properties, {
  duration: 0.6,
  easing: easings.easeOut
});
```

**Cleanup on completion:**
```javascript
animate(element, { opacity: [0, 1] }, {
  duration: 0.6,
  onComplete: () => {
    element.style.willChange = '';  // Remove GPU hint
  }
});
```

**In-view one-time entrances:**
```javascript
inView('.section', ({ target }) => {
  animate(target, { opacity: [0, 1], y: [40, 0] }, { duration: 0.6 });
}, {
  amount: 0.3  // Trigger when 30% visible
});
```

### Reference Implementations

**Authoritative patterns in codebase:**

| File | Pattern Demonstrated |
|------|---------------------|
| `src/2_javascript/hero/hero_general.js` | InView-based multi-phase sequence, easing maps, loader fadeout, will-change cleanup |
| `src/2_javascript/hero/hero_blog_article.js` | Content-first then overlay, short durations, expoOut easing |
| `src/2_javascript/navigation/language_selector.js` | Dropdown open/close with measured height animation |

---

## 4. 🚀 PERFORMANCE AND ACCESSIBILITY REQUIREMENTS

### Performance Optimization

**Set initial states to prevent flicker:**
```css
.animated-entrance {
  opacity: 0;
  transform: translateY(40px);
}
```

**Batch style writes:**
```javascript
// Bad: Causes layout thrashing
elements.forEach(el => {
  el.style.height = `${el.scrollHeight}px`; // Read
  el.classList.add('active');                // Write
});

// Good: Batch reads, then writes
const heights = elements.map(el => el.scrollHeight);
elements.forEach((el, i) => {
  el.style.height = `${heights[i]}px`;
  el.classList.add('active');
});
```

**Remove will-change after transitions:**
```javascript
element.style.willChange = 'transform, opacity';
animate(element, properties, {
  onComplete: () => {
    element.style.willChange = ''; // Restore normal layer behavior
  }
});
```

### Accessibility Requirements

**Respect prefers-reduced-motion:**
```javascript
const prefersReducedMotion = window.matchMedia(
  '(prefers-reduced-motion: reduce)'
).matches;

if (prefersReducedMotion) {
  // Skip animation, apply end state directly
  element.style.opacity = '1';
  element.style.transform = 'none';
} else {
  // Run full animation sequence
  animate(element, { opacity: [0, 1] }, { duration: 0.6 });
}
```

---

## 5. 🧪 TESTING AND DEBUGGING PROCEDURES

### Pre-deployment Checklist

**Cross-device timing verification:**
1. Desktop - Verify full animation durations
2. Tablet - Check medium viewport behavior
3. Mobile - Ensure animations are brief (300ms max recommended)

**Layout stability:**
1. Measure before animating (capture scrollHeight, offsetWidth)
2. Apply transitions to measured pixel values
3. Set `height: auto` / `width: auto` after transition completes
4. Verify no content jumps during animation

**Reduced motion testing:**
1. Enable "Reduce motion" in OS accessibility settings
2. Verify animations either skip or use minimal duration (<20ms)
3. Confirm end states are visually correct without animation

**Performance profiling:**
1. Open DevTools Performance panel
2. Record during animation sequence
3. Check for:
   - Long tasks (>50ms on main thread)
   - Forced reflows (purple bars)
   - Excessive layer promotions

### Common Issues and Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Layout jump on height animation | Transitioning to `height: auto` | Measure scrollHeight, transition to pixel value, then set auto |
| Jank on scroll | Animating layout properties | Use transform/opacity only; add `will-change` temporarily |
| Animation doesn't start | Motion.dev not loaded | Add retry logic with setTimeout |
| Elements flicker before animation | No initial state set | Set opacity: 0 in CSS before JS runs |

---

**Core principle:** CSS first for simplicity, Motion.dev for complexity. Keeps payloads small, performance high, and behavior predictable.
