# CDN Versioning - Workflow Details

Complete technical documentation for the CDN version management system that ensures JavaScript changes reach users through browser cache invalidation.

---

## 1. 🎯 WHY VERSION NUMBERS ARE CRITICAL

### The Problem with Static Storage

Cloudflare R2 is a static object storage service. Unlike intelligent CDNs, it doesn't understand:
- File updates
- Cache invalidation signals
- Version management

### Browser Caching Behavior

Without version parameters in URLs, browsers will cache JavaScript files indefinitely based on:
- Browser cache settings (can be weeks/months)
- CDN edge cache (24-48 hours typically)
- Local storage policies

### The Version Parameter Solution

By adding `?v=1.0.2` to URLs, we create a **different URL** from the browser's perspective:
- `page_loader.js` → Cached, old version
- `page_loader.js?v=1.0.2` → New URL, forces fresh download

---

## 2. 📁 FILES THAT NEED VERSIONING

### JavaScript Files on R2 CDN

All files hosted at: `https://pub-85443b585f1e4411ab5cc976c4fb08ca.r2.dev/`

**Core Scripts**:
- `page_loader.js` - Page loading animations
- `hero_general.js` - Hero section animations
- `hero_video.js` - Video hero functionality
- `hero_cards.js` - Card animations
- `dropdown.js` - Navigation dropdowns
- `mobile_menu.js` - Mobile navigation

**Feature Scripts**:
- `modal_cookie_consent.js` - Cookie consent modal
- `modal_welcome.js` - Welcome modal
- `form_validation.js` - Form validation
- `form_submission.js` - Form handling
- `marquee_brands.js` - Brand marquee

### HTML File Structure

The project uses a specific directory structure:

```
/src/0_html/
├── global.html (CRITICAL - loaded on every page)
├── home.html
├── contact.html
├── terms_and_services.html
├── cms/
│   ├── blog.html
│   ├── blog_post.html
│   ├── careers.html
│   └── careers_vacancy.html
├── nobel/
│   ├── n1_nobel.html
│   ├── n2_isps.html
│   ├── n3_location.html
│   ├── n4_team.html
│   └── n5_brochures.html
└── services/
    ├── d1_bunkering.html
    ├── d2_filtration.html
    ├── d3_ship_store.html
    ├── d4_custom_solutions.html
    └── d5_webshop.html
```

---

## 3. 🔢 VERSION NUMBERING STRATEGY

### Semantic Versioning (MAJOR.MINOR.PATCH)

**PATCH** (x.x.Z): Bug fixes, small tweaks
- Example: 1.0.1 → 1.0.2
- Use: Default auto-increment

**MINOR** (x.Y.x): New features, non-breaking changes
- Example: 1.0.2 → 1.1.0
- Use: Manual specification

**MAJOR** (X.x.x): Breaking changes, major refactors
- Example: 1.1.0 → 2.0.0
- Use: Manual specification

### Emergency Versioning

For critical fixes that need immediate cache-busting:
- Jump versions significantly: 1.0.2 → 1.0.99
- Ensures all caches are bypassed
- Document reason in version history

---

## 4. 🚀 DEPLOYMENT SEQUENCE

### Correct Order

1. **Modify JavaScript** → Test locally if possible
2. **Run version updater** → Updates all HTML files
3. **Upload JavaScript to R2** → Via Cloudflare dashboard or CLI
4. **Upload HTML to Webflow** → All files must be updated
5. **Clear CDN cache** → If using Cloudflare CDN in front of R2
6. **Publish Webflow** → Makes changes live

### Critical Points

- **Never** upload JS without updating HTML versions
- **Never** update only some HTML files
- **Always** verify version increment before deployment
- **Always** clear CDN cache for emergency fixes

---

## 5. 🔧 COMMON ISSUES AND SOLUTIONS

### Issue: Changes Not Appearing

**Symptoms**: JavaScript changes don't show on live site

**Causes**:
1. HTML versions not updated
2. CDN cache not cleared
3. Browser cache not refreshed

**Solution**:
1. Run version updater
2. Clear CDN cache
3. Test in incognito mode

### Issue: Partial Updates

**Symptoms**: Some pages show new behavior, others don't

**Cause**: Not all HTML files were updated

**Solution**: Run version updater to update ALL files

### Issue: Version Conflicts

**Symptoms**: Mixed behavior, console errors

**Cause**: Different versions across files

**Solution**: Run updater with specific version to sync all files

---

## 6. 🔗 INTEGRATION WITH WEBFLOW

### The Gap This Skill Fills

Webflow doesn't have built-in version management for external scripts. This skill bridges that gap by:

1. Maintaining version consistency across all pages
2. Providing clear deployment instructions
3. Tracking version history
4. Automating the tedious manual update process

---

## 7. ✅ BEST PRACTICES

### Versioning Guidelines

1. **Always increment** for any change, no matter how small
2. **Use patch versions** for bug fixes (auto-increment)
3. **Use minor versions** for new features (manual)
4. **Use major versions** for breaking changes (manual)
5. **Document** significant changes in commit messages
6. **Test** in incognito/private browsing after deployment
7. **Monitor** console for any loading errors

---

**For Reference**: This document provides complete technical details for the CDN versioning workflow. See `troubleshooting.md` for specific problem resolution and `SKILL.md` for usage instructions.
