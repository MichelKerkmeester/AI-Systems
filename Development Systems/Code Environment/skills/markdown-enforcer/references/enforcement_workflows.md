# Approval Workflows - Structural Fix Patterns

Examples of structural fixes that require user approval before applying. Shows how to present changes, gather approval, and handle different user responses.

---

## Workflow 1: Add Missing YAML Frontmatter

### Scenario
SKILL.md file missing required frontmatter block.

### Detection
```bash
# Check first line
if ! head -1 "$file_path" | grep -q "^---$"; then
  echo "Missing frontmatter"
fi
```

### Present to User

**Approval Prompt**:
```
╔══════════════════════════════════════════════════════════╗
║ STRUCTURAL FIX REQUIRED: Add YAML Frontmatter           ║
╚══════════════════════════════════════════════════════════╝

File: .claude/skills/new-skill/SKILL.md
Type: SKILL.md (frontmatter required)
Status: ❌ MISSING (currently starts with H1)

Proposed frontmatter (inferred from document context):

  ---
  name: new-skill
  description: Automated framework for systematic debugging and error resolution
  allowed-tools: Read, Bash, Grep
  ---

This will be inserted at the beginning of the file before the H1 title.

Inferred from:
  - name: directory name (.claude/skills/new-skill/)
  - description: H1 subtitle and first paragraph
  - allowed-tools: tool references found in WORKFLOW section

Options:
  1. Accept and apply
  2. Edit values before applying
  3. Skip this fix

Your choice [1/2/3]:
```

### Handle User Response

**Option 1: Accept**
```bash
# Apply frontmatter directly
{
  echo "---"
  echo "name: new-skill"
  echo "description: Automated framework for systematic debugging"
  echo "allowed-tools: Read, Bash, Grep"
  echo "---"
  echo ""
  cat "$file_path"
} > "$temp_file"

mv "$temp_file" "$file_path"

echo "✓ Frontmatter added successfully"
```

**Option 2: Edit**
```bash
# Present interactive editing
echo "Edit frontmatter values (press Enter to keep default):"
echo ""

read -p "name [$inferred_name]: " user_name
name="${user_name:-$inferred_name}"

read -p "description [$inferred_desc]: " user_desc
description="${user_desc:-$inferred_desc}"

read -p "allowed-tools [$inferred_tools]: " user_tools
tools="${user_tools:-$inferred_tools}"

# Show final version for confirmation
echo ""
echo "Final frontmatter:"
echo "---"
echo "name: $name"
echo "description: $description"
echo "allowed-tools: $tools"
echo "---"
echo ""

read -p "Apply this? [y/N]: " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  # Apply edited frontmatter
  apply_frontmatter "$name" "$description" "$tools"
  echo "✓ Custom frontmatter applied"
else
  echo "⊘ Fix cancelled"
fi
```

**Option 3: Skip**
```bash
echo "⊘ Frontmatter fix skipped"
echo "⚠️  Document remains non-compliant"
echo ""
echo "To fix later:"
echo "  1. Add frontmatter manually"
echo "  2. Run: document-style-fixer $file_path"
```

---

## Workflow 2: Reorder Sections to Standard Sequence

### Scenario
SKILL.md sections exist but are out of order.

### Detection
```bash
# Extract current section order
current_order=$(grep "^## [0-9]" "$file_path" | sed 's/^## [0-9]*\. [^ ]* //')

# Expected order
expected_order="WHEN TO USE
HOW IT WORKS
INPUTS
WORKFLOW
RULES
SUCCESS CRITERIA
INTEGRATION POINTS
QUICK REFERENCE"

# Compare
if [[ "$current_order" != "$expected_order" ]]; then
  echo "Section order violation"
fi
```

### Present to User

