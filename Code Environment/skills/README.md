# Claude Skills

Curated collection of specialized skills for Webflow frontend development, Git workflow, documentation, and code quality. Each skill provides systematic approaches, best practices, and real-world patterns.

#### 📋 TABLE OF CONTENTS

1. [📂 SKILLS OVERVIEW](#1--skills-overview)
2. [🔗 SKILL INTEGRATION PATTERNS](#2--skill-integration-patterns)
3. [📊 SKILL CATEGORIES SUMMARY](#3--skill-categories-summary)
4. [🚀 QUICK START](#4--quick-start)
5. [💡 BEST PRACTICES](#5--best-practices)
6. [📚 ADDITIONAL RESOURCES](#6--additional-resources)

---

## 1. 📂 SKILLS OVERVIEW

### Code Quality & Debugging

**[code-systematic-debugging](./code-systematic-debugging/)**
Four-phase debugging framework for browser console errors, CSS layout issues, JavaScript animations, and Webflow-specific bugs. Ensures root cause identification before attempting fixes.

**When to use**: Console errors, layout bugs, animation issues, event handler failures, cross-browser problems, mobile responsive issues

**[code-verification-before-completion](./code-verification-before-completion/)**
Requires browser testing across viewports and animations before claiming work complete. No "works on my machine" claims without evidence.

**When to use**: Before claiming any work is fixed, complete, or passing. Requires testing in Chrome/Firefox/Safari at mobile and desktop viewports.

**[code-root-cause-tracing](./code-root-cause-tracing/)**
Traces bugs backward through call stack and event chain using DevTools to find original trigger. Fix at source, not symptom.

**When to use**: Errors deep in execution, mysterious event handler failures, animation wrong values, video initialization issues, DOM unexpected state

**[code-defense-in-depth](./code-defense-in-depth/)**
Multi-layer validation at every point data passes through (input, processing, output). Makes JavaScript errors structurally impossible.

**When to use**: Form handling, API calls, DOM manipulation, user input, third-party data integration, XSS prevention

**[code-condition-based-waiting](./code-condition-based-waiting/)**
Replaces arbitrary `setTimeout` with condition polling. Wait for actual DOM ready, library loaded, animation complete, or video ready state.

**When to use**: DOM elements not found, timing issues, race conditions, external CDN scripts, animations, fonts, media loading

**[code-cdn-versioning](./code-cdn-versioning/)**
Automates CDN cache-busting by updating version numbers in HTML files after JavaScript modifications. Forces browsers to download fresh versions.

**When to use**: After JavaScript file changes, when users see stale cached code, before deploying updates


### Browser Automation & Testing

**[mcp-chrome-devtools](./mcp-chrome-devtools/)**
Browser automation, debugging, and performance analysis using Puppeteer CLI scripts. Automates browsers, screenshots, performance testing, network monitoring.

**When to use**: Automated testing, screenshot generation, performance analysis, network monitoring, form automation, web scraping


### Git Workflows

**[git-commit](./git-commit/)**
Professional Git commit workflow following Conventional Commits specification. Analyzes changes, determines commit strategy, filters artifacts, writes clear messages.

**When to use**: Before any git commit, when reviewing staged changes, ensuring atomic commits, excluding artifacts

**[git-worktrees](./git-worktrees/)**
Creates isolated workspaces with minimal branching. Short-lived temp branches merge back to main immediately, keeping codebase unified.

**When to use**: Feature work needing isolation, executing implementation plans, parallel development, experimental changes


### Documentation

**[markdown-flowchart](./markdown-flowchart/)**
Creates comprehensive ASCII flowcharts in markdown. Visualizes workflows, user journeys, system architectures, and decision trees with clear visual hierarchy.

**When to use**: Multi-step workflows, user journeys, system architecture, decision trees, parallel execution, approval gates

**[markdown-c7-optimizer](./markdown-c7-optimizer/)**
Complete document quality pipeline with structure enforcement, content optimization (c7score), and style guide compliance. Three-phase system: Enforcement → Optimization → Validation. Automatically fixes safe violations via hooks, blocks critical issues, and optimizes content for AI assistants.

**Pipeline Phases**:
- **Enforcement**: Validates filenames, frontmatter, structure; auto-fixes safe violations
- **Optimization**: Enhances content for AI-friendliness using 16 transformation patterns (c7score 85+ target)
- **Validation**: Scores structure (0-100), c7score (0-100), and style compliance (0-100)

**Hook Integration**:
- `PostToolUse`: Auto-corrects filename violations (non-blocking)
- `UserPromptSubmit`: Blocks critical violations with fix suggestions

**When to use**: Creating or editing markdown files, optimizing documentation for AI assistants, quality validation, generating llms.txt files

**[save-context](./save-context/)**
Saves expanded conversation context from feature implementations and architectural discussions. Preserves dialogue, decisions, flowcharts, and file changes.

**When to use**: Completing significant implementation, wrapping up complex features, documenting architectural decisions, team sharing

**Auto-triggers**: Keywords ("save context") or 200+ messages (75% context used)


### Meta Skills

**[create-skill](./create-skill/)**
Provides guidance for creating effective skills with specialized knowledge, workflows, or tool integrations.

**When to use**: Creating new skills, updating existing skills, extending Claude capabilities

---

## 2. 🔗 SKILL INTEGRATION PATTERNS

### Frontend Development Workflow

```
1. code-systematic-debugging     → Find and understand bugs
2. code-root-cause-tracing       → Trace to original trigger
3. code-defense-in-depth         → Add validation at all layers
4. code-verification-before-completion → Test in browsers
5. git-commit                    → Commit with clear message
```

### Timing & Async Issues

```
1. code-condition-based-waiting  → Replace setTimeout with polling
2. code-verification-before-completion → Test across slow connections
3. code-systematic-debugging     → Verify race conditions eliminated
```

### Quality Assurance

```
1. code-defense-in-depth         → Validate at every layer
2. code-verification-before-completion → Test all scenarios
3. code-cdn-versioning           → Update version numbers
4. git-commit                    → Atomic commits with clear intent
```

### Documentation

```
1. markdown-c7-optimizer         → Enforce structure, optimize content, validate quality
2. markdown-flowchart            → Visualize workflows
3. save-context                  → Preserve decisions
```

---

## 3. 📊 SKILL CATEGORIES SUMMARY

| Category | Skills | Primary Focus |
|----------|--------|---------------|
| **Code Quality** | 6 | Debugging, validation, timing, tracing, verification, cache-busting |
| **Browser Testing** | 1 | Automation, performance, screenshots |
| **Git Workflow** | 2 | Commits, worktrees, branching strategy |
| **Documentation** | 3 | Document quality pipeline (c7-optimizer), flowcharts, context preservation |
| **Meta** | 1 | Skill creation and management |

**Total Active Skills**: 13

---

## 4. 🚀 QUICK START

**For new bugs**:
```
Use code-systematic-debugging for systematic investigation
→ code-root-cause-tracing if error is deep in call stack
→ code-defense-in-depth to prevent recurrence
→ code-verification-before-completion before claiming fixed
```

**For timing issues**:
```
Use code-condition-based-waiting to replace setTimeout
→ code-verification-before-completion with network throttling
→ code-systematic-debugging to verify elimination
```

**For new features**:
```
Use code-defense-in-depth during implementation
→ code-verification-before-completion across viewports
→ code-cdn-versioning after JS changes
→ git-commit with atomic commits
→ save-context to preserve decisions
```

---

## 5. 💡 BEST PRACTICES

### When to Use Multiple Skills

**Complex bugs**: systematic-debugging + root-cause-tracing + defense-in-depth
**Race conditions**: condition-based-waiting + verification-before-completion
**New features**: defense-in-depth + verification-before-completion + git-commit
**Documentation**: markdown-c7-optimizer + markdown-flowchart + save-context + git-commit

### Naming Convention

All skills use lowercase with hyphens. Code-focused skills use `code-` prefix for easy categorization and filtering.

### Skill Structure

Each skill provides:
- **When to Use** - Specific triggering conditions and symptoms
- **How It Works** - Process overview and core principles
- **Implementation** - Step-by-step workflows with examples
- **Rules** - ALWAYS/NEVER/ESCALATE IF guidelines
- **Examples** - Real-world usage patterns
- **Integration Points** - How skills work together

---

## 6. 📚 ADDITIONAL RESOURCES

**Project Standards**:
- `/AGENTS.md` - Project-specific conventions and workflows
- `/.claude/knowledge/` - Webflow constraints, code standards, debugging guides

**External Documentation**:
- MDN Web Docs - Browser APIs and JavaScript
- Can I Use - Browser compatibility tables
- Webflow University - Platform-specific guidance