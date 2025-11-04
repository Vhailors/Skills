#!/usr/bin/env python3
"""
organize_screenshots.py - Organizes screenshots for pixel-perfect site copy workflow

Creates standardized directory structure for screenshot storage and comparison:
    site-copy-[domain]/
    ├── original/
    │   ├── desktop-1440px.png
    │   ├── tablet-768px.png
    │   └── mobile-320px.png
    ├── replica/
    │   ├── desktop-1440px.png
    │   ├── tablet-768px.png
    │   └── mobile-320px.png
    └── comparison/
        ├── desktop-diff.png
        ├── tablet-diff.png
        └── mobile-diff.png

Usage:
    python organize_screenshots.py <domain> <output-dir>

Example:
    python organize_screenshots.py stripe.com ./screenshots
"""

import os
import sys
from pathlib import Path
from urllib.parse import urlparse


def create_screenshot_structure(domain: str, output_dir: str = ".") -> dict:
    """
    Create standardized screenshot directory structure

    Args:
        domain: The domain name (e.g., 'stripe.com')
        output_dir: Base output directory

    Returns:
        Dictionary with paths to created directories
    """
    # Sanitize domain name for directory
    sanitized_domain = domain.replace("https://", "").replace("http://", "")
    sanitized_domain = sanitized_domain.replace("/", "_").replace(":", "_")

    # Create base directory
    base_dir = Path(output_dir) / f"site-copy-{sanitized_domain}"

    # Create subdirectories
    dirs = {
        "base": base_dir,
        "original": base_dir / "original",
        "replica": base_dir / "replica",
        "comparison": base_dir / "comparison",
    }

    for dir_path in dirs.values():
        dir_path.mkdir(parents=True, exist_ok=True)

    # Create README with instructions
    readme_content = f"""# Screenshot Comparison for {domain}

## Directory Structure

- `original/` - Screenshots from the original site
- `replica/` - Screenshots of your implementation
- `comparison/` - Side-by-side or diff images

## Standard Breakpoints

- `desktop-1440px.png` - Desktop view (1440x900)
- `tablet-768px.png` - Tablet view (768x1024)
- `mobile-320px.png` - Mobile view (320x568)

Additional breakpoints can be added as needed.

## Comparison Workflow

1. Capture screenshots from original site → save to `original/`
2. Implement replica and capture screenshots → save to `replica/`
3. Compare side-by-side to validate pixel-perfect accuracy
4. Generate diff images (optional) → save to `comparison/`

## Quality Checklist

- [ ] Typography matches (fonts, weights, sizes, line-heights)
- [ ] Colors are exact (no approximations)
- [ ] Spacing matches at all breakpoints
- [ ] Hover/interaction states implemented
- [ ] Responsive behavior matches
- [ ] Visual equivalence confirmed
"""

    readme_path = base_dir / "README.md"
    with open(readme_path, "w") as f:
        f.write(readme_content)

    return {k: str(v) for k, v in dirs.items()}


def main():
    if len(sys.argv) < 2:
        print("Usage: python organize_screenshots.py <domain> [output-dir]")
        print("Example: python organize_screenshots.py stripe.com ./screenshots")
        sys.exit(1)

    domain = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) > 2 else "."

    print(f"📁 Creating screenshot structure for {domain}")
    dirs = create_screenshot_structure(domain, output_dir)

    print(f"\n✅ Created directories:")
    for name, path in dirs.items():
        print(f"   {name:12} → {path}")

    print(f"\n📋 Next steps:")
    print(f"   1. Capture screenshots from {domain} → save to {dirs['original']}")
    print(f"   2. Implement replica and capture screenshots → save to {dirs['replica']}")
    print(f"   3. Compare visually for pixel-perfect accuracy")


if __name__ == "__main__":
    main()
