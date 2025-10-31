# Media Editor - MCP Intelligence - Video, Audio - v0.200

Technical reference for Video-Audio MCP server capabilities and integration for video and audio processing operations.

**Purpose:** Document Video-Audio MCP specific features, supported operations, and technical specifications. Conversation flows and thinking methodology are in Interactive Intelligence and MEDIA Framework respectively.

---

## 📋 TABLE OF CONTENTS

1. [🔌 SERVER OVERVIEW](#1-server-overview)
2. [🛠️ CORE CAPABILITIES](#2-core-capabilities)
3. [🎬 VIDEO OPERATIONS](#3-video-operations)
4. [🎵 AUDIO OPERATIONS](#4-audio-operations)
5. [🎨 ADVANCED FEATURES](#5-advanced-features)
6. [📊 FORMAT SUPPORT](#6-format-support)
7. [⚙️ CODEC SPECIFICATIONS](#7-codec-specifications)
8. [🏎️ QUICK REFERENCE](#8-quick-reference)

---

<a id="1-server-overview"></a>

## 1. 🔌 SERVER OVERVIEW

### MCP Server Details

```yaml
server:
  name: "Video-Audio MCP Server"
  package: "@misbahsy/video-audio-mcp"
  repository: "https://github.com/misbahsy/video-audio-mcp"
  engine: "FFmpeg (comprehensive media framework)"
  protocol: "Model Context Protocol (MCP)"
  language: "Python"
  installation:
    recommended: "UV (uv sync)"
    alternative: "Python pip"
```

### Connection Verification

**Reference:** Connection verification logic is in Interactive Intelligence v0.110.

```yaml
verification:
  priority: "first_action_before_all_operations"
  tool: "health_check"
  displays:
    connected: "✅ Video-Audio MCP Connected - Media processing available"
    disconnected: "❌ Video-Audio MCP Not Connected - Setup required"
  
dependencies:
  required:
    - "FFmpeg installed on system"
    - "Python environment configured"
    - "MCP server running"
```

---

<a id="2-core-capabilities"></a>

## 2. 🛠️ CORE CAPABILITIES

### Available Operations

**Note:** Thinking methodology (10 rounds standard, 1-5 quick) is defined in MEDIA Framework v0.110.

```yaml
video_operations:
  format_conversion:
    tools: [convert_video_format, convert_video_properties]
    
  editing:
    tools: [trim_video, concatenate_videos, adjust_video_speed]
    
  properties:
    tools: [set_video_resolution, change_aspect_ratio, set_video_codec]
    
  optimization:
    tools: [set_video_bitrate, set_video_frame_rate]
    
  effects:
    tools: [fade_in_out, add_transition_effect]

audio_operations:
  extraction:
    tools: [extract_audio_from_video]
    
  conversion:
    tools: [convert_audio_format, convert_audio_properties]
    
  processing:
    tools: [remove_silence]

advanced_features:
  overlays:
    tools: [add_text_overlay, add_image_overlay]
    
  subtitles:
    tools: [add_subtitle]
    
  composition:
    tools: [insert_broll, concatenate_videos]
    
system_tools:
  health_check:
    description: "Server status verification"
    returns: [status, ffmpeg_version]
```

---

<a id="3-video-operations"></a>

## 3. 🎬 VIDEO OPERATIONS

### Format Conversion

```yaml
convert_video_format:
  parameters:
    video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    target_format:
      type: string
      required: true
      options: [mp4, mov, avi, webm, mkv]
      
convert_video_properties:
  parameters:
    input_video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    target_format:
      type: string
      optional: true
      
    resolution:
      type: string
      format: "WIDTHxHEIGHT"
      example: "1920x1080"
      
    video_codec:
      type: string
      examples: [libx264, libx265, vp9]
      
    audio_codec:
      type: string
      examples: [aac, mp3, opus]
      
    video_bitrate:
      type: string
      format: "NUMBER[K|M]"
      example: "5M"
      
    audio_bitrate:
      type: string
      format: "NUMBER[K]"
      example: "192k"
      
    frame_rate:
      type: integer
      common: [24, 30, 60]
```

### Video Editing

```yaml
trim_video:
  parameters:
    video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    start_time:
      type: string
      formats: ["HH:MM:SS", "seconds"]
      examples: ["00:01:30", "90"]
      
    end_time:
      type: string
      formats: ["HH:MM:SS", "seconds"]
      
concatenate_videos:
  parameters:
    video_paths:
      type: array
      items: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    transition:
      type: string
      options: [fade, dissolve, wipe, none]
      
adjust_video_speed:
  parameters:
    video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    speed_factor:
      type: float
      range: [0.25, 4.0]
      examples:
        slow_motion: [0.25, 0.5]
        normal: 1.0
        timelapse: [2.0, 4.0]
```

### Resolution and Aspect Ratio

```yaml
set_video_resolution:
  parameters:
    video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    width:
      type: integer
      required: true
      
    height:
      type: integer
      required: true
      
change_aspect_ratio:
  parameters:
    video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    aspect_ratio:
      type: string
      required: true
      options: ["16:9", "4:3", "1:1", "9:16", "21:9"]
      
common_aspect_ratios:
  "16:9":
    use: "Standard video"
    resolutions: ["1920x1080", "1280x720"]
    
  "4:3":
    use: "Legacy content"
    resolutions: ["640x480", "800x600"]
    
  "1:1":
    use: "Social media square"
    resolutions: ["1080x1080", "720x720"]
    
  "9:16":
    use: "Vertical video"
    resolutions: ["1080x1920", "720x1280"]
    
  "21:9":
    use: "Cinematic"
    resolutions: ["2560x1080", "3440x1440"]
```

---

<a id="4-audio-operations"></a>

## 4. 🎵 AUDIO OPERATIONS

### Audio Extraction and Conversion

```yaml
extract_audio_from_video:
  parameters:
    video_path:
      type: string
      required: true
      
    output_audio_path:
      type: string
      required: true
      
    audio_codec:
      type: string
      optional: true
      common: [aac, mp3, flac]
      
convert_audio_format:
  parameters:
    input_audio_path:
      type: string
      required: true
      
    output_audio_path:
      type: string
      required: true
      
    target_format:
      type: string
      required: true
      
    bitrate:
      type: string
      optional: true
      
    sample_rate:
      type: integer
      optional: true
      
    channels:
      type: integer
      optional: true
      options: [1, 2]
      
convert_audio_properties:
  parameters:
    input_audio_path:
      type: string
      required: true
      
    output_audio_path:
      type: string
      required: true
      
    target_format:
      type: string
      optional: true
      
    bitrate:
      type: string
      optional: true
      
    sample_rate:
      type: integer
      optional: true
      
    channels:
      type: integer
      optional: true
```

### Audio Quality Guidelines

**Note:** Quality vs size optimization logic is in MEDIA Framework Section 2 (Evaluate).

```yaml
bitrate_presets:
  voice_only:
    bitrate: "96k"
    use: "Speech, podcasts"
    file_size: "smallest"
    
  standard:
    bitrate: "128k"
    use: "General audio"
    file_size: "small"
    
  music_streaming:
    bitrate: "192k"
    use: "Music, good quality"
    file_size: "moderate"
    
  high_quality:
    bitrate: "256k"
    use: "High quality music"
    file_size: "large"
    
  maximum:
    bitrate: "320k"
    use: "Archival, production"
    file_size: "largest"

sample_rate_presets:
  voice:
    rate: 22050
    use: "Voice/speech minimal"
    
  cd_quality:
    rate: 44100
    use: "Standard music"
    
  professional:
    rate: 48000
    use: "Video production"
    
  high_res:
    rate: 96000
    use: "Specialized audio"
```

### Audio Processing

```yaml
remove_silence:
  parameters:
    video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    silence_threshold:
      type: float
      description: "Auto-calculated via analysis"
      
    minimum_silence_duration:
      type: float
      description: "Auto-determined"
```

---

<a id="5-advanced-features"></a>

## 5. 🎨 ADVANCED FEATURES

### Overlays

```yaml
add_text_overlay:
  parameters:
    video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    text:
      type: string
      required: true
      
    position:
      type: string
      options: [top-left, top-center, top-right, center-left, center, center-right, bottom-left, bottom-center, bottom-right]
      
    font_size:
      type: integer
      optional: true
      
    font_color:
      type: string
      optional: true
      
    start_time:
      type: string
      optional: true
      
    duration:
      type: string
      optional: true
      
add_image_overlay:
  parameters:
    video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    image_path:
      type: string
      required: true
      description: "Watermark or logo"
      
    position:
      type: string
      options: [top-left, top-center, top-right, center-left, center, center-right, bottom-left, bottom-center, bottom-right]
      
    scale:
      type: float
      optional: true
      
    start_time:
      type: string
      optional: true
      
    duration:
      type: string
      optional: true
```

### Transitions and Effects

```yaml
add_transition_effect:
  parameters:
    video1_path:
      type: string
      required: true
      
    video2_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    transition_type:
      type: string
      options: [fade, dissolve, wipe]
      
    transition_duration:
      type: float
      optional: true
      
fade_in_out:
  parameters:
    video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
```

### Subtitles

```yaml
add_subtitle:
  parameters:
    video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    subtitle_path:
      type: string
      required: true
      description: "SRT or ASS format"
      
    style:
      type: object
      optional: true
      properties:
        Fontsize: integer
        PrimaryColour: string
        OutlineColour: string
        BorderStyle: integer
        Outline: integer
        Shadow: integer
```

### B-Roll and Composition

```yaml
insert_broll:
  parameters:
    main_video_path:
      type: string
      required: true
      
    broll_video_path:
      type: string
      required: true
      
    output_video_path:
      type: string
      required: true
      
    insert_points:
      type: array
      items: string
      description: "Timestamps for insertion"
      
    broll_duration:
      type: float
      optional: true
```

---

<a id="6-format-support"></a>

## 6. � FORMAT SUPPORT

### Video Formats

```yaml
formats:
  mp4:
    extensions: [".mp4", ".m4v"]
    video_codecs: [H.264, H.265]
    audio_codecs: [AAC, MP3]
    best_for: "Universal compatibility"
    
  mov:
    extensions: [".mov", ".qt"]
    video_codecs: [H.264, ProRes]
    audio_codecs: [AAC, PCM]
    best_for: "Apple ecosystem"
    
  avi:
    extensions: [".avi"]
    video_codecs: ["Various"]
    audio_codecs: ["Various"]
    best_for: "Legacy systems"
    
  mkv:
    extensions: [".mkv"]
    video_codecs: ["Any"]
    audio_codecs: ["Any"]
    best_for: "Maximum flexibility"
    
  webm:
    extensions: [".webm"]
    video_codecs: [VP8, VP9]
    audio_codecs: [Opus, Vorbis]
    best_for: "Web streaming"
```

### Audio Formats

```yaml
formats:
  mp3:
    extension: ".mp3"
    codec: "MPEG-1 Layer 3"
    type: "Lossy"
    use: "Universal playback"
    
  wav:
    extension: ".wav"
    codec: "PCM"
    type: "Lossless"
    use: "Editing/Production"
    
  aac:
    extensions: [".aac", ".m4a"]
    codec: "Advanced Audio Coding"
    type: "Lossy"
    use: "Modern devices"
    
  flac:
    extension: ".flac"
    codec: "Free Lossless Audio Codec"
    type: "Lossless"
    use: "Archival quality"
    
  ogg:
    extension: ".ogg"
    codec: "Vorbis"
    type: "Lossy"
    use: "Open source"
```

---

<a id="7-codec-specifications"></a>

## 7. ⚙️ CODEC SPECIFICATIONS

### Video Codecs

**Note:** Codec selection logic is in MEDIA Framework Section 3 (Decide).

```yaml
video_codecs:
  h264_libx264:
    name: "H.264 (libx264)"
    compatibility: "Universal (best)"
    compression: "Good"
    speed: "Fast"
    use: "Default choice"
    
  h265_libx265:
    name: "H.265 (libx265)"
    compatibility: "Modern devices"
    compression: "Excellent (50% smaller)"
    speed: "Slower"
    use: "Size optimization"
    
  vp9:
    name: "VP9"
    compatibility: "Web browsers"
    compression: "Excellent"
    speed: "Slow"
    use: "Web streaming"
    
  prores:
    name: "ProRes"
    compatibility: "Professional editing"
    compression: "Minimal (high quality)"
    speed: "Very fast"
    use: "Production workflow"
    
  dnxhd:
    name: "DNxHD"
    compatibility: "Broadcast"
    compression: "Minimal"
    speed: "Fast"
    use: "Broadcast quality"
```

### Audio Codecs

```yaml
audio_codecs:
  aac:
    name: "AAC"
    compatibility: "Modern standard"
    quality: "Excellent"
    use: "Default choice"
    
  mp3:
    name: "MP3"
    compatibility: "Universal"
    quality: "Good"
    use: "Maximum compatibility"
    
  pcm:
    name: "PCM"
    compatibility: "Universal"
    quality: "Perfect (uncompressed)"
    use: "Editing/Production"
    
  flac:
    name: "FLAC"
    compatibility: "Good"
    quality: "Perfect (lossless)"
    use: "Archival"
    
  opus:
    name: "Opus"
    compatibility: "Modern"
    quality: "Excellent"
    use: "Streaming efficiency"
```

---

<a id="8-quick-reference"></a>

## 8. 🏎️ QUICK REFERENCE

### MCP Tools Summary

```yaml
tools:
  system:
    health_check: "Server status verification"
    
  video_conversion:
    convert_video_format: "Change container format"
    convert_video_properties: "Full transcode with settings"
    
  video_editing:
    trim_video: "Cut segments"
    concatenate_videos: "Join multiple videos"
    adjust_video_speed: "Speed up/slow down"
    
  video_properties:
    set_video_resolution: "Change dimensions"
    change_aspect_ratio: "Adjust aspect ratio"
    set_video_codec: "Change video codec"
    set_video_bitrate: "Adjust quality/size"
    set_video_frame_rate: "Change FPS"
    
  audio_operations:
    extract_audio_from_video: "Extract audio track"
    convert_audio_format: "Change audio format"
    convert_audio_properties: "Full audio transcode"
    remove_silence: "Auto-remove silent portions"
    
  overlays:
    add_text_overlay: "Add text to video"
    add_image_overlay: "Add watermark/logo"
    
  effects:
    add_transition_effect: "Add transitions between clips"
    fade_in_out: "Add fade effects"
    
  subtitles:
    add_subtitle: "Burn subtitles"
    
  composition:
    insert_broll: "Insert B-roll footage"
```

### Integration References

```yaml
related_documents:
  thinking_methodology:
    file: "Media Editor - MEDIA Thinking Framework - v0.110.md"
    sections:
      - "Section 2: MEDIA Principles (codec selection)"
      - "Section 3: Cognitive Rigor (format analysis)"
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
      - "FFmpeg installation verification"
      - "Codec availability checks"
      - "Performance optimization"
```

### Performance Characteristics

```yaml
performance:
  engine: "FFmpeg"
  characteristics:
    - "Hardware acceleration support"
    - "Streaming for large files"
    - "Multi-threaded processing"
    - "Cross-platform compatibility"
    
  benchmarks:
    small_files:
      size: "< 100MB"
      trim: "1-5s"
      convert: "5-15s"
      compress: "10-30s"
      overlay: "5-20s"
      
    medium_files:
      size: "100MB-1GB"
      trim: "5-20s"
      convert: "30-120s"
      compress: "60-300s"
      overlay: "20-60s"
      
    large_files:
      size: "> 1GB"
      trim: "20-60s"
      convert: "2-10min"
      compress: "5-20min"
      overlay: "1-5min"
```

### Limitations

```yaml
limitations:
  dependencies:
    required:
      - "FFmpeg installed"
      - "Python environment"
      - "Sufficient disk space"
    
  file_size:
    recommended_max: "2GB per operation"
    workaround: "Split large files"
    
  operations:
    can_do:
      - "Format conversion, transcoding"
      - "Trimming, concatenation"
      - "Overlays, subtitles, effects"
      - "Audio extraction and processing"
    
    cannot_do:
      - "AI content generation"
      - "Complex video editing (NLE features)"
      - "Real-time processing"
      - "Direct upload to platforms"
      
  ffmpeg_dependent:
    note: "All capabilities depend on FFmpeg installation"
    check: "Run 'ffmpeg -version' to verify"
```

---

*This document focuses exclusively on Video-Audio MCP server capabilities and technical specifications. For thinking methodology, see MEDIA Framework v0.110. For conversation flows and error handling, see Interactive Intelligence v0.110.*

---

<a id="1-📋-overview"></a>

## 1. 📋 OVERVIEW

### MCP Server Details
- **Name**: Video-Audio MCP Server
- **Package**: @misbahsy/video-audio-mcp
- **Repository**: https://github.com/misbahsy/video-audio-mcp
- **Engine**: FFmpeg (comprehensive media framework)
- **Protocol**: Model Context Protocol (MCP)
- **Language**: Python
- **Installation**: UV (recommended) or Python pip
- **Thinking**: Automatic 10-round deep analysis (standard), 1-5 auto-scaled (quick mode)

### Core Capabilities
Based on the actual GitHub documentation:
- Professional video format conversion and codec changes
- Audio extraction and format conversion
- Video trimming with precise timing control
- Text overlays and image watermarks
- Subtitle burning and management
- Video concatenation with transitions
- Speed adjustment and aspect ratio changes
- Silence removal and audio processing
- B-roll insertion capabilities

### Integration with Media Editor
Video-Audio MCP serves as the video and audio processing engine within the Media Editor system, complementing Imagician's image processing capabilities.

**CRITICAL**: Always verify connection before operations.
**AUTOMATIC**: All operations use 10 rounds of deep thinking (no user choice).

---

<a id="2-🔌-connection-verification"></a>

## 2. 🔌 CONNECTION VERIFICATION

### Initial Connection Check

**Required Before Any Operation:**
```python
async def verify_video_audio_connection():
    """Check if Video-Audio MCP server is connected"""
    
    try:
        # Test with health_check tool
        result = await video_audio_mcp.health_check()
        return {
            'connected': True,
            'status': 'ready',
            'message': 'Video-Audio MCP connected and ready',
            'ffmpeg': result.get('ffmpeg_version', 'unknown'),
            'thinking': '10 rounds automatic'
        }
    except Exception as e:
        return {
            'connected': False,
            'status': 'error',
            'message': str(e),
            'action': 'setup_required'
        }
```

### Connection Status Displays

**Connected:**
```markdown
✅ Video-Audio MCP Connected

Media processing available:
• Video conversion and transcoding
• Audio extraction and processing
• Trimming, overlays, subtitles
• FFmpeg version: [version]
• **Deep analysis: 10 rounds automatic**
```

**Not Connected:**
```markdown
❌ Video-Audio MCP Not Connected

Video/audio processing unavailable.

**To enable:**
• Install FFmpeg on your system
• Clone video-audio-mcp repository
• Install with UV: uv sync
• Configure Claude Desktop
• Restart application

Need setup help?
```

### Dependency Check Pattern
```python
def check_dependencies():
    """Verify all dependencies are available"""
    checks = {
        'connection': test_mcp_connection(),
        'ffmpeg': verify_ffmpeg_installed(),
        'python': check_python_version(),
        'permissions': check_file_permissions(),
        'temp_dir': verify_temp_directory(),
        'thinking_mode': 'automatic_10_rounds'
    }
    return all(checks.values())
```

### FFmpeg Verification
```markdown
🔧 FFmpeg Status Check

**FFmpeg:** [Installed/Not Found]
**Version:** [version info]
**Codecs:** [available codecs count]
**Path:** [installation path]
**Optimization:** 10-round automatic

[If not installed: Installation instructions]
```

---

<a id="3-🛠️-core-operations"></a>

## 3. 🛠️ CORE OPERATIONS

### Available MCP Tools with Automatic Thinking

From the GitHub repository documentation:

| Tool Name | Description | Primary Use | Thinking Applied |
|-----------|-------------|-------------|------------------|
| **health_check** | Returns server running status | System verification | 10 rounds auto |
| **extract_audio_from_video** | Extract audio tracks from video files | Audio separation | 10 rounds auto |
| **trim_video** | Cut video segments with precise timing | Clip creation | 10 rounds auto |
| **convert_video_format** | Convert between video formats | Format compatibility | 10 rounds auto |
| **convert_video_properties** | Comprehensive video property conversion | Full transcoding | 10 rounds auto |
| **change_aspect_ratio** | Adjust video aspect ratios | Platform optimization | 10 rounds auto |
| **set_video_resolution** | Change video resolution | Quality adjustment | 10 rounds auto |
| **set_video_codec** | Switch video codecs | Codec optimization | 10 rounds auto |
| **set_video_bitrate** | Adjust video quality and file size | Size optimization | 10 rounds auto |
| **set_video_frame_rate** | Change playback frame rates | FPS adjustment | 10 rounds auto |
| **convert_audio_format** | Convert between audio formats | Audio compatibility | 10 rounds auto |
| **convert_audio_properties** | Comprehensive audio property conversion | Audio optimization | 10 rounds auto |
| **add_text_overlay** | Add text to videos | Titles/captions | 10 rounds auto |
| **add_image_overlay** | Add image watermarks or logos | Branding | 10 rounds auto |
| **concatenate_videos** | Join multiple videos together | Compilation | 10 rounds auto |
| **add_transition_effect** | Add transitions between clips | Smooth editing | 10 rounds auto |
| **add_subtitle** | Burn subtitles into video | Accessibility | 10 rounds auto |
| **adjust_video_speed** | Speed up or slow down playback | Time effects | 10 rounds auto |
| **fade_in_out** | Add fade effects | Professional polish | 10 rounds auto |
| **insert_broll** | Insert B-roll footage | Content enhancement | 10 rounds auto |
| **remove_silence** | Automatically remove silent portions | Audio cleanup | 10 rounds auto |

---

<a id="4-🎬-video-operations"></a>

## 4. 🎬 VIDEO OPERATIONS

### Video Format Conversion with Deep Analysis

```python
convert_video_format:
  video_path: str           # Input video path
  output_video_path: str    # Output path
  target_format: str        # Target format (mp4, mov, avi, webm, etc.)
  thinking_rounds: 10       # Automatic optimization
```

**Supported Formats (Auto-Optimized):**
- **MP4**: Universal compatibility, H.264/H.265 (10 rounds analysis)
- **MOV**: QuickTime, ProRes support (10 rounds analysis)
- **AVI**: Legacy compatibility (10 rounds analysis)
- **WebM**: Web optimization, VP8/VP9 (10 rounds analysis)
- **MKV**: Container flexibility (10 rounds analysis)

### Video Properties Conversion with Automatic Optimization

```python
convert_video_properties:
  input_video_path: str     # Source video
  output_video_path: str    # Output path
  target_format: str        # Optional format change
  resolution: str          # e.g., "1920x1080" (auto-optimized)
  video_codec: str         # e.g., "libx264" (auto-selected)
  audio_codec: str         # e.g., "aac" (auto-selected)
  video_bitrate: str       # e.g., "5M" (auto-calculated)
  audio_bitrate: str       # e.g., "192k" (auto-calculated)
  frame_rate: int          # e.g., 30 (auto-determined)
  thinking_applied: 10     # Automatic deep analysis
```

### Video Trimming with Intelligent Analysis

```python
trim_video:
  video_path: str          # Input video
  output_video_path: str   # Output path
  start_time: str         # Format: "HH:MM:SS" or seconds
  end_time: str           # Format: "HH:MM:SS" or seconds
  auto_optimization: True  # 10 rounds applied
```

**Time Format Examples (Auto-Validated):**
- "00:01:30" - 1 minute 30 seconds
- "90" - 90 seconds
- "01:30:00" - 1 hour 30 minutes

### Resolution and Aspect Ratio with Deep Thinking

```python
set_video_resolution:
  video_path: str
  output_video_path: str
  width: int              # Target width (auto-optimized)
  height: int             # Target height (auto-optimized)
  thinking: 10            # Automatic application

change_aspect_ratio:
  video_path: str
  output_video_path: str
  aspect_ratio: str       # e.g., "16:9", "4:3", "1:1"
  auto_analysis: True     # 10 rounds optimization
```

**Common Aspect Ratios (Auto-Selected):**
| Ratio | Use Case | Resolution Examples | Auto-Optimized |
|-------|----------|-------------------|----------------|
| 16:9 | Standard video | 1920x1080, 1280x720 | 10 rounds |
| 4:3 | Legacy content | 640x480, 800x600 | 10 rounds |
| 1:1 | Social media | 1080x1080, 720x720 | 10 rounds |
| 9:16 | Vertical video | 1080x1920, 720x1280 | 10 rounds |
| 21:9 | Cinematic | 2560x1080, 3440x1440 | 10 rounds |

### Video Speed Adjustment with Automatic Analysis

```python
adjust_video_speed:
  video_path: str
  output_video_path: str
  speed_factor: float     # Auto-determined via deep analysis
  thinking_rounds: 10     # Automatic
```

**Speed Guidelines (Auto-Applied):**
- 0.25x - 0.5x: Slow motion effects (10 rounds analysis)
- 0.75x: Slight slowdown (10 rounds analysis)
- 1.0x: Normal speed (10 rounds analysis)
- 1.25x - 1.5x: Slight speedup (10 rounds analysis)
- 2.0x - 4.0x: Time-lapse effect (10 rounds analysis)

---

<a id="5-🎵-audio-operations"></a>

## 5. 🎵 AUDIO OPERATIONS

### Audio Extraction with Deep Optimization

```python
extract_audio_from_video:
  video_path: str
  output_audio_path: str
  audio_codec: str        # Auto-selected via 10 rounds
  thinking_applied: 10    # Automatic optimization
```

### Audio Format Conversion with Automatic Analysis

```python
convert_audio_format:
  input_audio_path: str
  output_audio_path: str
  target_format: str      # Auto-optimized
  bitrate: str           # Auto-calculated via deep thinking
  sample_rate: int       # Auto-determined
  channels: int          # Auto-selected
  thinking_rounds: 10    # Automatic
```

### Audio Properties Conversion with Deep Thinking

```python
convert_audio_properties:
  input_audio_path: str
  output_audio_path: str
  target_format: str      # Auto-selected
  bitrate: str           # Auto-optimized via 10 rounds
  sample_rate: int       # Auto-determined
  channels: int          # Auto-selected
  auto_analysis: True    # 10 rounds applied
```

### Audio Quality Settings (Auto-Applied)

| Bitrate | Quality | Use Case | File Size | Auto-Selected When |
|---------|---------|----------|-----------|-------------------|
| 96k | Low | Voice only | Smallest | Voice detected |
| 128k | Standard | General audio | Small | Standard use |
| 192k | Good | Music streaming | Moderate | Music detected |
| 256k | High | Quality music | Large | High quality need |
| 320k | Maximum | Archival | Largest | Archive mode |

### Sample Rate Guidelines (Auto-Determined)

| Rate | Use Case | Notes | Thinking Applied |
|------|----------|-------|------------------|
| 22050 Hz | Voice/Speech | Minimal quality | 10 rounds |
| 44100 Hz | CD Quality | Standard for music | 10 rounds |
| 48000 Hz | Professional | Video production | 10 rounds |
| 96000 Hz | High-res audio | Specialized use | 10 rounds |

---

<a id="6-🎨-advanced-features"></a>

## 6. 🎨 ADVANCED FEATURES

### Text Overlay with Intelligent Positioning

```python
add_text_overlay:
  video_path: str
  output_video_path: str
  text: str               # Text to display
  position: str          # Auto-positioned via 10 rounds
  font_size: int         # Auto-sized via deep analysis
  font_color: str        # Auto-selected for visibility
  start_time: str        # When to show text
  duration: str          # How long to display
  thinking_applied: 10   # Automatic optimization
```

**Position Options (Auto-Selected):**
- top-left, top-center, top-right
- center-left, center, center-right
- bottom-left, bottom-center, bottom-right
- All positions optimized via 10-round analysis

### Image Overlay (Watermark) with Auto-Optimization

```python
add_image_overlay:
  video_path: str
  output_video_path: str
  image_path: str        # Watermark/logo path
  position: str          # Auto-positioned for best visibility
  scale: float           # Auto-scaled via 10 rounds
  start_time: str        # When to show
  duration: str          # How long to show
  auto_optimized: True   # 10 rounds applied
```

### Video Concatenation with Automatic Transitions

```python
concatenate_videos:
  video_paths: List[str]  # List of videos to join
  output_video_path: str
  transition: str         # Auto-selected via deep analysis
  thinking_rounds: 10     # Automatic optimization
```

**Transition Types (Auto-Selected):**
- fade - Crossfade between clips (10 rounds optimization)
- dissolve - Dissolve transition (10 rounds optimization)
- wipe - Wipe effect (10 rounds optimization)
- none - Direct cut (when appropriate)

### Transitions with Deep Analysis

```python
add_transition_effect:
  video1_path: str
  video2_path: str
  output_video_path: str
  transition_type: str    # Auto-selected via 10 rounds
  transition_duration: float  # Auto-calculated
  thinking_applied: 10    # Automatic
```

### Subtitle Burning with Intelligent Styling

```python
add_subtitle:
  video_path: str
  output_video_path: str
  subtitle_path: str      # SRT or ASS file
  style: dict            # Auto-styled via 10 rounds
  auto_optimization: True # Deep thinking applied
```

**Subtitle Style Options (Auto-Optimized):**
```python
style = {
  'Fontsize': 24,        # Auto-sized via analysis
  'PrimaryColour': '&H00FFFFFF',  # Auto-selected
  'OutlineColour': '&H00000000',   # Auto-contrasted
  'BorderStyle': 1,      # Auto-determined
  'Outline': 2,          # Auto-calculated
  'Shadow': 0            # Auto-applied
}
```

### B-Roll Insertion with Automatic Timing

```python
insert_broll:
  main_video_path: str
  broll_video_path: str
  output_video_path: str
  insert_points: List[str]  # Auto-calculated via 10 rounds
  broll_duration: float     # Auto-optimized
  thinking_rounds: 10       # Automatic
```

### Silence Removal with Intelligent Detection

```python
remove_silence:
  video_path: str
  output_video_path: str
  silence_threshold: float  # Auto-calculated via deep analysis
  minimum_silence_duration: float  # Auto-determined
  auto_optimized: True     # 10 rounds applied
```

---

<a id="7-📊-supported-formats"></a>

## 7. 📊 SUPPORTED FORMATS

### Video Formats with Automatic Optimization
Based on FFmpeg capabilities:

| Container | Extensions | Video Codecs | Audio Codecs | Best For | Auto-Optimized |
|-----------|-----------|--------------|--------------|----------|----------------|
| **MP4** | .mp4, .m4v | H.264, H.265 | AAC, MP3 | Universal compatibility | 10 rounds |
| **MOV** | .mov, .qt | H.264, ProRes | AAC, PCM | Apple ecosystem | 10 rounds |
| **AVI** | .avi | Various | Various | Legacy systems | 10 rounds |
| **MKV** | .mkv | Any | Any | Flexibility | 10 rounds |
| **WebM** | .webm | VP8, VP9 | Opus, Vorbis | Web streaming | 10 rounds |

### Audio Formats with Deep Analysis

| Format | Extension | Codec | Quality | Use Case | Auto-Selected |
|--------|-----------|-------|---------|----------|---------------|
| **MP3** | .mp3 | MPEG-1 Layer 3 | Lossy | Universal playback | 10 rounds |
| **WAV** | .wav | PCM | Lossless | Editing/Production | 10 rounds |
| **AAC** | .aac, .m4a | Advanced Audio | Lossy | Modern devices | 10 rounds |
| **FLAC** | .flac | Free Lossless | Lossless | Archival | 10 rounds |
| **OGG** | .ogg | Vorbis | Lossy | Open source | 10 rounds |

### Codec Selection Guide (Automatic via Deep Thinking)

**Video Codecs (Auto-Selected):**
- **H.264 (libx264)**: Best compatibility (10 rounds analysis)
- **H.265 (libx265)**: 50% smaller files (10 rounds analysis)
- **VP9**: Web optimization (10 rounds analysis)
- **ProRes**: Professional editing (10 rounds analysis)
- **DNxHD**: Broadcast quality (10 rounds analysis)

**Audio Codecs (Auto-Selected):**
- **AAC**: Modern standard (10 rounds analysis)
- **MP3**: Universal support (10 rounds analysis)
- **PCM**: Uncompressed (10 rounds analysis)
- **FLAC**: Lossless compression (10 rounds analysis)
- **Opus**: Best for streaming (10 rounds analysis)

---

<a id="8-💾-installation--setup"></a>

## 8. 🚨 ERROR HANDLING

### Common Issues with Automatic Recovery

| Issue | Cause | Solution | Fallback | Thinking Applied |
|-------|-------|----------|----------|------------------|
| **Connection lost** | Server crashed | Restart MCP server | Check setup | Auto-retry with 10 rounds |
| **FFmpeg not found** | FFmpeg not installed | Install FFmpeg for platform | Use Docker image | Auto-diagnose |
| **Format not supported** | Invalid codec/format | Check FFmpeg codec support | Convert to standard | Auto-convert via deep analysis |
| **File not found** | Wrong path | Verify file path and permissions | Request correct path | Path analysis via thinking |
| **Memory error** | Large file processing | Process in segments | Reduce quality settings | Auto-segment with optimization |
| **Codec error** | Missing codec | Install full FFmpeg | Use alternative codec | Auto-select alternative |
| **Timeout** | Long processing | Increase timeout | Split into smaller operations | Auto-split via deep analysis |

### Error Recovery Strategies with Deep Thinking

```python
async def process_with_fallback(operation, mode='standard'):
    # Check connection first
    connection = await verify_video_audio_connection()
    if not connection['connected']:
        return {
            'error': 'Video-Audio MCP not connected',
            'action': 'Please setup the MCP server',
            'guide': 'See installation instructions'
        }
    
    # Apply automatic thinking
    thinking_rounds = 10 if mode == 'standard' else auto_scale(1, 5)
    
    try:
        return await video_audio_mcp.process(operation, {'thinking': thinking_rounds})
    except Exception as error:
        # Auto-recovery with deep analysis
        if 'memory' in str(error).lower():
            # Reduce quality for memory issues (10 rounds analysis)
            operation['video_bitrate'] = '2M'
            operation['resolution'] = '1280x720'
            return await video_audio_mcp.process(operation)
        
        if 'codec' in str(error).lower():
            # Fallback to standard codec (10 rounds)
            operation['video_codec'] = 'libx264'
            operation['audio_codec'] = 'aac'
            return await video_audio_mcp.process(operation)
        
        raise error
```

### Error Display Format
```markdown
⚠️ Media Processing Error

**Issue:** [Error description]
**Server:** Video-Audio MCP
**FFmpeg:** [Status]
**Connection:** [Status]
**Auto-recovery:** Applying 10 rounds of analysis...

**Solutions:**
• [Primary solution]
• [Alternative approach]
• [Fallback option]

Attempting automatic resolution...
```

### Debugging

```bash
# Test FFmpeg installation
ffmpeg -version
ffmpeg -codecs
ffmpeg -formats

# Test server directly
python server.py

# Check Python dependencies
pip list | grep mcp
```

---

<a id="9-⚙️-configuration"></a>

## 9. ⚡ USAGE EXAMPLES

### Example Prompts with Automatic Deep Thinking

**Video Processing (10 rounds auto):**
```
"Extract audio from video.mp4 and save as MP3"
→ System applies 10 rounds automatically
→ Optimal codec and bitrate selected
→ No user input needed

"Trim video from 1:30 to 5:45"
→ Deep analysis for lossless trim
→ Smart re-encoding if needed

"Convert movie.avi to MP4 with H.264"
→ 10 rounds determine best settings
→ Automatic quality/size balance
```

**Audio Processing (10 rounds auto):**
```
"Convert podcast.wav to MP3"
→ Bitrate auto-optimized to 192kbps
→ Sample rate intelligently preserved

"Extract audio from presentation.mp4"
→ Format auto-selected based on content
→ Quality maximized automatically
```

**Advanced Operations (10 rounds deep analysis):**
```
"Join intro.mp4, main.mp4, and outro.mp4"
→ Transitions auto-selected
→ Encoding parameters unified
→ Seamless output created

"Add subtitles.srt to video"
→ Style auto-optimized for readability
→ Position and size calculated

"Remove silence from lecture.mp4"
→ Threshold auto-detected
→ Natural pacing preserved
```

### Workflow Example with Automatic Thinking

```python
# Complete video production workflow
async def produce_final_video(raw_footage, mode='standard'):
    # 0. Verify connection
    connection = await verify_video_audio_connection()
    if not connection['connected']:
        raise Exception("Video-Audio MCP not connected. Please setup.")
    
    # Automatic deep thinking applied throughout
    thinking = 10 if mode == 'standard' else auto_scale(1, 5)
    
    # 1. Extract and process audio (10 rounds optimization)
    audio = await extract_audio_from_video(raw_footage)
    audio_cleaned = await remove_silence(audio)  # Threshold auto-calculated
    
    # 2. Trim to desired length (10 rounds for precision)
    trimmed = await trim_video(raw_footage, "00:00:30", "00:05:30")
    
    # 3. Add text overlays (position/size auto-optimized)
    with_title = await add_text_overlay(trimmed, "Product Demo", 
                                       position="auto",  # 10 rounds determine best
                                       duration="5")
    
    # 4. Insert B-roll (timing auto-calculated)
    with_broll = await insert_broll(with_title, broll_path,
                                   insert_points="auto")  # 10 rounds optimize
    
    # 5. Add transitions (type auto-selected)
    final_clips = await add_transitions(clips, transition_type="auto")
    
    # 6. Add watermark (scale/position auto-determined)
    with_watermark = await add_image_overlay(final_clips, logo_path,
                                            position="auto",
                                            scale="auto")
    
    # 7. Burn subtitles (style auto-optimized)
    with_subtitles = await add_subtitle(with_watermark, subtitle_path)
    
    # 8. Export in multiple formats (settings auto-optimized)
    await export_formats(with_subtitles, ['mp4', 'webm'])
```

### Integration with Media Editor

When integrated with the Media Editor system:

- Media Editor verifies Video-Audio MCP connection
- Receives natural language request
- **Applies 10 rounds of thinking automatically**
- Routes to Video-Audio MCP
- Executes operation with FFmpeg
- Returns processed media with metrics

Example conversation:
```
User: "Make this video Instagram-ready"
Media Editor: [Checking Video-Audio MCP connection...]
→ Connection verified ✔
→ FFmpeg available ✔
→ Applying deep optimization (10 rounds)...
→ Video-Audio MCP: Change aspect ratio to 1:1
→ Video-Audio MCP: Trim to 60 seconds max
→ Video-Audio MCP: Add subtitles for silent viewing
→ Result: Instagram-optimized video ready
```

### Quick Mode Examples

```
User: "$quick compress video.mp4"
→ Auto-scaling: Video compression = 3 rounds
→ Fast bitrate reduction applied
→ 60% size reduction in half the time

User: "$quick extract audio from presentation.mp4"
→ Auto-scaling: Simple extraction = 2 rounds
→ Direct stream copy when possible
→ Completed in seconds
```


<a id="10-🚨-error-handling"></a>

## Performance Notes

- Uses FFmpeg for all operations
- Supports hardware acceleration where available
- Handles large files through FFmpeg's streaming
- Python-based server for cross-platform compatibility
- Multi-threaded processing support
- **All operations enhanced by automatic deep thinking**

### Performance Benchmarks with Thinking Applied

| Operation | Small (<100MB) | Medium (100MB-1GB) | Large (>1GB) | Thinking Overhead |
|-----------|---------------|-------------------|--------------|-------------------|
| Trim | 1-5s | 5-20s | 20-60s | +20ms |
| Convert | 5-15s | 30-120s | 2-10min | +25ms |
| Compress | 10-30s | 60-300s | 5-20min | +30ms |
| Add overlay | 5-20s | 20-60s | 1-5min | +20ms |
| Concatenate | 10-30s | 30-90s | 2-10min | +25ms |

### Performance Status Display
```markdown
📊 Video-Audio MCP Performance

**Connection:** Active
**FFmpeg:** Running
**CPU Usage:** 45%
**Memory:** 512MB
**Queue:** 1 operation
**Progress:** 67%
**Thinking mode:** 10 rounds automatic
**Processing:** Optimized with deep analysis

Operating at peak efficiency
```

### Quick Mode Performance
```markdown
⚡ Quick Mode Performance

**Connection:** Active
**FFmpeg:** Running
**Thinking:** 3 rounds (auto-scaled)
**Speed boost:** 40-60% faster
**Quality:** Essential optimization only

Fast processing engaged
```

---

*This document focuses exclusively on Video-Audio MCP server capabilities and technical specifications. For thinking methodology, see MEDIA Framework. For conversation flows and error handling, see Interactive Intelligence.*