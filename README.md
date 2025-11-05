# AI Magic ✨

> - 99.999% of people won't try these systems. Beat the odds?
> - Don't reward me with unwanted coffee: https://buymeacoffee.com/michelkerkmeester

## 📋 Table of Contents

#### ✏️ Writer Systems
1. [Product Owner](#1-product-owner)
2. [Prompt Engineering Assistant](#2-prompt-engineering-assistant)

#### 💬 MCP Systems
3. [Media Editor Agent](#3-media-editor-agent)
4. [Webflow Agent](#4-webflow-agent)
5. [Notion Agent](#5-notion-agent)
6. [ClickUp Agent](#6-clickup-agent)

#### 🤖 Development
7. [DEV: Context, Prompts & Workflows](#8-dev-context-prompts-workflows)

#### 📚 Resources
- [Claude Desktop](https://claude.ai/desktop)
- [Claude Skills](https://www.anthropic.com/news/skills)
- [Claude Subagents](https://docs.claude.com/en/docs/claude-code/sub-agents)
- [AGENTS.md](https://github.com/openai/agents.md)
- [MCP Protocol Documentation](https://modelcontextprotocol.io)
- [Docker Desktop](https://docker.com/products/docker-desktop)

---

### ✏️ Writer Systems

<a id="1-product-owner-writer"></a>
#### 1. Product Owner Writer

Create professional tickets, stories, epics, and documentation with automatic complexity scaling and concise transparent DEPTH processing.

**Intelligent Modes & Commands**:
  - Modes: $ticket, $story, $epic, $doc, $interactive (default), $quick (instant)
  - Auto-complexity: Simple (2-3), Standard (4-5), Complex (6-8 sections)
  - Smart routing: Single comprehensive question, then intelligent template selection

**DEPTH + RICCE Framework**:
  - **DEPTH Methodology**: 10-round thinking (Discover → Engineer → Prototype → Test → Harmonize)
  - **Two-Layer Transparency**: Full rigor internally, concise meaningful updates externally
  - **RICCE Structure**: Role, Instructions, Context, Constraints, Examples
  - **$quick mode**: Auto-scaled 1-5 rounds based on complexity
  
**Cognitive Rigor (Mandatory)**:
  - Multi-perspective analysis: Minimum 3 perspectives (target 5) - blocking requirement
  - Assumption audit: Surface, classify, challenge, flag critical dependencies
  - Perspective inversion: Analyze opposition, strengthen solution
  - Constraint reversal: Non-obvious insights through backward logic
  - Mechanism-first: WHY before WHAT validation in all solutions
---

<a id="2-prompt-engineering-assistant"></a>
#### 2. Prompt Engineering Assistant

Create effective AI prompts using 7 specialized frameworks, systematic evaluation, and transparent DEPTH processing.

**Modes & Output Formats**:
  - **Core Modes**: $interactive (DEFAULT), $improve, $refine, $quick, $short
  - **Format Options**: Standard/Markdown (baseline), JSON (+5-10% tokens), YAML (+3-7% tokens)
  - **Complexity Management**: Auto framework selection (1-4 RCAF), choice offered (5-6), simplification challenge (7+)
  - **Pattern Library**: 20+ enhancement patterns (vague→specific, assumption elimination, etc.)  

**DEPTH Thinking & Prompt frameworks**:
  - **DEPTH Framework**: Discover → Engineer → Prototype → Test → Harmonize
  - **Transparent Reporting**: Shows improvements, CLEAR before/after, framework reasoning
  - **RCAF** (92% success): Default for 80% of prompts - Role, Context, Action, Format
  - **COSTAR** (94%): Content creation - Context, Objective, Style, Tone, Audience, Response
  - **RACE** (88%): Urgent tasks - Role, Action, Context, Execute
  - **CRAFT** (91%): Complex projects - Context, Role, Action, Format, Target
  - **TIDD-EC** (93%): Precision-critical - Task, Instructions, Do's, Don'ts, Examples, Context
  - **CIDI** (90%): Process documentation - Context, Instructions, Details, Input
  - **CRISPE** (87%): Strategy/exploration - Capacity, Insight, Statement, Personality, Experiment
  - **CLEAR Evaluation**: 5 dimensions (Correctness, Logic, Expression, Arrangement, Reuse)
  - Target scores: 40+/50 standard, 45+/50 excellence

---

### 💬 MCP Systems

<a id="3-media-editor-agent"></a>
#### 3. Media Editor Agent

Edit image, video, and audio files through natural language with MCP tools and terminal command execution.

**Smart MCP agent focused on media editing**:
  - Up to date with all current MCP and FFmpeg capabilities
  - Interactive mode helps you optimize media files
  - MEDIA Thinking Framework (Measure → Evaluate → Decide → Implement → Analyze)

**Capabilities**:
  - **Image Operations**: Resize, convert, compress, crop, batch processing
  - **Audio Operations**: Extract, convert, normalize, quality optimization
  - **Video Operations**: Transcode, trim, overlay, subtitles, format conversion
  - **HLS Video Conversion**: FFmpeg-powered terminal commands to convert videos to HLS playslists

---

<a id="4-webflow-agent"></a>
#### 4. Webflow Agent

Webflow development and CMS management through natural language.

**Smart MCP agent focused on Webflow**:
  - Up to date with all current MCP capabilities
  - Interactive mode helps you build optimal structures
  - SYNC Thinking Framework (Survey → Yield → Navigate → Create)

**Capabilities**:
  - **CMS Operations**: Create collections, fields, and relationships
  - **Designer Integration**: Build components and layouts with Designer API
  - **Content Management**: SEO optimization, content publishing, site analysis

---

<a id="5-notion-agent"></a>
#### 5. Notion Agent

Automate Notion workspace operations through natural language.

**Smart MCP agent focused on Notion**:
  - Up to date with all current MCP capabilities
  - Interactive mode helps you build optimal structures
  - SYNC Thinking Framework (Survey → Yield → Navigate → Create)

**Capabilities**:
  - **Database Operations**: Create databases with flexible properties, relations, rollups, formulas
  - **Page Management**: Build hierarchical pages, nested structures, rich content blocks
  - **Search & Collaboration**: Workspace search, comments, page sharing
  - **Smart Structure Selection**: Auto-balance database vs page hierarchies based on use case

---

<a id="6-clickup-agent"></a>
#### 6. ClickUp Agent

Automate ClickUp task management and agile workflows through natural language.

**Smart MCP agent focused on ClickUp**:
  - Up to date with all current MCP capabilities
  - Interactive mode helps you organize projects efficiently
  - SYNC Thinking Framework (Survey → Yield → Navigate → Create)

**Capabilities**:
  - **Hierarchy Operations**: Create spaces, folders, lists with organizational structure
  - **Task Management**: Single/bulk task creation, updates, assignments, priorities, custom fields
  - **Time Tracking**: Start/stop timers, manage time entries, generate reports
  - **Collaboration**: Comments, tags, file attachments, team assignments

---

### 🤖 Development

<a id="7-dev-context-prompts-workflows"></a>
#### 7. Development: Context, Prompts & Workflows

Professional development system with AI guardrails, automated quality validation, and comprehensive workflow tooling for GitHub SpecKit integration, browser automation, and code quality enforcement.

---

🤖 **AGENTS.md** — AI Behavior Guardrails

Comprehensive quality framework preventing common AI failures and enforcing rigorous development standards.

**Key Features**:
  - **Collaboration First**: No implementation without explicit approval; analysis-only mode by default
  - **Confidence Gates**: <80% → clarify | 40-79% → proceed with caution | 80-100% → proceed
  - **Anti-Pattern Prevention**: Rush to code, assumption-based changes, task misinterpretation, cascading breaks, over-engineering, clever over clear
  - **Explicit Uncertainty**: Mandatory "I'M UNCERTAIN ABOUT THIS:" prefix when confidence <100%
  - **Request Analysis Framework**: Classification → Scope → Context → Solution → Validation → Review
  - **Hook-Based Validation**: PreToolUse, PostToolUse, UserPromptSubmit hooks with skill-rules.json integration

---

📝 **Prompts** — Workflow Automation

Structured prompts for code workflows and GitHub SpecKit integration.

**Code Workflows** (`prompts/code/`):
  - `code_debugger.yaml` — Systematic debug workflow with evidence-based troubleshooting
  - `code_implementer.yaml` — Implementation workflow with quality checks
  - `code_performance_improvement.yaml` — Performance optimization strategies
  - `code_plan.yaml` — Planning and architecture workflows

**GitHub SpecKit** (`prompts/github_spec_kit/`):
  - `sk__complete.yaml` — Full spec-driven development with manual approval gates
  - `sk__spec_plan.yaml` — Specification and planning phase
  - `sk__implementation.yaml` — Implementation-only mode
  - `sk__feature_research.yaml` — Feature research and analysis
  - `parallel_agents/` — Multi-agent parallel execution for complex features

---

⚡ **Skills** — Executable Workflows

Claude Skills for browser automation, Git workflows, and visual documentation.

**Available Skills**:
  - **`chrome-devtools/`** — Browser automation, debugging, performance analysis with Puppeteer
  - **`git-commit/`** — Automated Git commit workflows with conventional commits
  - **`git-worktrees/`** — Git worktree management for parallel development
  - **`markdown-flowchart/`** — Generate Mermaid flowcharts from descriptions
  - **`workflow-spec-kit/`** — GitHub SpecKit automation and integration

---

🛠️ **Hooks** — Automated Validation

Hook-based validation scripts that run automatically during development.

**Validation Hooks**:
  - **`validate-bash.sh`** — PreToolUse hook: Validates bash commands before execution
  - **`validate-post-response.sh`** — PostToolUse hook: Checks file edits against risk patterns
  - **`validate-skill-activation.sh`** — UserPromptSubmit hook: Suggests relevant skills based on context
  - **`skill-rules.json`** (409 lines) — Risk patterns, prompt triggers, file triggers, enforcement rules

---

📚 **Knowledge Base** — Reference Guides

Development standards, platform constraints, and best practices documentation.

**Available Guides**:
  - **`code_standards.md`** — JS/CSS naming conventions, file headers, comment standards, BEM methodology
  - **`animation_strategy.md`** — Motion.dev integration, performance patterns, sequence orchestration
  - **`debugging.md`** — Systematic debug workflow, evidence-based troubleshooting methodology
  - **`webflow_platform_constraints.md`** — Webflow-specific limitations, workarounds, and best practices
  - **`initialization_pattern.md`** — Component lifecycle, setup patterns, and initialization strategies
  - **`document_style_guide.md`** — Documentation formatting standards and writing guidelines
  - **`serena_mcp.md`** — Serena MCP server integration guide and usage patterns