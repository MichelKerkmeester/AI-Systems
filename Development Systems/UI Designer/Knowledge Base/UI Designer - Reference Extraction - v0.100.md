# UI Designer - Reference Extraction

Extract design tokens from visual references and apply through creative control modes.

**Core Purpose:** Transform screenshots/mockups into design systems via intelligent token extraction, STYLE.md generation, and flexible creative modes.

**Scope:** Reference extraction workflows - token detection, STYLE.md generation, creative control modes, Figma integration. For conversation patterns, see `UI Designer - Interactive Intelligence`. For thinking methodology, see `UI Designer - CANVAS Thinking Framework`.

---

## 📋 TABLE OF CONTENTS

1. [🎯 OVERVIEW](#1-overview)
2. [📸 EXTRACTION WORKFLOWS](#2-extraction-workflows)
3. [🎨 TOKEN EXTRACTION](#3-token-extraction)
4. [🎛️ CREATIVE CONTROL MODES](#5-creative-control-modes)
5. [🔗 CANVAS INTEGRATION](#6-canvas-integration)
6. [✅ QUALITY ASSURANCE](#7-quality-assurance)
7. [🏎️ QUICK REFERENCE](#8-quick-reference)

---

## 1. 🎯 OVERVIEW

### Reference-Driven Workflow

**Process:** User shows → Tokens extracted → STYLE.md created → Creative mode applied → Design generated

**Why This Works:**
- **Precision** - Exact hex values, spacing, typography from visual sources
- **Speed** - Show design vs 500-word description
- **Consistency** - Build design systems from real examples
- **Documentation** - Auto-generate STYLE.md for project continuity
- **Flexibility** - Control adherence through creative modes (10-50% deviation)

### Reference Sources

| Source | Location | Best For |
|--------|----------|----------|
| **Context Folder** | `/Context/` | Project references, batch processing |
| **Chat Upload** | Drag & drop | Quick iterations, single references |
| **Figma MCP** | Via integration | Direct design file access |
| **URL Screenshots** | Web pages | Live site analysis |

---

## 2. 📸 EXTRACTION WORKFLOWS

### 5-Step Extraction Pipeline

```yaml
step_1_detection:
  - Scan /Context/ folder or detect uploaded images
  - Support: PNG, JPG, JPEG, WebP, SVG
  - Auto-categorize by dimensions (desktop/mobile/tablet)

step_2_visual_analysis:
  - Identify UI elements (buttons, forms, cards, navigation)
  - Map layout structure (grid systems, flexbox patterns)
  - Analyze visual hierarchy

step_3_token_extraction:
  colors: Extract hex values → Build semantic palette → Calculate contrast ratios
  typography: Identify fonts → Measure sizes/line-heights → Calculate scale ratio
  spacing: Measure padding/margins → Detect grid system → Build spacing scale
  effects: Extract shadows → Identify borders → Detect gradients

step_4_pattern_inference:
  - Identify interaction states (hover, active, focus, disabled)
  - Map navigation flow
  - Extract component patterns

step_5_style_md_generation:
  trigger: "References detected + no STYLE.md exists"
  action: "Offer to create STYLE.md from tokens"
  workflow:
    1. Extract all tokens (colors, typography, spacing, effects)
    2. Generate STYLE.md using template
    3. Populate with design tokens + accessibility notes
    4. Save to /Design System/STYLE.md
    5. Use as primary system for current design
```

### STYLE.md Auto-Generation

```yaml
style_md_workflow:
  when: "References detected + no STYLE.md exists"
  
  token_aggregation:
    sources: [images, figma_mcp, css_variables]
    priority: "Figma > CSS variables > Visual references"
    conflicts: "Ask user which to use"
  
  populate_style_md:
    colors: Hex values + semantic mappings + WCAG validation
    typography: Font families + type scale + line-heights
    spacing: Grid system (4px/8px) + spacing scale
    effects: Shadows + border radius + animation timings
    components: Button variants + form patterns + navigation
    layout: Breakpoints + grid systems + container widths
    accessibility: Contrast ratios + WCAG compliance + focus indicators
  
  save_location: "/Design System/STYLE.md"
  
  update_existing:
    trigger: "STYLE.md exists + new references"
    ask: "Update STYLE.md with new tokens or keep existing?"
    options: [merge, replace, keep]
```

### Source-Specific Workflows

```yaml
context_folder:
  location: "/Context/"
  trigger: Conversation start OR user mentions "reference"
  batch: Process all images simultaneously
  organization:
    Context/
      ├── homepage-desktop.png
      ├── homepage-mobile.png
      └── components/*.png

chat_upload:
  trigger: User drags image into chat
  advantage: Zero file management, immediate processing
  best_for: Quick iterations, single references

figma_mcp:
  trigger: User approves Figma check
  advantage: Direct API access, live design files
  extraction: Components + styles + design tokens
  
url_screenshots:
  trigger: User provides website URL
  extraction: Live CSS values + font stacks + media queries
  limitation: Dynamic content may vary
    - Some styles computed at runtime
    - Authentication-gated content inaccessible
```

### Figma MCP Integration Workflow

**MANDATORY PRE-FLIGHT:** Always ask at conversation start: "Should I check Figma files using Figma MCP for design specifications?" (unless user already specified)

#### Quick Setup (3 Steps)
1. Generate Figma API token: `Figma Settings → Account → Personal Access Tokens`
2. Add to MCP config: `FIGMA_API_TOKEN=your_token` in Claude Desktop MCP settings
3. Test connection: Use `figma_list_files` tool

#### Connection Status
| Status | Message | Action |
|--------|---------|--------|
| ✅ Connected | "Figma MCP Connected" | Proceed with extraction |
| ❌ Disconnected | "Not Connected" | Check MCP settings, restart Claude Desktop |
| ⚠️ Auth Failed | "Authentication Issue" | Regenerate API token |
| ⚠️ Access Denied | "Permission Issue" | Verify file sharing permissions |

#### 7-Step Extraction Process

```yaml
figma_extraction_flow:
  step_1_preflight: "Ask user: 'Check Figma files using MCP?'"
  
  step_2_connect: 
    tools: [figma_list_files, figma_get_file]
    input: "Figma URL or file key"
    output: "File structure + metadata"
  
  step_3_creative_mode:
    ask: "Apply as: Strict/Balanced/Creative?"
    default: "Balanced"
  
  step_4_extract_styles:
    colors: "Paint styles → Hex values + semantic mapping"
    typography: "Text styles → Font families, sizes, weights, line-heights"
    effects: "Shadow/blur styles → CSS box-shadow, filter values"
    spacing: "Auto Layout → Padding, gap, margins (8px grid)"
  
  step_5_extract_components:
    structure: "Component definitions, variants, properties"
    states: "Map variant properties to CSS classes"
    docs: "Component descriptions and usage notes"
  
  step_6_transform_to_web:
    colors: "RGB(0-255) → #HEX or rgba()"
    fonts: "Figma fonts → Web font stacks with fallbacks"
    layout: "Auto Layout → Flexbox/Grid + gap properties"
    variants: "Component variants → CSS classes + data attributes"
    constraints: "Hug → fit-content, Fill → flex:1, Fixed → fluid"
  
  step_7_apply_creative_mode:
    strict: "Use exact values, ≤10% deviation"
    balanced: "Match aesthetic + optimize for web, 10-25% deviation"
    creative: "Inspired interpretation + modern enhancements, 25-50% deviation"
```

#### Figma → Web Transformation Matrix

| Figma Property | CSS Output | Example |
|----------------|------------|---------|
| **RGB Color** | `#HEX` or `rgba()` | `rgb(59,130,246)` → `#3B82F6` |
| **Text Style** | Font stack | `Inter` → `'Inter', system-ui, sans-serif` |
| **Auto Layout (H)** | `flex-direction: row` + `gap` | Horizontal layouts |
| **Auto Layout (V)** | `flex-direction: column` + `gap` | Vertical layouts |
| **Hug Contents** | `width: fit-content` | Dynamic sizing |
| **Fill Container** | `flex: 1` or `width: 100%` | Responsive width |
| **Drop Shadow** | `box-shadow` | `0 4px 6px rgba(0,0,0,0.1)` |
| **Layer Blur** | `filter: blur()` | Glassmorphism effects |
| **Variants** | CSS classes + data attributes | `[Size: Large]` → `.btn--large` |

#### What You CAN Extract ✅

- **Styles:** Colors (exact hex), typography (fonts, sizes, weights), effects (shadows, borders)
- **Components:** Structure, variants, all states, documentation
- **Layout:** Auto Layout values, constraints, spacing systems
- **Tokens:** Generate CSS variables, semantic mappings, spacing scales

#### What You CANNOT Do ❌

- **Modify:** Cannot edit Figma files, create components, or publish styles (read-only)
- **Access:** Private files need token permissions, team-restricted content needs access
- **Fonts:** Custom/unavailable fonts require alternatives or user-provided font files
- **Plugins:** Plugin-generated content not accessible via API

#### Creative Mode Application

**Strict Mode (≤10% deviation):**
- Pixel-perfect Figma replication
- Exact values for colors, spacing, typography
- Use for: Brand guidelines, legal compliance, client deliverables

**Balanced Mode (10-25% deviation) [DEFAULT]:**
- Core aesthetic preserved + web optimization
- WCAG AA enhancements, 8px grid normalization
- Use for: Production sites, web apps

**Creative Mode (25-50% deviation):**
- Design inspiration + contemporary enhancements
- Modern effects (glassmorphism, gradients, 3D)
- Use for: Portfolio, exploration, innovation

#### Troubleshooting

| Issue | Solution |
|-------|----------|
| Connection failed | Check API token in MCP settings, restart Claude Desktop |
| File not found | Verify Figma URL/key, check sharing permissions |
| Missing styles | Ensure styles are published in Figma library |
| Font substitution needed | Accept Google Font alternative or specify preference |
| Slow extraction | Large files take longer; extract specific pages/frames instead |

---

## 3. 🎨 TOKEN EXTRACTION

### Token Categories

```yaml
colors:
  extract: All hex values from reference
  build: Primitive tokens (gray-50 to gray-900, color-500 scales)
  semantic: primary, secondary, success, error, text, background, surface
  validate: WCAG AA (4.5:1 min) + WCAG AAA (7:1 critical text)

typography:
  identify: Character shapes → Google Fonts database → Closest alternatives
  measure: Font sizes + line-heights + weights
  calculate: Scale ratio (usually 1.125 - 1.333)
  output: Type scale (xs: 0.75rem → 4xl: 2.25rem)
  fallback: Exact match → Similar Google Font → System font

spacing:
  detect: Grid system (4px, 8px, 12px, or 16px base)
  measure: All padding/margin values
  build: Spacing scale (0: 0 → 20: 5rem)
  apply: Consistent throughout design

effects:
  shadows: offset + blur + spread + color
  borders: width + style + radius
  gradients: type + angle + stops
  other: opacity + blur effects

  component_spacing:
    padding:
      - button: "py-2 px-4"
      - card: "p-6"
      - section: "py-12 px-4"

    margin:
      - stack: "space-y-4"
      - inline: "space-x-2"
      - section: "my-16"
```

### Effects Extraction

```yaml
effects_extraction:
  shadows:
    levels:
      - sm: "0 1px 2px rgba(0, 0, 0, 0.05)"
      - DEFAULT: "0 1px 3px rgba(0, 0, 0, 0.1)"
      - md: "0 4px 6px rgba(0, 0, 0, 0.1)"
      - lg: "0 10px 15px rgba(0, 0, 0, 0.1)"
      - xl: "0 20px 25px rgba(0, 0, 0, 0.1)"

  borders:
    radius:
      - none: "0"
      - sm: "0.125rem"
      - DEFAULT: "0.25rem"
      - md: "0.375rem"
      - lg: "0.5rem"
      - xl: "0.75rem"
      - full: "9999px"

  gradients:
    extraction:
      - Type: linear, radial, conic
      - Angle: 0-360 degrees
      - Stops: color and position
      - Opacity: per stop
```

---

## 5. 🎛️ CREATIVE CONTROL MODES

**Strict Mode (≤10% deviation)** - Pixel-perfect replication
- Exact colors, spacing, typography | No substitutions | Preserve all relationships
- Use: Brand guidelines, client mockups, legal requirements

**Balanced Mode (10-25% adaptation)** [DEFAULT] - Web-optimized
- WCAG AA accessibility | 8px grid normalization | Modern CSS features | Responsive behavior
- Use: Production sites, modern web apps

**Creative Mode (25-50% interpretation)** - Design inspiration
- Explore palettes, pairings, modern effects | Innovative layouts | Advanced interactions
- Use: Portfolio, exploration, innovation

### Mode Selection Prompt
```markdown
🎯 References detected in [Context / upload]. Apply as:
[Strict] [Balanced] [Creative]
```

### Mode Comparison
| Aspect | Strict | Balanced | Creative |
|--------|--------|----------|----------|
| Color | 95%+ exact | 85% + WCAG | 60% inspired |
| Typography | Exact/closest | Optimized web font | Creative pairing |
| Spacing | Pixel-perfect | Grid-normalized | Rhythm-based |
| Layout | 90%+ match | Responsive-optimized | Modern interpretation |
| Effects | Replicated | Performance-optimized | Trend-enhanced |

---

## 6. 🔗 CANVAS INTEGRATION

**Reference Detection** (Phase C - Concept)
- Auto-scan: `/Context/` folder + chat uploads + mentioned URLs
- Prompt: "Found [X] references. Extract design system? [Yes/Select/Skip]"
- If yes: Extract tokens → Apply multi-perspective analysis → Use as design foundation

**Token Application** (Phase V - Visual)
- Priority: 1. Extracted tokens → 2. Brand guidelines → 3. Generated tokens
- Process: Apply colors → typography → spacing → effects → Validate against reference

**Multi-Perspective Weights by Mode**
| Perspective | Strict | Balanced | Creative |
|-------------|--------|----------|----------|
| Visual Design Expert | 40% | 25% | 15% |
| UX Flow | 20% | 30% | 25% |
| Innovation Lens | 5% | 20% | 35% |

---

## 7. ✅ QUALITY ASSURANCE

**Accuracy Targets**
- Colors: 99% hex accuracy (color picker verification)
- Typography: 95% visual similarity (side-by-side comparison)
- Spacing: 98% measurement precision (overlay verification)
- Layout: 100% structural accuracy (wireframe overlay)

**Mode Compliance Checks**
- **Strict:** ≤10% deviation, hex verification, spacing validation
- **Balanced:** 75%+ aesthetic similarity, WCAG AA, grid normalization
- **Creative:** Design rationale clarity, core intent preservation

**Quality Gates**
- DESIGN score ≥ 40/50 | Mode compliance verified | 3 breakpoints responsive
- WCAG AA validated | 60fps animations | Comparison screenshots + deviation report

---

## 8. 🏎️ QUICK REFERENCE

**Extraction Commands**
- `$extract strict` - Pixel-perfect replication (≤10%)
- `$extract` - Balanced mode with web optimization [DEFAULT]
- `$extract creative [image]` - Creative interpretation (25-50%)
- `$extract tokens` - Tokens only (no prototype generation)
- `$extract [url]` - Extract from live website
- `$extract batch` - Process all Context folder references
- `$extract --focus "colors typography"` - Extract specific elements only

**Best Practices**
- **Before:** High-res images (1920px+) | Multiple states | Clear naming | Organized folders
- **During:** Confirm mode | Review tokens | Validate patterns | Check WCAG
- **After:** Compare output | Verify compliance | Document deviations | Get approval

**Troubleshooting**
| Issue | Solution |
|-------|----------|
| Colors mismatch | Use PNG not JPG, verify no compression |
| Font not found | Provide name or accept closest match |
| Layout differs | Check resolution, specify structure needs |
| Spacing inconsistent | Verify grid detection, manual override |
| Missing details | Zoom and re-extract specific areas |
| Slow extraction | Reduce to 1920px width |

**Folder Organization**
```
Context/
├── project-name/
│   ├── desktop/ (homepage.png, about.png, contact.png)
│   ├── mobile/ (homepage-mobile.png, nav-mobile.png)
│   ├── components/ (buttons-all-states.png, forms.png, cards.png)
│   └── style-guide.png
└── README.md (optional)
```

---

*Reference Extraction enables precision visual analysis with flexible creative control, integrating with CANVAS methodology for systematic rigor and exceptional quality.*