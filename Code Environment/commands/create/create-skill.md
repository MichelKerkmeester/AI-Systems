---
description: Create effective skills that extend Claude's capabilities with specialized knowledge, workflows, and tool integrations
argument-hint: [skill-name] [description]
---

# Create Skill

Create new Claude Skills using the skill framework's bundled scripts for initialization, validation, and packaging.

---

## 1. 📋 INPUTS

### Required Inputs

**Skill Name**:
- **Format**: Lowercase, hyphen-case, max 64 characters
- **Validation**: Letters, digits, hyphens only
- **Example**: `pdf-editor`, `api-client`, `database-query`

**Description**:
- **Format**: What it does + when to use it
- **Required**: Both WHAT and WHEN clauses
- **No angle brackets**: < or > characters not allowed
- **Max length**: 1024 characters
- **Third-person**: "This skill should be used when..."
- **Example**: "Query database tables. This skill should be used when working with SQL or data analysis tasks."

### Optional Inputs

**Scope**:
- **`--personal`**: Create in `~/.claude/skills/` (default)
- **`--project`**: Create in `.claude/skills/`

### User Arguments

```text
$ARGUMENTS
```

---

## 2. 🚀 WORKFLOW

Follow these steps in order. Skip only when there's a clear reason a step doesn't apply.

### Step 1: Understand with Concrete Examples

**Purpose**: Ground the skill in real usage patterns before creating it

**Skip only when**: Usage patterns are already clearly understood from user input.

**Process**:
1. Gather concrete examples of how the skill will be used
2. Examples can come from user or be generated and validated
3. Ask focused questions about functionality and use cases

**Example Questions**:
- "What functionality should the [skill-name] skill support?"
- "Can you give examples of how this would be used?"
- "What would a user say that should trigger this skill?"

**Best Practice**: Ask most important questions first, avoid overwhelming user.

**Validation**: Clear understanding of functionality the skill should support.

---

### Step 2: Plan Reusable Skill Contents

**Purpose**: Identify which bundled resources (scripts, references, assets) will add value

**Process**:
1. For each concrete example from Step 1, consider how to execute it from scratch
2. Identify what would be helpful to have pre-built for repeated execution
3. Categorize resources into scripts/, references/, or assets/

**Analysis Criteria**:

**Create `scripts/` when**:
- Same code being rewritten repeatedly
- Deterministic operations needed (data processing, file conversions)
- File manipulation tasks (PDF, images, documents)
- Examples: `scripts/rotate_pdf.py`, `scripts/process_data.py`

**Create `references/` when**:
- Documentation Claude should reference while working
- Information would exceed 5k words in SKILL.md
- Domain knowledge or schemas needed
- Examples: `references/schema.md`, `references/api_docs.md`

**Create `assets/` when**:
- Skill needs files for final output (not loaded into context)
- Templates or boilerplate code used
- Brand assets needed (logos, fonts, images)
- Examples: `assets/logo.png`, `assets/template.html`

**Communication**: Explain which directories will be created and why.

**Example**: "Based on the examples, we'll need scripts/ for PDF manipulation and references/ for API documentation."

**Output**: List of planned bundled resources.

---

### Step 3: Initialize the Skill

**Purpose**: Create skill directory structure using the framework's init script

**Skip only when**: Skill already exists and you're iterating on it.

**Always run the init script**:

```bash
python /Users/michelkerkmeester/MEGA/Development/Websites/anobel.com/.claude/skills/create-skill/scripts/init_skill.py {{SKILL_NAME}} --path {{TARGET_PATH}}
```

**Where**:
- `{{SKILL_NAME}}`: The validated skill name (hyphen-case)
- `{{TARGET_PATH}}`: Path where skill directory should be created
  - Personal: `~/.claude/skills/` (default)
  - Project: `.claude/skills/`

**Script Creates**:
```
skill-name/
├── SKILL.md (template with TODO placeholders)
├── scripts/
│   └── example.py (executable placeholder)
├── references/
│   └── api_reference.md (documentation placeholder)
└── assets/
    └── example_asset.txt (asset placeholder)
```

**After Initialization**: All example files can be customized or deleted as needed.

**Validation**: Skill directory created successfully with all template files.

---

### Step 4: Edit the Skill

**Purpose**: Customize the skill for the specific use case

**Remember**: Creating this skill for another Claude instance to use. Focus on information that would be beneficial and non-obvious.

#### 4.1: Start with Bundled Resources

Begin with the resources identified in Step 2.

**For `scripts/` directory**:
- Replace `scripts/example.py` with actual executable scripts
- Make scripts executable: `chmod +x scripts/*.py`
- Scripts can be Python, Bash, or any executable code
- Add TODO comments explaining purpose

**For `references/` directory**:
- Replace `references/api_reference.md` with actual documentation
- Include API docs, schemas, workflows, domain knowledge
- Keep files focused and well-organized
- Add grep search patterns in SKILL.md if references are large (>10k words)

**For `assets/` directory**:
- Replace `assets/example_asset.txt` with actual assets
- Add templates, images, fonts, boilerplate code
- These files are NOT loaded into context, but used in output

