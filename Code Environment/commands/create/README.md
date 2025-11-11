# Claude Code Commands - Create

Slash commands for creating and configuring Claude Code extensions including skills, commands, hooks, agents, and plugins.

#### 📋 TABLE OF CONTENTS

1. [📖 OVERVIEW](#1--overview)
2. [⚡ AVAILABLE COMMANDS](#2--available-commands)
3. [🚀 QUICK START GUIDE](#3--quick-start-guide)
4. [🏗️ ARCHITECTURE](#4-️-architecture)
5. [💡 BEST PRACTICES](#5--best-practices)
6. [🔧 TROUBLESHOOTING](#6--troubleshooting)
7. [🔗 INTEGRATION](#7--integration)
8. [📊 COMMAND REFERENCE SUMMARY](#8--command-reference-summary)
9. [🆘 SUPPORT](#9--support)

---

## 1. 📖 OVERVIEW

This directory contains commands for creating and configuring Claude Code extensions. These commands help you extend Claude's capabilities through skills, commands, hooks, agents, and plugins.

### Capabilities
- ✅ Create skills with specialized knowledge and workflows
- ✅ Generate slash commands with standardized structure
- ✅ Configure event-driven hooks for automation
- ✅ Create custom subagents for specialized tasks
- ✅ Convert projects into distributable plugins

### Command Support Status

| Command | Status | Scope | Description |
|---------|--------|-------|-------------|
| `/create-skill` | ✅ WORKING | User/Project | Create skills with scripts, references, assets |
| `/create-command` | ✅ WORKING | Project | Generate slash commands with templates |
| `/create-hook` | ✅ WORKING | Project | Configure event-driven hooks |
| `/create-agent` | ✅ WORKING | User/Project | Create custom subagents |
| `/create-plugin` | ✅ WORKING | Project | Convert projects to plugins |

---

## 2. ⚡ AVAILABLE COMMANDS

### `/create-skill` - Create Skills

Create new Claude Skills with specialized knowledge, workflows, and tool integrations.

```bash
/create-skill pdf-editor "Edit PDF files. Use when working with PDF manipulation tasks."
/create-skill api-client "Make API requests. Use when integrating with external APIs." --project
```

**Features**:
- Interactive workflow with concrete examples
- Automatic directory structure creation
- Template generation for SKILL.md
- Support for scripts/, references/, and assets/ directories
- Personal (`~/.claude/skills/`) or project (`.claude/skills/`) scope

**Use cases**:
- Domain-specific knowledge (legal, medical, finance)
- Specialized workflows (data analysis, testing)
- Tool integrations (APIs, databases)
- File manipulation (PDFs, images, documents)

**Safety:** ✅ Non-destructive, creates new directories

---

### `/create-command` - Generate Slash Commands

Generate properly structured slash commands with standardized formatting.

```bash
/create-command analyze-deps "Analyze dependencies for outdated packages"
/create-command check-security "Run security audit on dependencies"
```

**Features**:
- Standardized command template
- Contract-based structure (inputs/outputs)
- Bash tool integration
- Idempotent and deterministic patterns

**Use cases**:
- Custom workflow automation
- Project-specific operations
- Build and deployment tasks
- Code analysis and validation

**Safety:** ✅ Non-destructive, creates new files

---

### `/create-hook` - Configure Event Hooks

Create and configure event-driven hooks with production-ready templates.

```bash
/create-hook PreToolUse Bash "validate-command.sh"
/create-hook PostToolUse Edit "auto-format.sh"
```

**Features**:
- Interactive mode with hook type selection
- Production-ready templates (eslint, prettier, etc.)
- Support for all hook events
- External script generation
- Automatic settings.json configuration

**Hook Types**:
- **PreToolUse**: Before tool execution (validation, security)
- **PostToolUse**: After tool execution (formatting, quality checks)
- **UserPromptSubmit**: Before prompt processing (triggers, validation)
- **Notification**: System notifications
- **SessionStart/End**: Session lifecycle events

**Use cases**:
- Code quality automation (linting, formatting)
- Security validation (dangerous commands)
- Auto-save and context preservation
- Custom workflows and triggers

**Safety:** ✅ Non-destructive, creates scripts and config

---

### `/create-agent` - Create Custom Subagents

Create specialized subagents for focused tasks with custom system prompts.

```bash
/create-agent code-reviewer "Expert code reviewer. Use proactively after code changes."
/create-agent debugger "Debug specialist. Use when investigating bugs." --tools "Read,Grep,Bash"
```

**Features**:
- Configurable tool access
- Custom system prompts
- Model selection (sonnet, opus, haiku)
- User or project scope
- Markdown-based configuration

**Use cases**:
- Specialized roles (reviewer, debugger, tester)
- Domain experts (data scientist, DevOps)
- Workflow-specific agents (deployment, analysis)

**Safety:** ✅ Non-destructive, prevents overwriting

---

### `/create-plugin` - Convert to Plugin

Convert existing projects into distributable Claude Code plugins.

```bash
/create-plugin
/create-plugin ./my-plugin
```

**Features**:
- Automatic project structure analysis
- Plugin manifest generation (plugin.json)
- Marketplace manifest creation (marketplace.json)
- Comprehensive README generation
- Component mapping (commands, skills, hooks, agents)

**Use cases**:
- Distributing custom extensions
- Packaging reusable components
- Publishing to marketplace
- Sharing team workflows

**Safety:** ✅ Non-destructive, creates `.claude-plugin/` directory

---

## 3. 🚀 QUICK START GUIDE

### Creating Your First Extension

**1. Start with a Skill (Easiest)**
```bash
/create-skill my-first-skill "Practice skill. Use when learning Claude skills."
```
Follow the interactive workflow to define functionality and create bundled resources.

**2. Add a Command (Automation)**
```bash
/create-command hello-world "Print hello world message"
```
Edit the generated file in `.claude/commands/` to add your logic.

**3. Configure a Hook (Event-Driven)**
```bash
/create-hook PostToolUse Edit
```
Choose from interactive menu or use production templates for common tools.

**4. Create an Agent (Specialized Tasks)**
```bash
/create-agent helper "General helper agent. Use for assistance with various tasks."
```
Customize the system prompt in `.claude/agents/helper.md`.

**5. Package as Plugin (Distribution)**
```bash
/create-plugin
```
Generate plugin manifests and prepare for distribution.

---

## 4. 🏗️ ARCHITECTURE

### Directory Structure

```
.claude/
├── commands/
│   ├── create/
│   │   ├── README.md                    # This file
│   │   ├── create-skill.md              # Skill creation
│   │   ├── create-command.md            # Command generation
│   │   ├── create-hook.md               # Hook configuration
│   │   ├── create-agent.md              # Agent creation
│   │   └── create-plugin.md             # Plugin conversion
│   └── [other-command-groups]/
├── skills/
│   └── [project-skills]/
├── hooks/
│   ├── PreToolUse/
│   ├── PostToolUse/
│   └── UserPromptSubmit/
├── agents/
│   └── [project-agents]/
└── .claude-plugin/                      # Plugin distribution
    ├── plugin.json
    └── marketplace.json

~/.claude/                                # User-level extensions
├── skills/
│   └── [personal-skills]/
└── agents/
    └── [personal-agents]/
```

### Component Types

#### Skills
- **Location**: `.claude/skills/` (project) or `~/.claude/skills/` (user)
- **Structure**: SKILL.md + scripts/ + references/ + assets/
- **Purpose**: Specialized knowledge and reusable workflows

#### Commands
- **Location**: `.claude/commands/`
- **Structure**: Single .md file with frontmatter
- **Purpose**: Custom slash commands for automation

#### Hooks
- **Location**: `.claude/hooks/[HookType]/`
- **Structure**: Bash scripts + settings.json config
- **Purpose**: Event-driven automation and validation

#### Agents
- **Location**: `.claude/agents/` (project) or `~/.claude/agents/` (user)
- **Structure**: Single .md file with frontmatter
- **Purpose**: Specialized subagents with custom system prompts

#### Plugins
- **Location**: `.claude-plugin/` in project root
- **Structure**: Manifests + bundled components
- **Purpose**: Distributable extension packages

---

## 5. 💡 BEST PRACTICES

### Skills

**DO**:
- ✅ Ground skills in concrete usage examples
- ✅ Use scripts/ for repeated deterministic operations
- ✅ Use references/ for extensive documentation
- ✅ Use assets/ for output templates and resources
- ✅ Write clear "when to use" descriptions

**DON'T**:
- ❌ Include obvious information already in Claude's training
- ❌ Create overly broad skills (be specific)
- ❌ Duplicate functionality of existing skills
- ❌ Include sensitive data in skill files

### Commands

**DO**:
- ✅ Follow verb-first naming (analyze-deps, check-security)
- ✅ Use kebab-case for command names
- ✅ Define clear inputs/outputs contract
- ✅ Make commands idempotent
- ✅ Validate inputs before execution

**DON'T**:
- ❌ Use network tools without explicit permission
- ❌ Create non-deterministic commands
- ❌ Produce verbose console output
- ❌ Overlap with existing commands

### Hooks

**DO**:
- ✅ Use PreToolUse for validation and security
- ✅ Use PostToolUse for formatting and quality
- ✅ Exit with appropriate codes (0=allow, 2=block)
- ✅ Keep hooks fast and focused
- ✅ Use production templates for common tools

**DON'T**:
- ❌ Create blocking hooks that slow workflow
- ❌ Perform heavy computation in hooks
- ❌ Duplicate functionality across hooks
- ❌ Forget to make scripts executable (chmod +x)

### Agents

**DO**:
- ✅ Create specialized agents for focused tasks
- ✅ Limit tool access to what's needed
- ✅ Write clear system prompts
- ✅ Use descriptive "when to use" clauses
- ✅ Test agents thoroughly before deployment

**DON'T**:
- ❌ Create overly general agents
- ❌ Grant unnecessary tool permissions
- ❌ Use vague descriptions
- ❌ Overwrite existing agents without checking

### Plugins

**DO**:
- ✅ Include comprehensive README
- ✅ Use semantic versioning
- ✅ Test all components before packaging
- ✅ Document dependencies clearly
- ✅ Include LICENSE file

**DON'T**:
- ❌ Package incomplete or untested code
- ❌ Include sensitive configuration
- ❌ Use object format for repository field (use string URL)
- ❌ Forget to update version numbers

---

## 6. 🔧 TROUBLESHOOTING

### Skills Not Detected

**Problem**: Created skill doesn't appear in Claude's context

**Solutions**:
1. Verify skill is in correct directory (`.claude/skills/` or `~/.claude/skills/`)
2. Check SKILL.md has proper frontmatter
3. Restart Claude Code to reload skills
4. Verify description includes "when to use" clause

### Commands Not Working

**Problem**: Slash command not found or fails

**Solutions**:
1. Check command file is in `.claude/commands/` directory
2. Verify frontmatter has `description` field
3. Ensure command name matches filename
4. Check `allowed-tools` permissions in frontmatter
5. Validate bash commands are correct

### Hooks Not Firing

**Problem**: Hook doesn't execute on expected events

**Solutions**:
1. Verify hook is registered in `settings.json`
2. Check hook script is executable (`chmod +x`)
3. Ensure matcher pattern matches tool name
4. Test hook manually: `echo '{"test":"data"}' | bash hook.sh`
5. Check hook exit code (0=allow, 2=block)

### Agent Not Available

**Problem**: Custom agent not shown in agent selector

**Solutions**:
1. Verify agent file is in `.claude/agents/` or `~/.claude/agents/`
2. Check frontmatter has `name` and `description` fields
3. Ensure agent name is valid (lowercase, kebab-case)
4. Restart Claude Code to reload agents
5. Check for conflicting agent names

### Plugin Conversion Fails

**Problem**: Plugin manifest generation errors

**Solutions**:
1. Ensure project has valid structure
2. Check `plugin.json` uses string URL for repository (not object)
3. Verify all component paths are correct
4. Test plugin locally before distribution
5. Validate JSON syntax in manifests

---

## 7. 🔗 INTEGRATION

### With Skills Framework

Create commands integrate with the skills framework:
- **Initialization**: Uses `init_skill.py` script
- **Validation**: Follows skill naming conventions
- **Structure**: Creates standard directory layout
- **Templates**: Provides SKILL.md templates

### With Claude Code Settings

Commands modify or use settings.json:
- **Hooks**: Add entries to `hooks` configuration
- **Agents**: Reference agent files in configuration
- **Permissions**: May require tool permissions

### With Git Workflows

Extensions integrate with version control:
- **Skills**: Track in `.claude/skills/` (project) or exclude (user)
- **Commands**: Commit to `.claude/commands/`
- **Hooks**: Version control scripts in `.claude/hooks/`
- **Plugins**: Package entire `.claude-plugin/` directory

### With MCP Servers

Skills and commands can leverage MCP:
- **Skills**: Can bundle MCP server configurations
- **Commands**: Can invoke MCP tools via allowed-tools
- **Plugins**: Can include `.mcp.json` configuration

---

## 8. 📊 COMMAND REFERENCE SUMMARY

| Command | Purpose | Scope | Output Location | Time |
|---------|---------|-------|-----------------|------|
| `/create-skill` | Create skills | User/Project | `.claude/skills/` or `~/.claude/skills/` | 5-15 min |
| `/create-command` | Generate commands | Project | `.claude/commands/` | < 1 min |
| `/create-hook` | Configure hooks | Project | `.claude/hooks/` + settings.json | 2-5 min |
| `/create-agent` | Create agents | User/Project | `.claude/agents/` or `~/.claude/agents/` | < 1 min |
| `/create-plugin` | Convert to plugin | Project | `.claude-plugin/` | 2-5 min |

---

## 9. 🆘 SUPPORT

For issues or questions:
- **Skills**: Check `~/.claude/skills/create-skill/` for framework
- **Commands**: Review existing commands in `.claude/commands/`
- **Hooks**: See `.claude/hooks/README.md` for hook documentation
- **Agents**: Check `.claude/agents/` for examples
- **Plugins**: Review plugin.json schema in Claude Code docs

### Common Issues

**"Command not found"**
- Verify file is in `.claude/commands/` directory
- Check frontmatter syntax is correct

**"Permission denied"**
- Add required tools to `allowed-tools` in frontmatter
- Update permissions in settings.json

**"Skill not loading"**
- Restart Claude Code
- Check SKILL.md has proper structure
- Verify directory location

**"Hook not executing"**
- Make script executable: `chmod +x script.sh`
- Register in settings.json
- Test manually with sample input

---

## 10. 📜 VERSION HISTORY

**Current Version**: 1.0.0
**Last Updated**: 2025-11-11

### v1.0.0 (2025-11-11) - Initial Release
- ✅ Created extensibility command suite
- ✅ Implemented `/create-skill` with interactive workflow
- ✅ Implemented `/create-command` with template generation
- ✅ Implemented `/create-hook` with production templates
- ✅ Implemented `/create-agent` with custom configuration
- ✅ Implemented `/create-plugin` for distribution
- ✅ Added comprehensive README with best practices
- ✅ Added troubleshooting guides
- ✅ Added integration documentation

---

## 11. 🔗 RELATED DOCUMENTATION

- [Skills Framework](../../skills/create-skill/SKILL.md)
- [Hooks Documentation](../../hooks/README.md)
- [Claude Code Documentation](https://code.claude.com/docs/)
- [Plugin Development Guide](https://code.claude.com/docs/plugins)
- [Settings Configuration](https://code.claude.com/docs/settings)

---

**Created:** November 11, 2025
**Location:** `.claude/commands/create/`
**Total Commands:** 5
