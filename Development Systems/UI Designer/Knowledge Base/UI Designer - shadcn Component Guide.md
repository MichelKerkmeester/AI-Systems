# shadcn/ui Component Architecture

This document explains how shadcn/ui components should be used in the UI Designer system.

## Component Philosophy

shadcn/ui provides **unstyled, accessible base components** that serve as the foundation for all UI prototypes. These components are:
- **Copy-paste friendly** - Not installed as dependencies
- **Customizable** - Style with Tailwind CSS
- **Accessible** - Built with Radix UI primitives
- **Type-safe** - Full TypeScript support

## Available Components

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

## Usage Pattern

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

## Integration with Reference Extraction

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

## Best Practices

1. **Always start with shadcn base** - Don't recreate components from scratch
2. **Customize with Tailwind** - Use utility classes for styling
3. **Preserve accessibility** - Don't remove ARIA attributes from shadcn components
4. **Create variants for reuse** - Use CVA for repeated patterns
5. **Type everything** - Define props interfaces for all custom components
6. **Include demo files** - Show how to use each component
7. **Document customizations** - Explain why changes were made

## Quality Checklist

- [ ] Used appropriate shadcn base component
- [ ] Applied Tailwind classes for customization
- [ ] Preserved accessibility attributes
- [ ] Defined TypeScript interfaces for props
- [ ] Added responsive classes (sm:, md:, lg:)
- [ ] Implemented all interaction states (hover, focus, disabled)
- [ ] Created demo/usage example
- [ ] Documented component purpose and usage

## Resources

- shadcn/ui docs: https://ui.shadcn.com
- Tailwind CSS docs: https://tailwindcss.com
- Radix UI (underlying primitives): https://www.radix-ui.com
