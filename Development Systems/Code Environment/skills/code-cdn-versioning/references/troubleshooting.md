# CDN Version Updater - Troubleshooting Guide

Comprehensive solutions for common issues when using the CDN version updater script.

---

## 1. 🔧 SCRIPT EXECUTION ISSUES

### Problem: Permission Denied

**Error**: `Permission denied: update_html_versions.py`

**Solution**:
```bash
chmod +x .claude/skills/code-cdn-versioning/scripts/update_html_versions.py
```

### Problem: Python Not Found

**Error**: `python3: command not found`

**Solution**:
- Check Python installation: `which python3`
- Install if missing: `brew install python3` (macOS)
- Or use: `python` instead of `python3`

### Problem: Module Import Errors

**Error**: `ModuleNotFoundError`

**Solution**:
The script uses only Python standard library. If errors occur, check Python version:
```bash
python3 --version  # Should be 3.6+
```

---

## 2. 🔍 VERSION DETECTION ISSUES

### Problem: Cannot Find Current Version

**Symptom**: Script starts with version 1.0.1 even though files have versions

**Causes**:
- No HTML files have version parameters yet
- Version format is non-standard

**Solution**:
- Manually specify version: `python3 script.py 1.0.5`
- Check HTML files for existing version patterns

### Problem: Incorrect Version Increment

**Symptom**: Version jumps unexpectedly

**Solution**:
- Check version_history.txt for last used version
- Manually specify correct version

---

## 3. 📁 FILE PROCESSING ISSUES

### Problem: No HTML Files Found

**Error**: `No HTML files found!`

**Causes**:
- Wrong directory path
- Files in different location

**Solution**:
1. Verify path in script (line 13):
   ```python
   HTML_DIR = "/path/to/your/html/files"
   ```
2. Check files exist:
   ```bash
   ls -la /Users/michelkerkmeester/MEGA/Development/Websites/anobel.com/src/0_html/
   ```

### Problem: No Changes Made

**Message**: `All files already at version vX.X.X`

**Causes**:
- Files already have this version
- No R2 CDN scripts in files
- Scripts use different CDN pattern

**Solution**:
- Increment version and run again
- Check CDN pattern in script matches your URLs

---

## 4. 🎯 PATTERN MATCHING ISSUES

### Problem: Scripts Not Being Versioned

**Symptom**: HTML files processed but no versions added

**Causes**:
- CDN URL pattern doesn't match
- Script tags formatted differently

**Solution**:
Check your CDN pattern (line 14 in script):
```python
R2_CDN_PATTERN = "https://pub-85443b585f1e4411ab5cc976c4fb08ca.r2.dev"
```

Ensure it matches your actual URLs.

---

## 5. 🚀 DEPLOYMENT ISSUES

### Problem: Changes Not Visible After Deployment

**Symptom**: Updated versions but site shows old behavior

**Checklist**:
- [ ] JavaScript files uploaded to R2?
- [ ] HTML files uploaded to Webflow?
- [ ] Webflow site published?
- [ ] CDN cache cleared?
- [ ] Browser cache cleared (test incognito)?

**Solution**:
1. Verify file on CDN: `curl -I https://your-cdn.com/script.js?v=1.0.2`
2. Check response headers for cache settings
3. Force refresh: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)

### Problem: Webflow Not Accepting Changes

**Symptom**: Webflow shows old content after upload

**Solution**:
1. Clear Webflow cache (Settings → Hosting → Clear Cache)
2. Republish site
3. Wait 2-3 minutes for propagation

---

## 6. 🚨 EMERGENCY PROCEDURES

### Rollback to Previous Version

If new version causes issues:

**Quick Fix**: Revert HTML files
```bash
git checkout -- src/0_html/
```

**Run updater with old version**:
```bash
python3 update_html_versions.py 1.0.1  # Previous version
```

### Force Complete Refresh

For critical issues:

1. **Jump version significantly**:
   ```bash
   python3 update_html_versions.py 9.9.9
   ```

2. **Clear everything**:
   - CDN cache
   - Webflow cache
   - Browser cache

3. **Verify with curl**:
   ```bash
   curl -I "https://your-cdn.com/script.js?v=9.9.9"
   ```

---

## 7. ✅ VALIDATION CHECKS

### Verify Version Applied

```bash
# Check a specific file
grep "?v=" src/0_html/global.html

# Check all files
grep -r "page_loader.js" src/0_html/ | grep -o "v=[0-9.]*"
```

### Verify All Files Updated

```bash
# Count versioned scripts
grep -r "?v=1.0.2" src/0_html/ | wc -l

# Should match expected number of script references
```

### Check Version Consistency

```bash
# Find all unique versions (should be one)
grep -r "?v=" src/0_html/ | grep -o "v=[0-9.]*" | sort | uniq
```

---

## 8. 🆘 GETTING HELP

### Diagnostic Steps

If issues persist:

1. **Check version history**:
   ```bash
   cat .claude/skills/code-cdn-versioning/version_history.txt
   ```

2. **Review script output** carefully for specific error messages

3. **Verify file permissions**:
   ```bash
   ls -la src/0_html/
   ```

4. **Test with single file** first:
   ```bash
   # Modify script temporarily to test one file
   html_files = ['src/0_html/global.html']  # Line 80
   ```

5. **Enable debug output** by adding to script:
   ```python
   print(f"DEBUG: Processing {filepath}")
   print(f"DEBUG: Found pattern: {match.group()}")
   ```

---

**For Additional Support**: Review `workflow_details.md` for complete system documentation and `SKILL.md` for usage instructions.
