# UI Designer - Reference Extraction

Transforms visual references into production-ready prototypes through intelligent pattern extraction, style token generation, and creative control modes.

**Core Purpose:** Enable reference-driven design workflows that extract precise design tokens from visual sources (screenshots, mockups, URLs) and apply them through flexible creative modes while maintaining the systematic rigor of the CANVAS methodology.

---

## 📋 TABLE OF CONTENTS

1. [🎯 REFERENCE EXTRACTION OVERVIEW](#1-reference-extraction-overview)
2. [📸 EXTRACTION WORKFLOWS](#2-extraction-workflows)
3. [🔍 PATTERN RECOGNITION METHODOLOGY](#3-pattern-recognition-methodology)
4. [🎨 STYLE TOKEN EXTRACTION](#4-style-token-extraction)
5. [🎛️ CREATIVE CONTROL SYSTEM](#5-creative-control-system)
6. [🔗 CANVAS INTEGRATION](#6-canvas-integration)
7. [✅ QUALITY ASSURANCE](#7-quality-assurance)
8. [🏎️ QUICK REFERENCE](#8-quick-reference)

---

## 1. 🎯 REFERENCE EXTRACTION OVERVIEW

### The Reference-Driven Philosophy

**Visual Communication Over Verbal Description**

Traditional approach: User describes → AI interprets → Template selected → Design adapted

Reference-driven approach: User shows → AI analyzes → Tokens extracted → Creative mode applied → Design generated

### Why Reference Extraction Excels

- **Precision**: Extract exact hex values, spacing, typography from visual sources
- **Speed**: "Show this design" faster than describing in 500 words
- **Consistency**: Build cohesive design systems from real examples
- **Learning**: Each extraction enhances pattern recognition capabilities
- **Flexibility**: Control adherence through creative modes (Strict/Balanced/Creative)

### Supported Reference Types

| Source | Location | Speed | Fidelity | Best For |
|--------|----------|-------|----------|----------|
| **Context Folder** | `/Context/` | ⚡⚡⚡ | 🎯🎯🎯 | Project references, batch processing |
| **Direct Upload** | Chat drag & drop | ⚡⚡⚡ | 🎯🎯🎯 | Quick iterations, single references |
| **URL Screenshots** | Web pages | ⚡⚡ | 🎯🎯 | Live site analysis, competitor research |
| **Local Files** | User paths | ⚡⚡ | 🎯🎯🎯 | Design files, mockups |

---

## 2. 📸 EXTRACTION WORKFLOWS

### Primary Workflow: Context Folder Scanning

**Location**: `/AI Systems/Development Systems/UI Designer/Context/`

```yaml
context_folder_workflow:
  auto_detection:
    trigger:
      - Conversation start
      - User mentions "reference" or "screenshot"
      - CANVAS Phase C initiation

  scan_process:
    - Check Context folder for image files
    - Support: PNG, JPG, JPEG, WebP, SVG
    - Auto-categorize: desktop, mobile, tablet (by dimensions)

  batch_extraction:
    - Process all references simultaneously
    - Build unified design token system
    - Handle conflicts through user clarification

  organization:
    recommended_structure:
      Context/
        ├── homepage-desktop.png
        ├── homepage-mobile.png
        ├── components/
        │   ├── nav-bar.png
        │   ├── buttons-all-states.png
        │   └── form-examples.png
        └── style-guide.png
```

### Extraction Process Pipeline

```yaml
extraction_pipeline:
  step_1_detection:
    actions:
      - Scan Context folder or detect uploaded images
      - Identify image dimensions and type
      - Confirm extraction mode with user
    output: Reference inventory

  step_2_visual_analysis:
    actions:
      - Claude vision: Comprehensive UI element identification
      - Component classification (buttons, forms, cards, navigation)
      - Layout structure mapping (grid systems, flexbox patterns)
      - Visual hierarchy analysis (primary, secondary, tertiary)
    output: Component inventory

  step_3_style_extraction:
    colors:
      - Extract all hex values with precision
      - Build semantic palette (primary, secondary, accent, neutral)
      - Identify color relationships and harmony
      - Calculate contrast ratios

    typography:
      - Identify font characteristics (serif/sans-serif, weight)
      - Measure font sizes and line-heights
      - Calculate typographic scale ratio
      - Map to available web fonts

    spacing:
      - Measure padding and margin values
      - Detect underlying grid system (4px, 8px, custom)
      - Extract component-specific spacing
      - Build consistent spacing scale

    effects:
      - Extract shadows (offset, blur, spread, color)
      - Identify borders (width, style, radius)
      - Detect gradients (type, angle, stops)
      - Measure opacity and blur effects

  step_4_interaction_inference:
    states:
      - Identify hover, active, focus, disabled patterns
      - Extract state change properties
      - Infer transition timings

    feedback:
      - Map loading states
      - Identify error patterns
      - Extract success indicators

    navigation:
      - Understand user flow from screen relationships
      - Identify navigation patterns
      - Extract menu structures

  step_5_creative_application:
    strict_mode: "Replicate with ≤10% deviation"
    balanced_mode: "Match aesthetic with 10-25% optimization"
    creative_mode: "Interpret with 25-50% creative freedom"
```

### Direct Upload Workflow

```yaml
direct_upload_workflow:
  trigger: "User drags image into chat or uses upload button"

  advantages:
    - Zero file management required
    - Immediate processing
    - Natural conversation flow

  process:
    - Receive image through chat interface
    - Apply full extraction pipeline
    - Generate tokens and patterns
    - Apply selected creative mode

  best_practices:
    - Use for quick iterations
    - Ideal for single reference analysis
    - Faster than Context folder for one-off extractions
```

### URL Screenshot Workflow

```yaml
url_workflow:
  trigger: "User provides website URL for design extraction"

  process:
    - Use WebFetch to retrieve page
    - Analyze page structure and styles
    - Extract comprehensive design system
    - Handle responsive variations

  enhanced_extraction:
    - Live interaction patterns
    - Actual CSS values
    - Font stack detection
    - Media query breakpoints

  limitations:
    - Dynamic content may vary
    - Some styles computed at runtime
    - Authentication-gated content inaccessible
```

### Figma MCP Integration Workflow

**MANDATORY QUESTION:** Always ask at conversation start: "Should I check Figma files using Figma MCP for design specifications?" (unless user already specified)

```yaml
figma_mcp_workflow:
  purpose: "Extract design tokens, components, and specifications directly from Figma files"
  
  trigger:
    - User specifies Figma file URL/ID in initial request
    - User says "check Figma" or "use Figma MCP"
    - AI asks mandatory pre-flight question about Figma

  connection_setup:
    method: "MCP (Model Context Protocol) integration"
    access: "Via Figma MCP server configured in Claude settings"
    authentication: "Uses Figma API token configured in MCP settings"
    
  supported_operations:
    file_access:
      - "Get Figma file by URL or file key"
      - "List all pages in document"
      - "Access specific frames/components"
      
    component_extraction:
      - "Extract component definitions"
      - "Get component properties and variants"
      - "Access component documentation"
      
    style_extraction:
      - "Extract color styles (fills, strokes)"
      - "Get typography styles (fonts, sizes, weights, line-heights)"
      - "Access effect styles (shadows, blurs)"
      - "Grid and layout styles"
      
    token_generation:
      - "Convert Figma styles to CSS variables"
      - "Map component variants to HTML states"
      - "Extract spacing from Auto Layout"
      - "Generate responsive breakpoints"
      
    context_folder_priority:
      rule: "If /Context/ folder has design system files, ask user preference"
      question: "Would you like me to use your Context folder design system or Figma tokens?"
      skip_if: "User already specified in request"
      reference: "See Visual Excellence → CSS Variables & Fluid Responsive Design"

  extraction_pipeline:
    step_1_connect:
      action: "Connect to Figma via MCP"
      commands:
        - "figma_get_file(file_key: string)"
        - "figma_list_files()"
      output: "Figma file structure and metadata"
      
    step_2_analyze:
      action: "Analyze design system"
      extract:
        colors:
          - "Paint styles (solid, gradients)"
          - "Semantic naming (primary, secondary, etc.)"
          - "Color tokens with exact hex values"
          - "Opacity and blend modes"
          
        typography:
          - "Text styles with font families"
          - "Font sizes, weights, line-heights"
          - "Letter spacing and text transforms"
          - "Paragraph spacing"
          
        spacing:
          - "Auto Layout padding and gaps"
          - "Frame constraints and positioning"
          - "Component internal spacing"
          - "Infer spacing scale (4px, 8px, etc.)"
          
        components:
          - "Component structure and hierarchy"
          - "Variants and properties"
          - "Instance overrides"
          - "Component documentation/descriptions"
          
        effects:
          - "Shadow styles (drop, inner)"
          - "Blur effects"
          - "Border radius values"
          - "Stroke styles"
          
    step_3_transform:
      action: "Convert Figma data to web tokens"
      transformations:
        - "Figma RGB → CSS hex/rgb/hsl"
        - "Figma font names → Web-safe font stacks"
        - "Auto Layout → Flexbox/Grid"
        - "Component variants → CSS classes/states"
        - "Effects → CSS box-shadow/filter"
        
    step_4_apply:
      action: "Apply tokens per creative mode"
      strict_mode:
        - "Use exact Figma values (≤10% deviation)"
        - "Preserve all component variants"
        - "Match typography precisely"
        - "Replicate all effects"
        
      balanced_mode:
        - "Match aesthetic (10-25% adaptation)"
        - "Optimize for web performance"
        - "Simplify complex effects if needed"
        - "Use semantic HTML over divs"
        
      creative_mode:
        - "Interpret design vision (25-50% freedom)"
        - "Enhance with web-native patterns"
        - "Add micro-interactions"
        - "Improve accessibility"

  figma_specific_features:
    auto_layout_conversion:
      figma: "Auto Layout with padding/gap"
      html: "Flexbox/Grid with gap property"
      mapping:
        - "Horizontal → flex-direction: row"
        - "Vertical → flex-direction: column"
        - "Space between → justify-content: space-between"
        - "Hug → fit-content/auto"
        - "Fill → flex: 1"
        
    variant_mapping:
      figma: "Component with properties (size, state, etc.)"
      html: "CSS classes + data attributes"
      example:
        figma_variant: "Button [Size: Large, State: Hover]"
        html_output: "<button class='btn btn--large' data-state='hover'>"
        
    constraints_to_responsive:
      figma: "Frame constraints (Left/Right/Center, etc.)"
      html: "Media queries + flexbox/grid"
      responsive: "Convert fixed to fluid when appropriate"

  best_practices:
    preparation:
      - "Ensure Figma file is organized with named layers"
      - "Use Figma styles for colors and typography"
      - "Document components with descriptions"
      - "Create component variants for states"
      
    extraction:
      - "Start with design system/style guide frame"
      - "Extract components in logical order"
      - "Verify color contrast meets WCAG standards"
      - "Test extracted values in browser"
      
    optimization:
      - "Simplify complex nested structures"
      - "Consolidate similar styles"
      - "Remove redundant effects"
      - "Ensure mobile-friendly sizing"

  common_workflows:
    brand_guidelines:
      - "Extract brand colors from style guide"
      - "Get official typography specs"
      - "Build design token library"
      - "Use Strict mode for brand compliance"
      
    component_library:
      - "Extract all component variants"
      - "Map interaction states"
      - "Generate HTML component patterns"
      - "Use Balanced mode for web optimization"
      
    design_exploration:
      - "Get base design tokens"
      - "Use as inspiration not blueprint"
      - "Apply Creative mode for reinterpretation"
      - "Enhance with modern web patterns"

  error_handling:
    connection_issues:
      - "Verify Figma MCP server is running"
      - "Check API token validity"
      - "Confirm file access permissions"
      - "Fall back to screenshot extraction if needed"
      
    missing_data:
      - "Handle files without style libraries"
      - "Infer tokens from actual components"
      - "Ask user for clarification on ambiguous styles"
      - "Provide best-effort extraction"

  advantages_over_screenshots:
    precision: "Exact values, not visual approximation"
    structure: "Component hierarchy and relationships"
    states: "All variants captured systematically"
    documentation: "Component descriptions and notes"
    efficiency: "Direct API access faster than image analysis"
    
  integration_with_creative_modes:
    strict_mode_with_figma:
      use_case: "Client deliverables, brand guidelines"
      approach: "Pixel-perfect Figma replication"
      deviation: "≤10%"
      
    balanced_mode_with_figma:
      use_case: "Production websites, web apps"
      approach: "Figma aesthetic + web optimization"
      deviation: "10-25%"
      default: true
      
    creative_mode_with_figma:
      use_case: "Portfolio, innovation, exploration"
      approach: "Figma-inspired with artistic freedom"
      deviation: "25-50%"
```

**Example Figma MCP Usage:**

```yaml
user_request: "Design a button component based on Figma file: https://figma.com/file/ABC123"

ai_workflow:
  step_1: "Ask: Should I check Figma files using Figma MCP?" (if not already specified)
  step_2: "Connect to Figma via MCP: figma_get_file('ABC123')"
  step_3: "Extract button component variants"
  step_4: "Ask: Which creative mode? Strict/Balanced/Creative"
  step_5: "Generate HTML button with extracted tokens"
  step_6: "Apply creative mode adjustments"
  step_7: "Deliver self-contained HTML file"
```

---

## 3. 🔍 PATTERN RECOGNITION METHODOLOGY

### Component Classification System

```yaml
ui_components:
  buttons:
    variants: [solid, outlined, ghost, text, icon, floating_action]
    states: [default, hover, active, focus, disabled, loading]
    sizes: [xs, sm, md, lg, xl]

  forms:
    inputs: [text, email, password, number, date, select, textarea]
    layouts: [stacked_labels, inline_labels, floating_labels, no_labels]
    validation: [error, success, warning, info]

  cards:
    types: [basic, elevated, outlined, interactive, media]
    layouts: [vertical, horizontal, overlay]

  navigation:
    patterns: [top_bar, sidebar, tabs, breadcrumbs, pagination, stepper]
    mobile: [hamburger, bottom_nav, drawer]

  feedback:
    types: [toast, snackbar, alert, modal, inline]
    variants: [success, error, warning, info, neutral]

  layout:
    structures: [hero, grid, masonry, split, asymmetric]
    containers: [full_width, contained, fluid]
    sections: [header, main, sidebar, footer]
```

### Pattern Matching Algorithm

```python
def extract_patterns(reference_image):
    """
    Intelligent pattern extraction with confidence scoring
    """
    # Phase 1: Element Detection
    elements = claude_vision.detect_all_elements(reference_image)

    # Phase 2: Classification
    classified_components = []
    for element in elements:
        component_type = classify_component(element)
        confidence = calculate_confidence(element, component_type)

        classified_components.append({
            'element': element,
            'type': component_type,
            'confidence': confidence,
            'properties': extract_properties(element)
        })

    # Phase 3: Pattern Library Matching
    matches = []
    for component in classified_components:
        if component['confidence'] > 0.8:
            # High confidence: use pattern directly
            pattern = get_pattern_from_library(component['type'])
            strategy = 'direct_use'
        elif component['confidence'] > 0.5:
            # Medium confidence: adapt pattern
            pattern = adapt_pattern(component)
            strategy = 'adaptation'
        else:
            # Low confidence: custom build
            pattern = create_custom_pattern(component)
            strategy = 'custom'

        matches.append({
            'pattern': pattern,
            'strategy': strategy,
            'confidence': component['confidence']
        })

    return matches
```

### Confidence Scoring Matrix

| Confidence | Range | Strategy | Example |
|------------|-------|----------|---------|
| **High** | >80% | Use pattern directly | Standard button matches library |
| **Medium** | 50-80% | Adapt with modifications | Card with unique layout |
| **Low** | <50% | Build custom component | Novel interaction pattern |

---

## 4. 🎨 STYLE TOKEN EXTRACTION

### Color Extraction System

```yaml
color_extraction:
  process:
    detect_all_colors:
      - Scan entire reference image
      - Identify unique color values
      - Group similar shades

    extract_hex_values:
      - Convert to precise hex codes
      - Handle RGB/RGBA conversions
      - Preserve opacity values

    build_color_system:
      primitive_tokens:
        neutrals:
          - gray-50: "#F9FAFB"
          - gray-100: "#F3F4F6"
          - gray-900: "#111827"

        colors:
          - blue-500: "#3B82F6"
          - green-500: "#10B981"
          - red-500: "#EF4444"

      semantic_tokens:
        - primary: "var(--blue-500)"
        - secondary: "var(--gray-600)"
        - success: "var(--green-500)"
        - error: "var(--red-500)"
        - text-primary: "var(--gray-900)"
        - text-secondary: "var(--gray-600)"
        - background: "var(--white)"
        - surface: "var(--gray-50)"

    validation:
      - WCAG AA contrast (4.5:1 minimum)
      - WCAG AAA contrast (7:1 for critical text)
      - Color blind safe combinations
```

### Typography Extraction

```yaml
typography_extraction:
  font_identification:
    process:
      - Analyze character shapes and proportions
      - Match against Google Fonts database
      - Identify closest available alternatives

    fallback_strategy:
      - Primary: Exact match if identifiable
      - Secondary: Visually similar Google Font
      - Tertiary: System font with similar characteristics

  measurement:
    font_sizes:
      - Extract all unique sizes
      - Identify base size (usually body text)
      - Calculate scale ratio

    line_heights:
      - Measure for each font size
      - Calculate relative values
      - Identify rhythm pattern

    font_weights:
      - Detect all weight variations
      - Map to standard values (400, 500, 600, 700)

  output:
    type_scale:
      - xs: "0.75rem"    # 12px
      - sm: "0.875rem"   # 14px
      - base: "1rem"     # 16px
      - lg: "1.125rem"   # 18px
      - xl: "1.25rem"    # 20px
      - 2xl: "1.5rem"    # 24px
      - 3xl: "1.875rem"  # 30px
      - 4xl: "2.25rem"   # 36px

    font_families:
      heading: "'Inter', system-ui, sans-serif"
      body: "'Inter', system-ui, sans-serif"
      mono: "'JetBrains Mono', monospace"
```

### Spacing Extraction

```yaml
spacing_extraction:
  grid_detection:
    common_bases: [4, 8, 12, 16]
    process:
      - Measure all spacing values
      - Find greatest common divisor
      - Identify base unit

  spacing_scale:
    generation:
      - 0: "0"
      - 1: "0.25rem"   # 4px
      - 2: "0.5rem"    # 8px
      - 3: "0.75rem"   # 12px
      - 4: "1rem"      # 16px
      - 5: "1.25rem"   # 20px
      - 6: "1.5rem"    # 24px
      - 8: "2rem"      # 32px
      - 10: "2.5rem"   # 40px
      - 12: "3rem"     # 48px
      - 16: "4rem"     # 64px
      - 20: "5rem"     # 80px

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

## 5. 🎛️ CREATIVE CONTROL SYSTEM

### Mode Selection Interface

```markdown
🎯 **Creative Control Mode Selection**

I've detected references in [Context folder / chat upload]. How should I apply them?

**Strict Mode (≤10% deviation)**
- Pixel-perfect replication
- Exact color and spacing matching
- Minimal interpretation
- Use when: Brand guidelines, client mockups, legal requirements

**Balanced Mode (10-25% adaptation)** [DEFAULT]
- Match core aesthetic
- Optimize for web standards
- Enhance accessibility
- Use when: Production sites, modern web apps

**Creative Mode (25-50% interpretation)**
- Design inspiration
- Contemporary enhancements
- Unique personality
- Use when: Portfolio pieces, exploration, innovation

Selection: _
```

### Strict Mode Implementation

```yaml
strict_mode:
  deviation_tolerance: "≤10%"

  rules:
    colors:
      - Extract exact hex values
      - No substitutions without permission
      - Preserve all color relationships

    typography:
      - Match fonts exactly or document closest alternative
      - Preserve all size relationships
      - Maintain exact line-heights

    spacing:
      - Replicate to the pixel
      - No grid normalization
      - Preserve all inconsistencies

    layout:
      - Exact structural replication
      - Preserve quirks and exceptions
      - No responsive improvements unless requested

  allowed_changes:
    - Semantic HTML improvements
    - Accessibility attributes
    - Performance optimizations (with same visual result)
    - Responsive behavior (if not defined in reference)

  validation:
    - Side-by-side comparison
    - Deviation percentage calculation
    - User approval required

  output_format:
    """
    📊 Strict Mode Extraction Report

    Deviation: 7.8%
    - Colors: 0 changes (exact match)
    - Typography: Inter substituted for Helvetica (98% similarity)
    - Spacing: 2 values normalized (31px → 32px for rounding)
    - Layout: 100% structural match

    [Approve] [Request changes] [Switch mode]
    """
```

### Balanced Mode Implementation

```yaml
balanced_mode:
  deviation_tolerance: "10-25%"

  optimizations:
    accessibility:
      - Enhance color contrast to WCAG AA
      - Add keyboard navigation
      - Include ARIA labels
      - Ensure focus indicators

    performance:
      - Optimize animations (GPU acceleration)
      - Efficient CSS (avoid reflows)
      - Lazy loading for images
      - Modern CSS features (Grid, custom properties)

    consistency:
      - Normalize to 8px grid
      - Standardize component patterns
      - Unify interaction behaviors
      - Apply design tokens

  encouraged_enhancements:
    - Micro-interactions
    - Loading states
    - Error handling
    - Responsive improvements
    - Dark mode preparation

  validation:
    - Aesthetic similarity check
    - Enhancement documentation
    - WCAG compliance verification

  output_format:
    """
    🎨 Balanced Mode Enhancements

    Core aesthetic preserved with optimizations:

    ✅ Accessibility: 3 contrast improvements (WCAG AA)
    ✅ Grid: Normalized to 8px system
    ✅ Typography: Inter font family (better web rendering)
    ✅ Interactions: Added hover states and transitions
    ✅ Responsive: Mobile-first breakpoints implemented

    Overall deviation: 18% (within target range)
    """
```

### Creative Mode Implementation

```yaml
creative_mode:
  deviation_tolerance: "25-50%"

  creative_freedoms:
    colors:
      - Evolve palette while maintaining harmony
      - Add gradient overlays
      - Introduce accent colors
      - Apply modern color trends

    typography:
      - Explore font pairings
      - Add display fonts for impact
      - Implement fluid typography
      - Create typographic rhythm

    effects:
      - Glassmorphism
      - Neumorphism (if appropriate)
      - Advanced animations
      - Parallax effects
      - 3D transforms

    layout:
      - Modern patterns (Bento box, asymmetric grids)
      - Creative navigation solutions
      - Innovative component designs
      - Experimental interactions

  constraints:
    must_preserve:
      - Core design intent
      - Target audience appropriateness
      - Functional requirements
      - Brand personality (if defined)

  validation:
    - Design rationale documentation
    - Before/after comparison
    - Creative decisions explained

  output_format:
    """
    ✨ Creative Mode Interpretation

    Inspired by reference with creative enhancements:

    🎨 Color Evolution:
    - Base palette maintained
    - Added vibrant gradient accents
    - Introduced glassmorphism for depth

    📝 Typography:
    - Display font: "Clash Display" for headlines
    - Body: Inter (matching reference weight)
    - Added fluid scaling (clamp functions)

    ✨ Modern Enhancements:
    - Smooth micro-interactions
    - Parallax scroll effects
    - Animated gradient borders
    - 3D card hover transforms

    Deviation: 38% (creative interpretation applied)
    Design rationale: Modern, energetic, forward-thinking
    """
```

### Mode Comparison Matrix

| Aspect | Strict (≤10%) | Balanced (10-25%) | Creative (25-50%) |
|--------|--------|----------|----------|
| **Color Fidelity** | 95%+ exact | 85% with WCAG | 60% inspired |
| **Typography Match** | Exact or closest | Optimized alternative | Creative pairing |
| **Spacing Precision** | Near pixel-perfect | Grid-normalized | Rhythm-based |
| **Layout Structure** | 90%+ match | Responsive-optimized | Modern interpretation |
| **Effects** | Closely replicated | Performance-optimized | Trend-enhanced |
| **Interactions** | As visible | Best practices | Delightful |
| **Accessibility** | Added only | Prioritized | Integrated |
| **Performance** | Not modified | Optimized | Balanced with effects |

---

## 6. 🔗 CANVAS INTEGRATION

### Phase C (Concept) Enhancement

```yaml
enhanced_concept_phase:
  reference_detection:
    automatic:
      - Scan Context folder on conversation start
      - Detect image uploads in chat
      - Identify design URLs mentioned

    prompt: |
      "🎯 Reference Detection

      Found [3] references in Context folder:
      - homepage-desktop.png (1920x1080)
      - mobile-nav.png (375x667)
      - style-guide.png (1200x800)

      Extract design system? [Yes] [Select specific] [Skip]"

  extraction_integration:
    - If references exist: Extract tokens first
    - Apply multi-perspective analysis to extracted patterns
    - Use extracted tokens as design foundation
    - Creative mode influences perspective weights
```

### Phase V (Visual) Token Application

```yaml
visual_phase_with_extraction:
  token_source_priority:
    1: Extracted tokens (if references provided)
    2: Brand guidelines (if available)
    3: Generated tokens (standard CANVAS flow)

  extracted_token_application:
    process:
      - Apply extracted color system
      - Implement extracted typography
      - Use extracted spacing scale
      - Apply extracted effects

    validation:
      - Compare output to reference
      - Verify creative mode compliance
      - Check DESIGN quality score
```

### Multi-Perspective Analysis with References

```yaml
perspective_enhancement:
  Visual_Design_Expert:
    focus: "Aesthetic fidelity to reference"
    weight_by_mode:
      strict: 40%
      balanced: 25%
      creative: 15%

  UX_Flow:
    focus: "User journey optimization"
    weight_by_mode:
      strict: 20%
      balanced: 30%
      creative: 25%

  Innovation_Lens:
    focus: "Modern enhancements"
    weight_by_mode:
      strict: 5%
      balanced: 20%
      creative: 35%
```

---

## 7. ✅ QUALITY ASSURANCE

### Extraction Validation

```yaml
extraction_validation:
  accuracy_metrics:
    colors:
      target: "99% hex accuracy"
      method: "Direct comparison with color picker"

    typography:
      target: "95% visual similarity"
      method: "Side-by-side rendering comparison"

    spacing:
      target: "98% measurement precision"
      method: "Overlay measurement verification"

    layout:
      target: "100% structural accuracy"
      method: "Wireframe overlay comparison"
```

### Mode Compliance Verification

```yaml
mode_compliance:
  strict_mode_checks:
    - Deviation calculation (≤10%)
    - Element-by-element comparison
    - Color hex verification
    - Spacing measurement validation

  balanced_mode_checks:
    - Aesthetic similarity (75%+)
    - WCAG AA compliance
    - Grid normalization verification
    - Enhancement documentation

  creative_mode_checks:
    - Design rationale clarity
    - Core intent preservation
    - Innovation appropriateness
    - User satisfaction
```

### Quality Gates

```yaml
quality_gates:
  pre_delivery:
    - DESIGN score ≥ 40/50
    - Mode compliance verified
    - Responsive tested (3 breakpoints minimum)
    - Accessibility validated (WCAG AA)
    - Performance checked (60fps animations)

  user_approval:
    - Comparison screenshots provided
    - Deviation report generated
    - Enhancement list documented
    - Rationale explained
```

---

## 8. 🏎️ QUICK REFERENCE

### Command Shortcuts

```yaml
extraction_commands:
  strict_mode:
    command: "$extract strict"
    description: "Pixel-perfect replication from Context folder"

  balanced_default:
    command: "$extract"
    description: "Default extraction with web optimization"

  creative_mode:
    command: "$extract creative [image]"
    example: "$extract creative homepage.png"
    description: "Creative interpretation with 25-50% deviation"

  tokens_only:
    command: "$extract tokens"
    description: "Extract design tokens without generating prototype"

  url_extraction:
    command: "$extract [url]"
    example: "$extract https://example.com"
    description: "Extract from live website"

  batch_processing:
    command: "$extract batch"
    description: "Process all references in Context folder"

  focused_extraction:
    command: "$extract --focus [elements]"
    example: "$extract --focus 'colors typography'"
    description: "Extract specific design elements only"
```

### Best Practices Checklist

**Before Extraction:**
- [ ] High-resolution images (1920px+ width)
- [ ] Multiple states included (hover, active, error)
- [ ] Clear file naming convention
- [ ] Context folder organized by component/page

**During Extraction:**
- [ ] Confirm creative mode selection
- [ ] Review extracted tokens
- [ ] Validate pattern matching
- [ ] Check accessibility compliance

**After Extraction:**
- [ ] Compare output to reference
- [ ] Verify mode compliance
- [ ] Document any deviations
- [ ] Get user approval

### Troubleshooting Guide

| Issue | Solution |
|-------|----------|
| **Colors don't match** | Use PNG instead of JPG, verify no compression |
| **Font not identified** | Provide font name or accept closest match |
| **Layout differs** | Check reference resolution, specify exact structure needs |
| **Spacing inconsistent** | Verify grid system detection, manual override if needed |
| **Missing subtle details** | Zoom and re-extract specific areas |
| **Extraction too slow** | Reduce image resolution to 1920px width |
| **Conflicting references** | Specify primary reference or merge strategy |

### File Organization Template

```
Context/
├── project-name/
│   ├── desktop/
│   │   ├── homepage.png
│   │   ├── about.png
│   │   └── contact.png
│   ├── mobile/
│   │   ├── homepage-mobile.png
│   │   └── nav-mobile.png
│   ├── components/
│   │   ├── buttons-all-states.png
│   │   ├── forms.png
│   │   └── cards.png
│   └── style-guide.png
└── README.md (optional notes)
```

### Integration Points

| System Component | Integration Type | Location |
|-----------------|------------------|----------|
| **CANVAS Framework** | Reference detection in Phase C | `UI Designer - CANVAS Thinking Framework` |
| **Interactive Intelligence** | Mode selection dialogue | `UI Designer - Interactive Intelligence` |
| **Visual Excellence** | Quality validation | `UI Designer - Visual Excellence` |
| **Main Router** | Extraction workflow trigger | `UI Designer - v0.100` |

### Integration with UI Designer System

**This document is referenced by:**
- `UI Designer - v0.100` (Main): Section 3A (Reference Extraction overview), Section 4 (Request routing)
- `UI Designer - CANVAS Framework`: Phase C (Concept phase extraction workflow)
- `UI Designer - Interactive Intelligence`: State machine (reference_detection and mode_selection states)
- `UI Designer - Visual Excellence`: Design token systems and visual theory

**Integration workflow:** Main system detects references → This methodology extracts tokens → `UI Designer - Visual Excellence` applies theory → `UI Designer - CANVAS Thinking Framework` generates design

---

*The Reference Extraction system enables precision visual analysis and flexible creative control for reference-driven design workflows, integrating seamlessly with CANVAS methodology for systematic rigor and exceptional quality.*