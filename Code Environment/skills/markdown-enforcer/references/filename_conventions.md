# Filename Conventions - Markdown Naming Rules

Defines the automatic filename transformation rules enforced by the PostToolUse hook for all markdown files in the project.

---

## Core Rule

**All markdown files MUST use**: `lowercase_snake_case.md`

**Exceptions**:
- `README.md` (documentation root files - always ALL CAPS)
- `SKILL.md` (Claude Code skill definitions in `.claude/skills/*/` - always ALL CAPS)

---

## Transformation Rules

### Rule 1: Convert ALL CAPS to Lowercase

```bash
ANALYSIS.md → analysis.md
EXECUTIVE_SUMMARY.md → executive_summary.md
README.md → README.md (EXCEPTION - preserved)
SKILL.md → SKILL.md (EXCEPTION in .claude/skills/ only)
```

### Rule 2: Replace Hyphens with Underscores

```bash
my-document.md → my_document.md
feature-spec.md → feature_spec.md
user-guide-v2.md → user_guide_v2.md
```

### Rule 3: Convert camelCase to snake_case

```bash
myDocument.md → my_document.md
apiReference.md → api_reference.md
userSettings.md → user_settings.md
```

### Rule 4: Convert PascalCase to snake_case

```bash
MyDocument.md → my_document.md
APIReference.md → api_reference.md
UserSettings.md → user_settings.md
```

### Rule 5: Handle Mixed Violations

```bash
My-API_Guide.md → my_api_guide.md
Feature-Spec_v2.md → feature_spec_v2.md
USER-Guide-v2.md → user_guide_v2.md
```

---

## Algorithm Implementation

### Step 1: Extract Basename and Extension

```bash
filename="My-Document_Name.md"
extension="${filename##*.}"      # md
basename="${filename%.*}"        # My-Document_Name
```

### Step 2: Convert to Lowercase

```bash
basename=$(echo "$basename" | tr '[:upper:]' '[:lower:]')
# My-Document_Name → my-document_name
```

### Step 3: Replace Hyphens

```bash
basename=$(echo "$basename" | tr '-' '_')
# my-document_name → my_document_name
```

### Step 4: Handle camelCase (insert underscores before capitals)

```bash
# Already lowercased, so handle remaining case patterns
basename=$(echo "$basename" | sed 's/\([a-z]\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]')
```

### Step 5: Normalize Multiple Underscores

```bash
basename=$(echo "$basename" | sed 's/__*/_/g')
# my___document_name → my_document_name
```

### Step 6: Remove Leading/Trailing Underscores

```bash
basename=$(echo "$basename" | sed 's/^_//;s/_$//')
# _my_document_name_ → my_document_name
```

### Step 7: Reconstruct Filename

```bash
corrected_filename="${basename}.${extension}"
# my_document_name.md
```

---

## Exception Detection

### README.md Exception

```bash
if [[ "$filename" == "README.md" ]]; then
    # Always preserve README.md (no transformation)
    return 0  # Not a violation
fi
```

### SKILL.md Exception

```bash
# Only in .claude/skills/*/ directories
if [[ "$filename" == "SKILL.md" && "$filepath" =~ \.claude/skills/ ]]; then
    # Preserve SKILL.md in skills directories
    return 0  # Not a violation
fi
```

**Important**: `SKILL.md` outside `.claude/skills/` directories would be renamed to `skill.md`

---

## Violation Detection

### Check for Uppercase Letters

```bash
basename="${filename%.*}"

if [[ "$basename" =~ [A-Z] ]]; then
    # Contains uppercase → violation
    return 1
fi
```

### Check for Hyphens

```bash
if [[ "$basename" =~ - ]]; then
    # Contains hyphens → violation
    return 1
fi
```

### Valid Filenames

```bash
# These pass validation:
user_guide.md           # lowercase snake_case ✓
api_reference_v2.md     # with numbers ✓
README.md               # exception ✓
.claude/skills/my-skill/SKILL.md  # exception ✓

# These fail validation:
UserGuide.md            # PascalCase ✗
user-guide.md           # hyphens ✗
user_Guide.md           # mixed case ✗
API_REFERENCE.md        # ALL CAPS ✗
```

---

## Examples by Pattern

### Pattern: ALL CAPS

| Input | Output | Reason |
|-------|--------|--------|
| `ANALYSIS.md` | `analysis.md` | All uppercase → lowercase |
| `EXECUTIVE_SUMMARY.md` | `executive_summary.md` | All uppercase → lowercase, preserves underscore |
| `README.md` | `README.md` | Exception (preserved) |

### Pattern: Hyphens

