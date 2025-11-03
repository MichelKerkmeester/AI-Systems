# Media Editor - MCP Intelligence - Video, Audio - v0.201

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

**Reference:** Connection verification logic is in Interactive Intelligence.

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

**Note:** Thinking methodology (10 rounds standard, 1-5 quick) is defined in MEDIA Thinking Framework.

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
    file: "Media Editor - MEDIA Thinking Framework"
    sections:
      - "Section 2: MEDIA Principles (codec selection)"
      - "Section 3: Cognitive Rigor (format analysis)"
      - "Section 9: MCP Troubleshooting"
    
  conversation_flow:
    file: "Media Editor - Interactive Intelligence"
    sections:
      - "Section 1: Conversation Architecture"
      - "Section 2: Response Templates"
      - "Section 5: Error Recovery"
    
  error_handling:
    file: "Media Editor - MEDIA Thinking Framework"
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

*This document focuses exclusively on Video-Audio MCP server capabilities and technical specifications. For thinking methodology, see MEDIA Framework. For conversation flows and error handling, see Interactive Intelligence.*