**Approval Prompt**:
```
╔══════════════════════════════════════════════════════════╗
║ STRUCTURAL FIX REQUIRED: Reorder Sections               ║
╚══════════════════════════════════════════════════════════╝

File: .claude/skills/my-skill/SKILL.md
Type: SKILL.md (strict section order required)
Status: ❌ OUT OF ORDER

Current order:
  1. HOW IT WORKS
  2. WHEN TO USE          ← Should be #1
  3. RULES                ← Should be #5
  4. WORKFLOW             ← Should be #4

Required order:
  1. WHEN TO USE          ← Currently #2
  2. HOW IT WORKS         ✓ Currently #1
  3. INPUTS               ⚠️  MISSING
  4. WORKFLOW             ← Currently #4
  5. RULES                ← Currently #3
  6. SUCCESS CRITERIA     ⚠️  MISSING
  7. INTEGRATION POINTS   ⚠️  MISSING
  8. QUICK REFERENCE      ⚠️  MISSING

Actions that will be taken:
  1. Reorder existing sections to match standard sequence
  2. Add missing sections with placeholder content
  3. Preserve all existing content (no data loss)

Preview changes? [y/N]:
```

### Show Preview

**If user wants preview**:
```markdown
BEFORE (current):
─────────────────────────────────────────────────────
## 1. 🛠️ HOW IT WORKS

[Existing content preserved exactly]

## 2. 🎯 WHEN TO USE

[Existing content preserved exactly]

## 3. 📋 RULES

[Existing content preserved exactly]

## 4. 🚀 WORKFLOW

[Existing content preserved exactly]

AFTER (proposed):
─────────────────────────────────────────────────────
## 1. 🎯 WHEN TO USE

[Existing content preserved exactly - moved from #2]

## 2. 🛠️ HOW IT WORKS

[Existing content preserved exactly - was #1]

## 3. 📋 INPUTS

[NEW SECTION - placeholder content below]

### Required Inputs
- TBD

### Optional Inputs
- TBD

## 4. 🚀 WORKFLOW

[Existing content preserved exactly - was #4]

## 5. 📋 RULES

[Existing content preserved exactly - moved from #3]

## 6. 🎓 SUCCESS CRITERIA

[NEW SECTION - placeholder content below]

**Task Completion**:
- ✅ TBD

## 7. 🔗 INTEGRATION POINTS

[NEW SECTION - placeholder content below]

**Pairs With**:
- TBD

## 8. 🎯 QUICK REFERENCE

[NEW SECTION - placeholder content below]

### Command Examples
TBD

Apply these changes? [y/N]:
```

### Handle User Response

**If accepted**:
```bash
# Extract each section with content
extract_section() {
  local section_title="$1"
  awk "/^## [0-9]*\. .* $section_title\$/,/^## [0-9]/ {print}" "$file_path" | \
    sed '$ d'  # Remove next section header
}

# Rebuild file in correct order
{
  # Preserve frontmatter and H1
  sed -n '1,/^## 1\./p' "$file_path" | sed '$ d'

  # Add sections in correct order
  echo "## 1. 🎯 WHEN TO USE"
  extract_section "WHEN TO USE"
  echo "---"

  echo "## 2. 🛠️ HOW IT WORKS"
  extract_section "HOW IT WORKS"
  echo "---"

  # Add INPUTS if missing
  if ! grep -q "INPUTS" "$file_path"; then
    cat << 'EOF'
## 3. 📋 INPUTS

### Required Inputs
- TBD

### Optional Inputs
- TBD

---
EOF
  else
    echo "## 3. 📋 INPUTS"
    extract_section "INPUTS"
    echo "---"
  fi

  # Continue for all sections...

} > "$temp_file"

mv "$temp_file" "$file_path"

echo "✓ Sections reordered successfully"
echo "⚠️  Remember to:"
echo "   - Fill in TBD placeholders in new sections"
echo "   - Review section transitions"
echo "   - Verify content flow makes sense"
```

**If rejected**:
```bash
echo "⊘ Section reordering cancelled"
echo "⚠️  Document remains out of order"
echo ""
echo "Manual fix options:"
echo "  1. Cut/paste sections in editor to match required order"
echo "  2. Refer to: .claude/skills/document-style-validator/references/valid_skill_example.md"
echo "  3. Run validator to check: document-style-validator $file_path"
```

---

## Workflow 3: Add Missing Required Sections

### Scenario
SKILL.md missing one or more required sections.

