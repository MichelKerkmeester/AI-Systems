---
description: Convert a project into a Claude Code plugin
argument-hint: [project-path]
---

# Create Plugin

Guide users through converting existing projects into properly structured Claude Code plugins with marketplace configuration and comprehensive documentation.

---

## 1. 📋 INPUTS

### Required Inputs

**None** - Defaults to current directory

### Optional Inputs

**Project Path**:
- **Format**: Path to project directory
- **Default**: Current directory
- **Example**: `./my-plugin`, `/path/to/plugin`

### User Arguments

```text
$ARGUMENTS
```

---

## 2. 🚀 WORKFLOW

### Step 1: Analyze Project Structure

**Purpose**: Identify existing components for plugin conversion

**Actions**:
1. Examine project directory structure
2. Identify slash commands, agents, skills, hooks
3. Check for MCP integrations
4. Review existing documentation files
5. Map components to plugin structure

**Validation**: `structure_analyzed`

### Step 2: Create Plugin Structure

**Purpose**: Generate `.claude-plugin/` directory with manifests

**Directory Structure**:
```
my-plugin/
├── .claude-plugin/
│   ├── plugin.json          # Plugin metadata
│   └── marketplace.json      # Marketplace manifest
├── commands/                 # Slash commands (optional)
├── agents/                   # Agent definitions (optional)
├── skills/                   # Agent Skills (optional)
├── hooks/                    # Event handlers (optional)
├── .mcp.json                # MCP servers (optional)
└── README.md                # Documentation
```

**Validation**: `structure_created`

### Step 3: Generate Plugin Manifest

**Purpose**: Create `plugin.json` with proper metadata

**Template**:
```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": {
    "name": "Author Name",
    "url": "https://github.com/username"
  },
  "repository": "https://github.com/username/plugin-name",
  "license": "MIT"
}
```

**Important**:
- `repository` must be string URL, not object
- Use semantic versioning
- Name must be kebab-case

**Validation**: `plugin_manifest_created`

### Step 4: Generate Marketplace Manifest

**Purpose**: Create `marketplace.json` alongside plugin.json

**Template**:
```json
{
  "name": "marketplace-name",
  "owner": {
    "name": "Owner Name"
  },
  "plugins": [
    {
      "name": "plugin-name",
      "source": "./",
      "description": "Plugin description"
    }
  ]
}
```

**Important**:
- Must be in same `.claude-plugin/` directory
- Source must reference `"./"` for self-reference
- Name should match plugin name

**Validation**: `marketplace_manifest_created`

### Step 5: Organize Plugin Components

**Purpose**: Move/organize components into proper structure

**Component Organization**:
- **commands/**: Slash command markdown files with frontmatter
- **agents/**: Agent definition markdown files
- **skills/**: Subdirectories with SKILL.md files
- **hooks/**: hooks.json for event handlers
- **.mcp.json**: MCP server configurations

**Validation**: `components_organized`

### Step 6: Generate Documentation

**Purpose**: Create comprehensive README.md

**Documentation Sections**:
1. Plugin overview and purpose
2. Installation instructions
3. Usage examples for each component
4. Testing guidance
5. Contributing guidelines (if applicable)

**Validation**: `documentation_generated`

### Step 7: Provide Testing Workflow

**Purpose**: Guide user through local testing

**Testing Steps**:
```bash
# Local marketplace setup
cd my-plugin && claude
/plugin marketplace add .
/plugin install my-plugin@my-plugin-dev

# GitHub-based installation
# 1. Push to GitHub repository
# 2. /plugin marketplace add username/my-plugin
# 3. /plugin install my-plugin@my-plugin-dev
```

**Validation**: `testing_workflow_provided`

### Step 8: Output Result

**Purpose**: Confirm creation and provide next steps

**Output Format**:
```
Created plugin structure at: ./my-plugin
Generated components:
  - .claude-plugin/plugin.json
  - .claude-plugin/marketplace.json
  - commands/helper.md
  - README.md

Next steps:
1. cd my-plugin && claude
2. /plugin marketplace add .
3. /plugin install my-plugin@my-plugin-dev

STATUS=OK PLUGIN_PATH=./my-plugin
```

**Validation**: `result_outputted`

---

## 3. 💡 EXAMPLES

### Example 1: Convert Current Directory

```bash
/create-plugin
```

**Result**: Converts current directory to plugin structure

### Example 2: Convert Specific Project

```bash
/create-plugin ./my-custom-plugin
```

**Result**: Converts specified directory to plugin

---

## 4. 📖 RULES

### ALWAYS

- Create valid plugin.json in `.claude-plugin/` directory
- Create valid marketplace.json in same directory
- Use kebab-case for plugin naming
- Include proper frontmatter in markdown files
- Use `"./"` for marketplace source reference
- Validate JSON syntax
- Provide testing instructions
- Output final STATUS line

### NEVER

- Use object format for repository field (must be string URL)
- Skip marketplace.json creation
- Use invalid semantic versioning
- Omit required manifest fields
- Create plugins without documentation

### ESCALATE IF

- Project structure is unclear or non-standard
- Component organization is ambiguous
- Conflicting configurations exist
- Invalid JSON detected in manifests

---

## 5. 🎓 SUCCESS CRITERIA

**Plugin is successfully created when**:
- ✅ `.claude-plugin/` directory exists
- ✅ plugin.json has valid schema
- ✅ marketplace.json has valid schema
- ✅ Repository field is string URL
- ✅ Components are properly organized
- ✅ README.md provides clear documentation
- ✅ Testing workflow is documented
- ✅ Status output is provided

**Quality Gates**:
- Manifests pass validation
- Plugin name follows conventions
- Source references correct path
- Documentation is comprehensive

---

## 6. 🔗 INTEGRATION POINTS

### Related Commands

- **`/plugin marketplace add`**: Add marketplace
- **`/plugin install`**: Install plugin
- **`/plugin list`**: List installed plugins

### Testing Workflow

1. **Local testing**: Use `"./"` source reference
2. **GitHub testing**: Push and use GitHub URL
3. **Iteration**: Make changes, reinstall to test

### Best Practices

- Test locally before publishing
- Version bump for each release
- Document all components
- Include usage examples
- Provide installation troubleshooting

---

## 7. ⚠️ COMMON MISTAKES

**Repository field as object**:
- **Problem**: `{"type": "git", "url": "..."}`
- **Fix**: Use string URL: `"https://github.com/username/plugin"`

**Missing marketplace.json**:
- **Problem**: Only creating plugin.json
- **Fix**: Create both manifests in `.claude-plugin/`

**Wrong source reference**:
- **Problem**: Using GitHub URL for local testing
- **Fix**: Use `"./"` for self-reference

**Invalid semantic versioning**:
- **Problem**: Version like "v1.0" or "1.0"
- **Fix**: Use proper format: "1.0.0"
