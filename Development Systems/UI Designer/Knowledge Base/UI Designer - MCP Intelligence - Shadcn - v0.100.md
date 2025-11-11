# UI Designer - shadcn/ui Component Guide

Component selection, usage patterns, and preview strategies for shadcn/ui integration with React + TypeScript + Tailwind CSS.

**Core Purpose:** Define shadcn/ui component architecture, selection strategies, customization patterns, and instant preview methods for rapid prototyping.

**Scope:** Component architecture, usage patterns, preview strategies. For design philosophy, see `UI Designer - Visual Excellence`. For thinking methodology, see `UI Designer - CANVAS Thinking Framework`.

---

## 📋 TABLE OF CONTENTS

1. [🎯 COMPONENT PHILOSOPHY](#1-component-philosophy)
2. [📦 AVAILABLE COMPONENTS](#2-available-components)
3. [🔨 USAGE PATTERNS](#3-usage-patterns)
4. [🎨 COMPONENT SELECTION](#4-component-selection)
5. [🎭 CUSTOMIZATION APPROACH](#5-customization-approach)
6. [🔗 REFERENCE EXTRACTION](#6-reference-extraction)
7. [👁️ PREVIEW STRATEGIES](#7-preview-strategies)
8. [✅ QUALITY CHECKLIST](#8-quality-checklist)
9. [🏎️ QUICK REFERENCE](#9-quick-reference)

---

## 1. 🎯 COMPONENT PHILOSOPHY

shadcn/ui provides **unstyled, accessible base components** that serve as the foundation for all UI prototypes. These components are:
- **Copy-paste friendly** - Not installed as dependencies
- **Customizable** - Style with Tailwind CSS
- **Accessible** - Built with Radix UI primitives
- **Type-safe** - Full TypeScript support

### Why shadcn/ui?

**Advantages over vanilla HTML/CSS/JS:**
- Pre-built accessibility features
- Consistent component behavior
- TypeScript type safety
- Radix UI primitive foundation
- Active community and ecosystem
- Easy preview and iteration

---

## 2. 🔌 MCP SERVER INTEGRATION

### shadcn-ui MCP Server

**Configuration:** Automatically configured in `.mcp.json` and `.vscode/mcp.json`

```json
{
  "shadcn-ui": {
    "command": "npx",
    "args": ["-y", "shadcn-ui-mcp-server"],
    "env": {
      "GITHUB_TOKEN": "your_github_token"
    }
  }
}
```

### Available MCP Tools

```yaml
mcp_tools:
  list_shadcn_components:
    purpose: "Get complete list of available shadcn/ui components"
    usage: "Initial planning, component discovery"
    output: "Array of component names with categories"
  
  get_component_details:
    purpose: "Fetch detailed info about specific component"
    input: "Component name (e.g., 'button', 'dialog')"
    output: "Props, variants, usage patterns, dependencies"
  
  get_component_examples:
    purpose: "Get code examples for component"
    input: "Component name"
    output: "Multiple usage examples with variations"
  
  search_components:
    purpose: "Find components by keyword"
    input: "Search query (e.g., 'modal', 'form')"
    output: "Relevant components matching query"
```

### MCP Workflow

```yaml
component_selection_flow:
  step_1_analyze_need:
    action: "Analyze design requirements"
    questions:
      - "What UI pattern is needed?"
      - "What user interactions are required?"
      - "What states must be supported?"
  
  step_2_search_components:
    tool: "search_components OR list_shadcn_components"
    action: "Find matching base components"
  
  step_3_get_details:
    tool: "get_component_details"
    action: "Review props, variants, examples"
  
  step_4_select_base:
    action: "Choose most appropriate base component"
    criteria:
      - "Matches interaction pattern"
      - "Supports required states"
      - "Minimal customization needed"
  
  step_5_get_examples:
    tool: "get_component_examples"
    action: "Review usage patterns for implementation guidance"
```

---

## 3. 🎨 COMPONENT CATALOG

### Form Components
- `Button` - All button variants (primary, secondary, outline, ghost)
- `Input` - Text inputs with validation states
- `Textarea` - Multi-line text inputs
- `Select` - Dropdown selects
- `Checkbox` - Checkboxes with labels
- `RadioGroup` - Radio button groups
- `Switch` - Toggle switches
- `Slider` - Range sliders
- `Label` - Form labels
- `Form` - Form wrapper with validation

### Layout Components
- `Card` - Content containers
- `Separator` - Dividers
- `Tabs` - Tab navigation
- `Accordion` - Collapsible sections
- `Collapsible` - Show/hide content
- `ScrollArea` - Custom scrollbars
- `AspectRatio` - Maintain aspect ratios

### Overlay Components
- `Dialog` - Modal dialogs
- `Sheet` - Side panels/drawers
- `AlertDialog` - Confirmation dialogs
- `Popover` - Floating content
- `HoverCard` - Hover tooltips
- `Tooltip` - Simple tooltips
- `DropdownMenu` - Dropdown menus
- `ContextMenu` - Right-click menus

### Navigation Components
- `NavigationMenu` - Main navigation
- `Breadcrumb` - Breadcrumb navigation
- `Pagination` - Page navigation
- `Command` - Command palette (⌘K)

### Feedback Components
- `Alert` - Alert messages
- `Toast` - Toast notifications
- `Progress` - Progress bars
- `Badge` - Status badges
- `Avatar` - User avatars
- `Skeleton` - Loading skeletons

### Data Display
- `Table` - Data tables
- `DataTable` - Advanced data tables with sorting/filtering
- `Calendar` - Date picker calendar
- `Carousel` - Image carousels

### Component Selection Matrix

| Design Need | Primary Component | Alternative | Notes |
|-------------|-------------------|-------------|-------|
| Call-to-action | `Button` | - | Use variant prop for styles |
| Form input | `Input` + `Label` | `Textarea` for multi-line | Wrap in `Form` for validation |
| Dropdown selector | `Select` | `Combobox` for search | Select for simple, Combobox for large lists |
| Modal dialog | `Dialog` | `Sheet` for mobile | Sheet slides from side |
| Action menu | `DropdownMenu` | `ContextMenu` | ContextMenu for right-click |
| Content container | `Card` | `div` with Tailwind | Card provides semantic structure |
| Navigation | `NavigationMenu` | `Tabs` for views | NavigationMenu for site nav |
| Status indicator | `Badge` | `Alert` for messages | Badge for inline, Alert for blocks |
| Notification | `Toast` | `Alert` | Toast for temporary, Alert for persistent |
| Data grid | `DataTable` | `Table` | DataTable for features, Table for simple |

---

## 4. ⚡ PREVIEW WORKFLOW

### Rapid Preview Strategy

**Goal:** Enable instant visual feedback for created components

```yaml
preview_workflow:
  approach_1_storybook_like:
    structure: "Create standalone demo file that can be viewed in isolation"
    file_pattern: "{component-name}-preview.tsx"
    content:
      - "Import component"
      - "Show multiple states/variants"
      - "Include interactive controls"
      - "Apply Tailwind for layout"
    
  approach_2_nextjs_dev:
    setup: "Use Next.js dev server for hot reload"
    command: "npx next dev"
    benefit: "Instant browser preview with hot module replacement"
    
  approach_3_component_playground:
    pattern: "Create playground file with all variants visible"
    layout: "Grid of component states for visual comparison"
```

### Preview File Template

**MANDATORY:** Every component export must include a preview/demo file for instant visual testing.

```tsx
// component-name-preview.tsx
import React from 'react'
import { ComponentName } from './component-name'

/**
 * PREVIEW FILE - Open in browser to see component in action
 * This file shows all component variants and states for quick visual validation
 */
export default function ComponentNamePreview() {
  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-7xl mx-auto space-y-12">
        
        {/* Preview Header */}
        <header className="space-y-2">
          <h1 className="text-4xl font-bold">ComponentName Preview</h1>
          <p className="text-gray-600">All variants and states for visual validation</p>
        </header>

        {/* Default State */}
        <section className="space-y-4">
          <h2 className="text-2xl font-semibold">Default</h2>
          <div className="bg-white p-8 rounded-lg shadow">
            <ComponentName title="Default Example" />
          </div>
        </section>

        {/* Variants Grid */}
        <section className="space-y-4">
          <h2 className="text-2xl font-semibold">All Variants</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-sm font-medium text-gray-500 mb-4">Primary</h3>
              <ComponentName variant="primary" title="Primary" />
            </div>
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-sm font-medium text-gray-500 mb-4">Secondary</h3>
              <ComponentName variant="secondary" title="Secondary" />
            </div>
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-sm font-medium text-gray-500 mb-4">Outline</h3>
              <ComponentName variant="outline" title="Outline" />
            </div>
          </div>
        </section>

        {/* States */}
        <section className="space-y-4">
          <h2 className="text-2xl font-semibold">States</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-sm font-medium text-gray-500 mb-4">Loading</h3>
              <ComponentName loading title="Loading State" />
            </div>
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-sm font-medium text-gray-500 mb-4">Disabled</h3>
              <ComponentName disabled title="Disabled State" />
            </div>
          </div>
        </section>

        {/* Responsive Preview */}
        <section className="space-y-4">
          <h2 className="text-2xl font-semibold">Responsive Behavior</h2>
          <div className="space-y-4">
            <div className="w-full max-w-sm bg-white p-6 rounded-lg shadow">
              <p className="text-sm text-gray-500 mb-4">Mobile (375px)</p>
              <ComponentName title="Mobile View" />
            </div>
            <div className="w-full max-w-2xl bg-white p-6 rounded-lg shadow">
              <p className="text-sm text-gray-500 mb-4">Tablet (768px)</p>
              <ComponentName title="Tablet View" />
            </div>
            <div className="w-full bg-white p-6 rounded-lg shadow">
              <p className="text-sm text-gray-500 mb-4">Desktop (1280px+)</p>
              <ComponentName title="Desktop View" />
            </div>
          </div>
        </section>

      </div>
    </div>
  )
}
```

### Quick Preview Setup

```yaml
instant_preview_steps:
  step_1_create_component:
    action: "Generate component .tsx file"
  
  step_2_create_preview:
    action: "Generate preview file with all variants"
    template: "Use preview template above"
  
  step_3_setup_nextjs:
    files:
      - "app/preview/[component]/page.tsx → Dynamic preview route"
    benefit: "Navigate to /preview/component-name for instant view"
  
  step_4_run_dev_server:
    command: "npx next dev"
    access: "http://localhost:3000/preview/component-name"
```

### Preview Best Practices

```yaml
preview_checklist:
  visual_completeness:
    - [ ] All variants shown
    - [ ] All states demonstrated
    - [ ] Responsive breakpoints visible
    - [ ] Interactive elements functional
  
  organization:
    - [ ] Clear section headings
    - [ ] Grouped by variant/state
    - [ ] Labeled with context
    - [ ] Consistent spacing
  
  usability:
    - [ ] Easy to scan visually
    - [ ] Background contrast for visibility
    - [ ] Grid layout for comparison
    - [ ] Mobile-friendly preview layout
```

---

## 5. 🎛️ CUSTOMIZATION STRATEGIES

### Usage Pattern

### 1. Start with Base Component
```tsx
import { Button } from '@/components/ui/button'

<Button>Click me</Button>
```

### 2. Customize with Tailwind
```tsx
<Button className="bg-brand-500 hover:bg-brand-600 text-white">
  Click me
</Button>
```

### 3. Extend with Variants (CVA)
```tsx
import { cva } from "class-variance-authority"

const buttonVariants = cva(
  "base-classes",
  {
    variants: {
      variant: {
        brand: "bg-brand-500 hover:bg-brand-600",
        outline: "border-brand-500 text-brand-500"
      }
    }
  }
)

<Button className={buttonVariants({ variant: "brand" })}>
  Click me
</Button>
```

## Component Selection Strategy

When designing a UI, map design needs to shadcn components:

| Design Need | shadcn Component | Notes |
|-------------|------------------|-------|
| Call-to-action button | `Button` | Use variant prop for styles |
| Form field | `Input` + `Label` | Wrap in `Form` for validation |
| Modal popup | `Dialog` | Use `DialogTrigger`, `DialogContent` |
| Side drawer | `Sheet` | Mobile-friendly alternative to Dialog |
| Dropdown picker | `Select` or `DropdownMenu` | Select for forms, DropdownMenu for actions |
| Content card | `Card` | Use `CardHeader`, `CardContent`, `CardFooter` |
| Navigation bar | `NavigationMenu` | Supports nested menus |
| Status indicator | `Badge` | Use variant for colors |
| Success/error message | `Alert` or `Toast` | Alert for inline, Toast for temporary |
| Data grid | `Table` or `DataTable` | DataTable for advanced features |

## Customization Approach

### Colors via CSS Variables
shadcn uses CSS variables for theming:

```css
:root {
  --primary: 221.2 83.2% 53.3%;
  --secondary: 210 40% 96.1%;
  --accent: 210 40% 96.1%;
  --destructive: 0 84.2% 60.2%;
}
```

Override these or extend with brand colors:

```tsx
// tailwind.config.js
theme: {
  extend: {
    colors: {
      brand: {
        50: '#f0f9ff',
        500: '#02393e',
        900: '#011a1d'
      }
    }
  }
}
```

### Typography
Apply via Tailwind classes:

```tsx
<h1 className="text-4xl font-bold">Heading</h1>
<p className="text-base leading-7">Body text</p>
```

### Spacing
Use Tailwind spacing utilities:

```tsx
<Card className="p-6 space-y-4">
  <div className="space-y-2">
    <Label>Field</Label>
    <Input />
  </div>
</Card>
```

---

## 6. 🔗 INTEGRATION PATTERNS

### Reference Extraction Integration

When extracting tokens from references:

1. **Extract design tokens** (colors, typography, spacing, effects)
2. **Map UI patterns** to shadcn components
3. **Apply tokens via Tailwind** (extend config or use utility classes)
4. **Customize components** with className prop
5. **Create brand variants** if needed (using CVA)

Example workflow:
```tsx
// 1. Extracted tokens
const tokens = {
  primary: '#02393e',
  fontHeading: 'Clash Display',
  spacing: 8 // 8px grid
}

// 2. Map to Tailwind config
// tailwind.config.js
theme: {
  extend: {
    colors: { brand: { 500: '#02393e' } },
    fontFamily: { heading: ['Clash Display', ...] }
  }
}

// 3. Use in components
<Button className="bg-brand-500 font-heading">
  Brand Button
</Button>
```

### CANVAS Integration

**Phase C (Concept)** - Component Discovery
- Use MCP tools to search for matching components
- Analyze component props and variants
- Document component selection rationale

**Phase A (Architecture)** - Component Structure
- Plan component composition hierarchy
- Define custom props and interfaces
- Map shadcn components to design sections

**Phase V (Visual)** - Styling Application
- Apply Tailwind customization
- Extend with brand tokens
- Create variant definitions

**Phase S (Ship)** - Delivery
- Generate component files (.tsx)
- Create preview files for instant testing
- Document usage examples

---

## 7. ✅ QUALITY STANDARDS

### Component Quality Checklist

```yaml
quality_validation:
  component_selection:
    - [ ] Used most appropriate shadcn base component
    - [ ] Leveraged existing variants when possible
    - [ ] Minimized custom component creation
  
  customization:
    - [ ] Applied Tailwind classes for brand alignment
    - [ ] Preserved accessibility attributes from shadcn
    - [ ] Used semantic color tokens (primary, secondary, etc.)
    - [ ] Implemented responsive classes (sm:, md:, lg:)
  
  typescript:
    - [ ] Defined proper prop interfaces
    - [ ] Used TypeScript for all files (.tsx, .ts)
    - [ ] Exported types for reusability
  
  states:
    - [ ] Implemented hover states
    - [ ] Implemented focus states
    - [ ] Implemented disabled states
    - [ ] Implemented loading states (when applicable)
    - [ ] Implemented error states (for forms)
  
  preview:
    - [ ] Created preview/demo file
    - [ ] Showed all variants
    - [ ] Demonstrated all states
    - [ ] Included responsive examples
    - [ ] Organized for easy visual scanning
  
  documentation:
    - [ ] JSDoc comments for component
    - [ ] Props documented with descriptions
    - [ ] Usage examples provided
    - [ ] Customization guidance included
```

### Best Practices

| Category | Practice | Rationale |
|----------|----------|-----------|
| **Component Selection** | Always start with shadcn base | Accessibility, consistency, less code |
| **Customization** | Use Tailwind utility classes | Maintainability, consistency, speed |
| **Accessibility** | Preserve ARIA attributes | Legal compliance, inclusive design |
| **Variants** | Use CVA for repeated patterns | Type-safe variants, clear API |
| **Types** | Define interfaces for all props | Type safety, better DX, documentation |
| **Preview** | Include demo file with every component | Instant visual validation, faster iteration |
| **Documentation** | Explain customization choices | Team understanding, future maintenance |

---

## 8. 🏎️ QUICK REFERENCE

### MCP Commands

```typescript
// List all available components
mcp_shadcn-ui_list_shadcn_components()

// Get component details
mcp_shadcn-ui_get_component_details({ componentName: "button" })

// Get usage examples
mcp_shadcn-ui_get_component_examples({ componentName: "dialog" })

// Search for components
mcp_shadcn-ui_search_components({ query: "modal" })
```

### Component Selection Quick Guide

| Need | Component | Customization |
|------|-----------|---------------|
| Button | `Button` | `variant` + `size` + Tailwind |
| Modal | `Dialog` | `DialogContent` styling |
| Form | `Form` + `Input` | Validation + error states |
| Card | `Card` | Tailwind for shadows/borders |
| Menu | `DropdownMenu` | Menu items + icons |
| Nav | `NavigationMenu` | Active states + Tailwind |
| Notification | `Toast` | Semantic variants |

### Preview Checklist

- [ ] Preview file created (`{component}-preview.tsx`)
- [ ] All variants visible
- [ ] All states demonstrated
- [ ] Responsive breakpoints shown
- [ ] Background provides contrast
- [ ] Sections clearly labeled
- [ ] Grid layout for comparison

### File Structure Template

```
/export/###-component-name/
  ├── component-name.tsx          (Main component)
  ├── component-name-preview.tsx  (Visual preview - MANDATORY)
  ├── component-name.types.ts     (TypeScript types)
  └── README.md                   (Documentation)
```

### Integration Workflow

1. **Analyze** design requirements
2. **Search** for shadcn component via MCP
3. **Review** component details and examples
4. **Select** appropriate base component
5. **Customize** with Tailwind classes
6. **Create** preview file for validation
7. **Test** in browser via preview
8. **Iterate** based on visual feedback
9. **Document** usage and customizations
10. **Export** to numbered folder

---

*shadcn/ui integration via MCP server enables rapid component-based prototyping with accessible, customizable, type-safe React components and instant visual preview workflows.*