| Input | Output | Reason |
|-------|--------|--------|
| `my-document.md` | `my_document.md` | Hyphen → underscore |
| `feature-spec-v2.md` | `feature_spec_v2.md` | Multiple hyphens → underscores |
| `user-guide-final.md` | `user_guide_final.md` | Hyphens → underscores |

### Pattern: camelCase

| Input | Output | Reason |
|-------|--------|--------|
| `myDocument.md` | `my_document.md` | Insert underscore before capital |
| `apiReference.md` | `api_reference.md` | Insert underscore before capital |
| `userSettings.md` | `user_settings.md` | Insert underscore before capital |

### Pattern: PascalCase

| Input | Output | Reason |
|-------|--------|--------|
| `MyDocument.md` | `my_document.md` | Lowercase + insert underscores |
| `APIReference.md` | `api_reference.md` | Lowercase + insert underscores |
| `UserSettings.md` | `user_settings.md` | Lowercase + insert underscores |

### Pattern: Mixed Violations

| Input | Output | Reason |
|-------|--------|--------|
| `My-API_Guide.md` | `my_api_guide.md` | All transformations applied |
| `Feature-Spec_v2.md` | `feature_spec_v2.md` | Lowercase + hyphen fix |
| `USER-guide-V2.md` | `user_guide_v2.md` | All transformations applied |

---

## Directory-Specific Behavior

### Skills Directory

```
.claude/skills/my-skill/SKILL.md → PRESERVED (exception)
.claude/skills/my-skill/README.md → PRESERVED (exception)
.claude/skills/my-skill/reference.md → reference.md (if already compliant)
.claude/skills/my-skill/My-Reference.md → my_reference.md (corrected)
```

### Knowledge Directory

```
.claude/knowledge/STYLE_GUIDE.md → style_guide.md (corrected)
.claude/knowledge/README.md → README.md (preserved)
.claude/knowledge/myDocument.md → my_document.md (corrected)
```

### Specs Directory

```
specs/018-feature/ANALYSIS.md → analysis.md (corrected)
specs/018-feature/README.md → README.md (preserved)
specs/018-feature/feature-spec.md → feature_spec.md (corrected)
```

### Any Directory

```
README.md → README.md (always preserved)
SKILL.md → skill.md (only preserved in .claude/skills/*/)
```

---

## Hook Integration

### PostToolUse Hook Workflow

```
1. Tool executes (Write/Edit/NotebookEdit)
2. PostToolUse hook triggered
3. Extract file_path from tool input
4. Check if .md file
5. Check for exceptions (README.md, SKILL.md in skills/)
6. Detect violations (uppercase, hyphens)
7. Generate corrected filename
8. Rename file automatically
9. Log correction
10. Inject AI notification
11. Exit 0 (never blocks)
```

### Notification Format

When a filename is auto-corrected, this notification is injected:

```
⚠️  MARKDOWN NAMING AUTO-CORRECTED:
   Renamed: specs/018-feature/ANALYSIS.md → analysis.md
   Reason: Violates .claude/knowledge/document_style_guide.md naming conventions
   Rule: Only README.md and SKILL.md (in .claude/skills/) may use ALL CAPS
   Enforced: lowercase snake_case for all other markdown files
   Reference: /path/to/document_style_guide.md:37-42

   ✓ Future markdown files should follow: lowercase_snake_case.md
   ✗ Avoid: ALL_CAPS.md, My-File.md, MyFile.md, myFile.md
   ✓ Exceptions: README.md, .claude/skills/*/SKILL.md
```

---

## Testing Transformations

### Test Cases

```bash
# Test 1: ALL CAPS
to_snake_case "ANALYSIS.md"
# Expected: analysis.md

# Test 2: Hyphens
to_snake_case "my-document.md"
# Expected: my_document.md

# Test 3: camelCase
to_snake_case "myDocument.md"
# Expected: my_document.md

# Test 4: PascalCase
to_snake_case "MyDocument.md"
# Expected: my_document.md

# Test 5: Mixed
to_snake_case "My-API_Guide-v2.md"
# Expected: my_api_guide_v2.md

# Test 6: Exception
to_snake_case "README.md"
# Expected: README.md (no change)

# Test 7: Valid already
to_snake_case "my_document.md"
# Expected: my_document.md (no change)
```

---

## Quick Reference

### Valid Filenames ✓

```
user_guide.md
api_reference.md
feature_spec_v2.md
installation_instructions.md
README.md
.claude/skills/*/SKILL.md
```

### Invalid Filenames ✗

```
UserGuide.md           → user_guide.md
API-Reference.md       → api_reference.md
featureSpec.md         → feature_spec.md
INSTALLATION.md        → installation.md
My-File.md             → my_file.md
```

### Remember

- Lowercase only (except exceptions)
- Underscores for word separation
- No hyphens
- README.md always preserved
- SKILL.md preserved only in `.claude/skills/*/`
