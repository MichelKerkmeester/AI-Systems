# UI Designer - Templates & Patterns

**Ready-to-Use Templates, Code Examples, and Practical Implementations**

This document contains all practical templates, code examples, component patterns, and implementation specifications. For design theory, decision-making frameworks, and quality assessment methodologies, see **UI Designer - Visual Excellence**.

---

## 📋 TABLE OF CONTENTS

1. [🎨 Variant Strategy Templates](#1-variant-strategy-templates)
2. [📝 Typography Templates](#2-typography-templates)
3. [🎨 Color Palette Templates](#3-color-palette-templates)
4. [📏 Spacing System Templates](#4-spacing-system-templates)
5. [🧩 Component Pattern Library](#5-component-pattern-library)
6. [📐 Layout Pattern Templates](#6-layout-pattern-templates)
7. [✨ Visual Effect Templates](#7-visual-effect-templates)
8. [📱 Responsive Templates](#8-responsive-templates)
9. [🎭 Ready-to-Use Theme Templates](#9-ready-to-use-theme-templates)
10. [🏎️ Quick Lookup Reference](#10-quick-lookup-reference)

---

## 1. 🎨 VARIANT STRATEGY TEMPLATES

### Strategy Comparison Table

| Strategy | Philosophy | Best For | Strengths | Weaknesses |
|----------|-----------|----------|-----------|------------|
| **Minimalist/Executive** | Less is exponentially more | Executive dashboards, SaaS, content-focused apps | Professional, fast to process, elegant | Can feel sparse, less engaging |
| **Bold/Expressive** | Make a statement, command attention | Marketing pages, creative portfolios, youth brands | Memorable, energetic, stands out | Can overwhelm, may feel immature for enterprise |
| **Classic/Traditional** | Timeless, trustworthy, familiar | Financial, legal, academic, healthcare | Trust-building, professional, widely accepted | Can feel dated, less innovative |
| **Modern/Trendy** | Contemporary, design-forward | Tech startups, design agencies, consumer apps | Feels current, visually striking, memorable | May date quickly, can feel too trendy |
| **Data-Dense** | Maximum information density | Analytics dashboards, admin panels, trading platforms | Efficient, comprehensive, single-screen view | Overwhelming for casual users, high cognitive load |
| **Playful/Creative** | Delight users, break conventions | Children's apps, entertainment, creative tools | Memorable, engaging, emotionally connective | Can feel unprofessional, may alienate serious users |
| **Mobile-First** | Thumb-friendly, streamlined | Mobile-first apps, social media, e-commerce mobile | Perfect mobile UX, fast interaction | Desktop version may feel overly simplified |

### Strategy 1: Consistency First (Minimalist/Executive)

```yaml
minimalist_strategy:
  philosophy: "Less is exponentially more"

  visual_markers:
    whitespace: "40-60% of canvas"
    color_palette: "Monochromatic or 2 colors max"
    typography: "Clean sans-serif, line-height 1.6-1.8"
    padding: "2-3x normal (32px instead of 16px)"
    borders: "1px solid #E5E7EB or none"
    palette: "#f8f9fa backgrounds, #1a1a1a text"
```

### Strategy 2: Evolution-Friendly (Modern/Trendy)

```yaml
modern_strategy:
  philosophy: "Contemporary, design-forward"

  visual_markers:
    color_palette: "Duotones, gradients, vibrant with pastels"
    typography: "Geometric sans-serifs, variable fonts"
    elements: "Glassmorphism, 3D illustrations"
    effects: "backdrop-filter: blur(10px), rgba backgrounds"
    fonts: "Inter, Poppins, Clash Display"
    shadows: "0 10px 30px rgba(0,0,0,0.1)"
```

### Strategy 3: User Experience Priority (Mobile-Optimized)

```yaml
mobile_optimized_strategy:
  philosophy: "Thumb-friendly, mobile-first, streamlined"

  visual_markers:
    touch_targets: "Minimum 44px height"
    layout: "Single column, vertical flow"
    typography: "16px+ body, line-height 1.6"
    navigation: "Bottom navigation (not top)"
    thumb_zone: "Important actions in bottom 60% of screen"
    cta: "Fixed bottom CTAs for easy thumb access"
```

---

## 2. 📝 TYPOGRAPHY TEMPLATES

### 2.1 Typography Scale Templates

#### Perfect Fourth Ratio (1.333)

```yaml
perfect_fourth_scale:
  ratio: 1.333
  description: "Harmonious, balanced, professional - best for business applications"

  scale:
    xs: "12px"    # Fine print, captions
    sm: "14px"    # Supporting text, labels
    base: "16px"  # Body text (default)
    lg: "21px"    # (16 × 1.333) Subheadings
    xl: "28px"    # Section headings
    "2xl": "37px" # Page headings
    "3xl": "49px" # Hero text
    "4xl": "65px" # Extra large display

  line_heights:
    xs: "1.4"
    sm: "1.5"
    base: "1.6"
    lg: "1.5"
    xl: "1.4"
    "2xl": "1.2"
    "3xl": "1.1"
```

#### Major Third Ratio (1.25)

```yaml
major_third_scale:
  ratio: 1.25
  description: "Subtle, elegant, refined - best for sophisticated brands"

  scale:
    xs: "13px"
    sm: "14px"
    base: "16px"
    lg: "20px"
    xl: "25px"
    "2xl": "31px"
    "3xl": "39px"
    "4xl": "49px"

  line_heights:
    xs: "1.5"
    sm: "1.6"
    base: "1.7"
    lg: "1.6"
    xl: "1.4"
    "2xl": "1.3"
    "3xl": "1.2"
```

#### Golden Ratio (1.618)

```yaml
golden_ratio_scale:
  ratio: 1.618
  description: "Dramatic, bold, expressive - best for attention-grabbing designs"

  scale:
    xs: "10px"
    sm: "13px"
    base: "16px"
    lg: "26px"
    xl: "42px"
    "2xl": "68px"
    "3xl": "110px"

  line_heights:
    xs: "1.4"
    sm: "1.5"
    base: "1.6"
    lg: "1.4"
    xl: "1.3"
    "2xl": "1.1"
    "3xl": "1.0"
```

### 2.2 Proven Font Combinations

```yaml
font_pairings:
  professional_classic:
    heading: "Merriweather (serif)"
    body: "Open Sans (sans-serif)"
    personality: "Trustworthy, readable, professional"
    import: "https://fonts.googleapis.com/css2?family=Merriweather:wght@700;900&family=Open+Sans:wght@400;600"

  modern_tech:
    heading: "Inter (sans-serif)"
    body: "Inter (same font, different weights)"
    personality: "Clean, modern, tech-forward"
    import: "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700"

  elegant_editorial:
    heading: "Playfair Display (serif)"
    body: "Source Sans Pro (sans-serif)"
    personality: "Sophisticated, editorial, refined"
    import: "https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Source+Sans+Pro:wght@400;600"

  friendly_approachable:
    heading: "Poppins (geometric sans)"
    body: "Poppins (same font, lighter weight)"
    personality: "Friendly, modern, approachable"
    import: "https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700"
```

---

## 3. 🎨 COLOR PALETTE TEMPLATES

### 3.1 Color Harmony Method Examples

#### Monochromatic Palette (Blue)

```yaml
monochromatic_blue:
  description: "Single hue with varying saturation and lightness"
  use_case: "Minimalist, elegant, focused designs"

  palette:
    base: "#2563EB"      # Blue 600 - Primary
    light: "#93C5FD"     # Blue 300
    lighter: "#DBEAFE"   # Blue 100
    dark: "#1E40AF"      # Blue 700
    darker: "#1E3A8A"    # Blue 900

  usage:
    primary_action: "#2563EB"
    hover_state: "#1E40AF"
    background: "#DBEAFE"
    text_on_light: "#1E3A8A"
    text_on_dark: "#DBEAFE"
```

#### Analogous Palette (Blue-Purple-Cyan)

```yaml
analogous_harmony:
  description: "Colors adjacent on color wheel"
  use_case: "Harmonious, natural-feeling palettes"

  palette:
    primary: "#3B82F6"   # Blue
    secondary: "#8B5CF6" # Purple
    tertiary: "#06B6D4"  # Cyan

  usage:
    primary_button: "#3B82F6"
    secondary_button: "#8B5CF6"
    info_badges: "#06B6D4"
```

#### Complementary Palette (Red-Green)

```yaml
complementary_harmony:
  description: "Colors opposite on color wheel"
  use_case: "High contrast, vibrant, attention-grabbing"

  palette:
    primary: "#EF4444"   # Red
    complement: "#10B981" # Green

  usage:
    error_state: "#EF4444"
    success_state: "#10B981"
    warning: "#F59E0B"
    info: "#3B82F6"
```

#### Triadic Palette (Red-Blue-Yellow)

```yaml
triadic_harmony:
  description: "Three colors evenly spaced on color wheel"
  use_case: "Balanced, vibrant, playful"

  palette:
    color_1: "#EF4444"   # Red
    color_2: "#3B82F6"   # Blue
    color_3: "#F59E0B"   # Yellow/Orange
```

### 3.2 Complete Color System Template

```yaml
complete_color_system:
  semantic_colors:
    primary: "#2563EB"
    secondary: "#64748B"
    accent: "#F59E0B"
    success: "#10B981"
    warning: "#F59E0B"
    error: "#EF4444"
    info: "#3B82F6"

  text_colors:
    primary: "#111827"
    secondary: "#6B7280"
    tertiary: "#9CA3AF"
    disabled: "#D1D5DB"
    inverted: "#F9FAFB"

  background_colors:
    canvas: "#FFFFFF"
    surface: "#F9FAFB"
    elevated: "#FFFFFF"
    overlay: "rgba(0, 0, 0, 0.5)"

  border_colors:
    subtle: "#F3F4F6"
    default: "#E5E7EB"
    strong: "#D1D5DB"
    interactive: "#3B82F6"
```

---

## 4. 📏 SPACING SYSTEM TEMPLATES

### 4.1 8-Point Grid System

```yaml
eight_point_grid:
  philosophy: "All spacing is a multiple of 8px"

  scale:
    "0": "0px"
    "1": "8px"     # Compact
    "2": "16px"    # Standard
    "3": "24px"    # Comfortable
    "4": "32px"    # Generous
    "5": "40px"    # Spacious
    "6": "48px"    # Very spacious
    "8": "64px"    # Section breaks
    "10": "80px"   # Major sections
    "12": "96px"   # Large gaps

  css: |
    :root {
      --spacing-0: 0px; --spacing-1: 8px; --spacing-2: 16px;
      --spacing-3: 24px; --spacing-4: 32px; --spacing-5: 40px;
      --spacing-6: 48px; --spacing-8: 64px; --spacing-10: 80px;
      --spacing-12: 96px;
    }
```

### 4.2 Golden Ratio Spacing

```yaml
golden_ratio_spacing:
  ratio: 1.618
  philosophy: "Naturally pleasing proportions"

  scale:
    base: "16px"
    step_1: "26px"
    step_2: "42px"
    step_3: "68px"
    step_4: "110px"

  best_for: "Dramatic, organic, nature-inspired designs"
```

### 4.3 Component-Specific Spacing

```yaml
component_spacing:
  buttons:
    padding: "12px 24px"
    min_height: "44px"
    gap: "8-16px"

  forms:
    label_to_input: "8px"
    input_height: "40-48px"
    field_gap: "16-24px"
    section_gap: "32-48px"

  cards:
    padding: "16-32px"
    gap: "16-24px"

  navigation:
    height: "56-64px"
    item_padding: "8-16px"
    item_gap: "8px"
```

---

## 5. 🧩 COMPONENT PATTERN LIBRARY

### 5.1 Button Patterns

#### Primary Button (Complete Example)

```css
.btn-primary {
  background: #2563EB;
  color: #FFFFFF;
  padding: 12px 24px;
  border-radius: 8px;
  font-weight: 600;
  font-size: 16px;
  border: none;
  cursor: pointer;
  transition: all 200ms ease;
}

.btn-primary:hover {
  background: #1E40AF;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
}

.btn-primary:active {
  background: #1E3A8A;
  transform: translateY(0);
}

.btn-primary:disabled {
  background: #93C5FD;
  opacity: 0.5;
  cursor: not-allowed;
}
```

#### Button Variants (CSS Differences Only)

```css
/* Secondary: Transparent background with border */
.btn-secondary {
  background: transparent;
  color: #2563EB;
  border: 1px solid #2563EB;
}
.btn-secondary:hover { background: #EFF6FF; }

/* Ghost: No border, minimal styling */
.btn-ghost {
  background: transparent;
  color: #2563EB;
  border: none;
  padding: 8px 16px;
}
.btn-ghost:hover { background: rgba(37, 99, 235, 0.1); }

/* Icon: Square/circular button */
.btn-icon {
  width: 40px;
  height: 40px;
  padding: 10px;
  border-radius: 8px;
}
.btn-icon:hover { background: rgba(0, 0, 0, 0.05); }
```

### 5.2 Form Patterns

```css
.input {
  height: 40px;
  padding: 8px 12px;
  border: 1px solid #D1D5DB;
  border-radius: 6px;
  font-size: 16px;
  transition: border-color 200ms ease;
}

.input:hover { border-color: #9CA3AF; }

.input:focus {
  outline: none;
  border-color: #2563EB;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.input.error { border-color: #EF4444; }
.input:disabled { background: #F3F4F6; cursor: not-allowed; }

label {
  display: block;
  font-weight: 500;
  margin-bottom: 8px;
  color: #374151;
}

.error-message {
  color: #EF4444;
  font-size: 14px;
  margin-top: 4px;
}
```

### 5.3 Card Patterns

```css
.card {
  background: #FFFFFF;
  border: 1px solid #E5E7EB;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  transition: all 200ms ease;
}

.card:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  transform: translateY(-2px);
}

/* Variants */
.card-elevated { box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 32px; }
.card-flat { box-shadow: none; padding: 16px; }
```

### 5.4 Navigation Patterns

```css
/* Horizontal Nav */
.nav {
  height: 64px;
  padding: 0 24px;
  background: #FFFFFF;
  border-bottom: 1px solid #E5E7EB;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.nav-link {
  padding: 8px 16px;
  color: #6B7280;
  text-decoration: none;
  border-radius: 6px;
  transition: all 150ms ease;
}

.nav-link:hover { background: #F3F4F6; color: #111827; }
.nav-link.active { color: #2563EB; background: #EFF6FF; }

/* Sidebar Nav */
.sidebar {
  width: 280px;
  background: #F9FAFB;
  border-right: 1px solid #E5E7EB;
  height: 100vh;
}

.sidebar-item {
  padding: 12px 16px;
  color: #6B7280;
  border-left: 3px solid transparent;
  transition: all 150ms ease;
}

.sidebar-item:hover { background: #E5E7EB; color: #111827; }
.sidebar-item.active { background: #EFF6FF; color: #2563EB; border-left-color: #2563EB; }
```

---

## 6. 📐 LAYOUT PATTERN TEMPLATES

### 6.1 Hero Section Templates

```css
/* Centered Hero */
.hero-centered {
  text-align: center;
  max-width: 800px;
  margin: 0 auto;
  padding: 80px 24px;
}

.hero-centered h1 {
  font-size: 56px;
  font-weight: 700;
  margin-bottom: 24px;
  line-height: 1.2;
}

.hero-centered p {
  font-size: 20px;
  color: #6B7280;
  margin-bottom: 32px;
}

/* Split Hero */
.hero-split {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 64px;
  align-items: center;
  padding: 80px 24px;
  max-width: 1280px;
  margin: 0 auto;
}

@media (max-width: 768px) {
  .hero-split { grid-template-columns: 1fr; }
}
```

### 6.2 Grid Layout Templates

```css
/* Three Column Grid */
.grid-3col {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 24px;
}

@media (max-width: 1024px) { .grid-3col { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 640px) { .grid-3col { grid-template-columns: 1fr; } }

/* Asymmetric Grid */
.grid-asymmetric {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 32px;
  max-width: 1280px;
  margin: 0 auto;
}

@media (max-width: 768px) { .grid-asymmetric { grid-template-columns: 1fr; } }

/* Bento Box Grid */
.grid-bento {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-template-rows: repeat(3, 200px);
  gap: 16px;
}

.grid-item-large { grid-column: span 2; grid-row: span 2; }
.grid-item-wide { grid-column: span 2; }
.grid-item-tall { grid-row: span 2; }
```

### 6.3 Dashboard Layout

```css
.dashboard {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;
  padding: 24px;
}

.kpi-cards {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}

.chart-row {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}
```

---

## 7. ✨ VISUAL EFFECT TEMPLATES

### 7.1 Essential Micro-Interactions

```css
/* Button Press */
.btn-interactive { transition: transform 150ms ease-out; }
.btn-interactive:hover { transform: scale(1.02); }
.btn-interactive:active { transform: scale(0.98); }

/* Card Hover */
.card-hover { transition: all 200ms ease-out; }
.card-hover:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0,0,0,0.15);
}

/* Loading Spinner */
.spinner {
  width: 24px;
  height: 24px;
  border: 3px solid rgba(37, 99, 235, 0.2);
  border-top-color: #2563EB;
  border-radius: 50%;
  animation: spin 800ms linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* Toast Notification */
.toast {
  position: fixed;
  top: 16px;
  right: 16px;
  background: #FFFFFF;
  padding: 16px 24px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  animation: slideIn 300ms ease-out;
}

@keyframes slideIn {
  from { transform: translateY(-100%); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}
```

### 7.2 Transition Templates

```yaml
transition_timing:
  quick:
    duration: "150ms"
    easing: "ease-out"
    use_for: "Button hovers, icon changes, small UI elements"
    css: "transition: all 150ms ease-out;"

  standard:
    duration: "200-250ms"
    easing: "ease-in-out"
    use_for: "Card hovers, dropdowns, standard interactions"
    css: "transition: all 200ms ease-in-out;"

  slow:
    duration: "300-400ms"
    easing: "ease-out"
    use_for: "Page transitions, modal reveals, large movements"
    css: "transition: all 300ms ease-out;"

  spring:
    easing: "cubic-bezier(0.34, 1.56, 0.64, 1)"
    use_for: "Playful brands, delightful feedback"
    css: "transition: transform 400ms cubic-bezier(0.34, 1.56, 0.64, 1);"
```

### 7.3 Contemporary Effects

```css
/* Glassmorphism */
.glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
}

/* Neumorphism */
.neumorphic {
  background: #e0e5ec;
  box-shadow: 9px 9px 16px #a3b1c6, -9px -9px 16px #ffffff;
  border-radius: 12px;
}

/* Gradient Mesh */
.gradient-mesh {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 25%, #f093fb 50%, #4facfe 100%);
}
```

---

## 8. 📱 RESPONSIVE TEMPLATES

### 8.1 Responsive Breakpoints

```yaml
responsive_breakpoints:
  mobile_small: "320px"
  mobile: "375px"
  mobile_large: "414px"
  tablet: "768px"
  desktop_small: "1024px"
  desktop: "1280px"
  desktop_large: "1920px"
```

```css
/* Mobile first approach */
.container { padding: 16px; }

@media (min-width: 768px) { .container { padding: 24px; } }

@media (min-width: 1280px) {
  .container {
    padding: 32px;
    max-width: 1280px;
    margin: 0 auto;
  }
}
```

### 8.2 Mobile-First Responsive Grid

```css
.responsive-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 16px;
  padding: 16px;
}

@media (min-width: 640px) {
  .responsive-grid { grid-template-columns: repeat(2, 1fr); gap: 24px; }
}

@media (min-width: 1024px) {
  .responsive-grid { grid-template-columns: repeat(3, 1fr); gap: 32px; }
}

@media (min-width: 1280px) {
  .responsive-grid { grid-template-columns: repeat(4, 1fr); }
}
```

### 8.3 Touch Target Specifications

```yaml
touch_targets:
  minimum_size: "44px × 44px"
  recommended_size: "48px × 48px"

  css: |
    .touch-target {
      min-width: 44px;
      min-height: 44px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }
```

---

## 9. 🎭 READY-TO-USE THEME TEMPLATES

**Purpose:** Copy-paste complete CSS theme systems ready for immediate use.

**Usage:** Copy the entire `:root {}` block into your HTML `<style>` section and all theme values are instantly applied.

---

### Template 1: Neo-Brutalism (90s Web Revival)

```css
:root {
  /* Colors */
  --background: oklch(1.0000 0 0);           /* Pure white */
  --foreground: oklch(0 0 0);                /* Pure black */
  --primary: oklch(0.6489 0.2370 26.9728);   /* Bold orange */
  --primary-foreground: oklch(1.0000 0 0);
  --secondary: oklch(0.9680 0.2110 109.7692); /* Bright lime */
  --secondary-foreground: oklch(0 0 0);
  --accent: oklch(0.5635 0.2408 260.8178);   /* Deep purple */
  --accent-foreground: oklch(1.0000 0 0);
  --muted: oklch(0.9551 0 0);                /* Light gray */
  --muted-foreground: oklch(0.3211 0 0);
  --destructive: oklch(0 0 0);
  --destructive-foreground: oklch(1.0000 0 0);
  --border: oklch(0 0 0);                    /* Black borders */
  --input: oklch(0 0 0);
  --ring: oklch(0.6489 0.2370 26.9728);

  /* Fonts */
  --font-sans: DM Sans, sans-serif;
  --font-serif: ui-serif, Georgia, Cambria, "Times New Roman", Times, serif;
  --font-mono: Space Mono, monospace;

  /* Borders */
  --radius: 0px;                             /* Sharp corners */

  /* Shadows - Offset style */
  --shadow-2xs: 4px 4px 0px 0px hsl(0 0% 0% / 0.50);
  --shadow-xs: 4px 4px 0px 0px hsl(0 0% 0% / 0.50);
  --shadow-sm: 4px 4px 0px 0px hsl(0 0% 0% / 1.00), 4px 1px 2px -1px hsl(0 0% 0% / 1.00);
  --shadow: 4px 4px 0px 0px hsl(0 0% 0% / 1.00), 4px 1px 2px -1px hsl(0 0% 0% / 1.00);
  --shadow-md: 4px 4px 0px 0px hsl(0 0% 0% / 1.00), 4px 2px 4px -1px hsl(0 0% 0% / 1.00);
  --shadow-lg: 4px 4px 0px 0px hsl(0 0% 0% / 1.00), 4px 4px 6px -1px hsl(0 0% 0% / 1.00);
  --shadow-xl: 4px 4px 0px 0px hsl(0 0% 0% / 1.00), 4px 8px 10px -1px hsl(0 0% 0% / 1.00);
  --shadow-2xl: 4px 4px 0px 0px hsl(0 0% 0% / 2.50);

  /* Spacing */
  --spacing: 0.25rem;                        /* 4px base */
  --tracking-normal: 0em;
}

/* Use Case: Bold statements, 90s nostalgia, playful brands, anti-corporate aesthetic */
/* Personality: Rebellious, bold, unapologetic, raw, energetic */
```

---

### Template 2: Modern Dark (Vercel/Linear Style)

```css
:root {
  /* Colors */
  --background: oklch(0.1450 0 0);           /* Rich dark */
  --foreground: oklch(0.9850 0 0);           /* Soft white */
  --primary: oklch(0.9850 0 0);              /* White primary */
  --primary-foreground: oklch(0.1450 0 0);
  --secondary: oklch(0.2700 0 0);            /* Dark gray */
  --secondary-foreground: oklch(0.9850 0 0);
  --muted: oklch(0.2700 0 0);
  --muted-foreground: oklch(0.5560 0 0);     /* Mid gray */
  --accent: oklch(0.2700 0 0);
  --accent-foreground: oklch(0.9850 0 0);
  --destructive: oklch(0.5770 0.2450 27.3250); /* Muted red */
  --destructive-foreground: oklch(1 0 0);
  --border: oklch(0.2200 0 0);               /* Subtle border */
  --input: oklch(0.2200 0 0);
  --ring: oklch(0.7080 0 0);

  /* Fonts */
  --font-sans: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
  --font-serif: ui-serif, Georgia, Cambria, "Times New Roman", Times, serif;
  --font-mono: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;

  /* Borders */
  --radius: 0.625rem;                        /* 10px - moderate rounding */

  /* Shadows - Subtle modern */
  --shadow-2xs: 0 1px 3px 0px hsl(0 0% 0% / 0.05);
  --shadow-xs: 0 1px 3px 0px hsl(0 0% 0% / 0.05);
  --shadow-sm: 0 1px 3px 0px hsl(0 0% 0% / 0.10), 0 1px 2px -1px hsl(0 0% 0% / 0.10);
  --shadow: 0 1px 3px 0px hsl(0 0% 0% / 0.10), 0 1px 2px -1px hsl(0 0% 0% / 0.10);
  --shadow-md: 0 1px 3px 0px hsl(0 0% 0% / 0.10), 0 2px 4px -1px hsl(0 0% 0% / 0.10);
  --shadow-lg: 0 1px 3px 0px hsl(0 0% 0% / 0.10), 0 4px 6px -1px hsl(0 0% 0% / 0.10);
  --shadow-xl: 0 1px 3px 0px hsl(0 0% 0% / 0.10), 0 8px 10px -1px hsl(0 0% 0% / 0.10);
  --shadow-2xl: 0 1px 3px 0px hsl(0 0% 0% / 0.25);

  /* Spacing */
  --spacing: 0.25rem;
  --tracking-normal: -0.01em;                /* Tight tracking */
}

/* Use Case: Tech startups, developer tools, modern SaaS, professional dashboards */
/* Personality: Sleek, professional, minimalist, tech-forward, refined */
```

---

### Template 3: Glassmorphism (Frosted Glass Aesthetic)

```css
:root {
  /* Colors - Translucent with backdrop blur */
  --background: oklch(0.9800 0.01 264);      /* Soft lavender white */
  --foreground: oklch(0.2000 0.02 264);
  --primary: oklch(0.6000 0.15 264);         /* Violet */
  --primary-foreground: oklch(1.0000 0 0);
  --secondary: oklch(0.9500 0.02 264);       /* Translucent light */
  --secondary-foreground: oklch(0.2000 0.02 264);
  --muted: oklch(0.9500 0.01 264);
  --muted-foreground: oklch(0.5000 0.02 264);
  --accent: oklch(0.7000 0.18 310);          /* Pink accent */
  --accent-foreground: oklch(1.0000 0 0);
  --destructive: oklch(0.5830 0.2387 28.4765);
  --destructive-foreground: oklch(1.0000 0 0);
  --border: oklch(0.9000 0.01 264 / 0.3);    /* Semi-transparent */
  --input: oklch(0.9000 0.01 264 / 0.3);
  --ring: oklch(0.6000 0.15 264 / 0.5);

  /* Fonts */
  --font-sans: Poppins, -apple-system, BlinkMacSystemFont, sans-serif;
  --font-serif: ui-serif, Georgia, serif;
  --font-mono: ui-monospace, monospace;

  /* Borders */
  --radius: 1.25rem;                         /* 20px - very rounded */

  /* Shadows - Soft and colorful */
  --shadow-2xs: 0 2px 8px 0px hsl(264 40% 60% / 0.10);
  --shadow-xs: 0 2px 8px 0px hsl(264 40% 60% / 0.10);
  --shadow-sm: 0 4px 12px 0px hsl(264 40% 60% / 0.15);
  --shadow: 0 8px 16px 0px hsl(264 40% 60% / 0.20);
  --shadow-md: 0 12px 24px 0px hsl(264 40% 60% / 0.25);
  --shadow-lg: 0 16px 32px 0px hsl(264 40% 60% / 0.30);
  --shadow-xl: 0 24px 48px 0px hsl(264 40% 60% / 0.35);
  --shadow-2xl: 0 32px 64px 0px hsl(264 40% 60% / 0.40);

  /* Spacing */
  --spacing: 0.25rem;
  --tracking-normal: 0em;

  /* Glassmorphism effect (add to components) */
  --glass-bg: rgba(255, 255, 255, 0.15);
  --glass-blur: blur(12px);
  --glass-border: 1px solid rgba(255, 255, 255, 0.25);
}

/* Use Case: Modern apps, creative portfolios, artistic brands, premium products */
/* Personality: Ethereal, modern, sophisticated, dreamy, premium */
/* Note: Use backdrop-filter: var(--glass-blur) on components for glass effect */
```

---

### Template 4: Retro Gradient (80s Inspired)

```css
:root {
  /* Colors - Vibrant gradients */
  --background: oklch(0.1800 0.05 280);      /* Deep purple-black */
  --foreground: oklch(0.9800 0.05 60);       /* Warm white */
  --primary: oklch(0.7000 0.25 330);         /* Hot pink */
  --primary-foreground: oklch(0.1800 0.05 280);
  --secondary: oklch(0.6500 0.25 200);       /* Cyan blue */
  --secondary-foreground: oklch(0.1800 0.05 280);
  --muted: oklch(0.3000 0.08 280);
  --muted-foreground: oklch(0.7000 0.10 300);
  --accent: oklch(0.7500 0.28 60);           /* Neon yellow */
  --accent-foreground: oklch(0.1800 0.05 280);
  --destructive: oklch(0.6000 0.30 15);      /* Bright red */
  --destructive-foreground: oklch(0.9800 0.05 60);
  --border: oklch(0.4000 0.15 300);
  --input: oklch(0.3000 0.10 280);
  --ring: oklch(0.7000 0.25 330);

  /* Fonts */
  --font-sans: Outfit, -apple-system, BlinkMacSystemFont, sans-serif;
  --font-serif: ui-serif, Georgia, serif;
  --font-mono: Space Mono, monospace;

  /* Borders */
  --radius: 0.5rem;                          /* 8px - moderate */

  /* Shadows - Neon glow */
  --shadow-2xs: 0 0 8px 0px hsl(330 70% 60% / 0.40);
  --shadow-xs: 0 0 12px 0px hsl(330 70% 60% / 0.50);
  --shadow-sm: 0 0 16px 0px hsl(330 70% 60% / 0.60);
  --shadow: 0 0 20px 0px hsl(330 70% 60% / 0.70);
  --shadow-md: 0 0 24px 0px hsl(330 70% 60% / 0.80);
  --shadow-lg: 0 0 32px 0px hsl(330 70% 60% / 0.90);
  --shadow-xl: 0 0 48px 0px hsl(330 70% 60% / 1.00);
  --shadow-2xl: 0 0 64px 0px hsl(330 70% 60% / 1.00);

  /* Spacing */
  --spacing: 0.25rem;
  --tracking-normal: 0.02em;                 /* Slightly loose */

  /* Gradient backgrounds (use in styles) */
  --gradient-pink-cyan: linear-gradient(135deg, #f093fb 0%, #f5576c 50%, #4facfe 100%);
  --gradient-sunset: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
}

/* Use Case: Entertainment, music apps, gaming, creative agencies, nostalgia brands */
/* Personality: Bold, energetic, playful, nostalgic, attention-grabbing */
```

---

### Template 5: Minimal Monochrome (Pure B&W Sophistication)

```css
:root {
  /* Colors - Pure grayscale */
  --background: oklch(0.9900 0 0);           /* Near-white */
  --foreground: oklch(0.1500 0 0);           /* Near-black */
  --primary: oklch(0.1500 0 0);
  --primary-foreground: oklch(0.9900 0 0);
  --secondary: oklch(0.9500 0 0);
  --secondary-foreground: oklch(0.1500 0 0);
  --muted: oklch(0.9500 0 0);
  --muted-foreground: oklch(0.5000 0 0);     /* Mid gray */
  --accent: oklch(0.9500 0 0);
  --accent-foreground: oklch(0.1500 0 0);
  --destructive: oklch(0.2000 0 0);
  --destructive-foreground: oklch(0.9900 0 0);
  --border: oklch(0.9000 0 0);
  --input: oklch(0.9000 0 0);
  --ring: oklch(0.5000 0 0);

  /* Fonts */
  --font-sans: Inter, -apple-system, BlinkMacSystemFont, sans-serif;
  --font-serif: Merriweather, Georgia, serif;
  --font-mono: JetBrains Mono, monospace;

  /* Borders */
  --radius: 0.375rem;                        /* 6px - subtle rounding */

  /* Shadows - Subtle gray */
  --shadow-2xs: 0 1px 2px 0px hsl(0 0% 0% / 0.03);
  --shadow-xs: 0 1px 2px 0px hsl(0 0% 0% / 0.05);
  --shadow-sm: 0 1px 3px 0px hsl(0 0% 0% / 0.08), 0 1px 2px -1px hsl(0 0% 0% / 0.08);
  --shadow: 0 2px 4px 0px hsl(0 0% 0% / 0.10), 0 1px 2px -1px hsl(0 0% 0% / 0.10);
  --shadow-md: 0 4px 6px 0px hsl(0 0% 0% / 0.10), 0 2px 4px -1px hsl(0 0% 0% / 0.10);
  --shadow-lg: 0 10px 15px 0px hsl(0 0% 0% / 0.10), 0 4px 6px -2px hsl(0 0% 0% / 0.10);
  --shadow-xl: 0 20px 25px 0px hsl(0 0% 0% / 0.10), 0 10px 10px -5px hsl(0 0% 0% / 0.10);
  --shadow-2xl: 0 25px 50px 0px hsl(0 0% 0% / 0.25);

  /* Spacing */
  --spacing: 0.25rem;
  --tracking-normal: -0.01em;                /* Tight tracking */
}

/* Use Case: High-end brands, photography portfolios, minimalist products, architectural firms */
/* Personality: Sophisticated, timeless, elegant, professional, refined */
```

---

### Template 6: Warm Earthy (Natural Organic Tones)

```css
:root {
  /* Colors - Earth tones */
  --background: oklch(0.9700 0.02 70);       /* Warm off-white */
  --foreground: oklch(0.2500 0.05 40);       /* Deep brown */
  --primary: oklch(0.4500 0.12 40);          /* Terracotta */
  --primary-foreground: oklch(0.9700 0.02 70);
  --secondary: oklch(0.5500 0.10 110);       /* Sage green */
  --secondary-foreground: oklch(0.9700 0.02 70);
  --muted: oklch(0.9200 0.02 70);
  --muted-foreground: oklch(0.5000 0.05 40);
  --accent: oklch(0.6000 0.15 60);           /* Golden */
  --accent-foreground: oklch(0.2500 0.05 40);
  --destructive: oklch(0.5000 0.18 30);      /* Deep orange-red */
  --destructive-foreground: oklch(0.9700 0.02 70);
  --border: oklch(0.8500 0.03 70);
  --input: oklch(0.9000 0.02 70);
  --ring: oklch(0.4500 0.12 40);

  /* Fonts */
  --font-sans: Plus Jakarta Sans, -apple-system, BlinkMacSystemFont, sans-serif;
  --font-serif: Lora, Georgia, serif;
  --font-mono: Source Code Pro, monospace;

  /* Borders */
  --radius: 0.75rem;                         /* 12px - rounded */

  /* Shadows - Warm subtle */
  --shadow-2xs: 0 1px 2px 0px hsl(40 20% 30% / 0.08);
  --shadow-xs: 0 1px 3px 0px hsl(40 20% 30% / 0.10);
  --shadow-sm: 0 2px 4px 0px hsl(40 20% 30% / 0.12);
  --shadow: 0 4px 6px 0px hsl(40 20% 30% / 0.15);
  --shadow-md: 0 6px 10px 0px hsl(40 20% 30% / 0.18);
  --shadow-lg: 0 10px 15px 0px hsl(40 20% 30% / 0.20);
  --shadow-xl: 0 15px 25px 0px hsl(40 20% 30% / 0.25);
  --shadow-2xl: 0 25px 40px 0px hsl(40 20% 30% / 0.30);

  /* Spacing */
  --spacing: 0.25rem;
  --tracking-normal: 0em;
}

/* Use Case: Sustainable brands, organic products, wellness, nature-focused, lifestyle */
/* Personality: Warm, natural, grounded, authentic, calming */
```

---

### Template 7: Neon Cyberpunk (High Contrast Vibrant)

```css
:root {
  /* Colors - Neon on dark */
  --background: oklch(0.1200 0.02 280);      /* Deep purple-black */
  --foreground: oklch(0.9500 0.10 180);      /* Cyan-white */
  --primary: oklch(0.7500 0.30 180);         /* Electric cyan */
  --primary-foreground: oklch(0.1200 0.02 280);
  --secondary: oklch(0.6500 0.28 330);       /* Neon pink */
  --secondary-foreground: oklch(0.1200 0.02 280);
  --muted: oklch(0.2500 0.05 280);
  --muted-foreground: oklch(0.6000 0.10 180);
  --accent: oklch(0.8000 0.28 120);          /* Neon green */
  --accent-foreground: oklch(0.1200 0.02 280);
  --destructive: oklch(0.7000 0.30 10);      /* Bright red */
  --destructive-foreground: oklch(0.1200 0.02 280);
  --border: oklch(0.3000 0.10 180);
  --input: oklch(0.2000 0.05 280);
  --ring: oklch(0.7500 0.30 180);

  /* Fonts */
  --font-sans: Oxanium, -apple-system, BlinkMacSystemFont, sans-serif;
  --font-serif: ui-serif, Georgia, serif;
  --font-mono: Fira Code, monospace;

  /* Borders */
  --radius: 0.25rem;                         /* 4px - sharp but not 0 */

  /* Shadows - Neon glow intense */
  --shadow-2xs: 0 0 10px 0px hsl(180 80% 60% / 0.50);
  --shadow-xs: 0 0 15px 0px hsl(180 80% 60% / 0.60);
  --shadow-sm: 0 0 20px 0px hsl(180 80% 60% / 0.70);
  --shadow: 0 0 25px 0px hsl(180 80% 60% / 0.80);
  --shadow-md: 0 0 30px 0px hsl(180 80% 60% / 0.90);
  --shadow-lg: 0 0 40px 0px hsl(180 80% 60% / 1.00);
  --shadow-xl: 0 0 50px 0px hsl(180 80% 60% / 1.00), 0 0 25px 0px hsl(330 80% 60% / 0.60);
  --shadow-2xl: 0 0 60px 0px hsl(180 80% 60% / 1.00), 0 0 30px 0px hsl(330 80% 60% / 0.80);

  /* Spacing */
  --spacing: 0.25rem;
  --tracking-normal: 0.03em;                 /* Wide tracking */

  /* Neon effect (add to text/elements) */
  --neon-cyan: 0 0 10px hsl(180 100% 50%), 0 0 20px hsl(180 100% 50%), 0 0 30px hsl(180 100% 50%);
  --neon-pink: 0 0 10px hsl(330 100% 50%), 0 0 20px hsl(330 100% 50%), 0 0 30px hsl(330 100% 50%);
}

/* Use Case: Gaming, tech events, futuristic brands, nightlife, edgy products */
/* Personality: Futuristic, edgy, high-energy, bold, dystopian-cool */
```

---

### Theme Selection Guide

| Theme | Best For | Avoid When |
|-------|----------|------------|
| **Neo-Brutalism** | Bold statements, playful brands, anti-corporate | Professional enterprise, conservative industries |
| **Modern Dark** | Tech products, developer tools, SaaS | Friendly consumer brands, children's products |
| **Glassmorphism** | Creative portfolios, premium products | Data-heavy dashboards, text-heavy content |
| **Retro Gradient** | Entertainment, creative agencies, gaming | Corporate, financial, healthcare |
| **Minimal Monochrome** | Luxury brands, photography, architecture | Playful brands, need for warmth/energy |
| **Warm Earthy** | Sustainable brands, wellness, lifestyle | Tech startups, gaming, futuristic brands |
| **Neon Cyberpunk** | Gaming, tech events, futuristic brands | Professional services, traditional brands |

---

## 10. 🏎️ QUICK LOOKUP REFERENCE

### Font Pairing Quick Table

| Use Case | Heading | Body | Google Fonts Import |
|----------|---------|------|---------------------|
| Professional | Inter | Inter | `family=Inter:wght@400;600;700` |
| Elegant | Playfair Display | Source Sans Pro | `family=Playfair+Display:wght@700&family=Source+Sans+Pro:wght@400` |
| Bold Modern | Montserrat | Inter | `family=Montserrat:wght@700&family=Inter:wght@400` |
| Friendly | Poppins | Poppins | `family=Poppins:wght@400;700` |
| Traditional | Merriweather | Open Sans | `family=Merriweather:wght@700&family=Open+Sans:wght@400` |

### Color Hex Values by Use Case

| Use Case | Primary | Secondary | Accent | Background |
|----------|---------|-----------|--------|------------|
| Trust/Tech | #2563EB | #64748B | #F59E0B | #F9FAFB |
| Nature/Health | #10B981 | #14B8A6 | #84CC16 | #F0FDF4 |
| Energy/Food | #EF4444 | #F97316 | #FBB020 | #FEF2F2 |
| Premium/Luxury | #8B5CF6 | #1F2937 | #F59E0B | #FAFAFA |
| Creative/Playful | #FF6B6B | #4ECDC4 | #FFD93D | #FFFFFF |

### Spacing Values Quick Reference

| Use Case | Padding | Margin Between | Section Gap |
|----------|---------|----------------|-------------|
| Compact | 8px | 12px | 32px |
| Standard | 16px | 24px | 64px |
| Generous | 24px | 32px | 96px |
| Touch-Friendly | 16px | 16px | 48px |

### Common Mistakes & Fixes

```yaml
design_pitfalls:
  spacing:
    mistake: "Random spacing values (13px, 27px, etc.)"
    fix: "Use 8px grid exclusively (8, 16, 24, 32, 48, 64)"

  color:
    mistake: "Pure black (#000) and pure white (#fff)"
    fix: "Use rich darks (#1a1a1a) and soft whites (#fafafa)"

  typography:
    mistake: "Too many fonts (3+) or similar fonts"
    fix: "Maximum 2 fonts with clear personality contrast"

  hierarchy:
    mistake: "Everything same visual weight"
    fix: "Primary 2x larger, bold, high contrast"

  interaction:
    mistake: "No hover states or instant changes (no transitions)"
    fix: "All interactive elements need hover + 200ms transitions"

  alignment:
    mistake: "Elements off-grid or inconsistent left margins"
    fix: "Align everything to 8px grid, consistent margins"

  shadows:
    mistake: "Harsh, dark shadows or no shadows"
    fix: "Subtle layered shadows (2px + 8px blur, low opacity)"
```

### Emergency Design Improvements

```yaml
quick_polish_boost:
  if_feels_cramped:
    action: "Double all spacing values (16px → 32px, 24px → 48px)"

  if_hierarchy_unclear:
    action: "Make primary element 2x larger, bold (700), darker/higher contrast"

  if_feels_harsh:
    action: "Soften shadows (reduce opacity 50%), use #1a1a1a instead of #000, add subtle background tint"

  if_interactions_feel_dead:
    action: "Add 200ms transitions to all interactive elements, add hover states (background: rgba(0,0,0,0.05))"

  if_colors_feel_off:
    action: "Desaturate by 20%, ensure no pure colors (#000, #fff, #ff0000)"

  if_feels_unprofessional:
    action: "Increase whitespace (1.5x all spacing), use consistent 8px grid, refine typography (proper line-height 1.6)"
```

---

**END OF TEMPLATES & PATTERNS**

*This document provides all practical templates and code examples for immediate use. For design theory, decision-making frameworks, and quality assessment, see **UI Designer - Visual Excellence**.*

*Remember: Templates are starting points. Customize based on brand, audience, and context. Always validate accessibility (WCAG AA minimum) and test responsively.*