**Important**: Delete example files and entire directories that aren't needed for this skill.

**User Input May Be Required**: Brand assets, documentation templates, API credentials, etc.

#### 4.2: Update SKILL.md

Replace TODO placeholders by answering these questions:

1. **What is the purpose** of the skill, in a few sentences?
2. **When should the skill be used?** Be specific about triggers.
3. **How should Claude use the skill** in practice? Reference all bundled resources.

**Writing Style Requirements**:
- Use **imperative/infinitive form** (verb-first instructions)
- Use **third-person** in description ("This skill should be used when...")
- Use **objective, instructional language** ("To accomplish X, do Y")
- **Never use second person** ("You should...")

**Keep SKILL.md Under 5k Words**: Move detailed content to `references/` files.

**Validation**: SKILL.md is complete with proper frontmatter and all TODOs addressed.

---

### Step 5: Package the Skill

**Purpose**: Validate and package skill into distributable zip file

**Always run the package script**:

```bash
python /Users/michelkerkmeester/MEGA/Development/Websites/anobel.com/.claude/skills/create-skill/scripts/package_skill.py {{SKILL_PATH}} {{OUTPUT_DIR}}
```

**Where**:
- `{{SKILL_PATH}}`: Full path to the skill directory
- `{{OUTPUT_DIR}}`: Optional output directory (defaults to current directory)

**Script Process**:

1. **Validates automatically**:
   - YAML frontmatter format and required fields (name, description)
   - Skill naming conventions (hyphen-case)
   - Description completeness (no angle brackets)
   - File organization and structure

2. **Packages if validation passes**:
   - Creates `{{skill-name}}.zip` file
   - Includes all files with proper directory structure
   - Outputs list of included files

**If Validation Fails**:
- Review error messages
- Fix issues in SKILL.md or directory structure
- Run package script again

**Output Format**:
```
STATUS=CREATED PATH={{full_path_to_zip}}
```

**Validation**: Skill passes all validation checks and packages successfully.

---

### Step 6: Iterate

**Purpose**: Test and improve based on real usage

**When**: Right after using the skill, with fresh context of its performance.

**Iteration Workflow**:
1. Use skill on real tasks
2. Notice struggles, inefficiencies, or missing capabilities
3. Identify needed updates to SKILL.md or bundled resources
4. Implement changes
5. Test again

**Best Practice**: Iterate immediately after use when you have fresh context about what worked and what didn't.

**Remember**: Skills improve through real-world usage and refinement.

---

## 3. 💡 EXAMPLES

### Example 1: PDF Editor Skill

**User Input**: "Create a skill for PDF rotation and cropping"

**Step 1 - Concrete Examples**:
- "Help me rotate this PDF 90 degrees"
- "Crop this PDF to remove margins"

**Step 2 - Planned Resources**:
- `scripts/rotate_pdf.py` - Rotate PDFs deterministically
- `scripts/crop_pdf.py` - Crop PDFs with precise dimensions
- `references/pdf_operations.md` - Common operations and error handling

**Step 3 - Initialize**:
```bash
python init_skill.py pdf-editor --path ~/.claude/skills/
```

**Step 4 - Edit**:
- Create rotate and crop scripts
- Document operation formats in references
- Update SKILL.md with when to use each script

**Step 5 - Package**:
```bash
python package_skill.py ~/.claude/skills/pdf-editor
```

---

### Example 2: Brand Guidelines Skill

**User Input**: "Create a skill for applying company branding"

**Step 1 - Concrete Examples**:
- "Create a presentation with our brand colors"
- "Add our logo to this document"

**Step 2 - Planned Resources**:
- `assets/logo.png` - Company logo
- `assets/color_palette.json` - Brand colors
- `references/brand_guidelines.md` - Usage rules and placement

**Step 3 - Initialize**:
```bash
python init_skill.py brand-guidelines --path .claude/skills/
```

**Step 4 - Edit**:
- Add brand assets (logo, colors)
- Document brand guidelines
- Update SKILL.md with application rules

**Step 5 - Package**:
```bash
python package_skill.py .claude/skills/brand-guidelines
```

---

### Example 3: Database Query Skill

**User Input**: "Create a skill for querying our BigQuery database"

**Step 1 - Concrete Examples**:
- "How many users logged in today?"
- "Show me revenue by product category"

**Step 2 - Planned Resources**:
- `references/schema.md` - Complete table schemas
- `references/common_queries.md` - Query patterns and examples

**Step 3 - Initialize**:
```bash
python init_skill.py bigquery-helper --path ~/.claude/skills/
```

**Step 4 - Edit**:
- Document all table schemas
- Add common query patterns
- Update SKILL.md with query construction guidance
- Delete unused scripts/ and assets/ directories

**Step 5 - Package**:
```bash
python package_skill.py ~/.claude/skills/bigquery-helper
```

---

## 4. 📖 RULES

### ALWAYS

