# Puppeteer-Based Style Extraction Guide

## Overview

This guide explains how the automated Puppeteer-based style extraction works and how to use it effectively for pixel-perfect site copying.

## Why Puppeteer Over Chrome DevTools MCP?

**Chrome DevTools MCP Issues** (as of November 2025):
- Broken stdio implementation in versions 0.8.0-0.9.0
- Does not respond to initialize requests
- Requires complex WSL2 configuration workarounds
- Connection failures and timeout issues

**Puppeteer Advantages**:
- ✅ Reliable headless Chrome automation
- ✅ Direct programmatic access to computed styles
- ✅ Full control over extraction logic
- ✅ Works seamlessly in WSL2 environment
- ✅ Self-contained solution (no external MCP server dependencies)
- ✅ Automated screenshot capture at multiple breakpoints
- ✅ Generates structured JSON output for programmatic use

## How It Works

### 1. Automated Extraction Process

The `extract-styles.js` script performs the following steps:

```javascript
// 1. Launch headless Chrome
const browser = await puppeteer.launch({ headless: 'new' });

// 2. For each breakpoint (mobile, tablet, desktop):
//    - Create new page with specific viewport
//    - Navigate to target URL
//    - Wait for full page load (networkidle2)
//    - Extract computed styles using page.evaluate()
//    - Capture full-page screenshot
//    - Save data to JSON file

// 3. Generate comprehensive outputs:
//    - STYLE_GUIDE.md (human-readable)
//    - complete-extraction.json (full data)
//    - README.md (workflow instructions)
```

### 2. Breakpoints

The script analyzes sites at **6 standard breakpoints**:

| Breakpoint | Width | Height | Use Case |
|------------|-------|--------|----------|
| mobile | 320px | 568px | iPhone SE, small phones |
| mobile-large | 375px | 667px | iPhone 6/7/8, standard phones |
| tablet | 768px | 1024px | iPad portrait, tablets |
| desktop | 1024px | 768px | Small laptops, iPad landscape |
| desktop-large | 1440px | 900px | Standard desktop monitors |
| desktop-xl | 1920px | 1080px | Large desktop monitors, Full HD |

### 3. Extracted Properties

For each significant element on the page, the script extracts:

**Typography**:
- `font-family`, `font-size`, `font-weight`
- `line-height`, `letter-spacing`
- `text-align`, `text-transform`, `text-decoration`

**Colors**:
- `color`, `background-color`, `border-color`
- `opacity` (with alpha channel support)

**Box Model**:
- `width`, `height`
- `margin`, `margin-top/right/bottom/left`
- `padding`, `padding-top/right/bottom/left`
- `border`, `border-width`, `border-style`, `border-radius`

**Layout**:
- `display`, `position`, `top/right/bottom/left`, `z-index`
- Flexbox: `flex-direction`, `flex-wrap`, `justify-content`, `align-items`, `gap`
- Grid: `grid-template-columns`, `grid-template-rows`, `grid-gap`

**Visual Effects**:
- `box-shadow`, `text-shadow`
- `filter`, `backdrop-filter`
- `transform`, `transition`, `animation`

### 4. Output Structure

```
site-copy-<domain>/
├── STYLE_GUIDE.md              # Human-readable style guide
│   ├── Color Palette (hex codes)
│   ├── Typography (fonts, sizes)
│   ├── Spacing System (detected values)
│   ├── Shadows & Elevation
│   └── Responsive Breakpoints
│
├── README.md                   # Workflow instructions
│
├── original/                   # Original site screenshots
│   ├── mobile-320px.png
│   ├── mobile-large-375px.png
│   ├── tablet-768px.png
│   ├── desktop-1024px.png
│   ├── desktop-large-1440px.png
│   └── desktop-xl-1920px.png
│
├── data/                       # Extracted style data (JSON)
│   ├── complete-extraction.json
│   ├── mobile-styles.json
│   ├── mobile-large-styles.json
│   ├── tablet-styles.json
│   ├── desktop-styles.json
│   ├── desktop-large-styles.json
│   └── desktop-xl-styles.json
│
├── replica/                    # Your implementation screenshots (empty initially)
└── comparison/                 # Comparison notes (empty initially)
```

