---
name: create-skill
description: This skill provides guidance for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Claude's capabilities with specialized knowledge, workflows, or tool integrations.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Skill Creator

Guide for creating effective skills that extend Claude's capabilities with specialized knowledge, workflows, and tool integrations.

---

## 1. 📚 ABOUT SKILLS

Skills are modular, self-contained packages that transform Claude from a general-purpose agent into a specialized agent equipped with procedural knowledge.

**What Skills Provide**:
1. **Specialized workflows** - Multi-step procedures for specific domains
2. **Tool integrations** - Instructions for working with specific file formats or APIs
3. **Domain expertise** - Company-specific knowledge, schemas, business logic
4. **Bundled resources** - Scripts, references, and assets for complex tasks

---

## 2. 🏗️ ANATOMY OF A SKILL

Every skill consists of a required SKILL.md file and optional bundled resources:

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Python/Bash/etc.)
    ├── references/       - Documentation loaded into context as needed
    └── assets/           - Files used in output (templates, icons, fonts)
```

### SKILL.md (required)

**Metadata Quality**: The `name` and `description` in YAML frontmatter determine when Claude will use the skill. Be specific about what the skill does and when to use it. Use third-person (e.g., "This skill should be used when..." instead of "Use this skill when...").

**Writing Style**: Write using **imperative/infinitive form** (verb-first instructions), not second person. Use objective, instructional language (e.g., "To accomplish X, do Y" rather than "You should do X").

### Bundled Resources (optional)

#### Scripts (`scripts/`)

Executable code for tasks requiring deterministic reliability or repeatedly rewritten.

- **When to include**: Same code being rewritten repeatedly or deterministic reliability needed
- **Example**: `scripts/rotate_pdf.py` for PDF rotation tasks
- **Benefits**: Token efficient, deterministic, may execute without loading into context
- **Note**: Scripts may still need to be read for patching or environment adjustments

#### References (`references/`)

Documentation loaded as needed to inform Claude's process and thinking.

- **When to include**: Documentation Claude should reference while working
- **Examples**: `references/schema.md`, `references/api_docs.md`, `references/policies.md`
- **Use cases**: Database schemas, API docs, domain knowledge, company policies
- **Benefits**: Keeps SKILL.md lean, loaded only when needed
- **Best practice**: If files are large (>10k words), include grep search patterns in SKILL.md
- **Avoid duplication**: Keep only essential instructions in SKILL.md; move detailed reference material to references files

#### Assets (`assets/`)

Files used within the output Claude produces (not loaded into context).

- **When to include**: Skill needs files for final output
- **Examples**: `assets/logo.png`, `assets/template.html`, `assets/font.ttf`
- **Use cases**: Templates, images, icons, boilerplate code, fonts
- **Benefits**: Separates output resources from documentation

### Progressive Disclosure Design Principle

Skills use a three-level loading system for context efficiency:

1. **Metadata (name + description)** - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<5k words)
3. **Bundled resources** - As needed by Claude (Unlimited*)

*Unlimited because scripts can be executed without reading into context window.

---

## 3. 🔄 SKILL CREATION PROCESS

Follow these steps in order, skipping only if there is a clear reason they are not applicable.

### Step 1: Understanding the Skill with Concrete Examples

Skip only when skill's usage patterns are already clearly understood.

**Process**:
- Understand concrete examples of how skill will be used
- Examples can come from direct user input or generated and validated
- Ask focused questions about functionality and use cases

**Example Questions** (for image-editor skill):
- "What functionality should the image-editor skill support?"
- "Can you give examples of how this would be used?"
- "What would a user say that should trigger this skill?"

**Best Practice**: Avoid overwhelming users—ask most important questions first, follow up as needed.

**Conclude when**: Clear sense of functionality the skill should support.

---

### Step 2: Planning Reusable Skill Contents

Analyze each example to identify reusable resources.

**Analysis Process**:
1. Consider how to execute the example from scratch
2. Identify scripts, references, and assets helpful for repeated execution

**Example 1: PDF Editor Skill**
- Query: "Help me rotate this PDF"
- Analysis: Rotating PDF requires re-writing same code each time
- Solution: Create `scripts/rotate_pdf.py`

**Example 2: Frontend Webapp Builder**
- Query: "Build me a todo app"
- Analysis: Requires same boilerplate HTML/React each time
- Solution: Create `assets/hello-world/` template

**Example 3: BigQuery Skill**
- Query: "How many users logged in today?"
- Analysis: Re-discovering table schemas each time
- Solution: Create `references/schema.md`

**Output**: List of reusable resources (scripts, references, assets)

---

### Step 3: Initializing the Skill

Skip only if skill already exists and iteration is needed.

**Always run the init script** when creating new skills:

```bash
scripts/init_skill.py <skill-name> --path <output-directory>
```

**Script Actions**:
- Creates skill directory at specified path
- Generates SKILL.md template with proper frontmatter and TODO placeholders
- Creates example resource directories: `scripts/`, `references/`, `assets/`
- Adds example files that can be customized or deleted

**After initialization**: Customize or remove generated files as needed.

---

### Step 4: Edit the Skill

Remember: Creating this skill for another Claude instance to use. Focus on information that would be beneficial and non-obvious.

#### Start with Reusable Skill Contents

Begin with resources identified in Step 2: `scripts/`, `references/`, and `assets/` files.

**Note**: May require user input (e.g., brand assets, documentation templates).

**Important**: Delete example files and directories not needed for the skill.

#### Update SKILL.md

Answer these questions:

1. What is the purpose of the skill, in a few sentences?
2. When should the skill be used?
3. How should Claude use the skill in practice? Reference all reusable contents.

**Remember**: Use imperative/infinitive form, third-person, objective language.

---

### Step 5: Packaging a Skill

Package into distributable zip file with automatic validation:

```bash
scripts/package_skill.py <path/to/skill-folder>
```

**Optional output directory**:
```bash
scripts/package_skill.py <path/to/skill-folder> ./dist
```

**Packaging Process**:

1. **Validate** skill automatically:
   - YAML frontmatter format and required fields
   - Skill naming conventions and directory structure
   - Description completeness and quality
   - File organization and resource references

2. **Package** if validation passes:
   - Creates zip file named after skill (e.g., `my-skill.zip`)
   - Includes all files with proper directory structure

**If validation fails**: Fix errors and run packaging command again.

---

### Step 6: Iterate

Test and improve based on real usage.

**Iteration Workflow**:
1. Use skill on real tasks
2. Notice struggles or inefficiencies
3. Identify SKILL.md or bundled resource updates needed
4. Implement changes and test again

**Best Time**: Right after using skill, with fresh context of performance.

---

## 4. 📖 RULES

### ALWAYS

- Use third-person in descriptions ("This skill should be used when...")
- Write SKILL.md in imperative/infinitive form
- Keep SKILL.md under 5k words
- Include required YAML frontmatter (name, description)
- Move detailed content to references/ files
- Delete unused example files after initialization
- Validate before packaging

### NEVER

- Use second-person ("You should...")
- Duplicate information between SKILL.md and references/
- Create skills without concrete examples
- Skip validation step
- Include excessive detail in SKILL.md body
- Fabricate examples or use cases

### ESCALATE IF

- Skill purpose is unclear after user discussion
- User cannot provide concrete examples
- Validation fails repeatedly
- Skill requires features not supported by framework

---

## 5. 🎓 SUCCESS CRITERIA

**Skill is complete when**:
- ✅ YAML frontmatter includes name and description
- ✅ Description uses third-person form
- ✅ SKILL.md under 5k words
- ✅ All bundled resources properly organized
- ✅ Passes validation checks
- ✅ Successfully packages into zip file
- ✅ Tested on real examples

---

## 6. 💡 EXAMPLES

### Example 1: PDF Editor Skill

**Purpose**: Rotate, crop, and edit PDF files

**Bundled Resources**:
- `scripts/rotate_pdf.py`
- `scripts/crop_pdf.py`
- `references/pdf_operations.md`

**SKILL.md Content**: Instructions on when to use each script, command formats, error handling

---

### Example 2: Brand Guidelines Skill

**Purpose**: Apply company branding to documents

**Bundled Resources**:
- `assets/logo.png`
- `assets/color_palette.json`
- `references/brand_guidelines.md`

**SKILL.md Content**: How to apply branding, color usage rules, logo placement

---

### Example 3: Database Query Skill

**Purpose**: Query company database with proper schemas

**Bundled Resources**:
- `references/schema.md`
- `references/common_queries.md`

**SKILL.md Content**: How to construct queries, join patterns, optimization tips

---

## 7. 🔗 INTEGRATION POINTS

**Init Script**: `scripts/init_skill.py` - Generates skill templates

**Package Script**: `scripts/package_skill.py` - Validates and packages skills

**Validation**: Automatic checks for frontmatter, naming, structure

**Distribution**: Zip files for easy sharing and installation

---

## 8. 🎯 QUICK REFERENCE

**Required Files**:
- `SKILL.md` with YAML frontmatter (name, description)

**Optional Directories**:
- `scripts/` - Executable code
- `references/` - Documentation
- `assets/` - Output resources

**Writing Style**:
- Third-person descriptions
- Imperative/infinitive form
- Objective, instructional language

**Size Limit**: SKILL.md < 5k words

**Validation Command**: Automatic during packaging

**Package Command**:
```bash
scripts/package_skill.py <path/to/skill-folder>
```