### Detection
```bash
# Required sections for SKILL.md
required_sections=(
  "WHEN TO USE"
  "HOW IT WORKS"
  "WORKFLOW"
  "RULES"
  "SUCCESS CRITERIA"
  "INTEGRATION POINTS"
  "QUICK REFERENCE"
)

# Find missing sections
missing=()
for section in "${required_sections[@]}"; do
  if ! grep -q "## [0-9]*\. .* $section\$" "$file_path"; then
    missing+=("$section")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "Missing ${#missing[@]} required sections"
fi
```

### Present to User

**Approval Prompt**:
```
╔══════════════════════════════════════════════════════════╗
║ STRUCTURAL FIX REQUIRED: Add Missing Sections           ║
╚══════════════════════════════════════════════════════════╝

File: .claude/skills/my-skill/SKILL.md
Type: SKILL.md (8 sections required)
Status: ❌ INCOMPLETE

Missing sections (3):
  ⚠️  SUCCESS CRITERIA
  ⚠️  INTEGRATION POINTS
  ⚠️  QUICK REFERENCE

These sections will be added with placeholder content that you'll need to fill in:

SUCCESS CRITERIA:
  - Task Completion checklist (TBD)
  - Quality Standards checklist (TBD)
  - User Experience checklist (TBD)

INTEGRATION POINTS:
  - Pairs With: (TBD - list related skills)
  - Workflow Integration: (TBD - describe sequences)

QUICK REFERENCE:
  - Command Examples: (TBD - add usage examples)
  - Validation Checklist: (TBD - add checklist items)
  - Common Issues: (TBD - add troubleshooting)

All missing sections will use standard templates from:
  .claude/skills/document-style-validator/references/valid_skill_example.md

Options:
  1. Add all missing sections with placeholders
  2. Select which sections to add (interactive)
  3. Skip (leave non-compliant)

Your choice [1/2/3]:
```

### Handle User Response

**Option 1: Add all**
```bash
# Get insertion point (after last existing section)
last_section_line=$(grep -n "^## [0-9]" "$file_path" | tail -1 | cut -d: -f1)

# Build new sections
new_content=""

if [[ " ${missing[@]} " =~ " SUCCESS CRITERIA " ]]; then
  new_content+="---

## 6. 🎓 SUCCESS CRITERIA

**Task Completion**:
- ✅ TBD

**Quality Standards**:
- ✅ TBD

**User Experience**:
- ✅ TBD

"
fi

if [[ " ${missing[@]} " =~ " INTEGRATION POINTS " ]]; then
  new_content+="---

## 7. 🔗 INTEGRATION POINTS

**Pairs With**:
- \`related-skill\` - TBD

**Workflow Integration**:
\`\`\`
1. prerequisite  → TBD
2. this-skill    → TBD
3. follow-up     → TBD
\`\`\`

"
fi

if [[ " ${missing[@]} " =~ " QUICK REFERENCE " ]]; then
  new_content+="---

## 8. 🎯 QUICK REFERENCE

### Command Examples
TBD

### Validation Checklist
- [ ] TBD

### Common Issues
TBD

"
fi

# Insert new sections
sed -i "${last_section_line}a\\
$new_content" "$file_path"

echo "✓ Added ${#missing[@]} missing sections"
echo "⚠️  Next steps:"
echo "   1. Open file: $file_path"
echo "   2. Search for 'TBD' (${#missing[@]} sections)"
echo "   3. Fill in placeholder content"
echo "   4. Run validator: document-style-validator $file_path"
```

**Option 2: Interactive selection**
```bash
echo "Select sections to add (y/n for each):"
echo ""

sections_to_add=()

for section in "${missing[@]}"; do
  read -p "Add $section? [y/N]: " add
  if [[ "$add" =~ ^[Yy]$ ]]; then
    sections_to_add+=("$section")
  fi
done

if [[ ${#sections_to_add[@]} -gt 0 ]]; then
  echo ""
  echo "Adding ${#sections_to_add[@]} sections:"
  printf '  - %s\n' "${sections_to_add[@]}"

  read -p "Confirm? [y/N]: " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    # Add only selected sections
    add_selected_sections "${sections_to_add[@]}"
    echo "✓ Selected sections added"
  else
    echo "⊘ Cancelled"
  fi
else
  echo "⊘ No sections selected"
fi
```