## Usage Examples

### Basic Usage

```bash
cd /path/to/developer-skills-plugin/skills/pixel-perfect-site-copy
node scripts/extract-styles.js https://example.com
```

Creates: `./site-copy-example.com/` with all extracted data

### Custom Output Directory

```bash
node scripts/extract-styles.js https://stripe.com ./my-stripe-clone
```

Creates: `./my-stripe-clone/` with all extracted data

### Integration with Superflow

When the user says "copy site google.com", the superflow should:

1. **Run extraction**:
   ```bash
   node scripts/extract-styles.js https://google.com
   ```

2. **Review generated STYLE_GUIDE.md**:
   - Read the color palette
   - Identify font families
   - Note spacing system values
   - Check for shadows and effects

3. **Analyze component-level data**:
   - Open `data/complete-extraction.json`
   - Identify key components (header, nav, buttons, etc.)
   - Extract exact style values for each

4. **Implement using extracted data**:
   - Build HTML structure matching original
   - Apply Tailwind classes based on extracted styles
   - Use inline styles for exact values not in Tailwind
   - Reference screenshots for visual validation

5. **Validate pixel-perfect quality**:
   - Take screenshots of implementation
   - Save to `replica/` directory
   - Compare side-by-side with `original/`
   - Document any differences in `comparison/notes.md`

## Data Format

### STYLE_GUIDE.md Structure

```markdown
# Style Guide: <domain>

**Source**: <url>
**Extracted**: <timestamp>

## Color Palette
- #1a0dab - rgb(26, 13, 171)
- #ffffff - rgb(255, 255, 255)
...

## Typography
### Font Families
- Arial, sans-serif
- "Google Sans Text", Roboto, Helvetica, Arial, sans-serif
...

## Spacing System
Detected spacing values:
- 0px
- 4px
- 8px
- 16px
- 32px
...

## Shadows & Elevation
### Shadow 1
```css
box-shadow: 0 2px 4px rgba(0,0,0,0.1);
```
...

## Responsive Breakpoints
- **mobile**: 320x568px
- **tablet**: 768x1024px
- **desktop-large**: 1440x900px
...
```

### JSON Data Structure

```json
{
  "url": "https://example.com",
  "title": "Example Site",
  "viewport": { "width": 1440, "height": 900 },
  "breakpoint": "desktop-large",
  "components": [
    {
      "index": 0,
      "tag": "header",
      "id": "main-header",
      "classes": ["header", "sticky"],
      "text": "Navigation Menu",
      "styles": {
        "background-color": "rgb(255, 255, 255)",
        "box-shadow": "rgba(0, 0, 0, 0.1) 0px 2px 4px 0px",
        "display": "flex",
        "justify-content": "space-between",
        "padding": "16px 32px",
        "position": "sticky",
        "top": "0px",
        "z-index": "1000"
      },
      "boundingBox": {
        "x": 0, "y": 0,
        "width": 1440, "height": 64
      }
    }
  ],
  "colors": ["rgb(255, 255, 255)", "rgb(0, 0, 0)"],
  "fonts": ["Arial, sans-serif"],
  "spacing": ["0px", "4px", "8px", "16px", "32px"],
  "shadows": ["rgba(0, 0, 0, 0.1) 0px 2px 4px 0px"]
}
```

## Best Practices

### 1. Always Run Fresh Extraction

Don't reuse old extraction data. Websites update frequently:
```bash
# Good - Fresh extraction every time
node scripts/extract-styles.js https://site.com

# Bad - Using old data from previous extraction
# (stale colors, fonts, spacing)
```

### 2. Review All Breakpoints

Don't just check desktop. Responsive design is critical:
```bash
# Review screenshots at ALL breakpoints:
ls -lh site-copy-example.com/original/
# Check mobile-320px.png
# Check tablet-768px.png
# Check desktop-large-1440px.png
```

