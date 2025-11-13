#!/usr/bin/env python3
"""
Script to add version numbers to all script and preload references in HTML files
Part of the CDN Version Updater skill
"""

import os
import re
import glob
import sys
from datetime import datetime

# Configuration
PROJECT_ROOT = "/Users/USERNAME/projects/your-project"
HTML_DIR = os.path.join(PROJECT_ROOT, "src/0_html")
R2_CDN_PATTERN = "https://pub-85443b585f1e4411ab5cc976c4fb08ca.r2.dev"

def get_next_version(current_version=None):
    """Generate next version number based on semantic versioning"""
    if not current_version:
        # Try to find current version from any HTML file
        current_version = find_current_version()

    if current_version:
        # Parse version (e.g., "1.0.1")
        parts = current_version.split('.')
        if len(parts) == 3:
            major, minor, patch = parts
            # Increment patch version by default
            return f"{major}.{minor}.{int(patch) + 1}"

    # Default starting version
    return "1.0.1"

def find_current_version():
    """Find the current version from HTML files"""
    html_files = glob.glob(os.path.join(HTML_DIR, "**/*.html"), recursive=True)

    for filepath in html_files:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            # Look for version pattern
            match = re.search(r'\?v=(\d+\.\d+\.\d+)', content)
            if match:
                return match.group(1)

    return None

def add_version_to_url(url, version):
    """Add or update version parameter to URL"""
    # Remove existing version parameter if present
    url = re.sub(r'\?v=[\d\.]+', '', url)

    # Skip external CDNs (only process R2 CDN URLs)
    if R2_CDN_PATTERN not in url:
        return url

    # Add new version parameter
    return f"{url}?v={version}"

def process_html_file(filepath, version):
    """Process a single HTML file to add/update version numbers"""

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    changes_made = []

    # Pattern 1: Update <link rel="preload" href="https://pub-..."> tags
    preload_pattern = r'(<link\s+rel="preload"\s+href=")(' + re.escape(R2_CDN_PATTERN) + r'/[^"]+\.js)(?:\?v=[\d\.]+)?(")'

    def replace_preload(match):
        prefix = match.group(1)
        url = match.group(2)
        suffix = match.group(3)
        new_url = add_version_to_url(url, version)
        if url != new_url or match.group(0).find('?v=') == -1:
            changes_made.append(f"  Preload: {url.split('/')[-1]} → {new_url.split('/')[-1]}")
        return prefix + new_url + suffix

    content = re.sub(preload_pattern, replace_preload, content)

    # Pattern 2: Update <script src="https://pub-..."> tags
    script_pattern = r'(<script\s+src=")(' + re.escape(R2_CDN_PATTERN) + r'/[^"]+\.js)(?:\?v=[\d\.]+)?(")'

    def replace_script(match):
        prefix = match.group(1)
        url = match.group(2)
        suffix = match.group(3)
        new_url = add_version_to_url(url, version)
        if url != new_url or match.group(0).find('?v=') == -1:
            changes_made.append(f"  Script: {url.split('/')[-1]} → {new_url.split('/')[-1]}")
        return prefix + new_url + suffix

    content = re.sub(script_pattern, replace_script, content)

    # Only write if changes were made
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return changes_made

    return None

def main():
    """Process all HTML files"""
    # Determine version
    if len(sys.argv) > 1:
        version = sys.argv[1]
        print(f"📌 Using specified version: v{version}")
    else:
        version = get_next_version()
        print(f"🔄 Auto-incrementing to version: v{version}")

    print(f"🚀 Updating HTML files in {HTML_DIR}")
    print("=" * 60)

    # Find all HTML files
    html_files = glob.glob(os.path.join(HTML_DIR, "**/*.html"), recursive=True)

    if not html_files:
        print("❌ No HTML files found!")
        return 1

    print(f"📁 Found {len(html_files)} HTML files to process\n")

    total_changes = 0
    files_modified = []

    for filepath in sorted(html_files):
        relative_path = os.path.relpath(filepath, HTML_DIR)
        changes = process_html_file(filepath, version)

        if changes:
            print(f"✅ {relative_path}")
            for change in changes:
                print(change)
            print()
            files_modified.append(relative_path)
            total_changes += len(changes)
        else:
            print(f"⏭️  {relative_path} (already at v{version} or no R2 scripts)")

    print("=" * 60)
    print(f"\n📊 Summary:")
    print(f"  - Files processed: {len(html_files)}")
    print(f"  - Files modified: {len(files_modified)}")
    print(f"  - Total changes: {total_changes}")
    print(f"  - Version applied: v{version}")

    if files_modified:
        print(f"\n✅ Successfully updated to version v{version}!")
        print("\n📝 Modified files:")
        for file in files_modified:
            print(f"  - {file}")

        print("\n🎯 Next steps:")
        print("  1. Upload modified JavaScript files to Cloudflare R2")
        print("  2. Upload these HTML files to Webflow")
        print("  3. Clear CDN cache if needed")
        print("  4. Publish Webflow site")
    else:
        print(f"\n✅ All files already at version v{version}")

    # Save version to history
    history_file = os.path.join(PROJECT_ROOT, ".claude/skills/code-cdn-versioning/version_history.txt")
    os.makedirs(os.path.dirname(history_file), exist_ok=True)
    with open(history_file, 'a') as f:
        f.write(f"{datetime.now().isoformat()} - v{version} - {total_changes} changes\n")

    return 0

if __name__ == "__main__":
    sys.exit(main())