- Start with concrete examples before creating skill
- Use the actual init_skill.py script to initialize
- Plan bundled resources based on real needs analysis
- Delete unused example files and directories
- Write SKILL.md in imperative/infinitive form
- Use third-person in description
- Keep SKILL.md under 5k words
- Make scripts executable (chmod +x)
- Run validation before finalizing
- Use the package_skill.py script to package

### NEVER

- Skip the init script - always use it for initialization
- Create skills without concrete examples
- Use second-person ("You should...")
- Duplicate content between SKILL.md and references/
- Include angle brackets in description
- Exceed character limits (name: 64, description: 1024)
- Skip validation step
- Leave example files that aren't needed

### ESCALATE IF

- Skill purpose unclear after discussion
- User cannot provide concrete examples
- Validation fails repeatedly
- Skill requires features not supported by framework
- Scripts require dependencies not available

---

## 5. 🎓 SUCCESS CRITERIA

**Skill successfully created when**:
- ✅ Concrete examples gathered and understood
- ✅ Bundled resources planned appropriately
- ✅ Init script run successfully
- ✅ SKILL.md completed with proper frontmatter
- ✅ Description uses third-person form
- ✅ Bundled resources created and organized
- ✅ Unused example files deleted
- ✅ Scripts are executable
- ✅ Passes validation checks
- ✅ Successfully packages into zip file
- ✅ Ready for testing on real tasks

**Quality Gates**:
- Name is meaningful and descriptive
- Description triggers skill appropriately
- Bundled resources add clear value
- SKILL.md under 5k words
- Examples demonstrate real usage
- File ready for Claude Code restart

---

## 6. 🔗 INTEGRATION POINTS

### Bundled Scripts

**Init Script**: `.claude/skills/create-skill/scripts/init_skill.py`
- Creates skill directory with template files
- Generates SKILL.md with TODO placeholders
- Creates example resource directories

**Validation Script**: `.claude/skills/create-skill/scripts/quick_validate.py`
- Validates YAML frontmatter
- Checks naming conventions
- Verifies required fields
- Called automatically by package script

**Package Script**: `.claude/skills/create-skill/scripts/package_skill.py`
- Runs validation automatically
- Creates distributable zip file
- Includes all files with proper structure

### Storage Locations

- **Personal**: `~/.claude/skills/` (user-wide, default)
- **Project**: `.claude/skills/` (project-specific)

### Progressive Disclosure

Skills use three-level loading for context efficiency:
1. **Metadata** (~100 words) - Always in context
2. **SKILL.md** (<5k words) - Loaded when triggered
3. **Bundled resources** - Loaded/executed as needed

### Best Practices

- Test with trigger queries matching description
- Complete all TODO placeholders
- Populate bundled resources before packaging
- Move detailed info to references/
- Include concrete examples
- Iterate based on real usage
- Keep skill focused on specific domain

---

## 7. ⚠️ COMMON MISTAKES

**Not using the init script**:
- **Problem**: Manually creating files instead of using init_skill.py
- **Fix**: Always run the init script to ensure proper structure

**Vague descriptions**:
- **Problem**: "Helper skill for tasks"
- **Fix**: Be specific: "Query database tables. This skill should be used when working with SQL or data analysis."

**Missing WHEN clause**:
- **Problem**: "Processes PDF files"
- **Fix**: Add when: "Extract text from PDFs. This skill should be used when working with forms or document extraction."

**Creating all directories without analysis**:
- **Problem**: Keeping scripts/, references/, assets/ even when not needed
- **Fix**: Delete unused directories based on Step 2 analysis

**SKILL.md too long**:
- **Problem**: Embedding all documentation in SKILL.md
- **Fix**: Move detailed content to references/, keep SKILL.md focused

**Non-executable scripts**:
- **Problem**: Scripts created without execute permissions
- **Fix**: Always run `chmod +x scripts/*.py`

**Using second person**:
- **Problem**: "You should use this when..."
- **Fix**: Use third-person: "This skill should be used when..."

**Skipping concrete examples**:
- **Problem**: Starting to build without understanding usage
- **Fix**: Always start with Step 1 - gather real examples

---

## 8. 📚 REFERENCE

### Skill Framework

**Based on**: Official Claude Code Agent Skills documentation

**Skill Discovery**: Name and description determine when Claude invokes skill

**Progressive Disclosure**:
1. Metadata (~100 words) - Always in context
2. SKILL.md (<5k words) - Loaded when triggered
3. Bundled resources - Loaded/executed as needed

**Frontmatter Properties**:
- **Required**: name, description
- **Optional**: allowed-tools, metadata, license
- **Use metadata for**: version, author, tags, category

**Changes Take Effect**: After Claude Code restart

**Testing**: Ask questions matching description triggers

### Script Locations

All scripts are in: `.claude/skills/create-skill/scripts/`

- `init_skill.py` - Initialize new skill
- `quick_validate.py` - Validate skill structure
- `package_skill.py` - Package skill into zip

### Validation Rules

- Name: Hyphen-case, lowercase, max 64 chars
- Description: No angle brackets, max 1024 chars, include WHAT and WHEN
- Frontmatter: Valid YAML with required fields
- Structure: SKILL.md required, bundled resources optional
