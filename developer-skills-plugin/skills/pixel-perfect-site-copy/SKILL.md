---
name: pixel-perfect-site-copy
description: This skill should be used when the user requests to copy, clone, or replicate a website with pixel-perfect accuracy. Triggered by phrases like "copy site", "clone website", "replicate this page", or "pixel-perfect copy". Uses Chrome DevTools MCP to extract styling and creates comprehensive style guides for exact visual reproduction.
---

# Pixel-Perfect Site Copy

## Overview

This skill enables exact replication of websites by extracting complete styling information using Chrome DevTools MCP and generating comprehensive style guides that ensure pixel-perfect, preset-perfect quality.

## When to Use This Skill

Invoke this skill when the user requests:
- "Copy this site"
- "Clone [URL] pixel-perfect"
- "Replicate this website exactly"
- "Create a pixel-perfect copy of [URL]"
- "Extract all styling from this page"

This skill is specifically designed for visual replication tasks that require exact matching of:
- Typography (fonts, weights, sizes, spacing)
- Colors (including hover states and interactions)
- Layout and spacing
- Shadows and visual effects
- Animations and transitions
- Responsive behavior

## Prerequisites

Before starting, verify that Chrome DevTools MCP is available:
- The `chrome-devtools` MCP server must be configured in the plugin's `.mcp.json`
- MCP tools for inspecting elements, extracting styles, and capturing screenshots should be accessible
- Run verification script: `bash hooks/scripts/verify-chrome-devtools-mcp.sh` to check configuration
- If MCP is not available, inform the user that this skill requires Chrome DevTools MCP integration

**Verification Step**: Always run the MCP verification before proceeding with the workflow to avoid runtime failures.

## Workflow

Follow this complete workflow for pixel-perfect site replication:

### Phase 1: Site Inspection and Style Extraction

1. **Open target site in Chrome DevTools MCP**
   - Use Chrome DevTools MCP to connect to the target URL
   - Verify page loads completely before inspection

2. **Extract computed styles systematically**
   - Use DevTools MCP to inspect each major component (header, navigation, hero, content sections, footer)
   - For each component, extract:
     - Typography: font-family, font-weight, font-size, line-height, letter-spacing
     - Colors: background-color, color, border-color (including hover/active states)
     - Spacing: margin, padding, gap (for flexbox/grid)
     - Layout: display, flex properties, grid properties, position values
     - Visual effects: box-shadow, border-radius, opacity, filters
     - Animations: transition properties, animation keyframes, transform values
   - Use the "Computed" tab in DevTools to get final rendered values, not authored CSS
   - Document responsive behavior by checking styles at breakpoints: 320px, 768px, 1024px, 1440px

3. **Organize screenshot storage**
   - Run: `python scripts/organize_screenshots.py <domain>` to create standardized directory structure
   - This creates: `site-copy-<domain>/original/`, `replica/`, `comparison/` directories
   - Standardized naming: `desktop-1440px.png`, `tablet-768px.png`, `mobile-320px.png`

4. **Capture visual screenshots**
   - Use Chrome DevTools Device Toolbar to capture screenshots at common breakpoints
   - Take full-page screenshots for complete visual reference
   - Save to `site-copy-<domain>/original/` directory with standardized names
   - Capture at breakpoints: 320px, 768px, 1024px, 1440px minimum
   - **Critical**: These screenshots are the source of truth for pixel-perfect comparison

5. **Document layout structure**
   - Map the DOM hierarchy and semantic HTML structure
   - Identify layout systems used (flexbox, grid, etc.)
   - Note container relationships and nesting depth

### Phase 2: Style Guide Generation

1. **Read the style guide template**
   - Load `references/style-guide-template.md` to understand the 17 required sections
   - Load `references/design-quality-standards.md` for quality requirements

