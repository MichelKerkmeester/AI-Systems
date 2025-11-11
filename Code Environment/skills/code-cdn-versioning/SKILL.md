---
name: code-cdn-versioning
description: This skill automates CDN cache-busting by updating version numbers in HTML files after JavaScript modifications. This skill should be used when JavaScript files have been changed and need to force browsers to download fresh versions instead of serving cached files.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# CDN Version Updater

Automates the critical workflow of updating version query parameters in HTML files to ensure JavaScript changes reach users by bypassing browser and CDN caches.

---

## 1. 🎯 WHEN TO USE

**This skill should be used when**:
- JavaScript files have been modified (e.g., page_loader.js, hero_general.js)
- Bug fixes or features have been deployed to CDN
- Users report not seeing recent changes (cache issues)
- Part of deployment workflow after JS changes
- Emergency cache-busting is needed

**This skill should NOT be used for**:
- CSS-only changes (unless CSS is in JavaScript)
- HTML content changes without JS modifications
- External CDN scripts (jsdelivr, unpkg, etc.)
- Non-CDN hosted files

---

## 2. 🛠️ HOW IT WORKS

The skill modifies HTML files to append or update version query parameters (`?v=x.x.x`) to JavaScript URLs, forcing browsers to download fresh files instead of using cached versions.

**Process**:
1. Scans all HTML files in `/src/0_html/` directory
2. Finds R2 CDN script references (both `<script>` and `<link rel="preload">`)
3. Updates or adds version parameters to force cache refresh
4. Reports modified files and provides deployment instructions

**Output**: Updated HTML files with versioned script URLs and summary report

---

## 3. 📋 IMPLEMENTATION WORKFLOW

### Automatic Version Increment

To automatically increment the patch version:

```bash
cd /Users/michelkerkmeester/MEGA/Development/Websites/anobel.com
python3 .claude/skills/code-cdn-versioning/scripts/update_html_versions.py
```

This will:
- Find current version from HTML files (e.g., 1.0.1)
- Increment patch version (e.g., 1.0.1 → 1.0.2)
- Update all HTML files with new version

### Manual Version Specification

To set a specific version:

```bash
python3 .claude/skills/code-cdn-versioning/scripts/update_html_versions.py 1.1.0
```

Use manual versioning for:
- Minor releases (new features): 1.X.0
- Major releases (breaking changes): X.0.0
- Emergency fixes: Jump versions significantly (e.g., 1.0.99)

### Complete Deployment Workflow

1. **Make JavaScript changes**
   ```javascript
   // Example: Modified page_loader.js
   const TIMING = {
     HERO_OVERLAP_DELAY: 350,  // Changed from 400
   };
   ```

2. **Run version updater**
   ```bash
   python3 .claude/skills/code-cdn-versioning/scripts/update_html_versions.py
   ```

3. **Review changes**
   ```
   ✅ global.html
     Script: page_loader.js → page_loader.js?v=1.0.2
   ✅ home.html
     Script: hero_general.js → hero_general.js?v=1.0.2
   ```

4. **Deploy files**
   - Upload JS files to Cloudflare R2
   - Upload HTML files to Webflow
   - Clear CDN cache if needed
   - Publish Webflow site

---

## 4. 📖 RULES

### ALWAYS

- Run after ANY JavaScript modification
- Update ALL HTML files, not just some
- Increment version number for each deployment
- Verify changes before uploading
- Clear CDN cache after deployment

### NEVER

- Use the same version number after making changes
- Skip HTML files (all must be updated together)
- Modify external CDN URLs (jsdelivr, unpkg)
- Edit version numbers manually in HTML files
- Deploy JS without updating HTML versions

### ESCALATE IF

- Script reports no HTML files found
- Current version cannot be determined
- File permissions prevent updates
- Unusual CDN patterns encountered
- Webflow deployment fails

---

## 5. 🎓 SUCCESS CRITERIA

**Task complete when**:
- ✅ All HTML files have updated version parameters
- ✅ Version number has been incremented
- ✅ Summary shows files modified
- ✅ Deployment instructions provided
- ✅ Version history logged

---

## 6. 💡 EXAMPLES

### Example 1: Bug Fix in page_loader.js

**Context**: Fixed hero animation timing issue in page_loader.js

**Invocation**:
```bash
python3 .claude/skills/code-cdn-versioning/scripts/update_html_versions.py
```

**Output**:
```
🔄 Auto-incrementing to version: v1.0.2
📁 Found 18 HTML files to process
✅ global.html
  Script: page_loader.js → page_loader.js?v=1.0.2
✅ Successfully updated to version v1.0.2!
```

---

### Example 2: Major Release

**Context**: Releasing version 2.0.0 with breaking changes

**Invocation**:
```bash
python3 .claude/skills/code-cdn-versioning/scripts/update_html_versions.py 2.0.0
```

**Output**:
```
📌 Using specified version: v2.0.0
✅ Updated 18 files with 96 changes
```

---

## 7. 🔗 INTEGRATION POINTS

**Triggers**:
- "Update HTML versions"
- "I changed [script name].js"
- "Increment CDN versions"
- "Deploy JavaScript changes"

**Pairs With**:
- JavaScript modification workflows
- Webflow deployment process
- CDN cache management
- Git commit workflows

**Outputs**:
- Updated HTML files with versioned URLs
- Version history log
- Deployment instructions
- Summary of changes

---

## 8. 🎯 QUICK REFERENCE

**Key Commands**:
```bash
# Auto-increment version
python3 .claude/skills/code-cdn-versioning/scripts/update_html_versions.py

# Specific version
python3 .claude/skills/code-cdn-versioning/scripts/update_html_versions.py 1.1.0
```

**Version Format**: `MAJOR.MINOR.PATCH` (e.g., 1.0.2)

**Files Updated**:
- `/src/0_html/global.html` (CRITICAL - contains page_loader.js)
- `/src/0_html/cms/*.html`
- `/src/0_html/nobel/*.html`
- `/src/0_html/services/*.html`

**CDN Pattern**: `https://pub-85443b585f1e4411ab5cc976c4fb08ca.r2.dev`

---

## 📚 BUNDLED RESOURCES

### scripts/
- `update_html_versions.py` - Main version updater script

### references/
- `workflow_details.md` - Complete CDN versioning workflow documentation
- `troubleshooting.md` - Common issues and solutions