**Option 3: Skip**
```bash
echo "⊘ Section addition skipped"
echo "⚠️  Document incomplete (missing ${#missing[@]} required sections)"
echo ""
echo "Missing:"
printf '  - %s\n' "${missing[@]}"
echo ""
echo "Reference template:"
echo "  .claude/skills/document-style-validator/references/valid_skill_example.md"
```

---

## Workflow 4: Split INPUTS Section (Commands)

### Scenario
Command file has INPUTS section but doesn't separate Required vs Optional.

### Detection
```bash
# Check if INPUTS section exists but lacks subsections
if grep -q "^## [0-9]*\. .* INPUTS\$" "$file_path"; then
  if ! grep -q "### Required Inputs" "$file_path"; then
    echo "INPUTS section needs splitting"
  fi
fi
```

### Present to User

**Approval Prompt**:
```
╔══════════════════════════════════════════════════════════╗
║ STRUCTURAL FIX REQUIRED: Split INPUTS Section           ║
╚══════════════════════════════════════════════════════════╝

File: .claude/commands/create/create-command.md
Type: Command (requires Required/Optional input separation)
Status: ❌ NOT SEPARATED

Current INPUTS section:
  ## 1. 📋 INPUTS

  - `name`: Name of the command
  - `purpose`: What the command does
  - `optional_flag`: Optional parameter (default: false)

Required fix:
  ## 1. 📋 INPUTS

  ### Required Inputs
  - `name`: Name of the command
  - `purpose`: What the command does

  ### Optional Inputs
  - `optional_flag`: Optional parameter (default: false)

Detected parameters:
  Required (2): name, purpose
  Optional (1): optional_flag (has default value mentioned)

Auto-categorization based on:
  - Presence of "optional" keyword → Optional
  - Presence of "default:" text → Optional
  - Everything else → Required

Options:
  1. Apply auto-categorization
  2. Manually categorize parameters
  3. Skip this fix

Your choice [1/2/3]:
```

### Handle User Response

**Option 1: Auto-categorize**
```bash
# Extract INPUTS section
inputs_section=$(awk '/^## [0-9]*\. .* INPUTS$/,/^## [0-9]/ {print}' "$file_path" | sed '$ d')

# Auto-categorize parameters
required_params=()
optional_params=()

while IFS= read -r line; do
  if [[ "$line" =~ ^-[[:space:]]\`([^`]+)\`: ]]; then
    param_name="${BASH_REMATCH[1]}"
    param_line="$line"

    # Check for optional indicators
    if [[ "$param_line" =~ (optional|default:|\(optional\)) ]]; then
      optional_params+=("$param_line")
    else
      required_params+=("$param_line")
    fi
  fi
done <<< "$inputs_section"

# Build new INPUTS section
new_inputs="## 1. 📋 INPUTS

### Required Inputs"
for param in "${required_params[@]}"; do
  new_inputs+="
$param"
done

new_inputs+="

### Optional Inputs"
for param in "${optional_params[@]}"; do
  new_inputs+="
$param"
done

# Replace old INPUTS section with new
# ... (use Edit tool)

echo "✓ INPUTS section split successfully"
echo "  Required: ${#required_params[@]} parameters"
echo "  Optional: ${#optional_params[@]} parameters"
```

