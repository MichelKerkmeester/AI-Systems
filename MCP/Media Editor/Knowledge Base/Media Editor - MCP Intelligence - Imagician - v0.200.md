# Media Editor - MCP Intelligence - Imagician - v0.200

Technical reference for Imagician MCP server capabilities and integration for image processing operations.

**Purpose:** Document Imagician-specific features, supported operations, and technical specifications. Conversation flows and thinking methodology are in Interactive Intelligence and MEDIA Framework respectively.

---

## 📋 TABLE OF CONTENTS

1. [🔌 SERVER OVERVIEW](#1-server-overview)
2. [🛠️ CORE CAPABILITIES](#2-core-capabilities)
3. [📊 FORMAT SUPPORT](#3-format-support)
4. [⚙️ OPERATION SPECIFICATIONS](#4-operation-specifications)
5. [🎯 QUALITY OPTIMIZATION](#5-quality-optimization)
6. [� RESIZE & CROP](#6-resize--crop)
7. [🔄 TRANSFORMS](#7-transforms)
8. [🏎️ QUICK REFERENCE](#8-quick-reference)

---

<a id="1-server-overview"></a>

## 1. �🔌 SERVER OVERVIEW

### MCP Server Details

```yaml
server:
  name: "Imagician MCP"
  package: "@flowy11/imagician"
  repository: "https://github.com/flowy11/imagician"
  engine: "Sharp (Node.js image processing)"
  protocol: "Model Context Protocol (MCP)"
  installation:
    - "npx -y @flowy11/imagician"
    - "npm install -g @flowy11/imagician"
```

### Connection Verification

**Reference:** Connection verification logic is in Interactive Intelligence v0.110.

```yaml
verification:
  priority: "first_action_before_all_operations"
  tool: "list_images"
  displays:
    connected: "✅ Imagician Connected - Image processing available"
    disconnected: "❌ Imagician Not Connected - Setup required"
```

---

<a id="2-core-capabilities"></a>

## 2. 🛠️ CORE CAPABILITIES

### Available Operations

**Note:** Thinking methodology (10 rounds standard, 1-5 quick) is defined in MEDIA Framework v0.110.

```yaml
operations:
  resize:
    description: "Change image dimensions"
    parameters: [width, height, fit, preserveAspectRatio]
    
  convert:
    description: "Change image format"
    parameters: [format, quality]
    
  crop:
    description: "Extract specific region"
    parameters: [x, y, width, height]
    
  compress:
    description: "Optimize file size"
    parameters: [quality, strip, optimize]
    
  rotate:
    description: "Rotate by angle"
    parameters: [angle, background]
    
  flip:
    description: "Flip horizontally or vertically"
    parameters: [direction]
    
  metadata:
    tool: "getMetadata"
    description: "Extract image information"
    
  batch:
    description: "Process multiple images"
    parameters: [operations_array]
    
  list:
    tool: "list_images"
    description: "List images in folder"
    parameters: [folder]
```

### Processing Order

```yaml
optimal_sequence:
  - verify_connection
  - crop_if_needed
  - resize_if_needed
  - rotate_flip_if_needed
  - format_conversion
  - quality_optimization
```

---

<a id="3-format-support"></a>

## 3. 📊 FORMAT SUPPORT

### Supported Formats

```yaml
formats:
  jpeg:
    extensions: [".jpg", ".jpeg"]
    input: true
    output: true
    transparency: false
    best_for: "Photos, complex images"
    
  png:
    extensions: [".png"]
    input: true
    output: true
    transparency: true
    best_for: "Graphics, screenshots, transparency"
    
  webp:
    extensions: [".webp"]
    input: true
    output: true
    transparency: true
    best_for: "Modern web, balanced compression"
    
  avif:
    extensions: [".avif"]
    input: true
    output: true
    transparency: true
    best_for: "Next-gen compression, cutting-edge"
```

**Note:** Format selection logic and recommendations are in MEDIA Framework Section 2 (Evaluate).

---

<a id="4-operation-specifications"></a>

## 4. ⚙️ OPERATION SPECIFICATIONS

### Resize Operation

```yaml
resize:
  parameters:
    inputPath:
      type: string
      required: true
      description: "Path to input image"
      
    outputPath:
      type: string
      required: true
      description: "Path to save resized image"
      
    width:
      type: number
      optional: true
      description: "Target width in pixels"
      
    height:
      type: number
      optional: true
      description: "Target height in pixels"
      
    fit:
      type: string
      options: [cover, contain, fill, inside, outside]
      default: "inside"
      description: "How to fit image in dimensions"
      
    preserveAspectRatio:
      type: boolean
      default: true
      description: "Maintain aspect ratio"
  
  fit_modes:
    cover: "Crop to cover both dimensions"
    contain: "Fit within dimensions with padding"
    fill: "Stretch to exact dimensions"
    inside: "Resize to fit inside bounds"
    outside: "Resize to fit outside bounds"
```

### Convert Operation

```yaml
convert:
  parameters:
    inputPath:
      type: string
      required: true
      
    outputPath:
      type: string
      required: true
      
    format:
      type: string
      required: true
      options: [jpeg, png, webp, avif]
      
    quality:
      type: number
      range: [1, 100]
      default: 85
      description: "Output quality percentage"
```

### Crop Operation

```yaml
crop:
  parameters:
    inputPath:
      type: string
      required: true
      
    outputPath:
      type: string
      required: true
      
    x:
      type: number
      required: true
      description: "X coordinate from left"
      
    y:
      type: number
      required: true
      description: "Y coordinate from top"
      
    width:
      type: number
      required: true
      description: "Crop width in pixels"
      
    height:
      type: number
      required: true
      description: "Crop height in pixels"
```

### Compress Operation

```yaml
compress:
  parameters:
    inputPath:
      type: string
      required: true
      
    outputPath:
      type: string
      required: true
      
    quality:
      type: number
      range: [1, 100]
      default: 80
      
    strip:
      type: boolean
      default: false
      description: "Remove metadata"
      
    optimize:
      type: boolean
      default: true
      description: "Apply additional optimization"
```

---

<a id="5-quality-optimization"></a>

## 5. 🎯 QUALITY OPTIMIZATION

### Quality Guidelines

**Note:** Quality vs size optimization logic is in MEDIA Framework Section 2 (Evaluate).

```yaml
quality_presets:
  archive:
    quality: 100
    use_case: "Lossless preservation"
    file_size: "Largest"
    
  high_quality:
    quality: [90, 95]
    use_case: "Prints, professional"
    file_size: "Large"
    
  standard_web:
    quality: [80, 89]
    use_case: "Web display, default"
    file_size: "Moderate"
    
  good_compression:
    quality: [70, 79]
    use_case: "Size priority, acceptable quality"
    file_size: "Smaller"
    
  heavy_compression:
    quality: [60, 69]
    use_case: "Extreme size limits"
    file_size: "Small"
```

### Format-Specific Quality

```yaml
format_recommendations:
  photos:
    jpeg: [80, 85]
    webp: 85
    avif: [75, 80]
    
  graphics:
    png: 100
    webp: [90, 95]
    
  web_optimized:
    primary: "WebP at 85%"
    fallback: "JPEG at 80%"
    modern: "AVIF at 75%"
```

---

<a id="6-resize--crop"></a>

## 6. 📐 RESIZE & CROP

### Resize Strategies

```yaml
resize_strategies:
  proportional:
    description: "Maintain aspect ratio"
    use: "Most cases"
    aspect_ratio: "preserved"
    
  fixed_width:
    description: "Set width, auto height"
    use: "Responsive design"
    aspect_ratio: "preserved"
    
  fixed_height:
    description: "Set height, auto width"
    use: "Gallery rows"
    aspect_ratio: "preserved"
    
  exact_dimensions:
    description: "Force specific size"
    use: "Thumbnails"
    aspect_ratio: "may_distort"
    
  max_dimensions:
    description: "Fit within bounds"
    use: "Container limits"
    aspect_ratio: "preserved"
```

### Common Resize Scenarios

```yaml
thumbnail:
  width: 150
  height: 150
  fit: "cover"
  
web_optimization:
  width: 1920
  fit: "inside"
  preserveAspectRatio: true
  
mobile_optimization:
  width: 640
  fit: "inside"
  
social_media:
  instagram_feed: {width: 1080, height: 1080, fit: "cover"}
  instagram_story: {width: 1080, height: 1920, fit: "cover"}
  twitter_card: {width: 1200, height: 628, fit: "cover"}
```

---

<a id="7-transforms"></a>

## 7. 🔄 TRANSFORMS

### Rotation Operation

```yaml
rotate:
  parameters:
    inputPath:
      type: string
      required: true
      
    outputPath:
      type: string
      required: true
      
    angle:
      type: number
      required: true
      common_values: [90, 180, 270, -90, -180, -270]
      
    background:
      type: string
      optional: true
      description: "Background color for exposed areas"
```

### Flip Operation

```yaml
flip:
  parameters:
    inputPath:
      type: string
      required: true
      
    outputPath:
      type: string
      required: true
      
    direction:
      type: string
      required: true
      options: [horizontal, vertical]
```

### Orientation Auto-Correction

```yaml
auto_orientation:
  feature: "Automatic EXIF orientation correction"
  actions:
    - "Read EXIF orientation flag"
    - "Apply necessary rotation"
    - "Update or remove EXIF data"
```

---

<a id="8-quick-reference"></a>

## 8. 🏎️ QUICK REFERENCE

### MCP Tools Summary

```yaml
tools:
  list_images:
    purpose: "Connection check, list files"
    parameters: [folder]
    
  resize:
    purpose: "Change dimensions"
    key_params: [width, height, fit]
    
  convert:
    purpose: "Change format"
    key_params: [format, quality]
    
  crop:
    purpose: "Extract region"
    key_params: [x, y, width, height]
    
  compress:
    purpose: "Reduce file size"
    key_params: [quality, strip, optimize]
    
  rotate:
    purpose: "Rotate image"
    key_params: [angle, background]
    
  flip:
    purpose: "Mirror image"
    key_params: [direction]
    
  getMetadata:
    purpose: "Get image info"
    parameters: []
    
  batch:
    purpose: "Process multiple"
    parameters: [operations_array]
```

### Integration References

```yaml
related_documents:
  thinking_methodology:
    file: "Media Editor - MEDIA Thinking Framework - v0.110.md"
    sections:
      - "Section 2: MEDIA Principles (quality vs size)"
      - "Section 3: Cognitive Rigor (format selection)"
      - "Section 9: MCP Troubleshooting"
    
  conversation_flow:
    file: "Media Editor - Interactive Intelligence - v0.110.md"
    sections:
      - "Section 1: Conversation Architecture"
      - "Section 2: Response Templates"
      - "Section 5: Error Recovery"
    
  error_handling:
    file: "Media Editor - MEDIA Thinking Framework - v0.110.md"
    section: "Section 9: MCP Troubleshooting"
    includes:
      - "Docker volume configuration"
      - "Path translation"
      - "Permission diagnostics"
```

### Performance Characteristics

```yaml
performance:
  engine: "Sharp (libvips)"
  characteristics:
    - "Multi-threaded operations"
    - "Memory-efficient streaming"
    - "Hardware acceleration when available"
    
  benchmarks:
    small_files:
      size: "< 1MB"
      resize: "< 100ms"
      convert: "< 150ms"
      compress: "< 200ms"
      crop: "< 50ms"
      
    medium_files:
      size: "1-5MB"
      resize: "100-300ms"
      convert: "150-400ms"
      compress: "200-500ms"
      crop: "50-150ms"
      
    large_files:
      size: "> 5MB"
      resize: "300-1000ms"
      convert: "400-1500ms"
      compress: "500-2000ms"
      crop: "150-500ms"
```

### Limitations

```yaml
limitations:
  formats:
    supported: [JPEG, PNG, WebP, AVIF]
    not_supported: [GIF, TIFF, BMP, SVG]
    
  operations:
    can_do:
      - "Resize, convert, crop, compress"
      - "Rotate, flip, metadata"
      - "Batch processing"
    cannot_do:
      - "AI generation"
      - "Complex filters"
      - "Image composition"
      - "Text rendering"
      
  size_constraints:
    recommended_max: "50MB per image"
    memory_dependent: true
    batch_processing: "Preferred for large sets"
```

---

*This document focuses exclusively on Imagician MCP server capabilities and technical specifications. For thinking methodology, see MEDIA Framework. For conversation flows and error handling, see Interactive Intelligence.*