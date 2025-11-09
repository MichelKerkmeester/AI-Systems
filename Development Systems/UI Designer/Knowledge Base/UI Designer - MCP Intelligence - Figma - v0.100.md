# UI Designer - MCP Intelligence - Figma

Technical reference for Figma MCP server capabilities and integration for design specification extraction and token generation.

**Purpose:** Document Figma MCP specific features, supported operations, API specifications, and technical workflows. Conversation flows and thinking methodology are in Interactive Intelligence and CANVAS Thinking Framework respectively.

---

## 📋 TABLE OF CONTENTS

1. [🔌 SERVER OVERVIEW](#1-server-overview)
2. [🛠️ CORE CAPABILITIES](#2-core-capabilities)
3. [🎨 EXTRACTION OPERATIONS](#3-extraction-operations)
4. [🔄 TRANSFORMATION PIPELINE](#4-transformation-pipeline)
5. [🎛️ CREATIVE MODE INTEGRATION](#5-creative-mode-integration)
6. [⚙️ BEST PRACTICES](#6-best-practices)
7. [⚠️ LIMITATIONS](#7-limitations)
8. [🏎️ QUICK REFERENCE](#8-quick-reference)

---

<a id="1-server-overview"></a>

## 1. 🔌 SERVER OVERVIEW

### MCP Server Details

**Protocol:** Model Context Protocol (MCP) for native Figma file access  
**Authentication:** Figma API token (environment variable: `FIGMA_API_TOKEN`)  
**Access:** File read, style extraction, component definitions  

**7-Step Operation Flow:**
1. Pre-flight check (ask user about Figma integration)
2. Connection verification (`figma_list_files` or `figma_get_file`)
3. Receive Figma URL/file key
4. Select creative mode (Strict/Balanced/Creative)
5. Execute MCP extraction tools
6. Transform Figma data → CSS/HTML
7. Apply with creative mode adjustments

### Connection Status & Actions

| Status | Message | Resolution |
|--------|---------|------------|
| ✅ Connected | "Figma MCP Connected" | Proceed with extraction |
| ❌ Disconnected | "Figma MCP Not Connected" | Check Claude Desktop MCP settings |
| ⚠️ Auth Failed | "Authentication Issue" | Regenerate API token in Figma settings |
| ⚠️ Access Denied | "Permission Issue" | Verify file sharing permissions |

**Quick Setup:**
1. Generate Figma API token: `Figma Settings → Account → Personal Access Tokens`
2. Add to MCP config: `FIGMA_API_TOKEN=your_token`
3. Restart Claude Desktop
4. Test: Use `figma_list_files` tool

**Mandatory Pre-Flight:** Ask at conversation start: "Should I check Figma files using Figma MCP for design specifications?"

---

<a id="2-core-capabilities"></a>

## 2. 🛠️ CORE CAPABILITIES

**Note:** CANVAS thinking methodology in `CANVAS Thinking Framework`, conversation flows in `Interactive Intelligence`.

| Operation Type | Tools/Extractions | Required Permission | Purpose |
|----------------|-------------------|---------------------|---------|
| **File** | `figma_get_file`, `figma_list_files` | File read | Access file structure & metadata |
| **Styles** | Paint, text, effect, grid styles | Style library access | Extract design tokens |
| **Components** | Definitions, variants, overrides, docs | Component library access | Extract reusable patterns |
| **Layout** | Auto Layout, constraints, responsive | File read | Extract positioning data |

### What You CAN Do ✅

**File Access:**
- Get Figma file by URL or file key
- List all pages in document
- Access specific frames and components
- Retrieve file metadata and version info

**Style Extraction:**
- Extract color styles (fills, strokes) with exact hex values
- Get typography styles (fonts, sizes, weights, line-heights)
- Access effect styles (shadows, blurs, borders)
- Extract grid and layout styles

**Component Extraction:**
- Extract component definitions and structure
- Get component properties and variants
- Access component documentation and descriptions
- Map variant properties to implementation states

**Token Generation:**
- Convert Figma styles to CSS variables
- Map component variants to HTML states
- Extract spacing from Auto Layout settings
- Generate responsive breakpoints from constraints

**Context Folder Priority:**
- If `/Context/` folder has design system files, ask user preference
- Question: "Would you like me to use your Context folder design system or Figma tokens?"
- Skip if user already specified in request
- See Visual Excellence → CSS Variables & Fluid Responsive Design

### What You CANNOT Do ❌

**Editing Limitations:**
- Cannot modify Figma files
- Cannot create new components
- Cannot publish styles
- Cannot export image assets directly (use image URLs instead)

**Access Limitations:**
- Cannot access private files without token permissions
- Cannot access team-restricted content
- Cannot read draft files without explicit access

---

<a id="3-extraction-operations"></a>

## 3. 🎨 EXTRACTION OPERATIONS

### Extraction Pipeline

**7-Step Process:**

| Step | Action | Key Operations | Output |
|------|--------|----------------|--------|
| **1. Connect** | Connect to Figma via MCP | `figma_get_file()`, `figma_list_files()` | File structure + metadata |
| **2. Analyze** | Scan design system | Identify styles, components, patterns | Design inventory |
| **3. Colors** | Extract paint styles | Solid fills, gradients, opacity, blend modes | Color tokens (primitive + semantic) |
| **4. Typography** | Extract text styles | Fonts, sizes, weights, line-heights, spacing | Type scale + font families |
| **5. Spacing** | Extract Auto Layout | Padding, gaps, constraints, grid system | Spacing scale (4px/8px base) |
| **6. Components** | Extract components | Structure, variants, properties, overrides | Component definitions |
| **7. Effects** | Extract effects | Shadows, blurs, borders, strokes | Effect tokens |

### Extraction Details

**Token Categories & Mapping:**

| Category | Figma Source | CSS Output | Validation |
|----------|--------------|------------|------------|
| **Colors** | Paint styles (RGB) | `#RRGGBB`, `rgba()` values | WCAG AA (4.5:1 contrast) |
| **Typography** | Text styles | Font families, rem-based scale | Min 16px body, 1.5-1.8 line-height |
| **Spacing** | Auto Layout padding/gap | rem units (8px grid) | Consistency across components |
| **Effects** | Shadow/blur styles | `box-shadow`, `filter` values | Performance-optimized |
| **Components** | Component variants | HTML/CSS patterns | All states captured |

**Semantic Mapping:**

- **Primitive tokens:** `[color]-[shade]` (e.g., `blue-500`, `gray-900`)
- **Semantic tokens:** `[purpose]-[variant]` (e.g., `primary`, `text-secondary`, `bg-surface`)
- **Auto Layout → Flexbox/Grid:** Horizontal/Vertical → `flex-direction`, Gap → `gap` property
- **Constraints → Responsive:** Hug → `fit-content`, Fill → `flex: 1`, Fixed → converted to fluid

---

<a id="4-transformation-pipeline"></a>

## 4. 🔄 TRANSFORMATION PIPELINE

### Figma to Web Conversion Matrix

| Figma Property | Input Format | CSS Output | Example |
|----------------|--------------|------------|---------|
| **Colors** | RGB (0-255) | `#HEX`, `rgba()` | `rgb(59,130,246)` → `#3B82F6` |
| **Fonts** | Figma font names | Font stack with fallbacks | `Inter` → `'Inter', system-ui, sans-serif` |
| **Auto Layout (H)** | Horizontal | `display: flex; flex-direction: row;` | + gap property |
| **Auto Layout (V)** | Vertical | `display: flex; flex-direction: column;` | + gap property |
| **Hug Contents** | Dynamic sizing | `width: fit-content;` or `auto` | Flexible containers |
| **Fill Container** | Fill parent | `flex: 1;` or `width: 100%;` | Responsive width |
| **Component Variants** | `[Property: Value]` | CSS classes + data attributes | `[Size: Large]` → `.btn--large` |
| **Drop Shadow** | x, y, blur, color | `box-shadow: [values];` | `0 4px 6px rgba(0,0,0,0.1)` |
| **Layer Blur** | blur value | `filter: blur(Xpx);` | `blur: 10` → `blur(10px)` |
| **Background Blur** | blur value | `backdrop-filter: blur(Xpx);` | Glassmorphism effects |

### CSS Variable Generation Pattern

**Format:** `--[category]-[name]: [value];`

| Category | Pattern | Example |
|----------|---------|---------|
| **Colors** | `--color-[name]-[shade]` | `--color-blue-500: #3B82F6;` |
| **Semantic** | `--color-[purpose]` | `--color-primary: var(--color-blue-500);` |
| **Typography** | `--text-[size]`, `--font-[role]` | `--text-base: 1rem;` `--font-heading: 'Inter';` |
| **Spacing** | `--space-[scale]` | `--space-4: 1rem;` (8px grid) |
| **Effects** | `--shadow-[size]`, `--radius-[size]` | `--shadow-lg: 0 10px 15px ...;` |

---

<a id="5-creative-mode-integration"></a>

## 5. 🎛️ CREATIVE MODE INTEGRATION

### Creative Control Modes

**Reference:** Creative modes are defined in `UI Designer - Reference Extraction` document.

```yaml
strict_mode_with_figma:
  use_case: "Client deliverables, brand guidelines, legal compliance"
  approach: "Pixel-perfect Figma replication"
  deviation: "≤10%"
  
  rules:
    - Use exact Figma values (colors, spacing, typography)
    - Preserve all component variants as-is
    - Match typography precisely (or document closest alternative)
    - Replicate all effects exactly
    - No unsolicited optimizations
    
  allowed_changes:
    - Semantic HTML structure + accessibility attributes
    - Web-standard implementations (Figma → CSS)
```

### Creative Mode Comparison

| Mode | Deviation | Use Case | Key Focus |
|------|-----------|----------|-----------|
| **Strict** | ≤10% | Brand guidelines, legal requirements | Pixel-perfect replication, exact matching |
| **Balanced** [DEFAULT] | 10-25% | Production sites, web apps | Core aesthetic + web optimization + WCAG AA |
| **Creative** | 25-50% | Portfolio, exploration, innovation | Design inspiration + contemporary trends |

**Mode Selection Prompt:**
> "I've connected to your Figma file. Apply as: [Strict/Balanced/Creative]?"
> (Defaults to Balanced if not specified)

**Note:** Full mode specifications in `UI Designer - Reference Extraction v0.100 - Section 6`

---

<a id="6-best-practices"></a>

## 6. ⚙️ BEST PRACTICES

### Figma File Preparation Checklist

**Before Extraction:**
- ✓ Name layers clearly, group components, use pages for sections
- ✓ Publish color/text/effect styles with semantic naming
- ✓ Create component variants for all states + Auto Layout
- ✓ Document spacing system, typography scale, grid system

**During Extraction:**
- ✓ Start with design system/style guide → tokens before components
- ✓ Extract in order: atoms → molecules → organisms
- ✓ Validate WCAG contrast, readability, responsive behavior

**After Extraction:**
- ✓ Simplify nested structures, consolidate styles
- ✓ Optimize animations (60fps, GPU-accelerated properties)
- ✓ Add ARIA labels, keyboard navigation, focus indicators

### Common Workflow Templates

| Workflow | Mode | Approach |
|----------|------|----------|
| **Brand Guidelines** | Strict | Extract official tokens → Build token library → Document deviations |
| **Component Library** | Balanced | Extract variants → Map states to CSS → Generate docs + examples |
| **Design Exploration** | Creative | Extract base tokens → Reinterpret freely → Enhance with web patterns |

---

<a id="7-limitations"></a>

## 7. ⚠️ LIMITATIONS

| Limitation Type | Cannot Do | Workaround |
|-----------------|-----------|------------|
| **Access** | Private files, team-restricted content, password-protected files | Request sharing permissions or manual extraction |
| **Modification** | Edit Figma files, create components, publish styles | Read-only extraction, cannot write back |
| **Fonts** | Access custom/unavailable web fonts | Suggest Google Fonts alternatives + fallback stacks |
| **Effects** | Complex blend modes, untranslatable effects | Simplify or use CSS alternatives (filter, backdrop-filter) |
| **Plugins** | Plugin-generated content | Plugin data not accessible via API |

---

<a id="8-quick-reference"></a>

## 8. 🏎️ QUICK REFERENCE

### Setup (3 Steps)

1. **Generate Token:** Figma Settings → Account → Personal Access Tokens
2. **Configure MCP:** Add `FIGMA_API_TOKEN=[token]` to Claude Desktop MCP settings
3. **Verify:** Test with `figma_list_files()` tool

### Primary Commands

| Tool | Purpose | Returns |
|------|---------|---------|
| `figma_list_files()` | List accessible files | File list with keys |
| `figma_get_file(file_key)` | Extract complete file | Structure + metadata |

**Extraction Flow:** Connect → Extract styles → Extract components → Transform to CSS/HTML → Apply creative mode

### System Integration Map

| Document | Relevant Sections |
|----------|-------------------|
| `UI Designer - v0.100` | Pre-flight questions, Figma routing |
| `UI Designer - Reference Extraction` | Creative modes, extraction methodology |
| `UI Designer - CANVAS Thinking Framework` | Phase C (Concept) - token extraction |
| `UI Designer - Interactive Intelligence` | Pre-flight questions, state machine |
| `UI Designer - Visual Excellence` | CSS Variables, fluid responsive design |

### Troubleshooting

| Issue | Solution |
|-------|----------|
| Connection failed | Check API token, restart Claude Desktop |
| File not found | Verify URL/key, check sharing permissions |
| Missing styles | Ensure styles published in Figma |
| Font substitution | Accept alternative or specify preference |
| Slow extraction | Large files = longer time, extract specific pages |

### Pre-Flight Template

**Ask at conversation start:** "Should I check Figma files using Figma MCP for design specifications?"

**If yes:** Request Figma URL + creative mode (Strict/Balanced/Creative)

---

*The Figma MCP Intelligence system enables precise design specification extraction and systematic token generation from Figma files, integrating seamlessly with the CANVAS methodology and creative control framework for high-fidelity UI/UX prototypes.*