**Option 2: Manual categorization**
```bash
# Extract all parameters
params=$(grep "^- \`" "$file_path" | sed 's/^- `\([^`]*\)`.*/\1/')

echo "Categorize each parameter:"
echo ""

required_params=()
optional_params=()

while IFS= read -r param; do
  echo "Parameter: $param"
  read -p "  Required or Optional? [R/o]: " category

  if [[ "$category" =~ ^[Oo]$ ]]; then
    optional_params+=("$param")
    read -p "  Default value (press Enter to skip): " default
    if [[ -n "$default" ]]; then
      param_with_default="$param (default: $default)"
      # Store with default...
    fi
  else
    required_params+=("$param")
  fi
  echo ""
done <<< "$params"

# Build new INPUTS section with user categorization
# ... (apply similar to Option 1)

echo "✓ INPUTS section split with manual categorization"
```

---

## Workflow 5: Batch Mode Approval

### Scenario
Fixing multiple files, need efficient approval flow.

### Batch Approval Options

**Option A: Review All, Then Apply**
```
╔══════════════════════════════════════════════════════════╗
║ BATCH MODE: Review First                                ║
╚══════════════════════════════════════════════════════════╝

Scanning directory: .claude/skills/
Found: 5 files with violations

Summary:
  File 1: new-skill-1/SKILL.md
    - Add frontmatter
    - Add 2 missing sections

  File 2: new-skill-2/SKILL.md
    - Reorder sections
    - Add 1 missing section

  File 3: new-skill-3/SKILL.md
    - Add frontmatter
    - Add 3 missing sections

  File 4: my-command/command.md
    - Split INPUTS section

  File 5: other-skill/SKILL.md
    - Add 1 missing section

Total structural fixes: 12

Options:
  1. Review and approve each file individually
  2. Apply all safe fixes, skip structural (fastest)
  3. Accept all fixes for all files (⚠️  use with caution)
  4. Cancel batch operation

Your choice [1/2/3/4]:
```

**Option B: Stop on First Rejection**
```bash
# Process files one by one
for file in "${files_with_violations[@]}"; do
  echo "Processing: $file"

  # Show fixes for this file
  show_fixes "$file"

  read -p "Apply fixes to this file? [y/N/q]: " response

  case "$response" in
    [Yy])
      apply_fixes "$file"
      echo "✓ Fixed: $file"
      ;;
    [Qq])
      echo "⊘ Batch operation cancelled"
      echo "  Processed: $processed_count files"
      echo "  Remaining: $((${#files_with_violations[@]} - processed_count)) files"
      break
      ;;
    *)
      echo "⊘ Skipped: $file"
      ;;
  esac

  ((processed_count++))
done
```

---

## Best Practices for Approval Flows

### Clear Communication
- **Always show before/after** previews for structural changes
- **Explain why** the fix is needed (reference style guide)
- **Provide options** (accept/edit/skip)
- **Show impact** (what will change, what won't)

### User Control
- **Never force** structural changes
- **Allow editing** of generated content before applying
- **Support undo** (work on git-tracked files)
- **Respect rejection** (skip and document)

### Efficiency
- **Batch similar fixes** across multiple files
- **Remember preferences** during session (apply all/skip all)
- **Show summary** before applying batch changes
- **Provide shortcuts** for common responses (y/n/a/q)

### Safety
- **Always work on git** tracked files
- **Create backup** if file not in git
- **Validate after** applying fixes
- **Report errors** clearly if fix fails

---

## Quick Reference: Approval Templates

### Standard Approval Prompt Template
```
╔══════════════════════════════════════════════════════════╗
║ STRUCTURAL FIX REQUIRED: [Fix Name]                     ║
╚══════════════════════════════════════════════════════════╝

File: [path]
Type: [document type]
Status: [current issue]

[Description of current problem]

[Description of proposed fix]

[Preview or detailed explanation]

Options:
  1. [Primary action]
  2. [Alternative action]
  3. Skip this fix

Your choice [1/2/3]:
```

### Batch Approval Template
```
╔══════════════════════════════════════════════════════════╗
║ BATCH MODE: [Number] Files Found                        ║
╚══════════════════════════════════════════════════════════╝

[Summary of all files and fixes]

Options:
  1. Review each file individually
  2. Apply safe fixes only (skip structural)
  3. Accept all fixes (⚠️  caution)
  4. Cancel

Your choice [1/2/3/4]:
```

### Confirmation After Apply
```
✓ Fixes applied successfully

Changed:
  - [List of changes made]

Next steps:
  - Review changes: git diff [file]
  - Complete TODOs: search for "TBD"
  - Validate: document-style-validator [file]
  - Commit: git add [file] && git commit -m "docs: fix style violations"
```
