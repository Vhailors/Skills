# Chrome DevTools MCP Setup

This guide explains how to configure and use the Chrome DevTools MCP integration for the pixel-perfect site copy superflow.

## Overview

The Chrome DevTools MCP integration enables the pixel-perfect-site-copy superflow to:
- Connect to websites and extract computed styles from Chrome DevTools
- Capture screenshots at various breakpoints for visual comparison
- Inspect DOM structure and element properties
- Document responsive behavior and layout systems

This integration is **required** for the pixel-perfect site copy superflow to function.

## Installation

### Prerequisites

- Node.js installed (v16+ recommended)
- npm or npx available
- Internet connection (for npx to fetch packages)

### Configuration

The Chrome DevTools MCP server is already configured in the plugin's `.mcp.json` file:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": [
        "-y",
        "chrome-devtools-mcp"
      ]
    }
  }
}
```

### Verification

To verify the Chrome DevTools MCP is properly configured:

1. Check that `.mcp.json` contains the `chrome-devtools` server configuration
2. Ensure npx is available: `npx --version`
3. The MCP server will be started automatically when Claude Code loads the plugin

## Usage

### When the Superflow Activates

The pixel-perfect-site-copy superflow automatically activates when you use phrases like:
- "Copy this site: [URL]"
- "Clone [URL] pixel-perfect"
- "Replicate this website exactly"
- "Extract all styling from this page"

### What the MCP Enables

Once activated, the superflow uses Chrome DevTools MCP to:

1. **Connect to Target URL**
   - Opens the specified website in Chrome DevTools
   - Waits for complete page load
   - Verifies page is ready for inspection

2. **Extract Computed Styles**
   - Inspects each major component (header, nav, hero, sections, footer)
   - Extracts computed values for:
     - Typography (font-family, font-weight, font-size, line-height, letter-spacing)
     - Colors (background, text, borders, including hover/active states)
     - Spacing (margin, padding, gap)
     - Layout (display, flex/grid properties, position)
     - Visual effects (box-shadow, border-radius, opacity, filters)
     - Animations (transitions, keyframes, transforms)

3. **Capture Screenshots**
   - Takes screenshots at common breakpoints: 320px, 768px, 1024px, 1440px, 1920px
   - Captures full-page screenshots for complete visual reference
   - Saves screenshots for comparison during implementation

4. **Document Layout Structure**
   - Maps DOM hierarchy and semantic HTML
   - Identifies layout systems (flexbox, grid, float, position)
   - Notes container relationships and nesting depth

## Workflow Example

**User**: "Copy this site: https://stripe.com"

**Behind the scenes**:
1. Superflow detects "copy this site" keyword → activates pixel-perfect-site-copy
2. Skill invocation loads SKILL.md with complete workflow
3. Chrome DevTools MCP connects to https://stripe.com
4. Extracts computed styles for all major components
5. Captures screenshots at breakpoints
6. Generates STYLE_GUIDE.md with 17 sections
7. Implements pixel-perfect replica using Tailwind CSS
8. Validates against screenshots

## Troubleshooting

### MCP Not Available

**Error**: "This workflow requires Chrome DevTools MCP. Please configure it in .mcp.json"

**Solution**:
1. Verify `.mcp.json` exists in plugin root: `/path/to/developer-skills-plugin/.mcp.json`
2. Confirm the `chrome-devtools` entry exists in `mcpServers`
3. Check npx is available: `npx --version`
4. Restart Claude Code to reload MCP configuration

### Connection Timeouts

**Error**: Timeout when connecting to target URL

**Solution**:
1. Verify target URL is accessible in your browser
2. Check for network/firewall restrictions
3. Try with a simpler page first to verify MCP works
4. Increase timeout if needed (edit hook timeout in `hooks.json`)

### Incomplete Style Extraction

**Issue**: Some styles are missing or incorrect

**Solution**:
1. Ensure page fully loaded before inspection (check for loading spinners, lazy-loaded content)
2. Manually trigger animations/interactions that reveal styles
3. Use DevTools "Computed" tab for final rendered values, not authored CSS
4. Check for styles applied via JavaScript after page load

### Screenshot Quality Issues

**Issue**: Screenshots don't match expected output

**Solution**:
1. Verify Chrome DevTools Device Toolbar is set to correct dimensions
2. Clear browser cache before capturing (Cmd/Ctrl+Shift+Del)
3. Disable browser extensions that might affect rendering
4. Use full-page screenshot command (Cmd/Ctrl+Shift+P → "Capture full size screenshot")

## Technical Details

### MCP Server Communication

The Chrome DevTools MCP server runs as a subprocess that communicates via stdio:

```bash
npx -y chrome-devtools-mcp
```

Claude Code's MCP integration automatically:
- Starts the server when needed
- Routes MCP tool calls to the appropriate server
- Manages server lifecycle (start/stop/restart)
- Handles errors and connection issues

### Available MCP Tools

The Chrome DevTools MCP provides tools for:
- **Inspecting elements** - Get computed styles for any CSS selector
- **Capturing screenshots** - Take screenshots at specified dimensions
- **Executing JavaScript** - Run custom scripts in page context (for advanced extraction)
- **Network monitoring** - Track resource loading (for identifying assets)

### Security Considerations

- The MCP server runs locally with npx, not as a persistent service
- No data is sent to external servers (everything runs locally)
- The MCP can only access URLs you explicitly provide
- Chrome runs in a controlled environment (not your main browser profile)

## Advanced Usage

### Custom Style Extraction

For advanced use cases, you can specify exactly which elements to extract:

```
Copy this site: https://example.com
Focus on extracting:
- Header navigation styles
- Hero section gradients
- Card component shadows
```

The superflow will prioritize extracting styles for the specified components.

### Responsive Breakpoint Customization

By default, screenshots are captured at: 320px, 768px, 1024px, 1440px

You can request custom breakpoints:

```
Copy this site: https://example.com
Capture at breakpoints: 375px, 834px, 1536px
```

### Partial Page Extraction

For large sites, you can extract a specific section:

```
Copy just the pricing section from https://example.com/pricing
```

The superflow will focus on the specified section rather than the entire page.

## Integration with Skill System

The Chrome DevTools MCP is tightly integrated with the pixel-perfect-site-copy skill:

1. **Skill Prerequisites Check**
   - SKILL.md instructs Claude to verify MCP availability before starting
   - If unavailable, user is prompted to configure it

2. **Workflow Phases**
   - Phase 1: Site Inspection & Style Extraction (uses MCP)
   - Phase 2: Style Guide Generation (uses extracted data)
   - Phase 3: Implementation (uses style guide)
   - Phase 4: Quality Assurance (compares against MCP screenshots)

3. **Reference Files**
   - `references/style-guide-template.md` - 17-section template
   - `references/design-quality-standards.md` - Quality requirements and MCP extraction workflow

## Resources

- **Chrome DevTools MCP GitHub**: https://github.com/ChromeDevTools/chrome-devtools-mcp
- **Pixel-Perfect Site Copy Skill**: `skills/pixel-perfect-site-copy/SKILL.md`
- **Hook Detection Script**: `hooks/scripts/detect-copy-site.sh`
- **MCP Configuration**: `.mcp.json`

## Support

If you encounter issues not covered in this guide:

1. Check the Chrome DevTools MCP GitHub repository for known issues
2. Verify your Node.js and npm versions are up to date
3. Test with a simple page (e.g., `http://example.com`) to isolate the problem
4. Check Claude Code logs for MCP server errors

## Version Compatibility

- **Claude Code**: Any version with MCP support
- **Node.js**: v16+ recommended
- **Chrome DevTools MCP**: Latest version (auto-fetched by npx)
- **Plugin Version**: v2.0+

Last updated: 2025-10-31