### 3. Cross-Reference JSON and Style Guide

The style guide is human-readable, but JSON has complete detail:
```bash
# Read style guide for overview
cat site-copy-example.com/STYLE_GUIDE.md

# Check JSON for exact component styles
jq '.components[] | select(.tag == "button")' site-copy-example.com/data/complete-extraction.json
```

### 4. Validate Screenshots Visually

Automated extraction is accurate, but always visually verify:
- Open `original/desktop-large-1440px.png`
- Compare against live site in browser
- Confirm extraction captured the current design

### 5. Document Deviations

If you can't replicate something exactly, document why:
```markdown
# comparison/notes.md

## Deviations from Original

### Custom Font Not Available
- **Original**: "CustomFont-Bold" proprietary font
- **Replica**: "Inter-Bold" from Google Fonts (closest match)
- **Reason**: Custom font not publicly available

### Animation Timing
- **Original**: Complex JavaScript-based animation
- **Replica**: Simplified Tailwind transition
- **Reason**: Preserving no-JavaScript requirement
```

## Troubleshooting

### Script Times Out

**Problem**: Page takes too long to load
```
Error: Navigation timeout of 30000 ms exceeded
```

**Solution**: Increase timeout or wait condition
```javascript
// In extract-styles.js, modify:
await page.goto(url, {
  waitUntil: 'domcontentloaded',  // Less strict
  timeout: 60000                  // Longer timeout
});
```

### Missing Styles

**Problem**: Extracted data seems incomplete

**Solution**: Check element selectors in script
```javascript
// In extract-styles.js, add custom selectors:
const selectors = [
  'header', 'nav', 'main', 'footer',
  '.your-custom-class',  // Add this
  '[data-component="hero"]'  // Or this
];
```

### Screenshots Are Blank

**Problem**: Screenshots show blank/white pages

**Solution**: Wait for content to load
```javascript
// In extract-styles.js, add wait:
await page.goto(url, { waitUntil: 'networkidle2' });
await page.waitForSelector('body', { visible: true });
// Then take screenshot
```

### RGB to Hex Conversion Issues

**Problem**: Colors in style guide don't match visual appearance

**Solution**: Use extracted RGB values directly, or verify hex conversion
```javascript
// Script automatically converts RGB to Hex
// If needed, manually verify:
const hex = rgbToHex('rgb(26, 13, 171)');
// Result: #1a0dab
```

## Integration with Superflow Workflow

The Puppeteer extraction script is **Phase 1** of the pixel-perfect superflow:

**Phase 1: Automated Extraction** (Puppeteer script)
- ✅ Extract styles
- ✅ Capture screenshots
- ✅ Generate style guide

**Phase 2: Implementation** (Manual)
- Build HTML/Tailwind replica
- Match extracted styles exactly
- Reference screenshots continuously

**Phase 3: Validation** (Manual + Automated)
- Take replica screenshots
- Compare against originals
- Document differences

**Phase 4: Delivery** (Manual)
- Package style guide
- Include implementation
- Add comparison notes

## Future Enhancements

Potential improvements to the extraction script:

1. **Hover State Extraction**
   - Programmatically trigger hover states
   - Capture style changes

2. **Animation Analysis**
   - Detect CSS animations
   - Extract keyframe definitions
   - Document transition properties

3. **Interactive Element Testing**
   - Click buttons, open modals
   - Extract dynamic state styles

4. **Font File Download**
   - Detect custom fonts
   - Download WOFF/WOFF2 files
   - Include in output directory

5. **Comparison Mode**
   - Load original and replica
   - Automated visual diff
   - Highlight discrepancies

## Conclusion

The Puppeteer-based extraction script provides:
- ✅ Reliable, automated style extraction
- ✅ No dependency on broken MCP servers
- ✅ Comprehensive multi-breakpoint analysis
- ✅ Structured, usable output (MD + JSON)
- ✅ Foundation for pixel-perfect replication

This approach is now the **primary method** for pixel-perfect site copying in the developer-skills superflow system.