2. **Generate comprehensive style guide**
   - Create STYLE_GUIDE.md in the project root or /docs folder
   - Complete all 17 sections with extracted values (not placeholders):
     1. Overview
     2. Color Palette (exact hex codes, hover states)
     3. Typography (exact fonts, weights, sizes, line-heights)
     4. Spacing System (measured values from DevTools)
     5. Component Styles (buttons, inputs, cards, etc.)
     6. Shadows & Elevation (exact box-shadow values)
     7. Animations & Transitions (durations, timing functions)
     8. Border Radius (measured values)
     9. Opacity & Transparency
     10. Icons (system used, sizing guidelines)
     11. Design Style Guidelines
     12. Common Tailwind CSS Usage
     13. Responsive Design (breakpoints, mobile-first approach)
     14. Images & Media
     15. Charts & Data Visualization (if applicable)
     16. Code Structure & Implementation
     17. Example Component Reference Design Code

3. **Ensure all values are specific and measured**
   - Replace any TODO or placeholder values with actual extracted data
   - Include code examples showing how to implement common patterns
   - Document edge cases and special considerations

### Phase 3: Implementation

1. **Implement the replica using Tailwind CSS**
   - Create a single HTML file with complete markup
   - Use Tailwind utility classes for all styling
   - Use inline style attributes only when Tailwind doesn't provide the exact value needed
   - Include html, head, and body tags for a complete valid document
   - Use Lucide icons with 1.5 strokeWidth if icons are needed
   - Use Unsplash for placeholder images if originals can't be extracted

2. **Follow code structure standards**
   - Single code block containing complete HTML
   - Semantic HTML structure (header, nav, main, section, article, footer)
   - Responsive by default (mobile-first approach)
   - Do NOT use JavaScript for animations - use Tailwind transition/animation classes
   - Do NOT put Tailwind classes in the html tag - use body tag instead

3. **Implement responsive behavior**
   - Use Tailwind responsive prefixes (sm:, md:, lg:, xl:, 2xl:)
   - Match breakpoint behavior documented in style guide
   - Test at intermediate sizes, not just exact breakpoints

### Phase 4: Quality Assurance

1. **Capture replica screenshots**
   - Open your implemented HTML in browser
   - Capture screenshots at the same breakpoints used for original
   - Save to `site-copy-<domain>/replica/` directory with matching names
   - Use identical viewport dimensions as original captures

2. **Visual comparison**
   - Open `site-copy-<domain>/original/` and `replica/` directories side-by-side
   - Compare screenshots at each breakpoint systematically
   - Verify fonts match (family, weight, size, spacing) - pixel by pixel
   - Confirm colors are exact (use hex codes from style guide)
   - Check spacing matches at all breakpoints (margin, padding, gap)
   - Validate hover and interaction states
   - Test responsive behavior at intermediate sizes (not just exact breakpoints)

3. **Pixel-perfect validation**
   - Overlay screenshots if possible to check alignment
   - Verify line-heights produce identical text flow (no text wrapping differences)
   - Confirm shadow blur, spread, and offset values match visually
   - Check border radius values on all elements (no sharp corners where there should be rounded)
   - Validate animation timing and easing functions by testing interactions
   - **Use extended thinking** to analyze subtle differences and reason about their causes

4. **Quality standards checklist**
   - [ ] Typography is exact (fonts, weights, sizes, line-heights)
   - [ ] Colors are exact hex values (no approximations)
   - [ ] Spacing matches computed values from DevTools
   - [ ] Layout structure mirrors the original
   - [ ] Responsive behavior matches at all breakpoints
   - [ ] Hover/interaction states are implemented
   - [ ] Animations use Tailwind (no JavaScript)
   - [ ] Code is clean, semantic, and accessible
   - [ ] Screenshots show visual equivalence (original vs replica)
   - [ ] All screenshots saved to organized directory structure

5. **Documentation of comparison**
   - Create comparison notes in `site-copy-<domain>/comparison/notes.md`
   - Document any unavoidable differences (e.g., fonts not publicly available)
   - Note implementation challenges and solutions
   - Include side-by-side screenshot comparisons if differences exist

## Quality Standards

### Pixel-Perfect Mindset
The goal is not "looks similar" - the goal is "indistinguishable from the original". Every pixel, every font weight, every spacing value must be intentional and measured.

❌ **Wrong**: "This looks about right"
✅ **Correct**: "This matches the computed value of 16.8px line-height from DevTools"

❌ **Wrong**: "The spacing feels good"
✅ **Correct**: "The margin-bottom is 24px as extracted from DevTools Computed tab"

❌ **Wrong**: "It's close enough"
✅ **Correct**: "It's pixel-perfect"

### When to Use Extended Thinking

Extended thinking is **automatically enabled** for this superflow to ensure pixel-perfect quality. Use it especially for:

**During Style Extraction**:
- Complex visual hierarchies requiring careful analysis of layering and z-index
- Unclear measurements that need comparison against screenshots
- Nested layout systems (flex within grid, etc.) requiring reasoning about relationships
- Font weight determination when visual appearance is ambiguous

**During Implementation**:
- Responsive behavior logic that must be reasoned through
- Complex spacing calculations (negative margins, overlapping elements)
- Shadow and gradient replication requiring multiple iterations
- Animation timing that requires precise easing function selection

**During Quality Assurance**:
- Analyzing subtle visual differences between original and replica
- Reasoning about why spacing doesn't match and how to fix it
- Color contrast validation for WCAG compliance
- Accessibility considerations and semantic HTML structure
- Validating that text flow matches exactly (line breaks, widows/orphans)

**When to explicitly request extended thinking**: If you notice the implementation is "close but not quite" pixel-perfect, explicitly enable extended thinking to analyze the differences systematically.

## Key Principles

1. **Measure, don't estimate** - Always use DevTools Computed values
2. **Extract, don't approximate** - Copy exact values, not visual guesses
3. **Compare, don't assume** - Always validate against screenshots
4. **Document, don't omit** - Include all details in the style guide
5. **Replicate, don't redesign** - Preserve the original design choices

## Resources

### Reference Files
- **Style Guide Template**: `references/style-guide-template.md` - Complete template with 17 required sections
- **Quality Standards**: `references/design-quality-standards.md` - Detailed quality requirements and workflows

### Utility Scripts
- **Screenshot Organization**: `scripts/organize_screenshots.py` - Creates standardized directory structure for screenshot storage
  - Usage: `python scripts/organize_screenshots.py <domain> [output-dir]`
  - Creates: `site-copy-<domain>/original/`, `replica/`, `comparison/` directories
  - Includes README with workflow instructions

### Verification Scripts
- **MCP Verification**: `hooks/scripts/verify-chrome-devtools-mcp.sh` - Verifies Chrome DevTools MCP is configured
  - Run this first to avoid workflow failures
  - Checks `.mcp.json` for chrome-devtools configuration

## Output Deliverables

When completing a pixel-perfect site copy task, deliver:

1. **STYLE_GUIDE.md** - Comprehensive 17-section style guide with extracted values
2. **index.html** (or equivalent) - Complete HTML/Tailwind implementation
3. **Screenshots** - Visual comparison showing original vs. replica
4. **Documentation** - Notes on any challenges, limitations, or deviations from the original

## Example Usage

**User**: "Copy this site: https://stripe.com"

**Response**:
1. Connect to https://stripe.com using Chrome DevTools MCP
2. Extract computed styles for header, navigation, hero section, feature cards, footer
3. Capture screenshots at 320px, 768px, 1440px breakpoints
4. Generate STYLE_GUIDE.md with 17 sections populated with Stripe's design system
5. Implement pixel-perfect replica using Tailwind CSS
6. Validate visual equivalence against screenshots
7. Deliver complete package with style guide, implementation, and comparison screenshots

The result will be indistinguishable from the original Stripe homepage with every font, color, spacing, and interaction replicated exactly.
